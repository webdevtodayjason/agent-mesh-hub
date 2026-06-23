FROM eclipse-mosquitto:2

# Copy config
COPY mosquitto.conf /mosquitto/config/mosquitto.conf
COPY acl.conf /mosquitto/config/acl.conf
COPY passwords /mosquitto/config/passwords

# Fix permissions
RUN chmod 644 /mosquitto/config/mosquitto.conf /mosquitto/config/acl.conf && \
    chmod 644 /mosquitto/config/passwords

EXPOSE 1883 9001

CMD ["mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
