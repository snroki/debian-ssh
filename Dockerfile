FROM debian:stretch

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install rsyslog openssh-server iptables vim
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN mkdir -p /var/run/sshd \
  && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -i 's/#SyslogFacility AUTH/SyslogFacility AUTH/' /etc/ssh/sshd_config \
  && sed -i 's/#LogLevel INFO/LogLevel INFO/' /etc/ssh/sshd_config \
  && touch /root/.Xauthority \
  && true
RUN echo "root:root" | chpasswd

EXPOSE 22
CMD ["/run.sh"]
