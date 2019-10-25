FROM ivonet/centos-jdk:7-8u191
LABEL maintainer="Ivo Woltring, ivonet.nl" description="Payara 5 Server Full"
ENV PAYARA_VERSION 5.191
ENV PAYARA_ARCHIVE payara5
ENV DOMAIN_NAME domain1
ENV INSTALL_DIR /opt
ENV PAYARA_HOME ${INSTALL_DIR}/${PAYARA_ARCHIVE}/glassfish
ENV DEPLOYMENT_DIR ${PAYARA_HOME}/domains/${DOMAIN_NAME}/autodeploy
ENV PATH=".:${INSTALL_DIR}/${PAYARA_ARCHIVE}/bin:$PATH"
ENV AS_ADMIN_NEWPASSWORD secret
RUN useradd -b /opt -m -s /bin/sh -d ${INSTALL_DIR} serveradmin \
 && echo serveradmin:serveradmin | chpasswd \
 && curl -o ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip -L https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/$PAYARA_VERSION/payara-$PAYARA_VERSION.zip \
 && unzip ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip -d ${INSTALL_DIR} \
 && rm ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip \
 && ln -s ${DEPLOYMENT_DIR} /autodeploy \
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
 && asadmin stop-domain \
 && chown -R serveradmin:serveradmin /opt \
 && chmod -R a+rw /opt
USER serveradmin
WORKDIR /autodeploy
VOLUME ["/autodeploy"]
EXPOSE 4848 8009 8080 8181
CMD ["asadmin", "start-domain", "--verbose"]
