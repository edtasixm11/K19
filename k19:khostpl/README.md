# Kerberos khostpl
## @edt ASIX M11-SAD Curs 2019-2020

## atenció: refer que només faci authconfig

**edtasixm11/k18:khostpl** host amb PAM amb autenticació AP de  kerberos i IP de ldap.
  El servidor kerberos al que contacta s'ha de dir *kserver.edt.org*. El servidor ldap
  s'anomena ldap.edt.org. Aquest host es configura amb authconfig .
  S'ha afegit el paquet client SSH i l configuració client que permet connectar
  amb credencials de kerberos. Així es pot usar per connectar a servidors ssh kerberitzats.
  
per generar autenticació PAM amb kerberos i ldap cal:

Part Global:
  * instal·lar procs passwd.
  * crear els usuaris i assignar password als locals.
  * un cop fet tot, configurar amb authconfig la autenticació local,
    kerberos i ldap.

Part Ldap:
 * instal·lar openldap-clients nss-pam-ldapd authconfig
 * ?? copiar la configuració client /etc/openldap/ldap.conf.
 * ?? copiar la configuració client /etc/nslcd.
 * ?? copiar la configuració ns /etc/nsswitch.conf.
 * ?? activar el servei nslcd
 * ?? activar el servei nscd

Part Kerberos
 * instal·lar pam_krb5 authconfig
 * ??copiar /etc/krb5.conf per la configuració client kerberos
 * **retocar el fitxer de credencials de /etc/krb5.conf.d**
 * configurar authconfig

Authconfig:
```
authconfig  --enableshadow --enablelocauthorize --enableldap \
            --ldapserver='ldap.edt.org' --ldapbase='dc=edt,dc=org' \
            --enablekrb5 --krb5kdc='kserver.edt.org' \
            --krb5adminserver='kserver.edt.org' --krb5realm='EDT.ORG' \
            --enablemkhomedir --updateall
```

#### Execució:
```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net mynet -d edtasixm06/ldapserver:18group
docker run --rm --name kserver.edt.org -h kserver.edt.org --net mynet -d edtasixm11/k19:kserver
docker run --rm --name khost.edt.org -h khost.edt.org --net mynet -it edtasixm11/k19:khostpl
```

#### Execució AWS
```
docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 --net mynet -d edtasixm06/ldapserver:19group
docker run --rm --name kserver.edt.org -h kserver.edt.org  -p 88:88 -p 749:749 -p 464:464  --net mynet -d edtasixm11/k19:kserver
```

En un client local docker:
```
docker run --rm --name khost.edt.org -h khost.edt.org -it edtasixm11/k19:khostpl
# Cal editar /etc/hosts i afegir l'adreça Ip de la AMI AWS EC2
a.b.c.d kserver.edt.org ldap.edt.org
```

En un host client:
 * Usar authconfig.
```
# authconfig --savebackup unix
authconfig  --enableshadow --enablelocauthorize --enableldap \
            --ldapserver='ldap.edt.org' --ldapbase='dc=edt,dc=org' \
            --enablekrb5 --krb5kdc='kserver.edt.org' \
            --krb5adminserver='kserver.edt.org' --krb5realm='EDT.ORG' \
            --enablemkhomedir --updateall
# authconfig --savebackup krb5ldap
```

#### Test de verificació:

```
$ su - local01

[local01@host ~]$ su - user03
Password:  kuser03

[user03@host ~]$ id
uid=1005(user03) gid=100(users) groups=100(users),1001(kusers)
# pwd
# getent passwd user03
```
