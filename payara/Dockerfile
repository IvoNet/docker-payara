FROM ivonet/centos-jdk:7-1.8.0
LABEL maintainer="Ivo Woltring, ivonet.nl" description="Payara Server Full"
ENV PAYARA_ARCHIVE payara41
ENV DOMAIN_NAME domain1
ENV INSTALL_DIR /opt
ENV PAYARA_HOME ${INSTALL_DIR}/${PAYARA_ARCHIVE}/glassfish
ENV DEPLOYMENT_DIR ${PAYARA_HOME}/domains/${DOMAIN_NAME}/autodeploy
ENV PATH=".:${INSTALL_DIR}/${PAYARA_ARCHIVE}/bin:$PATH"
ENV AS_ADMIN_PASSWORD secret
RUN useradd -b /opt -m -s /bin/sh -d ${INSTALL_DIR} serveradmin \
 && echo serveradmin:serveradmin | chpasswd
RUN curl -o ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip -L https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+4.1.2.173/payara-4.1.2.173.zip \
 && unzip ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip -d ${INSTALL_DIR} \
 && rm ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip \
 && ln -s /autodeploy ${DEPLOYMENT_DIR}
RUN asadmin start-domain -d \
 && echo "AS_ADMIN_PASSWORD=">pwd.txt \
 && echo "AS_ADMIN_NEWPASSWORD=${AS_ADMIN_PASSWORD}">>pwd.txt \
 && cat pwd.txt \
 && asadmin --host localhost --port 4848 --user admin --passwordfile pwd.txt change-admin-password \
 && echo "AS_ADMIN_PASSWORD=${AS_ADMIN_PASSWORD}">pwd.txt \
 && cat pwd.txt \
 && asadmin --host localhost --port 4848 --user admin --passwordfile pwd.txt enable-secure-admin \
 && rm -f pwd.txt \
 && asadmin stop-domain \
 && chown -R serveradmin:serveradmin /opt \
 && chmod -R a+rw /opt 
USER serveradmin
WORKDIR /autodeploy
ENTRYPOINT ["asadmin", "start-domain", "--verbose"]
VOLUME ["/autodeploy"]
EXPOSE 4848 8009 8080 8181