FROM ivonet/centos-jdk:7-11.0.3
LABEL maintainer="Ivo Woltring, ivonet.nl" description="Payara 5 Server Full"
ENV PAYARA_VERSION 5.193.1
ENV PAYARA_ARCHIVE payara5
ENV DOMAIN_NAME domain1
ENV INSTALL_DIR /opt
ENV PAYARA_HOME ${INSTALL_DIR}/payara
ENV DEPLOY_DIR ${PAYARA_HOME}/${PAYARA_ARCHIVE}/glassfish/domains/${DOMAIN_NAME}/autodeploy
ENV PATH=".:${PAYARA_HOME}/${PAYARA_ARCHIVE}/bin:$PATH"
ENV AS_ADMIN_NEWPASSWORD secret

RUN useradd -b /opt -m -s /bin/sh -d ${PAYARA_HOME} serveradmin \
 && echo "root:secret" | chpasswd \
 && echo serveradmin:serveradmin | chpasswd \
 && chown -R serveradmin:serveradmin ${PAYARA_HOME}

USER serveradmin
WORKDIR ${PAYARA_HOME}

RUN curl -s -o ${PAYARA_ARCHIVE}.zip -L https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/$PAYARA_VERSION/payara-$PAYARA_VERSION.zip \
 && unzip -qq ${PAYARA_ARCHIVE}.zip -d ./ \
 && rm -f ${PAYARA_ARCHIVE}.zip \
 && asadmin start-domain -d \
 && echo "AS_ADMIN_PASSWORD=">pwd.txt \
 && echo "AS_ADMIN_NEWPASSWORD=${AS_ADMIN_NEWPASSWORD}">>pwd.txt \
 && cat pwd.txt \
 && asadmin --host localhost --port 4848 --user admin --passwordfile pwd.txt change-admin-password \
 && echo "AS_ADMIN_PASSWORD=${AS_ADMIN_NEWPASSWORD}">pwd.txt \
 && cat pwd.txt \
 && asadmin --host localhost --port 4848 --user admin --passwordfile pwd.txt enable-secure-admin \
 && echo "https://stackoverflow.com/questions/46334485/glassfish4-jmx-configuration-using-asadmin" \
 && asadmin --host localhost --port 4848 --user admin --passwordfile pwd.txt set configs.config.default-config.admin-service.jmx-connector.system.address=127.0.0.1 \
 && asadmin --host localhost --port 4848 --user admin --passwordfile pwd.txt set configs.config.default-config.admin-service.jmx-connector.system.security-enabled=false \
 && rm -f pwd.txt \
 && asadmin stop-domain

VOLUME ["${DEPLOY_DIR}"]
EXPOSE 4848 8009 8080 8181
CMD ["asadmin", "start-domain", "--verbose"]
