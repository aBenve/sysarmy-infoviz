

FROM debian:bookworm

COPY r-project.gpg /etc/apt/keyrings/r-project.gpg
COPY <<EOF /etc/apt/sources.list.d/r-project.list
deb [signed-by=/etc/apt/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/debian bookworm-cran40/
deb-src [signed-by=/etc/apt/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/debian bookworm-cran40/
EOF
RUN --mount=type=cache,target=/var/cache/apt,id=install \
    apt update && \
    apt install -y --no-install-recommends \
      nodejs npm \
      r-base-core r-recommended r-cran-tidyverse

WORKDIR /project

ENV LANG=C.UTF-8
