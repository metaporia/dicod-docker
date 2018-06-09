# Gcide Compilation

First install dicod (and dico) from package manager.

```bash
$ sudo apt -y install dico{,d}
```

Download dico tarball from http://www.gnu.org.ua/software/dico/download.html
(stable: 2.4, newest: 2.5).

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

I just encountered a bug that reads:
```bash
undefined symbol: grecs_print_version"
```
when I tried to run either `dico` or `dicod` outside of the src dir (~/dico-2.4/)

- FIXED: 
1. symlink dico, dicod into /usr/local/bin
2. rename old dicod to dicod2.2
3. uninstall old dico (v 2.2)

- FIXED again (bc the last one didn't actually load dicod modules)
- and then when the modules were (finally) loaded, (i presume) the versions of
  the system deps (gcide.so, dictorg.so) -- v2.2 -- were incompatible with the
  the newer--v2.4--version of dico{,d}.
    DO: individually list the dirs that house all object files for modules you
    wish dicod to load:
    e.g., /path/to/dico-2.4/modules/gcide{,.libs}, ...


Download source code tarball from gcide.gnu.org.ua/download (stable 0.51, newest: 0.52).

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

and change
~~~
module-load-path ("/usr/lib/dico")
~~~
to
~~~
module-load-path (/path/to/module/gcide,/path/module/dictorg,...)
~~~
OR (to exploit the managed installation's deps)
~~~
module-load-path (/usr/lib/x86_64-linux-gnu/dico)
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
