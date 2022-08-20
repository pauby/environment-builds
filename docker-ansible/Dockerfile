FROM rockylinux/rockylinux:latest

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum check-update; \
    yum install -y gcc libffi-devel python3 epel-release; \
    yum install -y python3-devel krb5-devel; \
    yum install -y python3-pip; \
    yum install -y wget; \
    yum clean all

RUN python3 -m pip install --upgrade pip; \
    python3 -m pip install --upgrade virtualenv; \
    python3 -m pip install pywinrm[kerberos]; \
    python3 -m pip install pywinrm; \
    python3 -m pip install jmespath; \
    python3 -m pip install requests; \
    python3 -m pip install ansible; 
    #\
    #wget -q https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt; \
    #python3 -m pip install -r requirements-azure.txt; \
    #rm -f requirements-azure.txt; \
    #/usr/local/bin/ansible-galaxy collection install azure.azcollection
