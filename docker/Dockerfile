# Stage 1: Builder stage
FROM alpine:latest AS builder

# Set proxy arguments as build arguments
ARG http_proxy
ARG https_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG no_proxy
ARG NO_PROXY

# Set environment variables for proxies
ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV no_proxy=${no_proxy}
ENV NO_PROXY=${NO_PROXY}

# Install necessary tools for the builder stage
RUN apk add --no-cache \
    curl

# Download and extract PowerShell in the builder stage
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-linux-x64.tar.gz -o /tmp/powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Stage 2: Final stage
FROM apache/airflow:2.10.2-python3.10

# Set proxy arguments as build arguments
ARG http_proxy
ARG https_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG no_proxy
ARG NO_PROXY

# Set environment variables for proxies
ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV no_proxy=${no_proxy}
ENV NO_PROXY=${NO_PROXY}

# Switch to root user to install dependencies
USER root

# Install necessary packages
RUN apt-get update -y \
    && apt-get install -y make \
    && apt-get clean

# Copy PowerShell binaries from the builder stage
COPY --chown=airflow:airflow --from=builder /opt/microsoft/powershell/7 /opt/microsoft/powershell/7

# Set execute permissions for PowerShell binary
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create a symbolic link for PowerShell binary
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Switch back to the airflow user
USER airflow

# Copy requirements.txt
COPY requirements.txt .

# Install Apache Airflow and additional Python dependencies
RUN pip install apache-airflow==${AIRFLOW_VERSION} -r requirements.txt
