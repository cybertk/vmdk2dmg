#!/usr/bin/env bats

fixtures() {
    FIXTURE_ROOT="/tmp/vmdk2dmg-tests"
    PATH="$BATS_TEST_DIRNAME/..:$PATH"

    FIXTURE_VM="vmdk2dmg-fixture-vm"
}

fixture_vm_state() {
    VBoxManage showvminfo "$FIXTURE_VM" --machinereadable | sed  -n 's/VMState="\(.*\)"/\1/p'
}

setup() {
    WORKSPACE=$(mktemp -d -t vmdk2dmg.workspace)
}

teardown() {
    rm -rf "$WORKSPACE"
    rm -f "$PWD/image.dmg"

    # Dump output when error. See https://github.com/sstephenson/bats/issues/105
    echo "$output"

    # Test will failed without sleep. Seems that disk is used by another application or already mounted.
    sleep 1
}

fixtures

# Global setup. See https://github.com/sstephenson/bats/issues/108
@test "ensure fixtures" {
    mkdir "$FIXTURE_ROOT" || true
    VBoxManage controlvm "$FIXTURE_VM" poweroff || true
    VBoxManage unregistervm "$FIXTURE_VM" --delete || true
    rm "$FIXTURE_ROOT/valid.vmdk" || true

    hdiutil create -ov -size 1m -type UDIF -fs "HFS+" "$FIXTURE_ROOT/empty.dmg"
    VBoxManage convertfromraw "$FIXTURE_ROOT/empty.dmg" "$FIXTURE_ROOT/valid.vmdk" --format vmdk
    [ -f "$FIXTURE_ROOT/valid.vmdk" ]

    VBoxManage createvm --name "$FIXTURE_VM" --register
    VBoxManage storagectl "$FIXTURE_VM" --name SATA --add sata
    VBoxManage storageattach "$FIXTURE_VM" --storagectl SATA --port 0 --type hdd \
        --medium "$FIXTURE_ROOT/valid.vmdk"
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

@test "running with valid vmdk_path and exlicit output path" {
    expected_dmg="$WORKSPACE/expected.dmg"

    run vmdk2dmg "$FIXTURE_ROOT/valid.vmdk" "$expected_dmg"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
}

@test "running with valid vmdk_path and without output path" {

    expected_dmg="$PWD/image.dmg"

    run vmdk2dmg "$FIXTURE_ROOT/valid.vmdk"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
}

@test "running with valid vmname and exlicit output path" {
    expected_dmg="$WORKSPACE/expected.dmg"

    run vmdk2dmg "$FIXTURE_ROOT/valid.vmdk" "$expected_dmg"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
    [ $(fixture_vm_state) = "poweroff" ]
}

@test "running with valid vmname and without output path" {
    expected_dmg="$PWD/image.dmg"

    run vmdk2dmg "$FIXTURE_VM"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
    [ $(fixture_vm_state) = "poweroff" ]
}

@test "running against a running vm" {
    expected_dmg="$PWD/image.dmg"

    VBoxManage startvm "$FIXTURE_VM" --type headless || [ -n "$TRAVIS" ]
    run vmdk2dmg "$FIXTURE_VM"
    [ $status -eq 0 ]
    [ -f "$expected_dmg" ]
    [ $(fixture_vm_state) = "saved" ]
}
