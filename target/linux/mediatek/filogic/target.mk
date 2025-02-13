ARCH:=aarch64
SUBTARGET:=filogic
BOARDNAME:=Filogic 8x0 (MT798x)
CPU_TYPE:=cortex-a53
TARGET_CFLAGS += -Os -pipe -funroll-loops -march=armv8-a+crypto+crc -mcpu=cortex-a53+crypto+crc -mtune=cortex-a53
TARGET_LDFLAGS += -Wl,-O2
DEFAULT_PACKAGES += fitblk kmod-phy-aquantia kmod-crypto-hw-safexcel wpad-openssl uboot-envtools bridger
KERNELNAME:=Image dtbs
DEFAULT_PROFILE:=h3c_magic-nx30-pro

define Target/Description
	Build firmware images for MediaTek Filogic ARM based boards.
endef
