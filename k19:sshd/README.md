# SSHD
## @edt ASIX M11-SAD Curs 2019-2020


**edtasixm11/k19:sshd** servidor SSH  amb PAM amb autenticació AP de  kerberos i IP de ldap.
  El servidor kerberos al que contacta s'ha de dir *kserver.edt.org*. El servidor ldap
  s'anomena ldap.edt.org. Aquest host es configura amb authconfig.
  Generat a partir de la imatge edtasixm11/khostpl que és un host amb PAM kerb5+ldap.
  Se li ha afegit:
  
    *  el servei sshd (cal generar les claus de host)
    *  el keytab contenint el princpial host/sshd.edt.org@EDT.ORG
    *  la configuració sshd_config per permetre connexions kerberitzades
    *  la configuració ssh_config per pode fer test des del propi host.

  Atenció al model de la xarxa:

    * aquest servidor sshd.edt.org ha de localitzar per nom de host els serveis 
      kerberos.edt.org i ldap.edt.org, de manera que han d'estar en una xarxa docker 
      propia, per exemple *mynet*.

    * quan el client que es vol connectar per ssh al servidor és un altre host docker 
      el podem posar a la mateixa xarxa *mynet*.

    * quan el client ssh que es vol connectar al servidor és extern (un host extern o un
      container desplegat a un altre host) cal configurar en aquest client el /etc/hosts.
      Cal assegurar-se de posar l'adreça IP del hosts que conté els tres serveis i col·locar 
      com a nom canònic perimerament el sshd.edt.org.  És a dir:
      a.b.c.d sshd.edt.org kserver.edt.org ldap.edt.org

    * això es degut a que en realitzar la resolució inversa (configurada per sshd)
      no obtindria el nom del servidor sshd sinó el que hi hagúes primer en la línia del
      /etc/hosts.

  
Authconfig:
```
authconfig  --enableshadow --enablelocauthorize --enableldap \
            --ldapserver='ldap.edt.org' --ldapbase='dc=edt,dc=org' \
            --enablekrb5 --krb5kdc='kserver.edt.org' \
            --krb5adminserver='kserver.edt.org' --krb5realm='EDT.ORG' \
            --enablemkhomedir --updateall
```

#### Execució local:
```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net mynet -d edtasixm06/ldapserver:18group
docker run --rm --name kserver.edt.org -h kserver.edt.org --net mynet -d edtasixm11/k19:kserver
docker run --rm --name khost.edt.org -h sshd.edt.org --net mynet -d edtasixm11/k19:sshd
docker run --rm --name khost.edt.org -h khost.edt.org --net mynet -it edtasixm11/k19:khostpl
```

#### Execució AWS
**Serveis**
```
docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 --net mynet -d edtasixm06/ldapserver:19group
docker run --rm --name kserver.edt.org -h kserver.edt.org  -p 88:88 -p 749:749 -p 464:464 --net mynet -d edtasixm11/k19:kserver
docker run --rm --name khost.edt.org -h sshd.edt.org --net mynet -p 1022:22 edtasixm11/k19:sshd
```
**Client docker**
```
docker run --rm --name khost.edt.org -h khost.edt.org  -it edtasixm11/k19:khostpl
# Cal configurar /etc/hosts amb adreça de AMI AWS EC2 (ídem ordre)
a.b.c.d sshd.edt.org kserver.edt.org ldap.edt.org
```
**Client host**
```
# authconfig  --enableshadow --enablelocauthorize \
              --enableldap --ldapserver='ldap.edt.org' --ldapbase='dc=edt,dc=org' \
              --enablekrb5 --krb5kdc='kserver.edt.org' --krb5adminserver='kserver.edt.org' \
              --krb5realm='EDT.ORG' \
              --enablemkhomedir --updateall
```


####Test de verificació:

Conexió a un suari local
```
[root@sshd docker]# ssh local02@sshd.edt.org
local02@sshd.edt.org's password: 
Last login: Sat Feb 29 11:50:05 2020 from 172.18.0.5
[local02@sshd ~]$ logout
Connection to sshd.edt.org closed.
```

Connexió a un usuari de xarxa
sense disposar prèviament de ticket
```
[root@sshd docker]# ssh pere@sshd.edt.org
pere@sshd.edt.org's password: 
Last login: Sat Feb 29 11:46:44 2020
[pere@sshd ~]$ logout
Connection to sshd.edt.org closed.
```

Connexió usant un usuari amb ticket kerberos
```
[root@sshd docker]# kinit pere
Password for pere@EDT.ORG: 
[root@sshd docker]# ssh pere@sshd.edt.org
Last login: Sat Feb 29 11:58:18 2020 from 172.18.0.5
```
Observeu que l'usuari client és root però ha adquirit eel ticket de pere
i entra automàticament via ssh al destí amb la identitat pere

Connexió de usuari kerberos a usuari kerberos (ídem):
```
[root@sshd docker]# su pere
sh-4.4$ exit

[root@sshd docker]# su - local01

[local01@sshd ~]$ su - pere
Password: 

[pere@sshd ~]$ klist
Ticket cache: DIR::/run/user/5001/krb5cc_etOpUg/tktWCmYku
Default principal: pere@EDT.ORG

Valid starting     Expires            Service principal
02/29/20 12:00:52  03/01/20 12:00:52  krbtgt/EDT.ORG@EDT.ORG
02/29/20 12:00:52  03/01/20 12:00:52  krbtgt/EDT.ORG@EDT.ORG

[pere@sshd ~]$ ssh pere@sshd.edt.org
The authenticity of host 'sshd.edt.org (172.18.0.5)' can't be established.
ECDSA key fingerprint is SHA256:Q5p1vpDUsUQmxFO8jrO4xV/BbZVhXcxYikcgHjxYTLM.
ECDSA key fingerprint is MD5:e6:fd:f4:ab:78:d6:2d:6f:ca:fa:bf:e1:99:46:b2:88.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'sshd.edt.org,172.18.0.5' (ECDSA) to the list of known hosts.
Last login: Sat Feb 29 12:00:56 2020
[pere@sshd ~]$ logout
Connection to sshd.edt.org closed.
```

Observem la seqüencia:
 * com a root fem su a pere però no som realment pere, l'ordre su enganya!
 * fem el pas previ de fer su a un usuari local
 * ara si fem su a pere i esdevenim un usari de xarxa
 * verifiquem que disposa de credencials de kerberos
 * en fer el ssh connecta automàticament al destí perquè ja té les credencials que 
   l'identifiquen

Connexió des d'un altre host
```
[root@khost docker]# kinit pere
Password for pere@EDT.ORG: 
[root@khost docker]# ssh pere@sshd.edt.org
Last login: Sat Feb 29 12:10:48 2020 from 172.18.0.4
[pere@sshd ~]$ id
uid=5001(pere) gid=100(users) groups=100(users)
[pere@sshd ~]$ pwd
/tmp/home/pere
[pere@sshd ~]$ getent passwd pere
pere:*:5001:100:Pere Pou:/tmp/home/pere:
[pere@sshd ~]$ klist
Ticket cache: FILE:/tmp/krb5cc_5001_p7FHTh4AyM
Default principal: pere@EDT.ORG

Valid starting     Expires            Service principal
02/29/20 12:11:22  03/01/20 12:11:12  krbtgt/EDT.ORG@EDT.ORG
[pere@sshd ~]$ 
```
