FORMULA = vmdk2dmg

test-homebrew-formula:
	# Setup
	cp $(FORMULA).rb $(shell brew --repository)/Library/Formula
	chmod 640 $(shell brew --repository)/Library/Formula/$(FORMULA).rb

	# Run tests
	brew reinstall --HEAD $(FORMULA)
	brew test $(FORMULA)
	brew audit --strict --online $(FORMULA)

test-lint:
	shellcheck vmdk2dmg
