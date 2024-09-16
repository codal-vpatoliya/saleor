### Build and install packages
FROM python:3.9 as build-python
ENV PYTHONUNBUFFERED 1
ENV PROJECT_VERSION="${PROJECT_VERSION}"
ARG COMMIT_ID
ARG PROJECT_VERSION
# Set work directory
WORKDIR /code
RUN groupadd -r django && useradd -r -m -g django django
RUN chown -R django:django /code
RUN chmod -R 755 /code
RUN apt-get -y update \
  && apt-get install -y gettext \
  # Cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
  && apt-get install -y \
  libcairo2 \
  libgdk-pixbuf2.0-0 \
  liblcms2-2 \
  libopenjp2-7 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libssl3 \
  libtiff6 \
  libwebp7 \
  libxml2 \
  libpq5 \
  shared-mime-info \
  mime-support
# Install of wkhtmltopdf already there above
RUN apt-get install -y binutils libproj-dev gdal-bin libgdal-dev poppler-utils
RUN apt-get install -y openssl libxml2-dev libxslt1-dev vim xvfb xauth xfonts-base xfonts-75dpi fontconfig libevent-dev
RUN apt-get install -y wget libcairo2-dev libjpeg62-turbo-dev libpango1.0-dev libgif-dev build-essential g++
RUN wget https://accis-package-public.s3.amazonaws.com/libjpeg-turbo8_2.0.3-0ubuntu1.20.04.1_amd64.deb
RUN dpkg -i libjpeg-turbo8_2.0.3-0ubuntu1.20.04.1_amd64.deb
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
RUN dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb
RUN dpkg -i wkhtmltox_0.12.5-1.focal_amd64.deb
RUN  apt-get clean \
  && rm -rf /var/lib/apt/lists/*
# Install Python dependencies
COPY requirements_dev.txt /code/
RUN pip install -r requirements_dev.txt
RUN chown -R django:django /home/django
RUN chmod -R 755 /home/django
USER django
# Copy project
COPY --chown=django:django . /code/
EXPOSE 8000
CMD ["bash", "docker/api.sh"]