SHELL = /bin/sh -e
FORMULA = vmdk2dmg

test: test-lint test-cli

test-lint:
	shellcheck vmdk2dmg

test-cli:
	./vmdk2dmg --help
	./vmdk2dmg -h

	# hdiutil create -ov -size 512k -fs fat32 /tmp/vmdk2dmg-test.dmg	
	hdiutil create -ov -size 512k -type UDIF -fs UDF /tmp/vmdk2dmg-test.dmg
	rm /tmp/vmdk2dmg-test-fixture.vmdk || true
	VBoxManage convertfromraw /tmp/vmdk2dmg-test.dmg /tmp/vmdk2dmg-test-fixture.vmdk --format vmdk

	rm /tmp/vmdk2dmg-test.dmg || true
	./vmdk2dmg /tmp/vmdk2dmg-test-fixture.vmdk /tmp/vmdk2dmg-test.dmg
	sleep 1
	rm image.dmg || true
	./vmdk2dmg /tmp/vmdk2dmg-test-fixture.vmdk

test-homebrew-formula:
	# Setup
	cp $(FORMULA).rb $(shell brew --repository)/Library/Formula
	chmod 640 $(shell brew --repository)/Library/Formula/$(FORMULA).rb

	# Run tests
	brew reinstall --HEAD $(FORMULA)
	brew test $(FORMULA)
	brew audit --strict --online $(FORMULA).rb

