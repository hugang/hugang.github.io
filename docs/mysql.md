# MySQL

## Download

```shell
git clone -b 5.7 https://github.com/mysql/mysql-server.git --depth=1
```

## library

`boost`

```shell
wget  http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
```

 `rpcgen`

```shell
# rpcgen not found
sudo pacman -S rpcsvc-proto
```

## Configuration

```shell
cmake . \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DDEFAULT_CHARSET=utf8 \
-DWITH_EXTRA_CHARSET=all \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DWITH_BOOST=/path/to/boost.tar.gz

```

## installation

```shell
# compile & install
make
sudo make install
# chown , chmod need create mysql group and user first
chown -R mysql:mysql /usr/local/mysql/
chmod 755 /usr/local/mysql/

# initialize database
/usr/local/mysql/bin/mysqld \
--user=mysql \
--basedir=/usr/local/mysql/ \
--datadir=/usr/local/mysql/data/ \
--log-error-verbosity=3 \
--initialize-insecure
```

## edit /etc/my.cnf

```shell
# before
datadir = /usr/local/var/mysql
#   ↓
# after
datadir = /usr/local/mysql/data

# skip password
skip-grant-tables
```

## start service

```bash
#start service
#bin/mysqld_safe --user=mysql &
bin/mysqld --user=mysql &

#reset password
mysql> UPDATE user SET authentication_string=password('123456') WHERE     user='root';
mysql> flush privileges;

```