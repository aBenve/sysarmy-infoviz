

FROM debian:bookworm

COPY r-project.gpg /etc/apt/keyrings/r-project.gpg
COPY r-project.list /etc/apt/sources.list.d/r-project.list
RUN --mount=type=cache,target=/var/cache/apt,id=install \
    apt update && \
    apt install -y --no-install-recommends \
      nodejs npm \
      r-base-core r-recommended r-cran-tidyverse

WORKDIR /project

ENV LANG=C.UTF-8
