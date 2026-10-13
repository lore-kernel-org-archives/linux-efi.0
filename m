Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2617340D576
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884002; cv=none; b=nh6ZIPdDQU1KhrUNT6MuMknUIsn63xDe5tTubTT33xiGn6X4vLH2zh9GFjrq91dfZqfF4S/V1cd7CkpzjPw5nrz/Nkeham6eHlFiOkxQ6iTT/E7ZJSLUVJEjE32LO94p1m//mlDHLB4WDvbuXWu2Hz7QQbnjAU8GHWRpv85ZgQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884002; c=relaxed/simple;
	bh=Yi+b9T2Ylb6sAXjzeQP0m3/BqH90GSxybJETmVu1asQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWzR+aCBFPF/RLNAjxGYtih1WgGJ2wqfyxenWNom+dRVniphzPnCR6wXx9QvrCOqyfKqVJ+FmXsd8oclg45SV3h6howNtGouJEWlvwY9LW4KyPsKRmKlk2aCrX1Y0WaNpNeslw/WXAEWPWeDEITy3CMTJqDaGS8fKSeUaqefyB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jm6dyr+v; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jm6dyr+v"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b03f23305so2298607f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883992; x=1792488792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m2zoYDz7tkLEOcidCJHUPELWMh9Gsou7ImUMY6ioATo=;
        b=jm6dyr+vwfy81d3TgikHRx7y2iOy+/PLlJe1pmod2MEHABSac1w9MmV0bB1LC0iOBm
         VFb+lVfnbGQCDfZKVJIgCPVGu7EwCogVqdU0P9fXhfIAp71NK7RycebUFaS4mAvmqaOM
         EQRH+dQZhR7fgPXYP+WqqLYfaQWmDaylBHoUXYQse2e2PFM226L5UZZqYCH42em4I56r
         1/+bNFqoWFnsEhQWU+8g+tZRVzpYo/POI/DE+3zwzXXvyaX+uAAn7KulOiCKXdc6Eb+k
         qK9l+UGyoMlDt3eedbRpASzZAQha+On0R1Ui8R/6POLPYe6gfHqOQLAaSE3UIYqnMq+k
         Rh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883992; x=1792488792;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2zoYDz7tkLEOcidCJHUPELWMh9Gsou7ImUMY6ioATo=;
        b=1jZ4G8/WKI+afbGHNCuh3izaxrhOCfwLZkfPCc81YSNCNcYKUZ7tpgjvjg6GYJJpzS
         1x8pEcq5eA6AkZqMoPOc8oVwX9lIJ7iDoq6ZNmXs1wDWgZEhXdmwJhPkAD9uVKgbh07f
         l34Q0vj/tFrBHhl2fKGrrMDdyywJEUtKmcqkxfCNiGui8hATC8aqHptc9U20wKFxVzrn
         XGUzqGvaR3wZXYszny8WihnpJIIJ/OXDHvtjylcaZlfpVKr15i5pXfroIaj097t3Zp5T
         HCXzwMwoV5NS1z7DQbaawgV8SSPcfM4TWZnXrsTt6FCu17y/iEsQC3rxlM7d0Dtny1i8
         S9Fg==
X-Forwarded-Encrypted: i=1; AKwUvBwvxb+scTFxt33n3W3yQ5fHgKq2jELV+3t4u4fZFX/TKNSXDgmMm9iNykkMsrgSPIL7N/OJKIAOtIU=@vger.kernel.org
X-Gm-Message-State: AFq9FYIYpCOASzwT/TkQdias0g4F0OCvzF6Lw1IgOMcAShy8bpITlE4d
	mng1HsXgE2RqynxRFQwsGjQXxbEw79T4Y3fkb53thRD6wWNSRwuH9btC
X-Gm-Gg: AYBFou39ef+lmQGvjIc8zDfO8OadXtP7N+1HO5EyDTnIFzVSM4CelfZyObRa5slY3SQ
	ArpGG2Brm0bKQvXRKc5quFArzNVx27uAPpo6UVmmXX4zvcfek4br7qixgJjrrDP0lxi4Yrpd3u8
	vFKk64R3NloOPO9nBLo2HK9VE/g4lUAiEcSGH6C3i/eEKbXF62xSyPjfYR+bSJU3C6duEWtwT8t
	VwbIA70ivJjf5t3xT5i6mdm4sOgUNhucDihCz5ngHDN9krbPA1/D3lvk8aLu01axBx6Tj9k2VUM
	GE2X+LVoGSIxVVHZa5QP89RSSgb91nA4JwEOsTDcUFHkw3GcN3Fr0cl0kOf4C1cC0g+HZrpALYv
	aCZSLHOv+E5MWX6jZzXr+WSGoVnMONCuxx/gmdRuDvn+x9k5AQwxPhm4iqaE5hJJEO3s5d2atV3
	O4LFd6B28+dctrHXStuc1y7TbGIy+3VPHOD7LJjjvUzy5ODAsxb/uRv57N0fIg7vMbDnpKxoy/l
	hht+yQzBnBrkH3PTwrGw/Vq
X-Received: by 2002:a05:6000:4310:b0:48a:f1fb:e165 with SMTP id ffacd0b85a97d-48dbaae39e0mr21823017f8f.21.1791883992057;
        Tue, 13 Oct 2026 02:33:12 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:33:11 -0700 (PDT)
From: =?UTF-8?q?M=C3=A0xim=20Pedraza=20Padilla?= <maximpedraza@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
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
	devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/13] drm/client: splash: take the background colour from the image source
Date: Tue, 13 Oct 2026 11:32:40 +0200
Message-Id: <20261013093243.505776-11-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013093243.505776-1-maximpedraza@gmail.com>
References: <20261013093243.505776-1-maximpedraza@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A logo designed for a light background looks wrong framed in black, and
products that share a board support package differ in their colours as
much as in their logos. The background colour belongs with the image,
so take it from the same place:

- a device tree image uses the optional "background-color" of its node;
- the BGRT carries no colour, and firmware splashes sit on black, so it
  uses the kernel's default;
- the BMP loaded as firmware is named on the command line, and so is its
  colour, through drm_client_lib.splash_color, which also covers the
  screen when there is no image at all.

CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR remains the default wherever
the source says nothing. The command line no longer overrides a device
tree image: a bootloader that wants another colour for a given boot,
say to flag a failed test on a production line, changes the node.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/Kconfig      |  7 ++++--
 drivers/gpu/drm/clients/drm_splash.c | 36 +++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
index aef3781cc110..f471019bab87 100644
--- a/drivers/gpu/drm/clients/Kconfig
+++ b/drivers/gpu/drm/clients/Kconfig
@@ -105,8 +105,11 @@ config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
 	help
 	  The default splash background color, in RGB888 format.
 
-	  The color can be overridden through the drm_client_lib.splash_color
-	  kernel command line parameter.
+	  The background color comes from the same place as the image. A
+	  device tree image can carry its own, and the drm_client_lib.splash_color
+	  kernel command line parameter sets it for a BMP loaded as firmware,
+	  or for the whole screen when there is no image. This color is used
+	  otherwise, and always with the BGRT image, which carries none.
 
 config DRM_CLIENT_SPLASH_SRC_DT
 	bool "Device tree as splash source"
diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index fdf398987007..463aff27c747 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -42,7 +42,8 @@
 
 static unsigned int splash_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
 module_param(splash_color, uint, 0400);
-MODULE_PARM_DESC(splash_color, "Splash background color (RGB888)");
+MODULE_PARM_DESC(splash_color,
+		 "Background color (RGB888) around the BMP loaded as firmware, or of the whole screen with no image");
 
 #if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP)
 #define DEFAULT_SPLASH_BMP "drm_splash.bmp"
@@ -133,6 +134,8 @@ struct drm_splash {
 	s32 off_x, off_y;
 	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
 	unsigned int rotation;
+	/* RGB888, from the same place as the image */
+	u32 bg_color;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -271,12 +274,18 @@ static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
 	return NULL;
 }
 
-/* The optional placement properties of the node, read once */
-static void drm_splash_dt_placement(struct drm_splash *splash,
-				    struct device_node *np)
+/* The optional properties of the node, read once */
+static void drm_splash_dt_props(struct drm_splash *splash,
+				struct device_node *np)
 {
 	u32 val[2];
 
+	/* The colour travels with the image, or it is the kernel's default */
+	if (!of_property_read_u32(np, "background-color", &val[0]))
+		splash->bg_color = val[0] & 0xffffff;
+	else
+		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
+
 	if (!of_property_read_u32_array(np, "logo-position", val, 2)) {
 		splash->pos_x = (s32)val[0];
 		splash->pos_y = (s32)val[1];
@@ -365,8 +374,8 @@ static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
 	return NULL;
 }
 
-static void drm_splash_dt_placement(struct drm_splash *splash,
-				    struct device_node *np)
+static void drm_splash_dt_props(struct drm_splash *splash,
+				struct device_node *np)
 {
 }
 
@@ -780,13 +789,22 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
 
 	np = drm_splash_dt_node(splash);
 	if (np) {
-		drm_splash_dt_placement(splash, np);
+		drm_splash_dt_props(splash, np);
 		of_node_put(np);
 		return DRM_SPLASH_SRC_DT;
 	}
 
-	if (drm_splash_bgrt_available(splash))
+	/* The BGRT carries no colour: firmware splashes sit on black */
+	if (drm_splash_bgrt_available(splash)) {
+		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
 		return DRM_SPLASH_SRC_BGRT;
+	}
+
+	/*
+	 * The BMP loaded as firmware is named on the command line, and so is
+	 * its colour, which also covers the screen when there is no image.
+	 */
+	splash->bg_color = splash_color & 0xffffff;
 	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
 		return DRM_SPLASH_SRC_BMP;
 
@@ -844,7 +862,7 @@ static int drm_splash_render_thread(void *data)
 
 			if (!scanout->bg_drawn) {
 				drm_dbg(client->dev, "draw background for scanout %d", i);
-				u32 color = drm_draw_color_from_xrgb8888(splash_color,
+				u32 color = drm_draw_color_from_xrgb8888(splash->bg_color,
 									 scanout->format);
 				drm_splash_fill_solid_color(scanout->buffer, color);
 				scanout->bg_drawn = true;
-- 
2.39.5

