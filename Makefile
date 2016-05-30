SHELL = /bin/sh -e
FORMULA = vmdk2dmg

test: test-lint test-cli

test-lint:
	shellcheck vmdk2dmg

test-cli:
	bats tests/cli-test.sh

test-homebrew-formula:
	# Setup
	cp $(FORMULA).rb $(shell brew --repository)/Library/Formula
	chmod 640 $(shell brew --repository)/Library/Formula/$(FORMULA).rb

	# Run tests
	brew reinstall --HEAD $(FORMULA)
	brew test $(FORMULA)
	brew audit --strict --online $(FORMULA).rb
	brew cask install paragon-vmdk-mounter virtualbox

bootstrap:
	brew reinstall caskroom/cask/brew-cask bats shellcheck
	brew cask install paragon-vmdk-mounter virtualbox
