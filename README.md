# REAMDE

## Aquire container

### Pull image from docker hub
```bash
docker pull beryj7/dicod-docker && \
    docker run -d --rm --name="dicod" -p2628:2628 beryj7/dicod-docker
```

### Build and run container instance
The more involved method: 
```bash
docker build . -t beryj7/dicod-docker:latest && \
    docker run --name="dicod" --rm -d -p2628:2628 beryj7/dicod-docker:latest 
```

## Query

### By attaching to DICT server container
The preferred query method.
```bash
docker exec dicod dico [<query-opts>] <word>
```

### Via exposed port on host system
Assuming that dico or dict is installed on the host, an instance is running,
and port 2628 is exposed, the following query should work:
```bash
dico -p 2628 <word>
```

[dico package]: ftp://download.gnu.org.ua/pub/release/dico/dico-2.4.tar.gz

### Dico wrapper for [neo]vim

For a nifty vim client see [dico-vim](https://gitlab.com/metaporia/dico-vim).
