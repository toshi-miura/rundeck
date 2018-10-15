# Dockerfile for rundeck
# https://github.com/jjethwa/rundeck

# add awscli && python

FROM debian:stretch

MAINTAINER Jordan Jethwa

ENV SERVER_URL=https://localhost:4443 \
    RUNDECK_STORAGE_PROVIDER=file \
    RUNDECK_PROJECT_STORAGE_TYPE=file \
    NO_LOCAL_MYSQL=false \
    LOGIN_MODULE=RDpropertyfilelogin \
    JAAS_CONF_FILE=jaas-loginmodule.conf \
    KEYSTORE_PASS=adminadmin \
    TRUSTSTORE_PASS=adminadmin \
    TZ=Asia/Tokyo \
    CLUSTER_MODE=false

RUN export DEBIAN_FRONTEND=noninteractive && \
    echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qqy install -t stretch-backports --no-install-recommends bash openjdk-8-jre-headless ca-certificates-java supervisor procps sudo ca-certificates openssh-client mysql-server mysql-client postgresql-9.6 postgresql-client-9.6 pwgen curl git uuid-runtime parallel jq && \
    cd /tmp/ && \
    curl -Lo /tmp/rundeck.deb http://dl.bintray.com/rundeck/rundeck-deb/rundeck_2.11.5-1-GA_all.deb && \
    echo '4149d0cff77a8f669a712ed959a27def9bc3dec00e56e1e6d6db78210c33382f  rundeck.deb' > /tmp/rundeck.sig && \
    shasum -a256 -c /tmp/rundeck.sig && \
    curl -Lo /tmp/rundeck-cli.deb https://github.com/rundeck/rundeck-cli/releases/download/v1.0.26/rundeck-cli_1.0.26-1_all.deb && \
    echo '0a584165e2ec7626bab8357c3ef63c81773f9ea2f359644a09144de717dc5c4a  rundeck-cli.deb' > /tmp/rundeck-cli.sig && \
    shasum -a256 -c /tmp/rundeck-cli.sig && \
    cd - && \
    dpkg -i /tmp/rundeck*.deb && rm /tmp/rundeck*.deb && \
    chown rundeck:rundeck /tmp/rundeck && \
    mkdir -p /var/lib/rundeck/.ssh && \
    chown rundeck:rundeck /var/lib/rundeck/.ssh && \
    sed -i "s/export RDECK_JVM=\"/export RDECK_JVM=\"\${RDECK_JVM} /" /etc/rundeck/profile && \
    curl -Lo /var/lib/rundeck/libext/rundeck-slack-incoming-webhook-plugin-0.9.jar https://github.com/higanworks/rundeck-slack-incoming-webhook-plugin/releases/download/v0.9.dev/rundeck-slack-incoming-webhook-plugin-0.9.jar && \
    echo 'b73321ce6e88d45e889661ab872c4bb6a188003a2891e87529df73b97c22569f  rundeck-slack-incoming-webhook-plugin-0.9.jar' > /tmp/rundeck-slack-plugin.sig && \
    cd /var/lib/rundeck/libext/ && \
    shasum -a256 -c /tmp/rundeck-slack-plugin.sig && \
    cd - && \
    apt-get -qqy install python3.6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "---------------------------------------------" && \
    apt-get update && \
    apt-get install -y python-pip && \
    pip install awscli && \
    pip install boto3 && \
    apt-get clean

ADD content/ /
RUN chmod u+x /opt/run && \
    mkdir -p /var/log/supervisor && mkdir -p /opt/supervisor && \
    chmod u+x /opt/supervisor/rundeck && chmod u+x /opt/supervisor/mysql_supervisor && chmod u+x /opt/supervisor/fatalservicelistener

EXPOSE 4440 4443

VOLUME  ["/etc/rundeck", "/var/rundeck", "/var/lib/rundeck", "/var/lib/mysql", "/var/log/rundeck", "/opt/rundeck-plugins", "/var/lib/rundeck/logs", "/var/lib/rundeck/var/storage"]

ENTRYPOINT ["/opt/run"]
