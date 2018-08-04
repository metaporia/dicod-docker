# README

## Build and run container instance
```bash
docker build . -t dict:latest && docker run --name dict-container --rm -it -d -p 2628:2628 dict:latest 
```

## Query running instance
Assuming that an instance is running, and some <port> is exposed, the following
query should work:
```bash
dico -p 2628 <word>
```
NB: 
- on ubuntu/debian the apt package for dico should work. If not download version
  2.4 of the [dico package] from GNU.
- on macos use run `brew install dict`. I may containerize the client as well.


[dico package]: ftp://download.gnu.org.ua/pub/release/dico/dico-2.4.tar.gz
