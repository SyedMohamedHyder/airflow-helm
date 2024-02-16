FROM apache/airflow:2.7.3-python3.10

ENV HTTP_PROXY=
ENV HTTPS_PROXY=
ENV http_proxy=
ENV https_proxy=

USER airflow

COPY requirements.txt .

RUN pip install apache-airflow==${AIRFLOW_VERSION} -r requirements.txt
