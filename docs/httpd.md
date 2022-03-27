# httpd

## download source code

> http server source
https://ftp.kddi-research.jp/infosystems/apache//httpd/httpd-2.4.46.tar.gz

> apr
https://ftp.yz.yamagata-u.ac.jp/pub/network/apache/apr/apr-1.7.0.tar.gz

> apr-util
https://ftp.yz.yamagata-u.ac.jp/pub/network/apache/apr/apr-util-1.6.1.tar.gz

## compile apr and apr-util

> apr
cd srclib/apr
./configure --prefix=/usr/local/apr-httpd/
make
make install

> apr-util
cd ../apr-util
./configure --prefix=/usr/local/apr-util-httpd/ --with-apr=/usr/local/apr-httpd/
make
make install

> httpd
cd ../../
./configure --with-apr=/usr/local/apr-httpd/ --with-apr-util=/usr/local/apr-util-httpd/
make
make install

> install location
/usr/local/apache2/

## configure systemd service
```bash
/usr/lib/systemd/system/httpd.service
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
