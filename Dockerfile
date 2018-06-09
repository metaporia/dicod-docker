FROM debian:9
MAINTAINER Liam & Keane

RUN mkdir /home/pedantry/

WORKDIR /home/pedantry
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y wget dicod build-essential
RUN wget ftp://download.gnu.org.ua/pub/release/dico/dico-2.4.tar.gz 
RUN tar xzf dico-2.4.tar.gz

WORKDIR /home/pedantry/dico-2.4
RUN apt-get -y install libpcre2-dev guile-2.0-dev zlib1g zlib1g-dev groff groff-base sudo
RUN ./configure --with-pcre --with-guile
RUN make -j4 && sudo make install
# note: guile site dir is not /usr/share/guile/site/2.0, but
# ($datadir)/guile/site, use --with-guile-site-dir to force use of the former.

WORKDIR /home/pedantry
RUN    wget ftp://ftp.gnu.org/gnu/gcide/gcide-0.51.tar.gz \
    && tar xzf gcide-0.51.tar.gz \
    && rm gcide-0.51.tar.gz
#COPY ./repo-key /home/pedantry 
# nb: passphrase is 'Enter'-- the key, not the literal. additionally,
# ./repo-key provides read access to 'git@gitlab.com:metaporia/dicod-docker.git'

#RUN \
#    chmod 400 /home/pedantry/repo-key && \
#    echo "IdentityFile /home/pedantry/repo-key" >> /etc/ssh/ssh_config && \
#    echo -e "StrictHostKeyChcecking no" >> /etc/ssh/ssh_config && \
#    git clone https://bitbucket.org/HelloKitty8/doc.git
#
