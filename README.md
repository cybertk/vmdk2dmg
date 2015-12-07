# vmdk2dmg

> Convert vmdk to dmg

[![CI Status](http://img.shields.io/travis/cybertk/vmdk2dmg/master.svg?style=flat)](https://travis-ci.org/cybertk/vmdk2dmg)

## Getting started

Install from Homebrew

```bash
brew install https://raw.githubusercontent.com/cybertk/vmdk2dmg/vmname/vmdk2dmg.rb
vmdk2dmg /path/to/vmdk
```

## Pre-requirements

**vmdk2dmg** depends on [Paragon VMDK Mounter](https://www.paragon-software.com/home/vd-mounter-mac-free/), you can also install it with Homebrew

```bash
brew cask install paragon-vmdk-mounter
```

If you need convert directly from Virtualbox VM name, **VirtualBox** is also required.

```bash
brew cask install virtualbox
```

## How does **vmdk2dmg** work?

1. Mount vmdk with `paragon-vmdk-mounter`
1. Create a dmg from the mounted device with `hdiutl`

## Contributing

Any contribution is more than welcome! See [Contributing Guide](CONTRIBUTING.md)
