#! /bin/bash

# res, initdb, initdbedt, kadmin, listprincs
DEBUG=1

function servicesStart(){
  if [ $DEBUG -eq 1 ]; then 
    echo "krb5kdc starting..."
    echo "kadmin starting..."
  fi 
  /usr/sbin/krb5kdc
  /usr/sbin/kadmind -nofork
}

function initdb(){
  if [ $DEBUG -eq 1 ]; then
    echo "initdb"	
  fi    
  cp /opt/docker/krb5.conf /etc/krb5.conf
  cp /opt/docker/kdc.conf /var/kerberos/krb5kdc/kdc.conf
  cp /opt/docker/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl
  kdb5_util create -s -P masterkey	
}

function initdbedt(){
  if [ $DEBUG -eq 1 ]; then
    echo "initdbedt"
  fi
  /opt/docker/install.sh && echo "Ok install"
}

function doKadmin(){
  if [ $DEBUG -eq 1 ]; then
    echo "doKadmin"	
  fi    
  kadmin.local -q "$1"
}

function listprincs(){
  if [ $DEBUG -eq 1 ]; then
    echo "listprincs"	 
  fi
  kadmin.local -q "listprincs"
}

if [ $DEBUG -eq 1 ]; then
  echo "inicialitzant..."
fi  

case $1 in
  "initdb")
    initdb;;
  "initdbedt")
    initdbedt;;
  "kadmin")
    doKadmin;;
  "listprincs")
    listprincs;;
esac

#initdbedt
#listprincs
servicesStart
exit 0


