################################################################################
#
# Scummvm
#
################################################################################
# Version.: Commits on Sep 11, 2021 branch 2.3
SCUMMVM_VERSION = 80b593cdbae9035dd043f8726915ad582ecda5b0
SCUMMVM_SITE = $(call github,scummvm,scummvm,$(SCUMMVM_VERSION))
SCUMMVM_LICENSE = GPLv2
SCUMMVM_DEPENDENCIES = sdl2 zlib jpeg libmpeg2 libogg libvorbis flac libmad libpng libtheora faad2 freetype

SCUMMVM_ADDITIONAL_FLAGS= -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/interface/vcos/pthreads -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -I$(STAGING_DIR)/usr/include/GLES -lpthread -lm -L$(STAGING_DIR)/usr/lib -lGLESv2 -lEGL

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	SCUMMVM_ADDITIONAL_FLAGS += -lbcm_host -lvchostif
endif

ifeq ($(BR2_PACKAGE_BATOCERA_RPI_ANY),y)
	SCUMMVM_CONF_OPTS += --host=raspberrypi
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3326_ANY),y)
	SCUMMVM_CONF_OPTS += --host=raspberrypi
	SCUMMVM_DEPENDENCIES += mali-g31-gbm
endif

SCUMMVM_CONF_ENV += RANLIB="$(TARGET_RANLIB)" STRIP="$(TARGET_STRIP)" AR="$(TARGET_AR) cru" AS="$(TARGET_AS)"
SCUMMVM_CONF_OPTS += --disable-static --enable-c++11 --enable-opengl --disable-debug --enable-optimizations --enable-mt32emu --enable-flac --enable-mad --enable-vorbis --disable-tremor \
					 --enable-fluidsynth --disable-taskbar --disable-timidity --disable-alsa --enable-vkeybd --enable-keymapper --disable-eventrecorder \
                	 --prefix=/usr --with-sdl-prefix="$(STAGING_DIR)/usr/bin/" --enable-release \

SCUMMVM_MAKE_OPTS += RANLIB="$(TARGET_RANLIB)" STRIP="$(TARGET_STRIP)" AR="$(TARGET_AR) cru" AS="$(TARGET_AS)" LD="$(TARGET_CXX)"

define SCUMMVM_ADD_VIRTUAL_KEYBOARD
	cp $(@D)/backends/vkeybd/packs/vkeybd_default.zip $(TARGET_DIR)/usr/share/scummvm
	cp $(@D)/backends/vkeybd/packs/vkeybd_small.zip $(TARGET_DIR)/usr/share/scummvm
	cp -f $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/emulators/scummvm/scummvm.keys $(TARGET_DIR)/usr/share/evmapy/
endef

SCUMMVM_POST_INSTALL_TARGET_HOOKS += SCUMMVM_ADD_VIRTUAL_KEYBOARD

$(eval $(autotools-package))
