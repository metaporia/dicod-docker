FROM debian:stretch
MAINTAINER Liam & Keane

RUN mkdir /home/pedantry/

WORKDIR /home/pedantry
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y wget build-essential
RUN wget ftp://download.gnu.org.ua/pub/release/dico/dico-2.4.tar.gz 
RUN tar xzf dico-2.4.tar.gz && rm dico-2.4.tar.gz

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

RUN apt-get -y install dict-foldoc dict-jargon dict-moby-thesaurus dict-bouvier dict-devil dicod  \
    dict-freedict-spa-eng dict-freedict-eng-spa \
    dict-freedict-eng-lat dict-freedict-lat-eng \
    dict-freedict-eng-fra dict-freedict-fra-eng


COPY ./dicod.conf /usr/local/etc/dicod.conf
COPY ./dicod.service /lib/systemd/system/dicod.service
COPY ./.dico /home/pedantry/.dico
#COPY ./dicod.service /etc/systemd/system/multi-user.target.wants/dicod.service
RUN /home/pedantry/dico-2.4/modules/gcide/idxgcide /home/pedantry/gcide-0.51
RUN   rm /lib/systemd/system/dicod@.service \
   && mv /usr/bin/dicod /usr/bin/dicod.old \
   && ln -s /usr/local/bin/dicod /usr/bin/dicod \
   && ln -s /usr/local/bin/dico /usr/bin/dico

EXPOSE 2628
ADD start.sh /start.sh

ENTRYPOINT ["/start.sh"]

# nb: passphrase is 'Enter'-- the key, not the literal. additionally,
# ./repo-key provides read access to 'git@gitlab.com:metaporia/dicod-docker.git'
# THIS IS TOTALLY UNNECESSARY
#COPY ./repo-key /home/pedantry 

#RUN \
#    chmod 400 /home/pedantry/repo-key && \
#    echo "IdentityFile /home/pedantry/repo-key" >> /etc/ssh/ssh_config && \
#    echo -e "StrictHostKeyChcecking no" >> /etc/ssh/ssh_config && \
#    git clone https://bitbucket.org/HelloKitty8/doc.gshit
#s 
