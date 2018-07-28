#!/usr/bin/env ./libexec/bats

pack(){
  clojure -Sdeps '{:deps {pack/pack.alpha {:local/root "/home/dominic/src/github.com/juxt/pack.alpha"}}}' "$@"
}

@test "build default skinny jar of edge" {
  rm -rf "${BATS_TMPDIR}/edge-skinny/"
  pushd edge/app
  run pack -m mach.pack.alpha.skinny --lib-dir "${BATS_TMPDIR}/edge-skinny/lib" --project-path "${BATS_TMPDIR}/edge-skinny/app.jar"
  popd

  [ "$status" -eq 0 ]
  [ -f "${BATS_TMPDIR}/edge-skinny/app.jar" ]
  stat --printf='' ${BATS_TMPDIR}/edge-skinny/lib/org.clojure__clojure__*.jar
  stat --printf='' ${BATS_TMPDIR}/edge-skinny/lib/aero__aero__*.jar
}

@test "build no libs skinny jar of edge" {
  rm -rf "${BATS_TMPDIR}/edge-skinny-nolib/"
  pushd edge/app
  run pack -m mach.pack.alpha.skinny --lib-dir "${BATS_TMPDIR}/edge-skinny-nolib/lib" --project-path "${BATS_TMPDIR}/edge-skinny-nolib/app.jar" --no-libs
  popd

  [ "$status" -eq 0 ]
  [ -f "${BATS_TMPDIR}/edge-skinny-nolib/app.jar" ]
  stat --printf='' ${BATS_TMPDIR}/edge-skinny-nolib/lib/org.clojure__clojure__*.jar && return 1 || return 0
  stat --printf='' ${BATS_TMPDIR}/edge-skinny-nolib/lib/aero__aero__*.jar && return 1 || return 0
}

@test "build no project skinny jar of edge" {
  rm -rf "${BATS_TMPDIR}/edge-skinny-noproj/"
  pushd edge/app
  run pack -m mach.pack.alpha.skinny --lib-dir "${BATS_TMPDIR}/edge-skinny-noproj/lib" --project-path "${BATS_TMPDIR}/edge-skinny-noproj/app" --no-project
  popd

  [ "$status" -eq 0 ]
  [ ! -f "${BATS_TMPDIR}/edge-skinny-noproj/app.jar" ]
  stat --printf='' ${BATS_TMPDIR}/edge-skinny-noproj/lib/org.clojure__clojure__*.jar
  stat --printf='' ${BATS_TMPDIR}/edge-skinny-noproj/lib/aero__aero__*.jar
}

@test "build dir output for project" {
  rm -rf "${BATS_TMPDIR}/edge-skinny-diroutput/"
  pushd edge/app
  run pack -m mach.pack.alpha.skinny --project-path "${BATS_TMPDIR}/edge-skinny-diroutput/app" --no-libs
  popd

  [ "$status" -eq 0 ]
  [ -d "${BATS_TMPDIR}/edge-skinny-diroutput/app/src" ]
  [ -d "${BATS_TMPDIR}/edge-skinny-diroutput/app/resources" ]
}


