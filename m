Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784935;
	b=XTo1H1YnIPQ7swRDtHCAxXkCAQpi8IV+Ew7QwbRcLh0sYmjro6ykUcKKyqNGwF9GWvZ8
	 EFP9V2kkPjw0YOeukdM1fkWTqVvwi/3N5EIEz8WtsTJG4ckKclz/sXv9PMBak1/LuQ3O5
	 ymT/hLW8JJec5aQiZk/0LswxqwPGAD6EuoPvxfyKSl1ejlP5IENp+17rXNZXXyEwIaPEo
	 7gtVIGV/XxBcrGo8lbXzxnS6Xqv1cCOkniVCVE7ZbGsicSS6bhJPb61kPx2oawqhhxgsb
	 HVPyGx5B3ROcZQ/8BvzIe0XPayjjm/y4YGQZJK75/zuuDn2crOa7ljURHtu2Glwb8FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OJeZ5lfVBLCJTO2h9IbyBfu46at+wrViI0WypyanlZc=;
	b=iYCn2c0sSzxBem0v9+6OOsyNd34lXLnRMpOha/EA8Fe/GxRGvGgofNvw+4zx7z9PS1oG
	 tY6irSTGIQ4Y08zKSZ99aZnDd/d+8Htz/xUTLv5tz0cvZH71nFkkgt3CfykV6j5F8AJyA
	 ypxY02i3kUsio88bvsrUGMC8ve2L/N26j7Yz+UwcrPzy3qoTqH2U2f0qTxdG/JQ9Y1gK2
	 GPnN5rUdMYeI1RdwFD5HbPgJ+bUvNPsXodgapzchkZ0Heo2Bc67rPUoteO03QMGA51r4e
	 tZKUYgT0Z0vorMvodVAD+0w6abAkTH1I7kxyAigaelmjGywuXjjEOcGd9eKay5I6CkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ehwW7B0R;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B59606A885
	for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 23:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1B59606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ehwW7B0R
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso15183835e9.1
        for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 15:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794784931; x=1795389731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OJeZ5lfVBLCJTO2h9IbyBfu46at+wrViI0WypyanlZc=;
        b=ehwW7B0R2Ep2olUzGeR7M0XQUAv1EgJ8XHVG5TpUDPFcuUygTx30YReBfJ4wvcWor9
         0YB2epcEkDV6K6NyUAz/T1+4Fm1biZh2dY65hLu5BQC29XCcgGYW/5hhD3MJRcPPHQu9
         0y3ca0NERxWVqx+/PQPrl19zVPQmn2mOwp2laV2eig5oyR+XtHqkeW6Er9shGBN0CKXx
         ICseacaje9dmXss6Ga33BU5a0m1mDJm6mbsZp6IJExy/WSxEI4VzzJ6tUDaUdZF4hjM7
         HEGW7uzM5YKyHDi+ERsbxSieyT1xTZAEwyRFD2a1rVffrqn10r1ttrSWuWnvabtuFaeg
         9ytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794784931; x=1795389731;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OJeZ5lfVBLCJTO2h9IbyBfu46at+wrViI0WypyanlZc=;
        b=0PwGXD9Ro1Xeti9qX4lnR5w2A0JAw88JBdgZH2jkcis3MQwuqLSdMl25hgZEF5Dwss
         ovkmuRFuoKnn3j9/2jk94bh5AmhGNtZ4JSMMukJaP39JJrriMbF5NhC3uj6sN0xW7nfu
         ROrHA6mWkCD01VFL5uBegOd24pMOU+oy91+fNKg76oVe8MnsCxz0Ds55lDU2R9XIRejd
         ytI/dwT1o80671LzDgpsjr5Lyyk1MRcTJucvLqWzbCMzkZ2GhZghGM6td1fyahgIzqY2
         WUekd6xTkXCxSLboebGrtIQxNxSeWezpktUFynLD0PArrMo+KHioVrxGj2e7npl6wj7G
         Ioog==
X-Forwarded-Encrypted: i=1; AL+hErF2w8MA7a6ZIByg9hMDVKfU/4BEXhzbyLLoV33LesKHcBlVF5sc/KQjuCURfymG/TYuakqkAdasxV0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+wcvqFaXudanVAFPmuqO1eCa5ca7qg0Z3ImVez/nlEWDaAvBjf
	lFtT1MrvAhkd5Aq4d3DlT2UkLNF21I3Tt/qnj/GYp5OGdx8d3a4+eq4T
X-Gm-Gg: AYBFou0ZUoCrAj+/vAKnsF7K8UZg8Ta8ZnCmyfZks2KodQ1OT+sXfUqhuZydndif6A4
	uDdAJELrNWPCGsWFrAyEtara5CoG3iLlfwL8Sszoq58CfPdP0vVoH6EO+a+tywYoNilcpEuWA6o
	0/t6x1GNHAvEmV0woIIPTx1n433aI2t1OOgIxfl0KBZIEkMwgPtA5MCpmqJO84nEjEUvnE7RZaP
	8bhIAhrzGD8nAxazclBQ3Azpp74FBPrVRWh12v4hLRaXTYYV6vZPAuS60rxyfYBrKPCsrey+t3u
	72X2eMv2Ts4i/m9IGh1QuZ09XjHxfLPRC9AKZoQtWYsjzpE2xMwlHjO7K66hsdmOj+ilPEK1pe0
	+mCSHwO5ecQICkZkbzi93+xZiHiOVNteB4pFojo6aLxu/cw8SU0LaO+GfZHO4Ek1wTVZuWkepjs
	1cLLcjnSvdyrVyZOwSpFma6LBhZbNt2aiPgxLGh+/MvgLq4Io0YV9LdsZ1h1qw/sbW1cAhDBEDF
	bddLJdg9IoDtb3ZOMeS+057xS9zajwgWX9pHGkI69RV5BAS+zzPQXinxYf8QH3sOgC7jW9mxZ8a
	MbthalzVTsDB65F2YqdIcf1roWLbSZPlDx7cZL1Pb7QPK40Uhu0YCtYw
X-Received: by 2002:a05:600c:890d:b0:4bb:5c97:f4b1 with SMTP id 5b1f17b1804b1-4bb5c97f545mr120954425e9.24.1794784930830;
        Sun, 15 Nov 2026 15:22:10 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f976esm127920955e9.3.2026.11.15.15.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 15:22:10 -0800 (PST)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Helge Deller <deller@gmx.de>,
	Peter Jones <pjones@redhat.com>
Cc: Francesco Valla <francesco@valla.it>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linux-efi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 4/6] drm: client: add splash client
Date: Mon, 16 Nov 2026 01:21:54 +0100
Message-Id: <20261116002156.1027726-5-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116002156.1027726-1-maximpedraza@gmail.com>
References: <20261116002156.1027726-1-maximpedraza@gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Valla <francesco@valla.it>

Add a DRM client that draws a simple splash, with possibility to show:

  - the logo provided by EFI BGRT;
  - a static BMP image (loaded as firmware);
  - a colored background.

The client is not meant to replace a full-featured bootsplash, but
rather to remove some complexity (and hopefully boot time) on small
embedded platforms or on systems with a limited scope (e.g: recovery
or manufacturing images).

The background color is set at build time from a dedicated config
option. Any color in RGB888 format can be used.

If enabled, the static BMP image is loaded using the kernel firmware
infrastructure; a valid BMP image with 24bpp color and no compression
is expected. The name of the image is set at build time, with the
default being 'drm_splash.bmp'.

Just like the existing DRM clients, the splash can be enabled from the
kernel command line using drm_client_lib.active=splash.

v7:
- restore leaves the commit to the work, which draws what is missing
  first, commits even with no scanouts left, and keeps a forced restore
  forced across suspend
- a hotplug while userspace has the display waits for the next restore,
  as fbdev does
- only a lack of memory makes the image be drawn again
- unregister cancels the work before it looks for a firmware request,
  which a restore can now make too
- the MAINTAINERS entry comes with this patch, with Màxim as maintainer
  and Francesco as reviewer
- rename the BMP source to FW, which is where it comes from: the BGRT is
  a BMP too
- fw_load() returns 0 when the firmware source is disabled, and
  image_load() does not call it then
- read the tile group id under mode_config.mutex, which an EDID update
  holds while it changes or frees the group

v6:
- draw from a work item on system_power_efficient_wq instead of a
  render thread
- set the scanouts up again on every hotplug, and keep the image for
  the outputs plugged in later
- keep the scanouts on screen until the new ones are committed, so that
  a hotplug does not blank every output
- also when the commit or the hotplug fails; restore retires them too
- redraw the image after a background that is drawn again
- accept the V4 and V5 BMP headers
- limit the background color to RGB888
- point no modeset at the framebuffer it had, which a probe without
  connectors leaves in place
- leave restore to the work while the device is suspended
- say in DRM_CLIENT_SPLASH_BMP_NAME that the BMP is requested only once
- don't fail a hotplug, which would stop the later ones for good
- restore commits whatever the modesets hold: an output without a
  buffer has no mode either, and is switched off
- take the BMP headers from <video/bmp.h>
- draw the image in two steps: the BMP upright in XRGB8888, then into
  the buffer's format, taken from its drm_format_info
- drop the splash_color and splash_bmp parameters: the color is set at
  build time only, and so is the BMP's name, with
  DRM_CLIENT_SPLASH_BMP_NAME
- read the 24 bpp source pixels with get_unaligned_le24() instead of a
  u32 load that runs past the pixel
- check the BGRT offsets without overflowing
- size a tiled framebuffer from the tile offsets, whatever order the
  CRTCs come in, and leave out a tile whose plane cannot take the
  format of its group
- don't pick a preferred format that cannot be drawn to, such as C8;
  without one from the driver, pick the one fbdev would
- only pick formats the plane takes with the linear modifier, the
  layout of a dumb buffer
- switch off a modeset left without a buffer instead of failing the
  commit for every output
- mark the background drawn only once it is
- hold the work back while the device is suspended, drawing included,
  and queue it on resume
- drop the fallback to a BMP that was never requested when the BGRT
  fails to load, and the unused struct device
- log with drm_dbg() rather than drm_info(), and end the messages with
  a newline
- destroy the mutex at unregister, and when registering fails
- sort the selects of DRM_CLIENT_SELECTION, use unsigned loop counters,
  and reword the comment on the x86 BGRT sanity check

v5:
- clear the modesets' framebuffers when the scanouts are freed
- free the scanouts when setting up fails
- release a firmware that lands after the drawing is done
- read the BGRT through the efi_bgrt_*() accessors
- drop "static inline" from the .c file

v4:
- fix the render thread never exiting when the BMP firmware is missing,
  a lost wake-up, and stopping a thread that had exited, never existed
  or failed to start
- fix buffers going to the wrong modesets and tiled groups in
  drm_splash_init_client(), and take modeset_mutex there
- don't keep an ERR_PTR as a buffer
- unmap the image only once
- fix use-after-frees on unbind and in the firmware callback
- check the BMP size without overflowing
- indent the Kconfig entry with tabs

Signed-off-by: Francesco Valla <francesco@valla.it>
Co-developed-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
---
 MAINTAINERS                                   |    8 +
 drivers/gpu/drm/clients/Kconfig               |   70 +-
 drivers/gpu/drm/clients/Makefile              |    1 +
 drivers/gpu/drm/clients/drm_client_internal.h |    9 +
 drivers/gpu/drm/clients/drm_client_setup.c    |    8 +
 drivers/gpu/drm/clients/drm_splash.c          | 1032 +++++++++++++++++
 6 files changed, 1127 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/clients/drm_splash.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a08087fb6e67..a97e17509451 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9168,6 +9168,14 @@ F:	Documentation/gpu/drm-ras.rst
 F:	drivers/gpu/drm/drm_ras*
 F:	include/drm/drm_ras*
 
+DRM SPLASH
+M:	Màxim Pedraza Padilla <maximpedraza@gmail.com>
+R:	Francesco Valla <francesco@valla.it>
+L:	dri-devel@lists.freedesktop.org
+S:	Maintained
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	drivers/gpu/drm/clients/drm_splash.c
+
 DRM TTM SUBSYSTEM
 M:	Natalie Vock <nat@pixelcluster.dev>
 M:	Arun Pravin <arunpravin.paneerselvam@amd.com>
diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
index 8d8bc37ec9f2..96ce58dda569 100644
--- a/drivers/gpu/drm/clients/Kconfig
+++ b/drivers/gpu/drm/clients/Kconfig
@@ -13,6 +13,7 @@ config DRM_CLIENT_SELECTION
 	tristate
 	depends on DRM
 	select DRM_CLIENT_LIB if DRM_CLIENT_LOG
+	select DRM_CLIENT_LIB if DRM_CLIENT_SPLASH
 	select DRM_CLIENT_LIB if DRM_FBDEV_EMULATION
 	help
 	  Drivers that support in-kernel DRM clients have to select this
@@ -85,10 +86,70 @@ config DRM_CLIENT_LOG
 	  If you only need logs, but no terminal, or if you prefer userspace
 	  terminal, say "Y".
 
+config DRM_CLIENT_SPLASH
+	bool "Display graphic splash"
+	depends on DRM_CLIENT_SELECTION
+	select DRM_CLIENT
+	select DRM_CLIENT_SETUP
+	select DRM_DRAW
+	help
+	  This enables a splash drm client, able to display either a plain
+	  color or a static image until the userspace is ready to take over.
+	  The splash is displayed on every screen, including those plugged in
+	  later.
+
+config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
+	hex "Splash background color"
+	depends on DRM_CLIENT_SPLASH
+	default 0x000000
+	range 0x000000 0xffffff
+	help
+	  The splash background color, in RGB888 format.
+
+config DRM_CLIENT_SPLASH_SRC_BGRT
+	bool "EFI BGRT as splash source"
+	depends on DRM_CLIENT_SPLASH
+	depends on ACPI_BGRT
+	select DRM_CLIENT_SPLASH_BMP_SUPPORT
+	help
+	  Use the BGRT image provided by the EFI bootloader, drawn where the
+	  firmware drew it. The color specified through the
+	  DRM_CLIENT_SPLASH_BACKGROUND_COLOR config option will be used as
+	  background.
+
+config DRM_CLIENT_SPLASH_SRC_FW
+	bool "BMP image loaded as firmware as splash source"
+	depends on DRM_CLIENT_SPLASH
+	select DRM_CLIENT_SPLASH_BMP_SUPPORT
+	select FW_LOADER
+	help
+	  Use a BMP (bitmap) image as splash. If the image is smaller than the
+	  display(s), it will be centered and the color specified through the
+	  DRM_CLIENT_SPLASH_BACKGROUND_COLOR config option will be used as
+	  background.
+
+	  The image will be loaded using the firmware loading facility the
+	  kernel provides; it shall use 24 bits per pixel and shall not be
+	  compressed.
+
+config DRM_CLIENT_SPLASH_FW_NAME
+	string "Firmware name of the BMP image"
+	depends on DRM_CLIENT_SPLASH_SRC_FW
+	default "drm_splash.bmp"
+	help
+	  The file the BMP image is loaded from, looked up like any other
+	  firmware: built into the kernel through EXTRA_FIRMWARE, in the
+	  initramfs, or under /lib/firmware. It is requested only once, when
+	  the splash first sets up: for a driver that probes before the root
+	  file system is mounted, it has to be built in or in the initramfs.
+
+config DRM_CLIENT_SPLASH_BMP_SUPPORT
+	bool
+
 choice
 	prompt "Default DRM Client"
 	depends on DRM_CLIENT_SELECTION
-	depends on DRM_FBDEV_EMULATION || DRM_CLIENT_LOG
+	depends on DRM_FBDEV_EMULATION || DRM_CLIENT_LOG || DRM_CLIENT_SPLASH
 	default DRM_CLIENT_DEFAULT_FBDEV
 	help
 	  Selects the default drm client.
@@ -111,6 +172,12 @@ config DRM_CLIENT_DEFAULT_LOG
 	  screen, but doesn't implement a full terminal. For that you will need
 	  a userspace terminal using drm/kms.
 
+config DRM_CLIENT_DEFAULT_SPLASH
+	bool "splash"
+	depends on DRM_CLIENT_SPLASH
+	help
+	  Use splash as default drm client.
+
 endchoice
 
 config DRM_CLIENT_DEFAULT
@@ -118,6 +185,7 @@ config DRM_CLIENT_DEFAULT
 	depends on DRM_CLIENT
 	default "fbdev" if DRM_CLIENT_DEFAULT_FBDEV
 	default "log" if DRM_CLIENT_DEFAULT_LOG
+	default "splash" if DRM_CLIENT_DEFAULT_SPLASH
 	default ""
 
 endmenu
diff --git a/drivers/gpu/drm/clients/Makefile b/drivers/gpu/drm/clients/Makefile
index 1304ff358509..b43b1e86fe8e 100644
--- a/drivers/gpu/drm/clients/Makefile
+++ b/drivers/gpu/drm/clients/Makefile
@@ -6,4 +6,5 @@ drm_client_lib-y := drm_client_setup.o
 drm_client_lib-$(CONFIG_DRM_CLIENT_LOG) += drm_log.o
 drm_client_lib-$(CONFIG_DRM_FBDEV_EMULATION) += drm_fbdev_client.o \
 						drm_fbdev_helper.o
+drm_client_lib-$(CONFIG_DRM_CLIENT_SPLASH) += drm_splash.o
 obj-$(CONFIG_DRM_CLIENT_LIB) += drm_client_lib.o
diff --git a/drivers/gpu/drm/clients/drm_client_internal.h b/drivers/gpu/drm/clients/drm_client_internal.h
index 6dc078bf6503..48ee0c1c2529 100644
--- a/drivers/gpu/drm/clients/drm_client_internal.h
+++ b/drivers/gpu/drm/clients/drm_client_internal.h
@@ -22,4 +22,13 @@ void drm_log_register(struct drm_device *dev);
 static inline void drm_log_register(struct drm_device *dev) {}
 #endif
 
+#ifdef CONFIG_DRM_CLIENT_SPLASH
+void drm_splash_register(struct drm_device *dev,
+			 const struct drm_format_info *format);
+#else
+static inline void drm_splash_register(struct drm_device *dev,
+				       const struct drm_format_info *format)
+{}
+#endif
+
 #endif
diff --git a/drivers/gpu/drm/clients/drm_client_setup.c b/drivers/gpu/drm/clients/drm_client_setup.c
index 515aceac22b1..c19498938ee3 100644
--- a/drivers/gpu/drm/clients/drm_client_setup.c
+++ b/drivers/gpu/drm/clients/drm_client_setup.c
@@ -56,6 +56,14 @@ void drm_client_setup(struct drm_device *dev, const struct drm_format_info *form
 		return;
 	}
 #endif
+
+#ifdef CONFIG_DRM_CLIENT_SPLASH
+	if (!strcmp(drm_client_default, "splash")) {
+		drm_splash_register(dev, format);
+		return;
+	}
+#endif
+
 	if (strcmp(drm_client_default, ""))
 		drm_warn(dev, "Unknown DRM client %s\n", drm_client_default);
 }
diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
new file mode 100644
index 000000000000..d54cf628cf17
--- /dev/null
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -0,0 +1,1032 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+/*
+ * Copyright (c) 2025-2026 Francesco Valla <francesco@valla.it>
+ */
+
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/efi-bgrt.h>
+#include <linux/firmware.h>
+#include <linux/init.h>
+#include <linux/iosys-map.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/unaligned.h>
+#include <linux/workqueue.h>
+
+#include <acpi/actbl1.h>
+
+#include <video/bmp.h>
+
+#include <drm/drm_client.h>
+#include <drm/drm_drv.h>
+#include <drm/drm_fourcc.h>
+#include <drm/drm_framebuffer.h>
+#include <drm/drm_plane.h>
+#include <drm/drm_print.h>
+
+#include "drm_client_internal.h"
+#include "drm_draw_internal.h"
+#include "drm_internal.h"
+
+/**
+ * DOC: overview
+ *
+ * This is a simple graphic bootsplash, able to display either a plain color or
+ * a static image.
+ */
+
+struct drm_splash_scanout {
+	int id;
+	/* Modesets scanning this buffer out, by position in the list */
+	u32 modesets;
+	u32 format;
+	unsigned int width;
+	unsigned int height;
+	struct drm_client_buffer *buffer;
+	bool bg_drawn;
+	bool img_drawn;
+};
+
+struct drm_splash {
+	struct drm_client_dev client;
+	u32 preferred_format;
+
+	/* Draws what is missing and shows it, queued when there is news */
+	struct work_struct work;
+
+	/*
+	 * Serialises the work against hotplug events, which set the scanouts
+	 * up again, suspend and resume, and the firmware callback
+	 */
+	struct mutex lock;
+	/* Suspended, and whether the work was held back meanwhile */
+	bool suspended, work_skipped;
+	/* A restore for the work to do, and whether it is forced */
+	bool restore_pending, restore_force;
+	/* A hotplug held back while userspace had the display, for restore */
+	bool hotplug_pending;
+	/* The source is picked at the first hotplug that finds an output */
+	bool source_picked;
+
+	u32 n_scanout;
+	struct drm_splash_scanout *scanout;
+	/*
+	 * The scanouts a hotplug replaced, kept on screen until the work has
+	 * committed the new ones, so that the outputs do not go dark meanwhile
+	 */
+	u32 n_old_scanout;
+	struct drm_splash_scanout *old_scanout;
+
+	/* A request was made, and fw_done tells when its callback is over */
+	bool fw_requested;
+	struct completion fw_done;
+	/*
+	 * The image is kept for as long as the splash is there, so that an
+	 * output plugged in later gets it too
+	 */
+	const struct firmware *fw;
+	void *map_data;
+
+	bool use_bgrt;
+};
+
+static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
+{
+	return container_of_const(client, struct drm_splash, client);
+}
+
+/* An EDID update can change or free the tile group under mode_config.mutex */
+static int drm_splash_tile_group_id(struct drm_connector *connector)
+{
+	guard(mutex)(&connector->dev->mode_config.mutex);
+	return connector->has_tile ? connector->tile_group->id : -1;
+}
+
+static struct drm_splash_scanout *
+get_scanout_from_tile_group(struct drm_splash *splash, int id)
+{
+	unsigned int j;
+
+	for (j = 0; j < splash->n_scanout; j++)
+		if (splash->scanout[j].id == id)
+			return &splash->scanout[j];
+
+	return NULL;
+}
+
+static void drm_splash_queue(struct drm_splash *splash)
+{
+	queue_work(system_power_efficient_wq, &splash->work);
+}
+
+#if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_FW)
+static int drm_splash_fw_load(struct drm_splash *splash, const u8 **data,
+			      size_t *size)
+{
+	const struct firmware *fw = splash->fw;
+
+	/* Under the lock, which the firmware callback takes to hand it over */
+	if (!fw)
+		return -ENOENT;
+
+	*data = fw->data;
+	*size = fw->size;
+
+	return 0;
+}
+
+static void drm_splash_fw_callback(const struct firmware *fw, void *context)
+{
+	struct drm_splash *splash = context;
+	struct drm_client_dev *client = &splash->client;
+
+	if (!fw || !fw->data) {
+		/* The firmware loader has said why already */
+		drm_dbg(client->dev, "splash: no firmware\n");
+		release_firmware(fw);
+		fw = NULL;
+	}
+
+	scoped_guard(mutex, &splash->lock)
+		splash->fw = fw;
+
+	/* Even without it: a background that failed to draw gets another go */
+	drm_splash_queue(splash);
+
+	/* Last: once this is seen, unregister may free the splash */
+	complete(&splash->fw_done);
+}
+
+static int drm_splash_fw_request(struct drm_splash *splash)
+{
+	struct drm_client_dev *client = &splash->client;
+
+	drm_dbg(client->dev, "splash: request %s as firmware\n",
+		CONFIG_DRM_CLIENT_SPLASH_FW_NAME);
+
+	return request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
+				       CONFIG_DRM_CLIENT_SPLASH_FW_NAME,
+				       client->dev->dev, GFP_KERNEL,
+				       splash, drm_splash_fw_callback);
+}
+#else
+static int drm_splash_fw_load(struct drm_splash *splash, const u8 **data,
+			      size_t *size)
+{
+	return 0;
+}
+
+static int drm_splash_fw_request(struct drm_splash *splash)
+{
+	return -EOPNOTSUPP;
+}
+#endif // CONFIG_DRM_CLIENT_SPLASH_SRC_FW
+
+static bool drm_splash_bgrt_available(struct drm_splash *splash)
+{
+	struct drm_client_dev *client = &splash->client;
+
+	if (!IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BGRT))
+		return false;
+
+	if (!efi_bgrt_has_image()) {
+		drm_dbg(client->dev, "splash: no BGRT found\n");
+		return false;
+	}
+
+	if (efi_bgrt_status() & ACPI_BGRT_ORIENTATION_OFFSET) {
+		drm_dbg(client->dev, "splash: BGRT rotation bits set, skipping\n");
+		return false;
+	}
+
+	return true;
+}
+
+static int drm_splash_bgrt_load(struct drm_splash *splash, const u8 **data,
+				size_t *size)
+{
+	struct drm_client_dev *client = &splash->client;
+	phys_addr_t addr = efi_bgrt_image_address();
+	size_t len = efi_bgrt_image_size();
+
+	if (!drm_splash_bgrt_available(splash))
+		return -ENOENT;
+
+	/* Mapped once, and kept for the outputs plugged in later */
+	if (!splash->map_data) {
+		drm_dbg(client->dev, "splash: BGRT image is at %pa, size=%zX\n",
+			&addr, len);
+
+		splash->map_data = memremap(addr, len, MEMREMAP_WB);
+		if (!splash->map_data) {
+			drm_warn(client->dev,
+				 "splash: failed to map BGRT image memory\n");
+			return -ENOMEM;
+		}
+	}
+
+	*data = splash->map_data;
+	*size = len;
+
+	return 0;
+}
+
+static u32 drm_splash_find_usable_format(struct drm_plane *plane,
+					 u32 preferred_format)
+{
+	unsigned int i;
+
+	/* Dumb buffers are linear: the plane must take the format so */
+	if (drm_draw_can_convert_from_xrgb8888(preferred_format) &&
+	    drm_plane_has_format(plane, preferred_format, DRM_FORMAT_MOD_LINEAR))
+		return preferred_format;
+
+	/* Otherwise, find the first format that can be converted from XRGB8888 */
+	for (i = 0; i < plane->format_count; i++) {
+		u32 format = plane->format_types[i];
+
+		if (drm_draw_can_convert_from_xrgb8888(format) &&
+		    drm_plane_has_format(plane, format, DRM_FORMAT_MOD_LINEAR))
+			return format;
+	}
+
+	return DRM_FORMAT_INVALID;
+}
+
+static void drm_splash_fill(struct iosys_map *map, unsigned int dst_pitch,
+			    unsigned int height, unsigned int width,
+			    const struct drm_format_info *format, u32 color)
+{
+	switch (drm_format_info_bpp(format, 0)) {
+	case 16:
+		drm_draw_fill16(map, dst_pitch, height, width, color);
+		break;
+	case 24:
+		drm_draw_fill24(map, dst_pitch, height, width, color);
+		break;
+	case 32:
+		drm_draw_fill32(map, dst_pitch, height, width, color);
+		break;
+	default:
+		WARN_ONCE(1, "Can't fill %p4cc\n", &format->format);
+	}
+}
+
+static int drm_splash_fill_solid_color(struct drm_client_buffer *buffer,
+				       u32 color)
+{
+	struct drm_client_dev *client = buffer->client;
+	struct drm_framebuffer *fb = buffer->fb;
+	struct drm_rect r = DRM_RECT_INIT(0, 0, fb->width, fb->height);
+	struct iosys_map map;
+	int ret;
+
+	ret = drm_client_buffer_vmap_local(buffer, &map);
+	if (ret) {
+		drm_err(client->dev, "splash: cannot vmap buffer: %d\n", ret);
+		return ret;
+	}
+
+	drm_splash_fill(&map, fb->pitches[0], drm_rect_height(&r),
+			drm_rect_width(&r), fb->format, color);
+
+	drm_client_buffer_vunmap_local(buffer);
+
+	return drm_client_buffer_flush(buffer, &r);
+}
+
+#if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_BMP_SUPPORT)
+/* The rows of a 24 bpp BMP, bottom up or top down, upright in XRGB8888 */
+static void drm_splash_bmp_decode(u32 *dst, const u8 *src, unsigned int spitch,
+				  unsigned int width, unsigned int height,
+				  bool invert_y)
+{
+	unsigned int x, y;
+
+	for (y = 0; y < height; y++) {
+		const u8 *p = src + (invert_y ? height - 1 - y : y) * spitch;
+
+		for (x = 0; x < width; x++, p += 3)
+			*dst++ = get_unaligned_le24(p);
+	}
+}
+
+/* An XRGB8888 image into a buffer of another format, at x0, y0 */
+static void drm_splash_blit(struct iosys_map *map, unsigned int dpitch,
+			    const struct drm_format_info *format,
+			    unsigned int x0, unsigned int y0, const u32 *src,
+			    unsigned int width, unsigned int height)
+{
+	unsigned int bpp = drm_format_info_bpp(format, 0);
+	unsigned int x, y, off;
+	u32 c;
+
+	for (y = 0; y < height; y++) {
+		off = (y0 + y) * dpitch + x0 * bpp / 8;
+
+		switch (bpp) {
+		case 16:
+			for (x = 0; x < width; x++, off += 2) {
+				c = drm_draw_color_from_xrgb8888(*src++, format->format);
+				iosys_map_wr(map, off, u16, c);
+			}
+			break;
+		case 24:
+			for (x = 0; x < width; x++, off += 3) {
+				c = drm_draw_color_from_xrgb8888(*src++, format->format);
+				iosys_map_wr(map, off, u8, c & 0xff);
+				iosys_map_wr(map, off + 1, u8, (c >> 8) & 0xff);
+				iosys_map_wr(map, off + 2, u8, (c >> 16) & 0xff);
+			}
+			break;
+		case 32:
+			for (x = 0; x < width; x++, off += 4) {
+				c = drm_draw_color_from_xrgb8888(*src++, format->format);
+				iosys_map_wr(map, off, u32, c);
+			}
+			break;
+		}
+	}
+}
+
+static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
+				     struct drm_splash_scanout *scanout,
+				     const u8 *data, size_t data_len)
+
+{
+	struct drm_client_buffer *buffer = scanout->buffer;
+	struct drm_client_dev *client = buffer->client;
+	struct drm_framebuffer *fb = buffer->fb;
+	const struct bmp_file_header *file_header;
+	const struct bmp_dib_header *dib_header;
+	u32 dib_header_size;
+	u16 bmp_id, bmp_bpp, bmp_planes;
+	u32 bmp_compression, bmp_pitch;
+	s32 bmp_width, bmp_height;
+	bool bmp_invert_y;
+	u32 bitmap_offset;
+	size_t row_len, pixels_len, end;
+	unsigned int x_pad, y_pad;
+	const u8 *image_data;
+	struct iosys_map map;
+	struct drm_rect r;
+	u32 *img;
+	int ret;
+
+	if (data_len < (sizeof(*file_header) + sizeof(*dib_header))) {
+		drm_err(client->dev, "splash: BMP file too short\n");
+		return -EINVAL;
+	}
+
+	file_header = (const struct bmp_file_header *)data;
+
+	bmp_id = get_unaligned_le16(&file_header->id);
+	if (bmp_id != BMP_FILE_MAGIC_ID) {
+		drm_err(client->dev, "splash: invalid BMP magic 0x%04X\n", bmp_id);
+		return -EINVAL;
+	}
+
+	bitmap_offset = get_unaligned_le32(&file_header->bitmap_offset);
+
+	dib_header = (const struct bmp_dib_header *)(data + sizeof(*file_header));
+
+	dib_header_size = get_unaligned_le32(&dib_header->dib_header_size);
+
+	bmp_width = (s32)get_unaligned_le32(&dib_header->width);
+	bmp_height = (s32)get_unaligned_le32(&dib_header->height);
+	bmp_planes = get_unaligned_le16(&dib_header->planes);
+	bmp_bpp = get_unaligned_le16(&dib_header->bpp);
+	bmp_compression = get_unaligned_le32(&dib_header->compression);
+
+	/*
+	 * Restrict supported format to uncompressed, 24bit RGB888. The V4 and
+	 * V5 headers only add fields after these, and bitmap_offset finds the
+	 * pixels.
+	 */
+	if (dib_header_size < 40 || bmp_width <= 0 || bmp_height == 0 ||
+	    bmp_height == S32_MIN || bmp_planes != 1 ||
+	    bmp_compression != 0 || bmp_bpp != 24) {
+		drm_err(client->dev, "splash: invalid BMP format\n");
+		return -EINVAL;
+	}
+
+	/* A positive height means bottom-to-top scan direction */
+	bmp_invert_y = (bmp_height > 0);
+	bmp_height = abs(bmp_height);
+
+	/*
+	 * Every field comes from the image, which the firmware supplied, so
+	 * check the arithmetic before trusting the result: rows are padded to
+	 * four bytes, and the pixels must end within the data.
+	 */
+	if (check_mul_overflow((size_t)bmp_width, (size_t)3, &row_len) ||
+	    check_add_overflow(row_len, (size_t)3, &row_len) ||
+	    check_mul_overflow(row_len & ~(size_t)3, (size_t)bmp_height,
+			       &pixels_len) ||
+	    check_add_overflow((size_t)bitmap_offset, pixels_len, &end) ||
+	    end > data_len) {
+		drm_err(client->dev, "splash: invalid BMP size\n");
+		return -EINVAL;
+	}
+	bmp_pitch = row_len & ~(size_t)3;
+
+	if (bmp_width > scanout->width || bmp_height > scanout->height) {
+		drm_err(client->dev, "splash: BMP image is too big for the screen\n");
+		return -EINVAL;
+	}
+
+	if (splash->use_bgrt) {
+		x_pad = efi_bgrt_image_offset_x();
+		y_pad = efi_bgrt_image_offset_y();
+
+		if (x_pad > scanout->width - bmp_width ||
+		    y_pad > scanout->height - bmp_height) {
+			drm_err(client->dev, "splash: BGRT image would overflow\n");
+			return -EINVAL;
+		}
+
+#ifdef CONFIG_X86
+		/*
+		 * BGRT sanity check, taken from efifb.c:
+		 *
+		 * Some firmware on x86 uses a non-native resolution for the
+		 * display if it has shown some text messages, while the BGRT
+		 * still describes the image for the native resolution. If
+		 * that image still fits, it ends up very close to the right
+		 * edge of the display, looking quite bad.
+		 */
+
+		if (x_pad != (scanout->width - bmp_width) / 2) {
+			drm_err(client->dev, "splash: BGRT sanity check failed\n");
+			return -EINVAL;
+		}
+#endif
+	} else {
+		/* Center X and Y */
+		x_pad = (scanout->width - bmp_width) / 2;
+		y_pad = (scanout->height - bmp_height) / 2;
+	}
+
+	image_data = data + bitmap_offset;
+
+	/* First the image upright in XRGB8888, then into the buffer's format */
+	img = kvmalloc_array(bmp_width, bmp_height * sizeof(*img), GFP_KERNEL);
+	if (!img)
+		return -ENOMEM;
+	drm_splash_bmp_decode(img, image_data, bmp_pitch, bmp_width, bmp_height,
+			      bmp_invert_y);
+
+	ret = drm_client_buffer_vmap_local(buffer, &map);
+	if (ret) {
+		drm_err(client->dev, "splash: cannot vmap buffer: %d\n", ret);
+		kvfree(img);
+		/* Like the allocation above, this may work on the next pass */
+		return -ENOMEM;
+	}
+
+	r = DRM_RECT_INIT(x_pad, y_pad, bmp_width, bmp_height);
+	drm_splash_blit(&map, fb->pitches[0], fb->format, x_pad, y_pad, img,
+			bmp_width, bmp_height);
+
+	kvfree(img);
+	drm_client_buffer_vunmap_local(buffer);
+
+	return drm_client_buffer_flush(buffer, &r);
+}
+#else
+static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
+				     struct drm_splash_scanout *scanout,
+				     const u8 *data, size_t data_len)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
+				 size_t *img_data_len)
+{
+	if (splash->use_bgrt)
+		return drm_splash_bgrt_load(splash, img_data, img_data_len);
+
+	if (!IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_FW))
+		return -ENOENT;
+
+	return drm_splash_fw_load(splash, img_data, img_data_len);
+}
+
+/* At unregister, once nothing else can use the image */
+static void drm_splash_image_cleanup(struct drm_splash *splash)
+{
+	memunmap(splash->map_data);
+	splash->map_data = NULL;
+	release_firmware(splash->fw);
+	splash->fw = NULL;
+}
+
+/* Delete the buffers of an array of scanouts, and the array */
+static void drm_splash_delete_scanouts(struct drm_splash_scanout **scanout,
+				       u32 *n_scanout)
+{
+	unsigned int i;
+
+	for (i = 0; i < *n_scanout; i++)
+		drm_client_buffer_delete((*scanout)[i].buffer);
+
+	kfree(*scanout);
+	*scanout = NULL;
+	*n_scanout = 0;
+}
+
+static int drm_splash_commit(struct drm_splash *splash, bool force)
+{
+	struct drm_client_dev *client = &splash->client;
+	int ret;
+
+	if (force)
+		ret = drm_client_modeset_commit_locked(client);
+	else
+		ret = drm_client_modeset_commit(client);
+
+	/* Whatever a hotplug replaced is no longer on screen */
+	if (!ret)
+		drm_splash_delete_scanouts(&splash->old_scanout,
+					   &splash->n_old_scanout);
+
+	return ret;
+}
+
+static void drm_splash_rebuild(struct drm_splash *splash);
+
+static void drm_splash_work(struct work_struct *work)
+{
+	struct drm_splash *splash = container_of(work, struct drm_splash, work);
+	struct drm_client_dev *client = &splash->client;
+	const u8 *img_data = NULL;
+	size_t img_data_len = 0;
+	bool img_loaded, restore, force;
+	unsigned int i;
+	int ret;
+
+	guard(mutex)(&splash->lock);
+
+	/*
+	 * Not while the device sleeps, not even drawing, which flushes the
+	 * buffers to the hardware: resume queues the work again
+	 */
+	if (splash->suspended) {
+		splash->work_skipped = true;
+		return;
+	}
+
+	restore = splash->restore_pending;
+	force = splash->restore_force;
+	splash->restore_pending = false;
+	splash->restore_force = false;
+
+	/* The outputs a hotplug found while userspace had the display */
+	if (restore && splash->hotplug_pending) {
+		splash->hotplug_pending = false;
+		drm_splash_rebuild(splash);
+	}
+
+	/* A restore commits even with no scanouts: it switches the outputs off */
+	if (!splash->n_scanout && !restore)
+		return;
+
+	/* A BMP loaded as firmware may not be there yet: its callback requeues */
+	img_loaded = !drm_splash_image_load(splash, &img_data, &img_data_len);
+
+	for (i = 0; i < splash->n_scanout; i++) {
+		struct drm_splash_scanout *scanout = &splash->scanout[i];
+
+		/* Its outputs are off: init_client could not create it */
+		if (!scanout->buffer)
+			continue;
+
+		if (!scanout->bg_drawn) {
+			u32 rgb = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
+			u32 color = drm_draw_color_from_xrgb8888(rgb, scanout->format);
+
+			/* Only success marks it done: a later pass retries */
+			ret = drm_splash_fill_solid_color(scanout->buffer, color);
+			scanout->bg_drawn = !ret;
+			/* The fill covers the image too */
+			scanout->img_drawn = false;
+		}
+
+		if (img_loaded && !scanout->img_drawn) {
+			/*
+			 * A failure leaves the background alone. Only a lack of
+			 * memory can go away: anything else, the image or where
+			 * it goes, would fail the same way on every pass.
+			 */
+			ret = drm_splash_bmp_to_scanout(splash, scanout, img_data,
+							img_data_len);
+			scanout->img_drawn = ret != -ENOMEM;
+		}
+	}
+
+	/*
+	 * With another master, the display is not the splash's to show; the
+	 * buffers stay drawn for when restore hands it back.
+	 */
+	ret = drm_splash_commit(splash, force);
+	/* What a hotplug replaced is then still on screen: it stays */
+	if (ret)
+		drm_dbg(client->dev, "splash: commit: %d\n", ret);
+}
+
+/* No mode and no connectors: a commit switches the output off */
+static void drm_splash_modeset_off(struct drm_device *dev,
+				   struct drm_mode_set *modeset)
+{
+	unsigned int k;
+
+	for (k = 0; k < modeset->num_connectors; k++) {
+		drm_connector_put(modeset->connectors[k]);
+		modeset->connectors[k] = NULL;
+	}
+	modeset->num_connectors = 0;
+	drm_mode_destroy(dev, modeset->mode);
+	modeset->mode = NULL;
+	modeset->fb = NULL;
+}
+
+static int drm_splash_init_client(struct drm_splash *splash)
+{
+	struct drm_client_dev *client = &splash->client;
+	struct drm_mode_set *modeset;
+	unsigned int fb_count = 0;
+	unsigned int i, k;
+	int err = -ENODEV;
+
+	if (drm_client_modeset_probe(client, 0, 0))
+		return -EIO;
+
+	mutex_lock(&client->modeset_mutex);
+
+	/*
+	 * Collect one scanout per usable modeset, or per tile group. Each
+	 * scanout records the modesets it feeds by their position in the
+	 * list, so that the second pass below can find them again whatever
+	 * was skipped in between.
+	 */
+	i = 0;
+	drm_client_for_each_modeset(modeset, client) {
+		struct drm_splash_scanout *tmp;
+		struct drm_splash_scanout *scanout;
+		unsigned int idx = i++;
+		u32 format;
+		int id;
+
+		if (WARN_ON_ONCE(idx >= 32))
+			break;
+
+		/* Skip modesets without a mode */
+		if (!modeset->mode)
+			continue;
+
+		id = drm_splash_tile_group_id(modeset->connectors[0]);
+		if (id >= 0) {
+			struct drm_splash_scanout *tiled;
+
+			/*
+			 * Tiled modesets contribute to a single framebuffer,
+			 * which reaches the far edge of the last tile, whatever
+			 * order the tiles come in.
+			 */
+			tiled = get_scanout_from_tile_group(splash, id);
+			if (tiled) {
+				/* Left off unless its plane takes the group's format */
+				if (!drm_plane_has_format(modeset->crtc->primary,
+							  tiled->format,
+							  DRM_FORMAT_MOD_LINEAR)) {
+					drm_warn(client->dev,
+						 "splash: tile plane can't take %p4cc\n",
+						 &tiled->format);
+					continue;
+				}
+				tiled->width = max(tiled->width, modeset->x +
+						   modeset->mode->hdisplay);
+				tiled->height = max(tiled->height, modeset->y +
+						    modeset->mode->vdisplay);
+				tiled->modesets |= BIT(idx);
+				continue;
+			}
+		}
+
+		format = drm_splash_find_usable_format(modeset->crtc->primary,
+						       splash->preferred_format);
+		if (format == DRM_FORMAT_INVALID) {
+			drm_warn(client->dev,
+				 "splash: can't find a usable format for modeset\n");
+			continue;
+		}
+
+		tmp = krealloc(splash->scanout,
+			       (splash->n_scanout + 1) * sizeof(*splash->scanout),
+			       GFP_KERNEL);
+		if (!tmp) {
+			drm_warn(client->dev,
+				 "splash: can't reallocate the scanout array\n");
+			break;
+		}
+
+		splash->scanout = tmp;
+		scanout = &splash->scanout[splash->n_scanout];
+		splash->n_scanout++;
+
+		memset(scanout, 0, sizeof(*scanout));
+		scanout->id = id;
+		scanout->modesets = BIT(idx);
+		scanout->format = format;
+		scanout->width = modeset->x + modeset->mode->hdisplay;
+		scanout->height = modeset->y + modeset->mode->vdisplay;
+	}
+
+	/* Now that the sizes are known, allocate one buffer per scanout */
+	for (k = 0; k < splash->n_scanout; k++) {
+		struct drm_splash_scanout *scanout = &splash->scanout[k];
+		struct drm_client_buffer *buffer;
+
+		buffer = drm_client_buffer_create_dumb(client, scanout->width,
+						       scanout->height,
+						       scanout->format);
+		if (IS_ERR(buffer)) {
+			err = PTR_ERR(buffer);
+			drm_warn(client->dev,
+				 "splash: can't create dumb buffer %d %d %p4cc: %pe\n",
+				 scanout->width, scanout->height, &scanout->format,
+				 buffer);
+			continue;
+		}
+
+		drm_dbg(client->dev, "splash: created dumb buffer %d %d %p4cc\n",
+			scanout->width, scanout->height, &scanout->format);
+
+		scanout->buffer = buffer;
+		fb_count++;
+	}
+
+	/*
+	 * And point every modeset at the buffer of its scanout. One left
+	 * without, whatever the reason, is switched off: a mode without a
+	 * framebuffer fails the commit, and with it every other output.
+	 * Never the old one: a probe without connectors leaves it there.
+	 */
+	i = 0;
+	drm_client_for_each_modeset(modeset, client) {
+		unsigned int idx = i++;
+
+		modeset->fb = NULL;
+		for (k = 0; idx < 32 && k < splash->n_scanout; k++) {
+			struct drm_splash_scanout *scanout = &splash->scanout[k];
+
+			if (scanout->buffer && (scanout->modesets & BIT(idx))) {
+				modeset->fb = scanout->buffer->fb;
+				break;
+			}
+		}
+
+		if (!modeset->fb)
+			drm_splash_modeset_off(client->dev, modeset);
+	}
+
+	mutex_unlock(&client->modeset_mutex);
+
+	/* -ENODEV without a usable modeset, which hotplug only logs */
+	return fb_count ? 0 : err;
+}
+
+static void drm_splash_free_scanout(struct drm_client_dev *client)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+	struct drm_mode_set *modeset;
+
+	/*
+	 * The modesets must not point at the framebuffers freed below, nor
+	 * keep a mode without one, which would fail every later commit
+	 */
+	mutex_lock(&client->modeset_mutex);
+	drm_client_for_each_modeset(modeset, client)
+		drm_splash_modeset_off(client->dev, modeset);
+	mutex_unlock(&client->modeset_mutex);
+
+	drm_splash_delete_scanouts(&splash->scanout, &splash->n_scanout);
+}
+
+/* Under the lock: set the scanouts up again, for the work to draw */
+static void drm_splash_rebuild(struct drm_splash *splash)
+{
+	struct drm_client_dev *client = &splash->client;
+	int ret;
+
+	/*
+	 * Every hotplug starts over, with the outputs there are now. The
+	 * scanouts on screen stay there until the work or restore has
+	 * committed the new ones; with some still waiting for that, the
+	 * current ones were never committed and can go.
+	 */
+	if (splash->old_scanout) {
+		drm_splash_free_scanout(client);
+	} else {
+		splash->old_scanout = splash->scanout;
+		splash->n_old_scanout = splash->n_scanout;
+		splash->scanout = NULL;
+		splash->n_scanout = 0;
+	}
+
+	ret = drm_splash_init_client(splash);
+	if (ret) {
+		/*
+		 * It may have set up scanouts before failing to get buffers.
+		 * Those on screen stay there, for the next hotplug to replace.
+		 */
+		drm_splash_free_scanout(client);
+		if (ret == -ENODEV)
+			drm_dbg(client->dev, "splash: no usable modeset\n");
+		else
+			drm_err(client->dev,
+				"splash: failed to init client: %d\n", ret);
+
+		return;
+	}
+
+	if (!splash->source_picked) {
+		splash->source_picked = true;
+		splash->use_bgrt = drm_splash_bgrt_available(splash);
+
+		/* If no other image has been loaded, try to load a BMP as firmware */
+		if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_FW) && !splash->use_bgrt) {
+			ret = drm_splash_fw_request(splash);
+			splash->fw_requested = !ret;
+			if (ret)
+				drm_err(client->dev,
+					"splash: failed to kick image load: %d\n", ret);
+		}
+	}
+}
+
+static int drm_splash_client_hotplug(struct drm_client_dev *client)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+
+	guard(mutex)(&splash->lock);
+
+	/*
+	 * As fbdev: with another master, nothing the splash draws can be
+	 * shown, so the outputs are set up again only at the next restore
+	 */
+	if (!drm_master_internal_acquire(client->dev)) {
+		splash->hotplug_pending = true;
+		return 0;
+	}
+	drm_master_internal_release(client->dev);
+
+	splash->hotplug_pending = false;
+	drm_splash_rebuild(splash);
+	drm_splash_queue(splash);
+
+	/* An error would stop the hotplug events: let the next one retry */
+	return 0;
+}
+
+/*
+ * The work draws whatever is missing and commits, but not while the
+ * device sleeps. An output without a buffer has no mode either: the commit
+ * switches it off.
+ */
+static int drm_splash_client_restore(struct drm_client_dev *client, bool force)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+
+	guard(mutex)(&splash->lock);
+	splash->restore_pending = true;
+	splash->restore_force |= force;
+	drm_splash_queue(splash);
+
+	return 0;
+}
+
+static void drm_splash_client_unregister(struct drm_client_dev *client)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+
+	/*
+	 * Hotplug, restore and resume no longer come. The work can make a
+	 * firmware request too, so it goes first.
+	 */
+	cancel_work_sync(&splash->work);
+
+	/*
+	 * A firmware request cannot be cancelled, and its callback uses the
+	 * splash and queues the work: let it finish first. It is usually over
+	 * already; at worst this waits for the firmware fallback timeout,
+	 * with clientlist_mutex held.
+	 */
+	if (splash->fw_requested) {
+		wait_for_completion(&splash->fw_done);
+		cancel_work_sync(&splash->work);
+	}
+	drm_splash_free_scanout(client);
+	drm_splash_delete_scanouts(&splash->old_scanout, &splash->n_old_scanout);
+	drm_splash_image_cleanup(splash);
+	mutex_destroy(&splash->lock);
+
+	/* Last: it ends up in drm_splash_client_free(), which frees splash */
+	drm_client_release(client);
+}
+
+static void drm_splash_client_free(struct drm_client_dev *client)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+	struct drm_device *dev = client->dev;
+
+	kfree(splash);
+
+	drm_dbg(dev, "Freed drm splash\n");
+}
+
+static int drm_splash_client_suspend(struct drm_client_dev *client)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+
+	guard(mutex)(&splash->lock);
+	splash->suspended = true;
+
+	return 0;
+}
+
+static int drm_splash_client_resume(struct drm_client_dev *client)
+{
+	struct drm_splash *splash = client_to_drm_splash(client);
+
+	guard(mutex)(&splash->lock);
+	splash->suspended = false;
+	if (splash->work_skipped) {
+		splash->work_skipped = false;
+		drm_splash_queue(splash);
+	}
+
+	return 0;
+}
+
+static const struct drm_client_funcs drm_splash_client_funcs = {
+	.owner		= THIS_MODULE,
+	.hotplug	= drm_splash_client_hotplug,
+	.restore	= drm_splash_client_restore,
+	.unregister	= drm_splash_client_unregister,
+	.free		= drm_splash_client_free,
+	.suspend	= drm_splash_client_suspend,
+	.resume		= drm_splash_client_resume,
+};
+
+/**
+ * drm_splash_register() - Register a drm device to drm_splash
+ * @dev: the drm device to register.
+ * @format: drm device preferred format.
+ */
+void drm_splash_register(struct drm_device *dev,
+			 const struct drm_format_info *format)
+{
+	struct drm_splash *splash;
+
+	splash = kzalloc_obj(*splash);
+	if (!splash)
+		goto err_warn;
+
+	INIT_WORK(&splash->work, drm_splash_work);
+	mutex_init(&splash->lock);
+	init_completion(&splash->fw_done);
+
+	if (format && format->num_planes == 1) {
+		splash->preferred_format = format->format;
+	} else {
+		unsigned int mode = dev->mode_config.preferred_depth;
+
+		/* As fbdev: 32 bits per pixel, unless the driver wants fewer */
+		if (!mode || mode == 24)
+			mode = 32;
+		splash->preferred_format =
+			drm_driver_color_mode_format(dev, mode);
+	}
+
+	if (drm_client_init(dev, &splash->client, "drm_splash",
+			    &drm_splash_client_funcs))
+		goto err_free;
+
+	drm_client_register(&splash->client);
+	drm_dbg(dev, "Registered with drm splash\n");
+
+	return;
+
+err_free:
+	mutex_destroy(&splash->lock);
+	kfree(splash);
+err_warn:
+	drm_warn(dev, "Failed to register with drm splash\n");
+}
-- 
2.39.5

