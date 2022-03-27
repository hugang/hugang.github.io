# PostgreSQL

## 编译
```shell
./configure
make
su
make install
```

## 创建postgres用户
```shell
make install
useradd postgres
mkdir /usr/local/pgsql/data
chown postgres /usr/local/pgsql/data
```

## 初期化数据库
```shell
su - postgres 
initdb --locale en_US.UTF-8 -D /var/lib/postgres/data
/usr/local/pgsql/bin/postgres -D /var/lib/postgres/data > /var/lib/postgres/data/pgsql.log 2>&1 &
```

## 启动远程连接
```shell
#pg_hba.conf
host    all    all        0.0.0.0/0    md5
#postgresql.conf
listen_addresses = 'localhost' # defaults to 'localhost'; use '*' for all
```

## 一些常用命令

```shell
# psql连接数据库
psql -U postgres -d dbname

# 执行sql
psql -U postgres -d dbname -f "...../xxx.sql"

# list databases
postgres=# \l

# enter database
postgres=# \c postgres;

# drop database
postgres=# drop database test;

# create user
postgres=# create user gitea PASSWORD 'gitea';

# change password
postgres=# alter user postgres PASSWORD 'postgres';

# create database and grant to user
postgres=# create database gitea;
postgres=# grant ALL ON database gitea to gitea;
```
