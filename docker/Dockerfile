FROM apache/airflow:2.7.3-python3.10

ARG http_proxy
ARG https_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}

USER root

RUN apt-get update -y \
    && apt-get install -y make \
    && apt-get clean

USER airflow

COPY requirements.txt .

RUN pip install apache-airflow==${AIRFLOW_VERSION} -r requirements.txt
