FROM python:3.10.9

SHELL ["/bin/bash", "-c"]

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip

RUN apt update && apt -qy install gcc libjpeg-dev libxslt-dev \
    libpq-dev libmariadb-dev libmariadb-dev-compat gettext cron openssh-client flake8 locales vim

RUN useradd -rms /bin/bash dj_template && chmod 777 /opt /run

WORKDIR /dj_template

RUN mkdir /dj_template/static && mkdir /dj_template/media && chown -R dj_template:dj_template /dj_template && chmod 755 /dj_template

COPY --chown=dj_template:dj_template . .

RUN pip install -r requirements.txt

USER dj_template

CMD ["gunicorn", "-b", "0.0.0.0:8001", "config.wsgi:application"]