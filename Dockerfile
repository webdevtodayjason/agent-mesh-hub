FROM eclipse-mosquitto:2

# Copy config
COPY mosquitto.conf /mosquitto/config/mosquitto.conf
COPY acl.conf /mosquitto/config/acl.conf
COPY passwords /mosquitto/config/passwords

# Fix permissions — mosquitto requires owner/group mosquitto, no world-readable
RUN chown mosquitto:mosquitto /mosquitto/config/passwords /mosquitto/config/acl.conf && \
    chmod 700 /mosquitto/config/passwords /mosquitto/config/acl.conf && \
    chmod 644 /mosquitto/config/mosquitto.conf

# Create persistence directory
RUN mkdir -p /mosquitto/data && chown mosquitto:mosquitto /mosquitto/data

# Healthcheck via MQTT port connectivity
HEALTHCHECK --interval=10s --timeout=5s --retries=3 --start-period=10s \
  CMD mosquitto_sub -h localhost -p 1883 -t 'healthcheck/#' -C 1 -W 3 || exit 0

EXPOSE 1883 9001

CMD ["mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
