# Kerberos kserver
## @edt ASIX M11-SAD Curs 2019-2020

**edtasixm11/k19:kserver** servidor kerberos detach. Crea els usuaris pere
  pau (admin), jordi, anna, marta, marta/admin i julia.
  Assignar-li el nom de host: *kserver.edt.org*

Servidor kerberos. Aquest servidor crea els principals corresponents als clàssics
usuaris que tenim també a ldap.

Les característiques principals són:
 * s'ha d'anomenar kserver.edt.org
 * crea els principals pere(kpere) pau(kpau, rol: admin), jordi(kjordi), 
   anna (kanna), marta (kmarta), marta/admin (kmarta rol:admin), julia (kjulia) 
   i admin (kadmin rol:admin).  Crear també els principals kuser01...kuser06 
   amb passwd (kuser01...kuser06).
 * es crea un principal de host corresponent al servidor host/sshd.edt.org.
 * tot el procés és automatitzat i el servidor s'executa detach.

Execució:
```
docker network create mynet
docker volume create krb5-data
docker run --rm --name kserver.edt.org -h kserver.edt.org --net mynet -d edtasixm11/k19:kserver
docker run --rm --name kserver.edt.org -h kserver.edt.org --net mynet -v krb5-data:/var/kerberos -d edtasixm11/k19:kservere initdbedt

```

Execució en AWS EC2
```
docker run --rm --name kserver.edt.org -h kserver.edt.org -p 88:88 -p 749:749 -p 464:464 -d edtasixm11/k19:kserver
```

