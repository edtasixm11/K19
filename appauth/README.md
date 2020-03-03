# APP Auth: Kerberos + ldap + sshd + PAM
## @edt ASIX M11-SAD Curs 2019-2020

App desplegada amb docker-compose, consta dels serveis kerberos, ldap, sshd i portainer.

Fitxers d'exemple:

 * docker-compose_kerberos-ldap.yml
 * docker-compose_kerberos-ldap-portainer.yml
 * docker-compose_kerberos-ldap-sshd.yml
 * docker-compose_kerberos-ldap-sshd-portainer.yml

Per treballar genereu el fitxer **docker-compose.yml** com un symlibk al 
fitxer que voleu provar. Es recomana usar el nom per defecte per facilitar
les ordres a usar (que utilitzen docker-compose.yml).

### Configuracions:

#### Exemple complert

```
version: "3"
services:
  kserver:
    image: edtasixm11/k19:kserver
    container_name: kserver.edt.org
    hostname: kserver.edt.org
    ports:
      - "88:88"
      - "464:464"
      - "749:749"
    networks:
      - mynet
  ldap:
    image: edtasixm06/ldapserver19:latest
    container_name: ldap.edt.org
    hostname: ldap.edt.org
    ports: 
      - "389:389"
    networks:
      - mynet
  sshd:
    image: edtasixm11/k19:sshd
    container_name: sshd.edt.org
    hostname: sshd.edt.org
    ports:
      - "1022:22"
    networks:
      - mynet
  portainer:
    image: portainer/portainer
    ports:
      - "9000:9000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      - mynet
networks:
  mynet:

```


#### Kerberos

```
version: "3"
services:
  kserver:
    image: edtasixm11/k19:kserver
    container_name: kserver.edt.org
    hostname: kserver.edt.org
    ports:
      - "88:88"
      - "464:464"
      - "749:749"
    networks:
      - mynet
networks:
  mynet:
```

#### LDAP

```
 ldap:
    image: edtasixm06/ldapserver19:latest
    container_name: ldap.edt.org
    hostname: ldap.edt.org
    ports: 
      - "389:389"
    networks:
      - mynet

```

#### sshd

```
  sshd:
    image: edtasixm11/k19:sshd
    container_name: sshd.edt.org
    hostname: sshd.edt.org
    ports:
      - "1022:22"
    networks:
      - mynet

```

#### Portainer

```
  portainer:
    image: portainer/portainer
    ports:
      - "9000:9000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      - mynet
```
