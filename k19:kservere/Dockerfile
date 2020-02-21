FROM fedora:27
RUN dnf -y install krb5-server krb5-workstation krb5-libs
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh /opt/docker/install.sh
WORKDIR /opt/docker
EXPOSE  "88" 
#EXPOSE [ "749" ]
#EXPOSE [ "464" ]
ENTRYPOINT [ "/opt/docker/startup.sh" ]

