# gcide & dicod bug fix - 12/20/17

First install dicod from package manager.

```bash
$ sudo apt -y install dicod
```

Download dico tarball from http://www.gnu.org.ua/software/dico/download.html
(stable: 2.4).

```bash
$ wget ftp://download.gnu.org.ua/pub/release/dico/dico-*.*.tar.gz
$ tar xzg dico-*.*.tar.gz
```

Navigate inside dico directory and then compile.

```bash
$ sudo apt -y install libpcre-dev guile-2.0-dev
$ ./configure --with-pcre --with-guile
$ make -j4 && sudo make install
```
Download source code tarball from gcide.gnu.org.ua/download (stable 0.51).

```bash
$ wget ftp://ftp.gnu.org/gnu/gcide/gcide-*.*.tar.gz
$ tar xzf gcide-*.*.tar.gz
```

rename the config file provided by the dicod apt package into
/usr/local/etc/

```bash
$ sudo mv /etc/dicod.conf /usr/local/etc/dicod.conf
```

Now add

~~~
load-module gcide;
database {
    name "gcide <version>";
    handler "gcide dbdir=/path/to/gcide"
}
~~~

Next, change the 'ExecStart' line in /lib/systemd/system/dicod.service to the
compiled dicod,

```systemd
[Unit]
Description=Dicod dictionary server
After=network.target auditd.service

[Service]
EnvironmentFile=-/etc/default/dicod
ExecStart=/usr/local/bin/dicod -f $DAEMON_OPTS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Now start the dicod service.  Recommended databases: foldoc, jargon, vera,
elements, bouvier, moby-thesaurus, devil
