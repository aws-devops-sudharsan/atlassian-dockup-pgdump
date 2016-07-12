FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client-9.3 python-pip && \
  pip install awscli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh
ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]
