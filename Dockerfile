FROM nodesource/nsolid:latest

LABEL maintainer "Joe McCann <joe@subprint.com>"

ENV NODE_ENV=production

# Install our dependencies (libfontconfig for phantomjs)
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
  bzip2 \
  ca-certificates \
  curl \
  git \
  libfontconfig \
  ttf-wqy-microhei \
  ttf-wqy-zenhei \ 
  software-properties-common \
  gconf-service \
  libasound2 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgcc1 \
  libgconf-2-4 \
  libgdk-pixbuf2.0-0 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libstdc++6 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  fonts-liberation \
  libappindicator1 \
  libnss3 \
  lsb-release \
  xdg-utils \
  wget \
  && rm -rf /var/lib/apt/lists/*

# should fix dir context issue w/builds (ALWAYS DO THIS!!!)
WORKDIR /build

# this is faster via npm run build-docker
COPY . /build
RUN npm install --global gulp-cli
RUN npm install \
  && npm cache verify
# Copy source over and create configs dir

# (THESE WOULD BE HAX!!!)
#RUN rm -rf /configs
#RUN mkdir -p /configs
#COPY . .

RUN echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/userns.conf
RUN adduser --disabled-password --gecos '' dillinger
RUN chown -R dillinger:dillinger /build/public
USER dillinger

EXPOSE 8080

CMD ["npm", "start"]
