FROM node:slim
MAINTAINER david.enke@zalari.de
WORKDIR /tmp
# install browser
RUN apt-get update && \
    apt-get install -y --force-yes xvfb openjdk-7-jre && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb
# install node dependencies
RUN npm install -g protractor protractor-screenshot-reporter mocha mocha-multi mocha-proshot chai chai-as-promised
RUN webdriver-manager update
RUN mkdir /protractor
# copy startup script
COPY ./protractor.sh /protractor.sh
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
