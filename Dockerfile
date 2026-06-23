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

# No HEALTHCHECK — Coolify manages health status via its own checks.
# Mosquitto doesn't speak HTTP, so HTTP-based health checks will always fail.
# The broker is healthy if the process is running and port 1883 is listening.

EXPOSE 1883 9001

CMD ["mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
