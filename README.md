Forlabs Base Symfony 4 image
===============================================================================

Base symfony 4 engine including composer and common php modules.

How to enable Opcache
-------------------------------------------------------------------------------

Opcache is disabled by default. Uncomment the line in the
following file to enable it:

`/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini`

Or use sed:

```
sed -r 's/^#(.{1,})/\1/' < /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini > /tmp/docker-php-ext-opcache.ini \
&& mv /tmp/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
```

