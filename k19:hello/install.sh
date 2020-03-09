#! /bin/bash

echo "host: $(hostname)" >> /opt/docker/index.html
cp /opt/docker/index.html /var/www/html/index.html

