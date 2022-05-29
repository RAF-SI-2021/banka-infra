# CrunchyData PostgreSQL Operator

Ovaj direktorijum sadrži manifeste potrebne za deployment [CrunchyData
PostgreSQL operatora][pgo]. Manifesti su zasnovani na primerima dostupnim u
postgres-operator-examples repozitorijumu.

Operator se prvi deployuje korišćenjem `kubectl create` komande:

```shell
kubectl create -f clusters/elab/pgo
```

Ažuriranje se vrši korišćenjem `kubectl replace` komande:

```shell
kubectl replace -f clusters/elab/pgo
```

Zbog limitacije veličine anotacije, nije moguće koristiti `kubectl apply` pošto
veličina CRD-a prevazilazi maksimalnu veličinu anotacije.

[pgo]: https://github.com/CrunchyData/postgres-operator
[pgo-examples]: https://github.com/CrunchyData/postgres-operator-examples