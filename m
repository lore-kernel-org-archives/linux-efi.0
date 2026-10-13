Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C2D23ABBF
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884003; cv=none; b=AtCqcCMYpXKp/1L4OS+SBkb4fogvjo6+mOi1Xj0NE3t303V3E6M1NCl/r7hi/Fvafgv/dyqyrCoYO7MP8ImY8/vIfgrAxgs3RPyEbIX1xAeDYxPb7oo0aAMdGIgXscT6mysxWxlIZR+jD+oIrq3F+AXK896fbPLIAal9Ic/odAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884003; c=relaxed/simple;
	bh=YvJn3mgp+G2nNJenwP7MUHb52rQiyc3j0XLaFzt4CjU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nCw0dNLoVJbkfAFTpYrlX5JKKdjHqb9b7h8X5gYtB6+1hiN2+76ewsZ23Nbvi3r5CrOmLrSmFLi283ZtnqpH0mmIXKDPUbjEtFHlonl0UYiHERNtRyX8WxbYewmpYIi9rO0YUkn4U2W10xl8wSjdvDCv3cjV3mQmekyIiqOb8xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U6vNW4UK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U6vNW4UK"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4649b35bso2535491f8f.3
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883997; x=1792488797; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LM9A0gS+GUhvPMZ4n822fJ+RM9SgTpNw1m9EuwRvulQ=;
        b=U6vNW4UKyDFrdDQXFh73JpADoASIYKSdQxlQFQUBCfYvrJU01SmSI5Fb1ltQTEaiyS
         l02T7EkyE4WORGSyVb/zvZulz+hHlsXU/CVoPE3iJtKp21s8h7N01aG0qP4Ef2w/7DYx
         gClycBAeX+fx690UjLIDa9YuqMAmbe1aypAWueda6hZ3eH4qz0dNdByCEgjwV+5d2bHH
         uOq502EY+ObvZQyYD5rK6hU47Wdx+JhWv4fw0JWIHXIrQknVLd8V03aqpsfKbUmpkg9K
         LXE7CUXeg5CcLvHRVVQnAzcQAMV8vl9ai2afpJrVW/gHD2EFFaXUORRkZaufPiMLnwhV
         SPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883997; x=1792488797;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LM9A0gS+GUhvPMZ4n822fJ+RM9SgTpNw1m9EuwRvulQ=;
        b=GbQTxh1jlbuvUA3+ZaV0Td2JwqwBa4cRwlZAei1/miaKEZLLOQl70iCEuezqKvjlH9
         T7W61d6zwIoeZ9o87MxjLHEFcy1xj2vnu2lXKZivakmm8fhWSIwTiLXJ4zUO7plHlAHi
         3uW9ZMGmrh/lQvIdus3YIQSvwCe7aBC47EtB+KfQQcJdDEbj6LLRp3i57NYKFVj1OOJx
         dm18Kq6v6m1IaYQqF1eOQgqFwKWA96MGPlhE9FEH7dF3z1wpiOQ1EPzE/nPvNw9Jcasj
         wEoYTDlJnauvinkPREOxpPDY4teSqhFl6dt+jRWtMzp8L8Cjv8EOPHp7LXznf9hFgSPP
         MKRg==
X-Forwarded-Encrypted: i=1; AKwUvByOYDWvfRJne4f7+estmLSfRAP3DFqAGWRKZfNFLsWv9i9RdHid/7dGTGeFq6Hd8YGUNQhtKhaX4ow=@vger.kernel.org
X-Gm-Message-State: AFq9FYIqoDD2jYl1D/4nJRKi4+NX6rxQ3ussns+JA5IJh3FytnvCI604
	BBNJxiZpcsxy6RIHSyHWQoIZSquLGodHZhI6WvmD8MwIwPsKjy+JhJHF
X-Gm-Gg: AYBFou00SYiB/sbXrjtloS5vaBdc6kmsJLrhUGOZ8I+7dbS7yOdk7o3fYInweOIu1WG
	fo6CtAEi+if1heHpATk+d1q4POdZVgFVbGJjiw9usLxYFEduqPbbN8eMX7Zbqo+wMAq7aSAixfF
	p1ffvlHft16Xcv92NW+naIy6EemHyCOLGiR9iCp+Pqyv0hc5dzfC8KvlDQtC2k+K1ehWXyC88xj
	jyf4jp5yC29Imv7+NkQY9HaX8WHHvoriVncUzI9JvEWX8G5YUcSJ2BksZOxzP9pgx8u+KD4DOlA
	lKpC2fxISITmJX4sVyC3GXMIhbo1HVH+/SnE9dmI4aFYa8hUzZhskOvVVbh8DTwM134LIGTiMs9
	0cYfBjz1bF6BLmc0BS48018xnq0oD3U3W3Z8eDYKCDclr9hDfXDBD98/yD1V9ORrYEG6RIhNfA5
	ykvflL0VPHe0CN0od3/X0Rwt4d19y7IlhF1avZ0G1/8VKPRXOw2nRD9KnzgULJp1i1ZtvyH2djl
	tqaGn6cH1mDzYki/8txYYku
X-Received: by 2002:a05:6000:2601:b0:48a:f571:7b50 with SMTP id ffacd0b85a97d-48dbaae7245mr24206423f8f.27.1791883996456;
        Tue, 13 Oct 2026 02:33:16 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:33:15 -0700 (PDT)
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
Subject: [PATCH v5 12/13] drm/client: splash: prefer what the command line asks for
Date: Tue, 13 Oct 2026 11:32:42 +0200
Message-Id: <20261013093243.505776-13-maximpedraza@gmail.com>
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

A logo or a colour given on the kernel command line was asked for this
very boot: a bootloader that picks the product variant from an EEPROM
and passes it along, a developer, or a production line that turns the
screen red when a test fails. The device tree, the BGRT and the kernel's
defaults describe what the board or the build normally wants. Let the
command line win, as console= wins over stdout-path.

Each parameter wins for what it says, and only when it is given, so
none has a default of its own:

- drm_client_lib.splash_bmp names a BMP to load as firmware, preferred
  over the device tree and the BGRT. Without it the order is unchanged:
  device tree, BGRT, then "drm_splash.bmp" loaded as firmware. An empty
  value counts as not given. A file that is named but missing gives no
  image rather than falling back, since it is what was asked for.

- drm_client_lib.splash_bmp=none asks for no image at all: only the
  background is drawn, whatever the other sources have.

- drm_client_lib.splash_pos=X,Y, splash_offset=DX,DY and
  splash_rotation=0|90|180|270 place and turn the image with the same
  meaning as the device tree properties, whatever the image's source.
  A BMP loaded as firmware has no other way to be placed or turned, and
  for the others they let a placement be tried without rebuilding a
  device tree. Positions take both values or are ignored with a
  warning. When they place a BGRT image, it is placed in screen pixels
  like any other, and neither the table offsets nor the efifb sanity
  check apply.

- drm_client_lib.splash_color sets the background whatever the image.
  Without it the colour comes from the source that supplied the image,
  a device tree node's "background-color", and otherwise from
  CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR. A device tree colour is not
  used around an image named on the command line: it belongs to another
  image.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/Kconfig      |  20 ++--
 drivers/gpu/drm/clients/drm_splash.c | 171 +++++++++++++++++++++------
 2 files changed, 142 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
index f471019bab87..2a374bea370b 100644
--- a/drivers/gpu/drm/clients/Kconfig
+++ b/drivers/gpu/drm/clients/Kconfig
@@ -105,11 +105,9 @@ config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
 	help
 	  The default splash background color, in RGB888 format.
 
-	  The background color comes from the same place as the image. A
-	  device tree image can carry its own, and the drm_client_lib.splash_color
-	  kernel command line parameter sets it for a BMP loaded as firmware,
-	  or for the whole screen when there is no image. This color is used
-	  otherwise, and always with the BGRT image, which carries none.
+	  The drm_client_lib.splash_color kernel command line parameter, when
+	  given, is used whatever the image. Otherwise a device tree image can
+	  carry its own color, and this one is used for everything else.
 
 config DRM_CLIENT_SPLASH_SRC_DT
 	bool "Device tree as splash source"
@@ -123,8 +121,9 @@ config DRM_CLIENT_SPLASH_SRC_DT
 	  show a different logo on each board or product, chosen by the
 	  device tree it boots with.
 
-	  When present, the device tree image is preferred over the other
-	  sources.
+	  When present, the device tree image is preferred over the BGRT and
+	  over the default BMP loaded as firmware. A BMP named on the kernel
+	  command line is preferred over it.
 
 config DRM_CLIENT_SPLASH_SRC_BGRT
 	bool "EFI BGRT as splash source"
@@ -150,9 +149,10 @@ config DRM_CLIENT_SPLASH_SRC_BMP
 
 	  The image will be loaded using the firmware loading facility the
 	  kernel provides; it shall use 24 bits per pixel and shall not be
-	  compressed. The name of the file can be set through the
-	  drm_client_lib.splash_bmp command line parameter, with the default
-	  being 'drm_splash.bmp'.
+	  compressed. A file named through the drm_client_lib.splash_bmp
+	  command line parameter is preferred over any other image source;
+	  otherwise 'drm_splash.bmp' is used when neither the device tree nor
+	  the BGRT provides an image.
 
 config DRM_CLIENT_SPLASH_BMP_SUPPORT
 	bool
diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index 4c30de7c5c16..46faae025ec2 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -40,18 +40,90 @@
  * a static image.
  */
 
-static unsigned int splash_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
-module_param(splash_color, uint, 0400);
+/*
+ * What is given on the command line wins over the device tree and the
+ * firmware tables, and each parameter only for what it says. Neither has a
+ * value of its own until it is given: -1 and NULL mean "not given".
+ */
+static int splash_color = -1;
+module_param(splash_color, int, 0400);
 MODULE_PARM_DESC(splash_color,
-		 "Background color (RGB888) around the BMP loaded as firmware, or of the whole screen with no image");
+		 "Background color as 0xRRGGBB, preferred over any other");
+
+static int splash_pos[2];
+static unsigned int splash_pos_n;
+module_param_array(splash_pos, int, &splash_pos_n, 0400);
+MODULE_PARM_DESC(splash_pos,
+		 "Image position as X,Y in screen pixels, -1 centres that axis");
+
+static int splash_offset[2];
+static unsigned int splash_offset_n;
+module_param_array(splash_offset, int, &splash_offset_n, 0400);
+MODULE_PARM_DESC(splash_offset,
+		 "Displacement as DX,DY in screen pixels, added after placing");
+
+static int splash_rotation = -1;
+module_param(splash_rotation, int, 0400);
+MODULE_PARM_DESC(splash_rotation,
+		 "Image rotation in degrees counter clockwise: 0, 90, 180 or 270");
 
 #if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP)
 #define DEFAULT_SPLASH_BMP "drm_splash.bmp"
-static char *splash_bmp = DEFAULT_SPLASH_BMP;
+static char *splash_bmp;
 module_param(splash_bmp, charp, 0400);
-MODULE_PARM_DESC(splash_bmp, "Name of splash image (default: \"" DEFAULT_SPLASH_BMP "\")");
+MODULE_PARM_DESC(splash_bmp,
+		 "BMP to load as firmware, preferred over any other image");
+
+/* Given on the command line, and not empty */
+static bool drm_splash_bmp_given(void)
+{
+	return splash_bmp && *splash_bmp;
+}
+
+/* "none" asks for no image at all, whatever the other sources have */
+static bool drm_splash_bmp_none(void)
+{
+	return drm_splash_bmp_given() && !strcmp(splash_bmp, "none");
+}
+
+static const char *drm_splash_bmp_name(void)
+{
+	return drm_splash_bmp_given() ? splash_bmp : DEFAULT_SPLASH_BMP;
+}
+#else
+static bool drm_splash_bmp_given(void)
+{
+	return false;
+}
+
+static bool drm_splash_bmp_none(void)
+{
+	return false;
+}
 #endif // CONFIG_DRM_CLIENT_SPLASH_SRC_BMP
 
+/* Degrees counter clockwise, as for panels, and as DRM counts them */
+static bool drm_splash_rotation_from_degrees(u32 degrees,
+					     unsigned int *rotation)
+{
+	switch (degrees) {
+	case 0:
+		*rotation = DRM_MODE_ROTATE_0;
+		return true;
+	case 90:
+		*rotation = DRM_MODE_ROTATE_90;
+		return true;
+	case 180:
+		*rotation = DRM_MODE_ROTATE_180;
+		return true;
+	case 270:
+		*rotation = DRM_MODE_ROTATE_270;
+		return true;
+	}
+
+	return false;
+}
+
 #define BMP_FILE_MAGIC_ID 0x4d42
 
 /* BMP header structures copied from drivers/video/fbdev/efifb.c */
@@ -134,6 +206,8 @@ struct drm_splash {
 	s32 off_x, off_y;
 	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
 	unsigned int rotation;
+	/* Placed from the command line, in screen pixels, whatever the source */
+	bool place_cmdline;
 	/* RGB888, from the same place as the image */
 	u32 bg_color;
 };
@@ -218,10 +292,11 @@ static int drm_splash_fw_request_bmp(struct drm_splash *splash)
 {
 	struct drm_client_dev *client = &splash->client;
 
-	drm_info(client->dev, "splash: request %s as firmware", splash_bmp);
+	drm_info(client->dev, "splash: request %s as firmware",
+		 drm_splash_bmp_name());
 
 	return request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
-				       splash_bmp, client->dev->dev, GFP_KERNEL,
+				       drm_splash_bmp_name(), client->dev->dev, GFP_KERNEL,
 				       splash, drm_splash_fw_callback);
 }
 #else
@@ -280,11 +355,9 @@ static void drm_splash_dt_props(struct drm_splash *splash,
 {
 	u32 val[2];
 
-	/* The colour travels with the image, or it is the kernel's default */
+	/* The colour travels with the image */
 	if (!of_property_read_u32(np, "background-color", &val[0]))
 		splash->bg_color = val[0] & 0xffffff;
-	else
-		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
 
 	if (!of_property_read_u32_array(np, "logo-position", val, 2)) {
 		splash->pos_x = (s32)val[0];
@@ -296,27 +369,10 @@ static void drm_splash_dt_props(struct drm_splash *splash,
 		splash->off_y = (s32)val[1];
 	}
 
-	/* Degrees counter clockwise, as for panels, and as DRM counts them */
-	if (!of_property_read_u32(np, "rotation", &val[0])) {
-		switch (val[0]) {
-		case 0:
-			splash->rotation = DRM_MODE_ROTATE_0;
-			break;
-		case 90:
-			splash->rotation = DRM_MODE_ROTATE_90;
-			break;
-		case 180:
-			splash->rotation = DRM_MODE_ROTATE_180;
-			break;
-		case 270:
-			splash->rotation = DRM_MODE_ROTATE_270;
-			break;
-		default:
-			drm_warn(splash->client.dev,
-				 "splash: %pOF: unsupported rotation %u",
-				 np, val[0]);
-		}
-	}
+	if (!of_property_read_u32(np, "rotation", &val[0]) &&
+	    !drm_splash_rotation_from_degrees(val[0], &splash->rotation))
+		drm_warn(splash->client.dev,
+			 "splash: %pOF: unsupported rotation %u", np, val[0]);
 }
 
 static int drm_splash_dt_load(struct drm_splash *splash, const u8 **data,
@@ -702,7 +758,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		return -EINVAL;
 	}
 
-	if (splash->src == DRM_SPLASH_SRC_BGRT) {
+	if (splash->src == DRM_SPLASH_SRC_BGRT && !splash->place_cmdline) {
 		/*
 		 * The BGRT offsets place the upright image on the upright
 		 * screen, which for a panel mounted turned is not the frame
@@ -827,10 +883,53 @@ static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
  * is whatever the firmware shows, and the BMP loaded as firmware is the
  * fallback. With none of them, only the background colour is drawn.
  */
+/*
+ * What the command line gives wins whatever the image and its source, each
+ * parameter for what it says. Positions come in pairs: half of one is
+ * ignored rather than guessed.
+ */
+static void drm_splash_cmdline_overrides(struct drm_splash *splash)
+{
+	struct drm_device *dev = splash->client.dev;
+
+	if (splash_color >= 0)
+		splash->bg_color = splash_color & 0xffffff;
+
+	if (splash_pos_n == 2) {
+		splash->pos_x = splash_pos[0];
+		splash->pos_y = splash_pos[1];
+		splash->place_cmdline = true;
+	} else if (splash_pos_n) {
+		drm_warn(dev, "splash: splash_pos needs X,Y, ignored");
+	}
+
+	if (splash_offset_n == 2) {
+		splash->off_x = splash_offset[0];
+		splash->off_y = splash_offset[1];
+		splash->place_cmdline = true;
+	} else if (splash_offset_n) {
+		drm_warn(dev, "splash: splash_offset needs DX,DY, ignored");
+	}
+
+	if (splash_rotation >= 0 &&
+	    !drm_splash_rotation_from_degrees(splash_rotation, &splash->rotation))
+		drm_warn(dev, "splash: unsupported splash_rotation %d, ignored",
+			 splash_rotation);
+}
+
 static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
 {
 	struct device_node *np;
 
+	/* Unless the source says otherwise, the kernel's default colour */
+	splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
+
+	/* A BMP named on the command line was asked for this very boot */
+	if (drm_splash_bmp_none())
+		return DRM_SPLASH_SRC_NONE;
+	if (drm_splash_bmp_given())
+		return DRM_SPLASH_SRC_BMP;
+
 	np = drm_splash_dt_node(splash);
 	if (np) {
 		drm_splash_dt_props(splash, np);
@@ -838,18 +937,11 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
 		return DRM_SPLASH_SRC_DT;
 	}
 
-	/* The BGRT carries no colour: firmware splashes sit on black */
 	if (drm_splash_bgrt_available(splash)) {
-		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
 		splash->rotation = drm_splash_bgrt_rotation();
 		return DRM_SPLASH_SRC_BGRT;
 	}
 
-	/*
-	 * The BMP loaded as firmware is named on the command line, and so is
-	 * its colour, which also covers the screen when there is no image.
-	 */
-	splash->bg_color = splash_color & 0xffffff;
 	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
 		return DRM_SPLASH_SRC_BMP;
 
@@ -1169,6 +1261,7 @@ static int drm_splash_client_hotplug(struct drm_client_dev *client)
 	splash->thread = thread;
 
 	splash->src = drm_splash_pick_source(splash);
+	drm_splash_cmdline_overrides(splash);
 
 	/* The BMP loaded as firmware is the only source that arrives later */
 	if (splash->src == DRM_SPLASH_SRC_BMP) {
-- 
2.39.5

