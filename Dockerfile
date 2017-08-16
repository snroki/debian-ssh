FROM debian:stretch

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN mkdir -p /var/run/sshd \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && touch /root/.Xauthority \
  && true
RUN echo "root:root" | chpasswd

EXPOSE 22
CMD ["/run.sh"]
