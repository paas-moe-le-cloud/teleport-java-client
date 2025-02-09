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

if [ -z "$GIT_PRIVATE_KEY" ]; then
  echo "GIT_PRIVATE_KEY is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_REPOSITORY_BRANCH" ]; then
  echo "GIT_REPOSITORY_BRANCH is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_URI" ]; then
  echo "GIT_URI is undefined." 1>&2
  exit 1
fi

export M2_HOME=~/.m2 && \
  mkdir -p ${M2_HOME} && \
  mkdir ~/.ssh || true && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  echo "$GIT_PRIVATE_KEY" > ~/.ssh/id_rsa && \
  chmod 600 ~/.ssh/id_rsa && \
  git config --global user.email "${GIT_USER_EMAIL}" && \
  git config --global user.name "${GIT_USER_NAME}" && \
  pushd repository && \
  git fetch && \
  git checkout -B ${GIT_REPOSITORY_BRANCH} && \
  git reset --hard origin/${GIT_REPOSITORY_BRANCH} && \
  popd && \
  pushd src && \
  ./mvnw -DperformRelease=true install && \
  VERSION=$(./mvnw -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec) && \
  echo "Installing teleport-java-client" && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client \
    -Dversion=${VERSION} \
    -Dfile=pom.xml \
    -Dpackaging=pom \
    -DgeneratePom=false \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  echo "Installing teleport-java-client-proto" && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-proto \
    -Dversion=${VERSION} \
    -Dfile=proto/target/teleport-java-client-proto-${VERSION}.jar \
    -Dpackaging=jar \
    -DgeneratePom=false \
    -DpomFile=proto/pom.xml \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-proto \
    -Dversion=${VERSION} \
    -Dfile=proto/target/teleport-java-client-proto-${VERSION}-sources.jar \
    -Dclassifier=sources \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-proto \
    -Dversion=${VERSION} \
    -Dfile=proto/target/teleport-java-client-proto-${VERSION}-javadoc.jar \
    -Dclassifier=javadoc \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  echo "Installing teleport-java-client-mock-server" && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-mock-server \
    -Dversion=${VERSION} \
    -Dfile=mock-server/target/teleport-java-client-mock-server-${VERSION}.jar \
    -Dpackaging=jar \
    -DgeneratePom=false \
    -DpomFile=mock-server/pom.xml \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-mock-server \
    -Dversion=${VERSION} \
    -Dfile=mock-server/target/teleport-java-client-mock-server-${VERSION}-sources.jar \
    -Dclassifier=sources \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-mock-server \
    -Dversion=${VERSION} \
    -Dfile=mock-server/target/teleport-java-client-mock-server-${VERSION}-javadoc.jar \
    -Dclassifier=javadoc \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
    echo "Installing teleport-java-client-reactor" && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-reactor \
    -Dversion=${VERSION} \
    -Dfile=reactor/target/teleport-java-client-reactor-${VERSION}.jar \
    -Dpackaging=jar \
    -DgeneratePom=false \
    -DpomFile=reactor/pom.xml \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-reactor \
    -Dversion=${VERSION} \
    -Dfile=reactor/target/teleport-java-client-reactor-${VERSION}-sources.jar \
    -Dclassifier=sources \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=teleport-java-client-reactor \
    -Dversion=${VERSION} \
    -Dfile=reactor/target/teleport-java-client-reactor-${VERSION}-javadoc.jar \
    -Dclassifier=javadoc \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
    echo "Installing spring-boot-starter-teleport-mock-server" && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=spring-boot-starter-teleport-mock-server \
    -Dversion=${VERSION} \
    -Dfile=spring-boot-starter-teleport-mock-server/target/spring-boot-starter-teleport-mock-server-${VERSION}.jar \
    -Dpackaging=jar \
    -DgeneratePom=false \
    -DpomFile=spring-boot-starter-teleport-mock-server/pom.xml \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=spring-boot-starter-teleport-client \
    -Dversion=${VERSION} \
    -Dfile=spring-boot-starter-teleport-mock-server/target/spring-boot-starter-teleport-mock-server-${VERSION}-sources.jar \
    -Dclassifier=sources \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=spring-boot-starter-teleport-client \
    -Dversion=${VERSION} \
    -Dfile=spring-boot-starter-teleport-mock-server/target/spring-boot-starter-teleport-mock-server-${VERSION}-javadoc.jar \
    -Dclassifier=javadoc \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
    echo "Installing spring-boot-starter-teleport-client" && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=spring-boot-starter-teleport-client \
    -Dversion=${VERSION} \
    -Dfile=spring-boot-starter-teleport-client/target/spring-boot-starter-teleport-client-${VERSION}.jar \
    -Dpackaging=jar \
    -DgeneratePom=false \
    -DpomFile=spring-boot-starter-teleport-client/pom.xml \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=spring-boot-starter-teleport-client \
    -Dversion=${VERSION} \
    -Dfile=spring-boot-starter-teleport-client/target/spring-boot-starter-teleport-client-${VERSION}-sources.jar \
    -Dclassifier=sources \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  ./mvnw install:install-file \
    -DgroupId=io.paasas \
    -DartifactId=spring-boot-starter-teleport-client \
    -Dversion=${VERSION} \
    -Dfile=spring-boot-starter-teleport-client/target/spring-boot-starter-teleport-client-${VERSION}-javadoc.jar \
    -Dclassifier=javadoc \
    -Dpackaging=jar \
    -DlocalRepositoryPath=../repository \
    -DcreateChecksum=true && \
  popd && \
  pushd repository && \
  git add --all && \
  git commit -m "ci: publish ${VERSION}" && \
  git push origin ${GIT_REPOSITORY_BRANCH}