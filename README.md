# vmdk2dmg

> Convert vmdk to dmg

[![CI Status](http://img.shields.io/travis/cybertk/homebrew-vmdk2dmg/master.svg?style=flat)](https://travis-ci.org/cybertk/homebrew-vmdk2dmg)

## Getting started

Install from Homebrew

```bash
brew install cybertk/vmdk2dmg/vmdk2dmg
vmdk2dmg /path/to/vmdk
```

## Prerequirements

**vmdk2dmg** depends on [Paragon VMDK Mounter](https://www.paragon-software.com/home/vd-mounter-mac-free/), you can also install it with Homebrew

```bash
brew cask install paragon-vmdk-mounter
```

## How does **vmdk2dmg** work?

1. Mount vmdk with `paragon-vmdk-mounter`
1. Create a dmg from the mounted device with `hdiutl`

## Contributing

See [Contributing Guide](CONTRIBUTING.md)
