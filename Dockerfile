FROM node:slim
MAINTAINER david.enke@zalari.de
WORKDIR /tmp
# install browser
RUN apt-get update && \
    apt-get install -y --force-yes wget && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y --force-yes google-chrome-stable && \
    apt-get clean
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
