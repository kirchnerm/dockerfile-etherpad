FROM debian:stable

WORKDIR /opt

RUN apt-get update && apt-get -y install gzip git-core curl python libssl-dev pkg-config build-essential
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

RUN git clone git://github.com/ether/etherpad-lite.git &&\
    sed '/installDeps.sh/d' etherpad-lite/bin/run.sh -i

WORKDIR /opt/etherpad-lite

RUN bin/installDeps.sh
RUN npm install sqlite3
RUN useradd -c "Etherpad user" -d /dev/null -s /bin/false etherpad
RUN chown -R etherpad:etherpad .

ADD config/ /opt/etherpad-lite/

RUN npm install \
    ep_headings \
    ep_monospace_default \
    ep_print


EXPOSE 9001
VOLUME ["/data"]

USER etherpad
CMD ["bin/run.sh"]