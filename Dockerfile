FROM centos:7

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ARG USER=ansible
ARG PASS=ansible
ARG UID=1000
ARG GID=1000

EXPOSE 22

RUN yum check-update; \
    yum install -y python3-pip; \
    yum install -y wget; \
    yum install -y unzip; \
    yum install -y which; \
    yum install -y openssh-server; \
    yum install -y openssh-clients; \
    yum clean all

RUN pip3 install --upgrade pip; \
    pip3 install --upgrade virtualenv; \
    pip3 install pywinrm[kerberos]; \
    pip3 install pywinrm; \
    pip3 install jmspath; \
    pip3 install requests; \
    python3 -m pip install ansible;

RUN cd /opt; \ 
    wget https://github.com/fboender/ansible-cmdb/releases/download/1.31/ansible-cmdb-1.31.zip -O ansible-cmdb-1.31.zip; \ 
    unzip ansible-cmdb-1.31.zip; \
    pip install ansible-cmdb

RUN rm /usr/bin/python; \
    ln -s /usr/bin/python3 /usr/bin/python

RUN echo 'root:Docker!' | chpasswd

RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PASS}" | \
    chpasswd
USER ${UID}:${GID}
WORKDIR /home/${USER}

