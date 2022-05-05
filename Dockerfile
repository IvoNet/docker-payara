FROM eclipse-temurin:17-jdk-focal as builder

RUN apt-get update \
 && apt-get install --no-install-recommends -y unzip \
 && apt-get clean  \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PAYARA_VERSION 5.2022.2

WORKDIR /opt
ADD "https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/$PAYARA_VERSION/payara-$PAYARA_VERSION.zip" /opt/
RUN unzip payara-$PAYARA_VERSION.zip

FROM eclipse-temurin:17-jdk-focal
LABEL maintainer="Ivo Woltring, ivonet.nl" description="Payara 5 Server Full"
ARG PASSWORD
ENV PAYARA_ARCHIVE glassfish
ENV DOMAIN_NAME domain1
ENV INSTALL_DIR /opt
ENV PAYARA_HOME ${INSTALL_DIR}/payara5
ENV DEPLOY_DIR ${PAYARA_HOME}/${PAYARA_ARCHIVE}/domains/${DOMAIN_NAME}/autodeploy
ENV PATH="${PAYARA_HOME}/bin:$PATH"
ENV USR payara

RUN useradd -b /opt -m -s /bin/sh -d ${PAYARA_HOME} ${USR} \
 && echo "root:${PASSWORD:-secret}" | chpasswd \
 && echo ${USR}:${USR} | chpasswd

WORKDIR ${PAYARA_HOME}
COPY --from=builder /opt/payara5 ${PAYARA_HOME}
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p "${DEPLOY_DIR}" \
 && chown -R ${USR}:${USR} ${PAYARA_HOME} \
 && chmod +x /entrypoint.sh

USER ${USR}
VOLUME ["${DEPLOY_DIR}"]

EXPOSE 4848 8009 8080 8181
ENTRYPOINT ["/entrypoint.sh"]
CMD ["asadmin", "start-domain", "--verbose"]

