FROM prom/prometheus

COPY entrypoint.sh /entrypoint.sh

EXPOSE 9090

USER root
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]

