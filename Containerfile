FROM quay.io/centos/centos:stream8
ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN dnf makecache \
    && dnf --setopt=install_weak_deps=false --disableplugin=fastestmirror -y install epel-release \
    && dnf --setopt=install_weak_deps=false --disableplugin=fastestmirror -y install \
    bash \
    cronie \
    drpm \
    e2fsprogs \
    initscripts \
    python38 \
    python38-pip \
    sudo \
    unzip \
    which \
    && dnf -y update \
    && rm -rf /var/cache/dnf

RUN pip3 -q install ansible-core q

RUN sed -i 's/Defaults    requiretty/Defaults    !requiretty/g' /etc/sudoers

RUN echo '# BLANK FSTAB' > /etc/fstab

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
