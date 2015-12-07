class ParagonVMDKMounterRequirement < Requirement
  fatal true

  satisfy { which("vdmutil") }

  def message; <<-EOS.undent
    "paragon-vmdk-mounter is required to install. Consider `brew install Caskroom/cask/paragon-vmdk-mounter`."
    EOS
  end
end

class VirtualboxRequirement < Requirement
  fatal true

  satisfy { which("VBoxManage") }

  def message; <<-EOS.undent
    "virtuabox is recommended to install in order to convert from VM name directly. Consider `brew install Caskroom/cask/virtualbox`."
    EOS
  end
end

class Vmdk2dmg < Formula
  desc "Convert vmdk to dmg"
  homepage "https://github.com/cybertk/vmdk2dmg"
  url "https://github.com/cybertk/vmdk2dmg.git",
    :tag => "v0.1.0",
    :revision => "326a9d05a7f74e6ab447f5344e7e4ba5e36c01cb"

  head "https://github.com/cybertk/vmdk2dmg.git"

  depends_on ParagonVMDKMounterRequirement
  depends_on VirtualboxRequirement => :recommended

  def install
    bin.install "vmdk2dmg"
  end

  test do
    assert_match /Usage/, shell_output("vmdk2dmg --help")
  end
end
