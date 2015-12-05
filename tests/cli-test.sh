#!/usr/bin/env bats

fixtures() {
  FIXTURE_ROOT="/tmp/vmdk2dmg-tests"
  RELATIVE_FIXTURE_ROOT="$(bats_trim_filename "$FIXTURE_ROOT")"
}

setup() {
    WORKSPACE=$(mktemp -d -t vmdk2dmg.workspace)
}

teardown() {
    rm -rf "$WORKSPACE"
    rm -f "$PWD/image.dmg"

    # Dump output when error. See https://github.com/sstephenson/bats/issues/105
    echo "$output"
}

fixtures

# Global setup. See https://github.com/sstephenson/bats/issues/108
@test "ensure fixtures" {
  mkdir "$FIXTURE_ROOT" || true
  rm "$FIXTURE_ROOT/valid.vmdk" || true

  hdiutil create -ov -size 512k -type UDIF -fs UDF "$FIXTURE_ROOT/empty.dmg"
  VBoxManage convertfromraw "$FIXTURE_ROOT/empty.dmg" "$FIXTURE_ROOT/valid.vmdk" --format vmdk
  [ -f "$FIXTURE_ROOT/valid.vmdk" ]
}

@test "running with '-h'" {
    run vmdk2dmg -h
    [ $status -eq 0 ]
    echo "${lines[0]}" | grep "^Usage: vmdk2dmg"
}

@test "running with '--help'" {
    run vmdk2dmg --help
    [ $status -eq 0 ]
    echo "${lines[0]}" | grep "^Usage: vmdk2dmg"
}

@test "running with valid vmdk and exlicit output path" {
    expected_dmg="$WORKSPACE/expected.dmg"

    run vmdk2dmg "$FIXTURE_ROOT/valid.vmdk" "$expected_dmg"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
}

@test "running with valid vmdk and without output path" {
    # Test will failed without sleep. Seems that disk is used by another application or already mounted.
    sleep 1

    expected_dmg="$PWD/image.dmg"

    run vmdk2dmg "$FIXTURE_ROOT/valid.vmdk"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
}
