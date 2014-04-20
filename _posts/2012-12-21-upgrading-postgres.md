---
title: Upgrading Postgres.app
date: 2012-12-21
excerpt: Migrating to Postgres 9.2 takes some command line acrobatics.
layout: article
---

<img src="/assets/images/elephant.jpg" class="full" alt="Elephant">

Heroku recently [unveiled][heroku] support for **Postgres 9.2**, offering performance improvements and several new features. Before migrating our *production* database at [Jobber][], we want to run it in development for a few days.

I've been using [Postgres.app][] on my Mac for a while now. Patches are seamless, but migrating from 9.1 to 9.2 takes some command line acrobatics. The [documentation][] sets you on the right track, but I ran into a few gotchas.

_These instructions are for upgrading to Version 9.2.2.0 (20). If you have a newer version, things may have improved!_

1. Keep your old copy of Postgres.app, you'll need it. After Quitting, move it to the desktop.
2. Download the new version of [Postgres.app][] and install it to Applications.
3. Launch the new version of Postgres. You need the *right-click+open* trick on Mountain Lion to get around Gatekeeper. It will move your old database files to a `var-9.1` folder and initialize a new database in its place.
4. Fiddle in `psql` to prepare the new database (see below).
5. Quit out of Postgres.app and perform the upgrade.

## Database already exists

My first attempt failed.

The new data files already had a `nathany` database (my username), so `pg_upgrade` couldn't create it. I'm sure there are a few ways to solve this problem, depending on whether or not you want to migrate this database or discard it. Let's keep it.

We'll need to use `psql` with the **new** Postgres.app running. Here are a few helpful [Meta-Commands][commands]:

Command|What it does
------------|-------------
\l|list databases (press `q` to return to the prompt)
\c name|switch databases (connect)
\q|quit

It won't DROP a database while connected to it, so I ended up creating a new temporary database. Use a name that won't cause conflicts:

``` postgresql-console
nathany=# CREATE DATABASE temporary_database;
CREATE DATABASE
nathany=# \c temporary_database
You are now connected to database "temporary_database" as user "nathany".
temporary_database=# DROP DATABASE nathany;
DROP DATABASE
temporary_database=# \q
```

Substitute `nathany` for your username.

## Upgrade

Now we can **quit** Postgres.app and run the upgrade. It requires absolute paths, so you must substitute `~/` for the path to your user folder (eg. `/Users/nathany/`).

``` bash
pg_upgrade --old-datadir "~/Library/Application Support/Postgres/var-9.1"
           --new-datadir "~/Library/Application Support/Postgres/var"
           --old-bindir "~/Desktop/Postgres.app/Contents/MacOS/bin"
           --new-bindir "/Applications/Postgres.app/Contents/MacOS/bin"
```

This assumes that the new version of Postgres.app is in Applications and the old version is on your Desktop.

## Cleanup

You can fire up Postgres.app and `psql` to drop that temporary database:

``` postgresql-console
nathany=# DROP DATABASE temporary_database;
DROP DATABASE
nathany=# \q
```

When the upgrade completes, it suggests you run:

``` bash
./analyze_new_cluster.sh
```

So do that. And finally, you can delete the old version of Postgres.app. **Phew!**

## That's A Wrap

You can [follow][] Postgres.app on Twitter to find out when you *get to do this all over again. :-)*

Now all I have left to do is find a [_nice_ database client][sequel] for Postgres. It looks like the two new candidates are [Tuples 2][] and [Induction][] (very alpha), though [Navicat][] has been steadily improving as well. Hmm.

Related Articles:

* [Upgrading Postgres.app From 9.2 to 9.3](http://www.yonbergman.com/2013/11/04/upgrading-postgres-app-9-2-to-9-3/) by Yonatan Bergman

[heroku]: https://postgres.heroku.com/blog/past/2012/12/6/postgres_92_now_available/
[documentation]: http://postgresapp.com/documentation
[pgupgrade]: http://www.postgresql.org/docs/current/static/pgupgrade.html
[commands]: http://www.postgresql.org/docs/9.2/static/app-psql.html#APP-PSQL-META-COMMANDS
[Jobber]: http://getjobber.com/
[Postgres.app]: http://postgresapp.com/

[sequel]: http://www.sequelpro.com/
[Tuples 2]: http://tuplesapp.com/
[Induction]: http://inductionapp.com/
[Navicat]: http://www.navicat.com/en/products/navicat_pgsql/pgsql_detail_mac.html
[pgAdmin]: http://www.pgadmin.org/download/macosx.php

[follow]: https://twitter.com/Postgresapp
[Twitter]: https://twitter.com/nathany
