#! /bin/bash

echo "host: $(uname -a) $(hostname)" >> /opt/docker/index.html
uname -a >> /opt/docker/index.html
hostname >> /opt/dcker/index.html
cp /opt/docker/index.html /var/www/html/index.html

