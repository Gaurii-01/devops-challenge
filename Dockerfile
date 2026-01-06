# Lightweight base image
FROM python:3.11-slim

# Install required package for Linux capabilities
RUN apt-get update && \
    apt-get install -y libcap2-bin && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd --create-home --shell /bin/bash appuser

# Set working directory
WORKDIR /app

# Copy application code
COPY app/app.py /app/app.py

# Install Python dependency
RUN pip install --no-cache-dir flask

# Allow non-root user to bind to port 80
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/python3.11

# Switch to non-root user (MANDATORY)
USER appuser

# Expose port 80
EXPOSE 80

# Run the application
CMD ["python3.11", "app.py"]
