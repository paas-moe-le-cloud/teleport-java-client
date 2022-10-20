#!/bin/bash

if [ -z "$GIT_BRANCH" ]; then
  echo "GIT_BRANCH is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_USER_NAME" ]; then
  echo "GIT_USER_NAME is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]; then
  echo "GIT_USER_EMAIL is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_URI" ]; then
  echo "GIT_PUSH_URI is undefined." 1>&2
  exit 1
fi

export M2_HOME=~/.m2

mkdir -p ${M2_HOME}

if [ $? -ne 0 ]; then
    exit 1
fi

pushd src && \
  ./mvnw -DperformRelease=true install && \
  VERSION=$(./mvnw -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec) && \
    echo "Installing teleport-java-client" && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client \
      -Dversion=${VERSION} \
      -Dfile=src/pom.xml \
      -Dpackaging=pom \
      -DgeneratePom=true \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    echo "Installing teleport-java-client-proto" && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-proto \
      -Dversion=${VERSION} \
      -Dfile=src/proto/target/teleport-java-client-proto-${VERSION}.jar \
      -Dpackaging=jar \
      -DgeneratePom=true \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-proto \
      -Dversion=${VERSION} \
      -Dfile=src/proto/target/teleport-java-client-proto-${VERSION}-sources.jar \
      -Dclassifier=sources \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-proto \
      -Dversion=${VERSION} \
      -Dfile=src/proto/target/teleport-java-client-proto-${VERSION}-javadoc.jar \
      -Dclassifier=javadoc \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    echo "Installing teleport-java-client-mock-server" && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-mock-server \
      -Dversion=${VERSION} \
      -Dfile=src/mock-server/target/teleport-java-client-mock-server-${VERSION}.jar \
      -Dpackaging=jar \
      -DgeneratePom=true \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-mock-server \
      -Dversion=${VERSION} \
      -Dfile=src/mock-server/target/teleport-java-client-mock-server-${VERSION}-sources.jar \
      -Dclassifier=sources \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-mock-server \
      -Dversion=${VERSION} \
      -Dfile=src/mock-server/target/teleport-java-client-mock-server-${VERSION}-javadoc.jar \
      -Dclassifier=javadoc \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    echo "Installing teleport-java-client-reactor" && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-reactor \
      -Dversion=${VERSION} \
      -Dfile=src/reactor/target/teleport-java-client-reactor-${VERSION}.jar \
      -Dpackaging=jar \
      -DgeneratePom=true \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-reactor \
      -Dversion=${VERSION} \
      -Dfile=src/reactor/target/teleport-java-client-reactor-${VERSION}-sources.jar \
      -Dclassifier=sources \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=teleport-java-client-reactor \
      -Dversion=${VERSION} \
      -Dfile=src/reactor/target/teleport-java-client-reactor-${VERSION}-reactor.jar \
      -Dclassifier=javadoc \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    echo "Installing spring-boot-starter-teleport-mock-server" && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=spring-boot-starter-teleport-mock-server \
      -Dversion=${VERSION} \
      -Dfile=src/spring-boot-starter-teleport-mock-server/target/spring-boot-starter-teleport-mock-server-${VERSION}.jar \
      -Dpackaging=jar \
      -DgeneratePom=true \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=spring-boot-starter-teleport-client \
      -Dversion=${VERSION} \
      -Dfile=src/spring-boot-starter-teleport-mock-server/target/spring-boot-starter-teleport-mock-server-${VERSION}-sources.jar \
      -Dclassifier=sources \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=spring-boot-starter-teleport-client \
      -Dversion=${VERSION} \
      -Dfile=src/spring-boot-starter-teleport-mock-server/target/spring-boot-starter-teleport-mock-server-${VERSION}-javadoc.jar \
      -Dclassifier=javadoc \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    echo "Installing spring-boot-starter-teleport-client" && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=spring-boot-starter-teleport-client \
      -Dversion=${VERSION} \
      -Dfile=src/spring-boot-starter-teleport-client/target/spring-boot-starter-teleport-client-${VERSION}.jar \
      -Dpackaging=jar \
      -DgeneratePom=true \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=spring-boot-starter-teleport-client \
      -Dversion=${VERSION} \
      -Dfile=src/spring-boot-starter-teleport-client/target/spring-boot-starter-teleport-client-${VERSION}-sources.jar \
      -Dclassifier=sources \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    ./mvnw install:install-file \
      -DgroupId=io.paasas \
      -DartifactId=spring-boot-starter-teleport-client \
      -Dversion=${VERSION} \
      -Dfile=src/spring-boot-starter-teleport-client/target/spring-boot-starter-teleport-client-${VERSION}-javadoc.jar \
      -Dclassifier=javadoc \
      -Dpackaging=jar \
      -DlocalRepositoryPath=../repository \
      -DcreateChecksum=true && \
    popd && \
    pushd repository && \
    git add --all && \
    git commit -m "ci: publish ${VERSION}" &&
    git push origin ${GIT_BRANCH}