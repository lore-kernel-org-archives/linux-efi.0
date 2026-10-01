Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E512249DB9B
	for <linux-efi@vger.kernel.org>; Thu,  1 Oct 2026 19:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884755; cv=none; b=NZpgSt5VNLFWnhmvt5OseXeVCP5DlUGd35yRkOPG87Hwo4gf4ohZOgquF0UTAIyfcrZ3786ocSYFCaobTGQweZNON66hrQ33uCEiNq5Ru83+/YgI99rmkULB3SAbDeQ4KEGbfGUT28BnuMwYvsynwlqrWpEH6PGp83Ka/DVGRxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884755; c=relaxed/simple;
	bh=pOnPiIGVi0ELicA6oznYH/UpDCA4kjJ7SFKYfwZalns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuEvwfFoTkmqfG9NJS1OMcK4Bw5c9r3yGsSj4UJpKNhuPPX5Pe6JBzSAQr2iv4E8pXC8STOWWScRbG7d8p+2OV5iPz6z4MU0bDkDo0s+oQx+FDeuunFA3wWxU7sBfcAR6Q93Ow9JhYpb2wW4HudYDxBYf0iRGWsrm3r6FDLlz0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U0VowFWG; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U0VowFWG"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c41135so1563772f8f.0
        for <linux-efi@vger.kernel.org>; Thu, 01 Oct 2026 12:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790884750; x=1791489550; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RA+5l49YL1R26v92bmYI09ptxDfVsC8dW7PotI97hnM=;
        b=U0VowFWGuoqwr6UMTX8tC8/bcYhEZcnzkhgVwKdY7Q3XhRvAKSIYQtW4+7lRhRUg24
         z5Fvp6t9yOlU3p0VsDsZnnbJR0IrNqolhIBVDaC/93NSQgtNgArqsY8NrNTA8B1Swavt
         FQkDJG343W0FwdlBSYE6Kc7Ciw5TYEjxz7vPktzIzhwyvGdC6CQgapa1eNalUaBTd1MJ
         QX4a/o1VQ2ZS9X6Uy1OFbJPKaPbGdhZthVWOcoKJC+AjRrp7hYt2XcMMNubc5HVnd48B
         Y+2sbtR4UbCEP0v+nUVCfZBtfwg4CTnoFEw1XvEqgYVVo9emq5eDcIZtPVNHRkLasQVn
         7L0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790884750; x=1791489550;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RA+5l49YL1R26v92bmYI09ptxDfVsC8dW7PotI97hnM=;
        b=MGFKiJ8G6bdSopdD/Ywzint7n6due3rOywdWVg8PuLUraIX9CfhWbXJ0+BHq52FilR
         EdZTmwgjayiUo+FSoYEW8VKK7NjbLfZMj8euNQAiAM56nxf8X6WpAfsdwBaVFAeUDI0S
         NuD4T4lfv0/t1dvb7EevV9DaW1zkj/Vvhxg5Mm3VXnL9/XucSyK4i1RR80DTmTgFBhEC
         t5Bqso3sM8SidGdF5XmdfNQxgxgbro8S2KxqcKZbP8DU4Yf1xyWfjSbxYonpQfrXNmjx
         RKkJtb+phTn5cNAuv7F0tIKJXkkrBz++TNQZiL3pPPaHinr+dxlncaoXSdSyERYQtk6X
         Y3ug==
X-Forwarded-Encrypted: i=1; AKwUvBzEyHK+EholvuO4T4orfHzVJn19TgI4DSlgOCxpMGPrVtJa5f3owmspQPTjafckYXHNJP2FhnHKM04=@vger.kernel.org
X-Gm-Message-State: AFuF++lr4tItBvIKU9N2daPxwccNcoEH6a2ZXEL0gRHk0RZVCQmoLFC/
	i2B1nsv7JepcRi2Ay/0i/A15uuomWEASoxCa7+7rPuoRVZDNC77oIB3y
X-Gm-Gg: AYBFou3bSSo5dKIA5CxqhnN38prbijxQGKlY5HMkcpomaEQfTgxuFqDfzOZmEBVxLo2
	qwfIP0FbNUgVzTdHYyNK9I4b24sbM8XA2NrF7SZT7HIsQmD4vFu95dFt10qJ08ZCKbCPpiGer4b
	qVnMDuFkfL5Ceekcdcc1z0CfttHK8IKWRoja9aVlRhXrXfJzKVuw2llX/yMP4VnqU54U+Tgq9+0
	uTyK9Yi+UbcZzBAUQuuaeER2yQsq4WioXuGP8uZfe+MbsJtYmnkbM12QA8CX/1+2v5UmNqS77jC
	/Bc/cIxihKr/0QePH36dNukTMmWHS9WBqluRoO9HmO3wG0kamb8f6yCVqa52lLktWGamwgd8w8B
	mOoF1t3Adh2fzWe0pvg+YMvzg1tgRpv3fEpY/6L109zpv/XabRUvVAI4p/t215BKXWJeaBQ4cd/
	D97PU/lRG0RtqjougS92aPrHeiTNFcS/rYPEGKW4W1FKjXnZ9oDQKHNSI+i1uPt7bkjmE+9wVUw
	m4UO5uK4wIKRbkpKTAtak8ARGqHDmfLl3Kn
X-Received: by 2002:a05:600c:3152:b0:49e:7c8c:361d with SMTP id 5b1f17b1804b1-4a027584bc4mr11324875e9.22.1790884749758;
        Thu, 01 Oct 2026 12:59:09 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0276f92d9sm15031045e9.4.2026.10.01.12.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 12:59:09 -0700 (PDT)
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
Subject: [PATCH RFC v4 10/13] drm/client: splash: take the background colour from the image source
Date: Thu,  1 Oct 2026 21:58:44 +0200
Message-Id: <20261001195847.141192-11-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001195847.141192-1-maximpedraza@gmail.com>
References: <20261001195847.141192-1-maximpedraza@gmail.com>
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
index 924bc0032d1d..30ba6573424e 100644
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
@@ -131,6 +132,8 @@ struct drm_splash {
 	s32 off_x, off_y;
 	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
 	unsigned int rotation;
+	/* RGB888, from the same place as the image */
+	u32 bg_color;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -263,12 +266,18 @@ static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
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
@@ -357,8 +366,8 @@ static inline struct device_node *drm_splash_dt_node(struct drm_splash *splash)
 	return NULL;
 }
 
-static inline void drm_splash_dt_placement(struct drm_splash *splash,
-					   struct device_node *np)
+static inline void drm_splash_dt_props(struct drm_splash *splash,
+				       struct device_node *np)
 {
 }
 
@@ -801,13 +810,22 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
 
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
 
@@ -865,7 +883,7 @@ static int drm_splash_render_thread(void *data)
 
 			if (!scanout->bg_drawn) {
 				drm_dbg(client->dev, "draw background for scanout %d", i);
-				u32 color = drm_draw_color_from_xrgb8888(splash_color,
+				u32 color = drm_draw_color_from_xrgb8888(splash->bg_color,
 									 scanout->format);
 				drm_splash_fill_solid_color(scanout->buffer, color);
 				scanout->bg_drawn = true;
-- 
2.39.5

