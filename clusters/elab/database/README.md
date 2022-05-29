# PostgreSQL baza podataka

Deployment baze podataka zahteva da je [PostgreSQL Operator (PGO) deployovan][../pgo].

Ova instanca baze podataka ima:
  - 3 baze podataka — user (za user-service), berza (za berza-service) i racun
    (za racun-service)
  - Korisnika sa username-om `admin` (password je automatski generisan) koji
    ima pristup ovim bazama podataka

Instanca se sastoji od 3 PostgreSQL replike u [High-Availability režimu][pgo-ha].
Takođe, deployovan je i pgBackRest koji služi za backpovanje baze podataka.

Operator koristi default StorageClass za pravljenje volume-a/PVC-ova. Svaka
replika koristi volume od 1GB (uključujući i pgBackRest servis).

## Pristup bazi preko Kubernetes-a

PGO automatski kreira nekoliko servisa. Jednostavnosti radi, možete koristiti
servis po imenu `banka-primary`.

## Password `admin` korisnika

Password za `admin` korisnika je automatski generisan, tako da je potrebno
preuzeti taj password. To je moguće učiniti sa sledećom `kubectl` komandom:

```shell
kubectl get secrets -n banka-pgo banka-pguser-admin -o go-template='{{.data.password | base64decode}}'
```

Ukoliko aplikaciju pokrećete preko Kubernetesa, ovu vrednost možete mountovoati
direktno u pod.

## Lokalni pristup bazama

Napomena: ovo je generalno potrebno ako se radi neko debagovanje.

Moguće je lokalno pristupiti bazama preko `psql` alata ili nekog drugog CLI/GUI
alata.

Na Ubuntu/Debian operativnim sistemima, `psql` možete instalirati sa:

```shell
sudo apt-get install -y postgresql-client
```

Kao prvi korak, potrebno je da nađete naziv pod-a neke instance, što možete
uraditi sa sledećom `kubectl` komandom:

```shell
kubectl get pod -n banka-pgo -o name \
  -l postgres-operator.crunchydata.com/cluster=banka,postgres-operator.crunchydata.com/role=master)
```

Rezultat ove komande zamenite sa `${PG_CLUSTER_PRIMARY_POD}` u sledećoj komandi:

```shell
kubectl -n banka-pgo port-forward "${PG_CLUSTER_PRIMARY_POD}" 5432:5432
```

Sada možete pristupiti PostgreSQL-u preko `localhost`-a sa username-om `admin`
i passwordom preuzetim po instrukcijama iznad.

Primer `psql` komande:

```shell
psql -U admin -h localhost <naziv-baze>
```

Napomena: `kubectl port-forward` nije baš pouzdan sa PostgreSQL-om i često se
desi da konekcija pukne, pa onda morate opet da pokrenete tu komandu.

[pgo-ha]: https://access.crunchydata.com/documentation/postgres-operator/5.1.1/tutorial/high-availability/
