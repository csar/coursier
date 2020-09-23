#!/usr/bin/env bash
set -e

if [ "$(expr substr "$(uname -s)" 1 5 2>/dev/null)" != "Linux" -a "$(uname)" != "Darwin" ]; then
  choco install -y windows-sdk-7.1 vcbuildtools kb2519277
fi


./scripts/cs-setup.sh
mkdir -p bin
./cs bootstrap -o bin/sbt sbt-launcher io.get-coursier:coursier_2.12:2.0.0-RC6-25
./cs install --install-dir bin cs coursier
./cs install --install-dir bin --contrib amm-runner
export PATH="$(pwd)/bin:$PATH"
echo "::add-path::$(pwd)/bin"

if [ "$1" == "--jvm" ]; then
  JVM="$2"
  eval "$(./cs java --env --jvm "$JVM")"
  echo "::set-env name=JAVA_HOME::$JAVA_HOME"
  echo "::add-path::$JAVA_HOME/bin"
fi

rm -f cs cs.exe
