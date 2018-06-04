#!/usr/bin/env ./libexec/bats

pack(){
  clojure -Sdeps '{:deps {pack/pack.alpha {:local/root "/home/dominic/src/github.com/juxt/pack.alpha"}}}' "$@"
}

@test "build onejar of edge" {
  pushd edge/app
  run pack -m mach.pack.alpha.one-jar "${BATS_TMPDIR}/edge-onejar.jar"
  popd

  [ "$status" -eq 0 ]
  [ -f "${BATS_TMPDIR}/edge-onejar.jar" ]
}

@test "onejar contains OneJar.class" {
  f="${BATS_TMPDIR}/edge-onejar.jar"
  [ "$(jar tf "$f" | grep OneJar.class)" = "OneJar.class" ]
}


@test "onejar contains clojure as a lib" {
  f="${BATS_TMPDIR}/edge-onejar.jar"
  [ -n "$(jar tf "$f" | grep 'lib/.*-clojure-1.*.jar')" ]
}


@test "onejar contains edge/main from the app itself" {
  f="${BATS_TMPDIR}/edge-onejar.jar"
  [ -n "$(jar tf "$f" | grep '^edge/main\.clj$')" ]
}

@test "Running exec from the jar works as expected" {
  f="${BATS_TMPDIR}/edge-onejar.jar"
  run java -jar "$f" -e '(System/exit 101)'

  [ "$status" -eq 101 ]
}

@test "Running edge.main starts listening within 10s" {
  f="${BATS_TMPDIR}/edge-onejar.jar"
  java -jar "$f" -m edge.main &
  pid=$!

  sleep 10
  result="$(ss -ntlp | grep "java" | grep ':3080')"

  kill "$pid"

  [ -n "$result" ]
}
