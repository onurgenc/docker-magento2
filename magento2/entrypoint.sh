#!/bin/bash
set -e
echo "magento base url : $MAGENTO_BASE_URL";

service php7.0-fpm start
if [  ! "$(ls -A /var/www/html/magento2)" ]; then
    echo "Magento2 Downloading...";
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento2

    echo "Permission fixs";
    cd /var/www/html/magento2

    chown -R www-data:www-data /var/www/html/magento2
    find . -type d -exec chmod 700 {} \; && find . -type f -exec chmod 600 {} \;

    echo "Magento2 Installing...";
    php /var/www/html/magento2/bin/magento setup:install --base-url=$MAGENTO_BASE_URL \
                --db-host=mysql --db-name=magento --db-user=root --db-password=123456 \
                --admin-firstname=Magento --admin-lastname=User --admin-email=onurgenc@gmail.com --admin-user=admin --admin-password=qwer1234 \
                --language=en_US  --currency=AED --timezone="Asia/Dubai" --use-rewrites=1 --backend-frontname=admin



    cp /root/.composer/auth.json /var/www/html/magento2/var/composer_home/auth.json

    composer require onurgenc/shopfinder dev-master
    composer update
    php /var/www/html/magento2/bin/magento deploy:mode:set developer
    php /var/www/html/magento2/bin/magento setup:static-content:deploy
    php /var/www/html/magento2/bin/magento setup:upgrade
    php /var/www/html/magento2/bin/magento setup:di:compile
    php /var/www/html/magento2/bin/magento cache:clean
    php /var/www/html/magento2/bin/magento cache:flush

    echo "Magento2 successfully installed"

else
    echo "Base url updating..."
    composer require onurgenc/shopfinder dev-master
    composer update
    php /var/www/html/magento2/bin/magento setup:store-config:set --base-url=$MAGENTO_BASE_URL
    php /var/www/html/magento2/bin/magento cache:flush
    echo "Started"
fi

echo "Admin url: $MAGENTO_BASE_URL/admin"
echo "user: admin"
echo "pass: qwer1234"

echo "Nginx restarting"

/etc/init.d/nginx restart

echo "Nginx started"



exec "$@"



