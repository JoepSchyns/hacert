FROM debian:latest

# Update and install 
# haproxy 
# cron (for scheduling cert renewals)
# supervisor (for running multiple processes in this container)
# python3 (for running certbot)
# python3 (The only "baremetal" certbot installation method)
# libaugeas0 dependency for certbot
RUN apt update && \
    apt upgrade -y && \
    apt install -y haproxy cron supervisor python3 python3-certbot libaugeas0

# supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# haproxy configuration
COPY haproxy.cfg /etc/haproxy/haproxy.cfg

# crontab
COPY --chmod=600 crontab /etc/cron.d/custom

# cert renewal script
COPY --chmod=111 update-haproxy-certs.sh /update-haproxy-certs.sh

# entrypoint
COPY --chmod=111 entrypoint.sh /entrypoint.sh

# Possible to drop privileges?

VOLUME /etc/letsencrypt

EXPOSE 80 443

ENTRYPOINT /entrypoint.sh

