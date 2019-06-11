FROM jenkins/slave

ENV ATLAS_VERSION 6.3.10
ENV MAVEN_REPOSITORY_MIRROR "false"
ENV JAVA_HOME /usr/local/openjdk-8
ENV PATH ${PATH}:/opt/atlassian-plugin-sdk-${ATLAS_VERSION}/bin/:/usr/local/openjdk-8/bin

USER root

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

RUN apt-get -y update && \
    apt-get -y install bash ca-certificates curl gzip tar && \
    mkdir -p /opt/atlas/ && \
    curl -jkSL -o /opt/atlassian-plugin-sdk-${ATLAS_VERSION}.tar.gz \
         https://maven.atlassian.com/content/repositories/atlassian-public/com/atlassian/amps/atlassian-plugin-sdk/${ATLAS_VERSION}/atlassian-plugin-sdk-${ATLAS_VERSION}.tar.gz && \
    chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint.sh && \
    tar -C /opt -xf /opt/atlassian-plugin-sdk-${ATLAS_VERSION}.tar.gz && \
    chown -R jenkins:root /opt/atlassian-plugin-sdk-${ATLAS_VERSION} && \
    rm -f /opt/atlassian-plugin-sdk-${ATLAS_VERSION}.tar.gz

USER jenkins

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD ["atlas-version"]
