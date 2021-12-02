FROM ubuntu:20.04

# 1. Configure TZ, so we don't get interactive prompt
ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 2. Build things from source first, so get build deps installed
RUN apt-get update && apt-get install -yqq --no-install-recommends\
  # build-essential includes `make`, `gcc` and `g++`
  build-essential git wget ca-certificates curl unzip ninja-build ccache

# 3. Tell apt to install node.js from nodesource.com, to get v16.x instead of v12.x
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# 4. Install cmake
RUN apt remove --purge --auto-remove cmake; \
  apt update; \
  apt install -y software-properties-common lsb-release; \
  apt clean all; \
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null; \
  apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"; \
  apt update; \
  apt install cmake;

# 5. Install all other compilers, from apt-get
RUN apt-get update && apt-get install -yqq --no-install-recommends\
  cargo openjdk-17-jdk golang nodejs php-cli python3 ruby rustc \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -yqq