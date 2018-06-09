# README
## Run Instance
```bash
docker build . -t dict:latest && docker run --name dict-container --rm -it -d -p 2628:2628 dict:latest 
```
At the moment, port-forwarding/binding is _not_ working, so to request a
definition from a running instance dicod-docker run the following:
```bash
docker exec dict-container dico -d* --host localhost <word> | fmt
```
