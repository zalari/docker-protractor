FROM node:slim
MAINTAINER david.enke@zalari.de
WORKDIR /tmp
RUN npm install -g protractor mocha mocha-multi mocha-proshot chai chai-as-promised && \
    webdriver-manager update && \
    apt-get update && \
    apt-get install -y --force-yes xvfb wget openjdk-7-jre && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y --force-yes && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb && \
    mkdir /protractor
COPY ./protractor.sh /protractor.sh
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
