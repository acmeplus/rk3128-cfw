################################################################################
#
# GENESISPLUSGX
#
################################################################################
LIBRETRO_GENESISPLUSGX_VERSION = 86c46138a567d6c0caa96d2285f34df381048fe8
LIBRETRO_GENESISPLUSGX_SITE = $(call github,ekeeke,Genesis-Plus-GX,$(LIBRETRO_GENESISPLUSGX_VERSION))
LIBRETRO_GENESISPLUSGX_LICENSE = Non-commercial

LIBRETRO_GENESISPLUSGX_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
LIBRETRO_GENESISPLUSGX_PLATFORM += rpi3_64

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
LIBRETRO_GENESISPLUSGX_PLATFORM += CortexA73_G12B

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ORANGEPI_PC),y)
LIBRETRO_GENESISPLUSGX_PLATFORM += rpi2

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_CHA),y)
LIBRETRO_GENESISPLUSGX_PLATFORM += rpi2
endif

define LIBRETRO_GENESISPLUSGX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_GENESISPLUSGX_PLATFORM)"
endef

define LIBRETRO_GENESISPLUSGX_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/genesis_plus_gx_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/genesisplusgx_libretro.so
endef

$(eval $(generic-package))
