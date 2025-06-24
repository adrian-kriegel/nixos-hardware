{ lib, ... }:
{
  imports = [
    ../../../../common/cpu/intel/meteor-lake
    ../../../../common/gpu/intel/meteor-lake
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # Fix internal speakers being either 0% or 100% regardless of volume.
  # https://github.com/thesofproject/linux/issues/5215#issuecomment-2443119895
  boot.extraModprobeConfig = ''
    options snd_sof_intel_hda_generic hda_model=alc287-yoga9-bass-spk-pin
  '';

  boot.kernelParams = [
    # Workaround: i915 0000:00:02.0: [drm] *ERROR* Atomic update failure on pipe A
    #             See https://www.dedoimedo.com/computers/intel-microcode-atomic-update.html
    "i915.enable_psr=0"

    # Workaround: Seems like guc on VT-d is faulty and may also cause GUC: TLB invalidation response timed out.
    #             It will cause random gpu resets under hw video decoding.
    #             See https://wiki.archlinux.org/title/Dell_XPS_16_(9640)#Random_freezes
    "iommu.strict=1"
    "iommu.passthrough=1"
  ];

  services = {
    fwupd.enable = lib.mkDefault true; # Firmware Upgrades. Partially supported.
    hardware.bolt.enable = lib.mkDefault true; # Thunderbolt
    thermald.enable = lib.mkDefault true; # This will save you money and possibly your life!
  };
}
