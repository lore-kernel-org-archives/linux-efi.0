Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109260;
	b=tsAfAvuLybHImHOqpsyGDJo5ei/zwaAPvYZE9ER+n+9ZjlaJ21Eyc7tHY4UhSZVsBZIA
	 onEglFO8bYDvxGVc9wUdsly8UeMDgix4J2aTTpNlxI6uyFK1Qtz3wtmfCV8UZJ4Ug459v
	 Ufmm91v5FFg/tCuGiAwGw34ZwnPWmhxC7iwCHYk463+37zhmArNwEXz4aCZj+ZrdZzTnJ
	 jqtbmZWZevUX+Iq9iEE3vC2b/DgagHJiJzMNsZ7nY3uQozksdfqArMU66EbfJyVw9dj+o
	 ByYkwCENL592k4bIF6mvolJivqG3rvYtoDRIIbKToqs3pFpf68F6Ywu1P175nYOudoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109260;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2Cr8yXgXPrHXAzcdb5EqwLzthXaUR2aKGPBEfEhJvCs=;
	b=X0Glj0sbyOxrcvwsxtU5n+nNgPytnpiTZGaIXgnkQzixK/lsI4IimkHBNBMkAmi/cASf
	 WQLRqI7xwQgtxfEdSJDiLaAt1DnTTwahfkmDvS3747zFMTa+2v3GHPB9NH/eF2C6kNUHn
	 GhcCYPkdeQndbKF/lLxVU2PJXfbDEU5wQ27GhZ/ailKx/k+BCMhrxAPr808jpPOx41n2t
	 fZU+OJNi3COfw8nVLbAB6AU43b3iHn0VIEunSt99cEQmvoydWyZ+NYVdXXHZOIaPEqM8H
	 EsSyAxaC0jDtDxg4B5myrK/Z1ae0qqpnxEAQADaR6HxGtd+fgBkY2CtFNymW8wZAFGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lxvZyNfZ;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4123B606AA3E
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:54:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4123B606AA3E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lxvZyNfZ
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c46bd7a7345so184634066b.0
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109258; x=1793714058; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Cr8yXgXPrHXAzcdb5EqwLzthXaUR2aKGPBEfEhJvCs=;
        b=lxvZyNfZbfmHwFAoI3uJn6Hz92WtopUiZu/E5Qd/S0nXBokt56ZhrCi4ZAUs18mzpA
         q4NrbE7Os9ZkdGXYwG/QmzGnnN0YvyVW9Ajvk607uMe8LJcijQKm+b8pmTdYqX7Rdggq
         qsT06RnqOu9xxUN0NoAkbCf7XEV8F6sQJeWkkD4ZztAORwkkrgU1zp/i7uL5S/Cr5Zpg
         cUcar/gHQ97/SboFYldgFSeKHwOfH8t6Cqh3xbzS1/TE1usRz3iQDLyrOUuinwH5wh4K
         6KcE0pSsmNKZAHWYqc0u+/KGhUEJ2M+ncwdakNOeYY5Ku5fahr4LrXIn6mg+kNRoYcPe
         mVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109258; x=1793714058;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Cr8yXgXPrHXAzcdb5EqwLzthXaUR2aKGPBEfEhJvCs=;
        b=2a3cX8g8q1BsN23RmwsMhyWHFdrgOlbDKvpPiyVWBq3BDVPakreZHlnF1slETHtn3O
         ZLzxnPYJATfc3tywPbjxsElK+4j563VeJR/CkDvuuv2erxLQZoNfkhCT63gjHG6gL3jz
         Nv+SDQjup6jBs6GabRaT3kH2TYh4mtl/P9PZO2JZCbAuA0DVtJ0eiqTkcFRMIF7YUUqa
         drMEIUnJBwM/ISufh9QGca/1gI+CD8cRRTtjAIKGzAfg+VZAjGCBKaorDeZJ0mAarORD
         FD54zVzFnT9iEmhYbHjioolBr5t89dUQFy4ukQoTXFYzS0KhcvZMfZFn1KONFpUI929/
         coag==
X-Forwarded-Encrypted: i=1; AKwUvBzGkAi8KRMJJj1Nh4tNNAfyAHfdVSwCZdt6p9gHFJloRMcW6lQi6LdGpTR+hwKyZAe9+MCjK5ny26g=@vger.kernel.org
X-Gm-Message-State: AFq9FYJk2UUa3p6+eJ7C20nobLAd4l8FLQzkm5kQsSeoHhd338iwYYRG
	qXe6gfLl0uOegba/6GjTMj8Gg1Yi4IIyapxCQcM7fE6LrhbA5MzB03dI
X-Gm-Gg: AYBFou1gyioZ3m9g6PRZtZF+WBO2lyUuL9Ut1PC2ihsM64xDLbVXddgD5Sgn3LDysJ2
	sAMJO6gGQci7IPhA+gGLnsayi76nraYAlLdnCkCyk6rgUqkjpIFb/11c9rerAnFBFnGhLpeRdxB
	GlbZ7EmvNWUqP8Z4+MpOFNLXFHkuxabnglvrhEvPEyj7r7ALbyZ/X6kdD6dOAoFgbnqM9DJ6yX3
	tbR/58M4TN/GOcH7BGW3Kc80nHluQdGN+UKiElOhSaUYObZ2oqQznUIzawQAU959vrRnwHfZKwd
	4i5nTc0A6IKjGPM0owT2GpfsSUxanGKWZTYouAHzgDFQu7F7mWWs7uQrsU/O/LBKyexU7NyoY46
	tpYhG2fE1yq+XlNnZjLWq/EpSZUeBY0bot4DLkC0GZwFPpWpkdmfOzMSgAcui7kztxeXv9ntYLr
	iOBLfOXgG33EZoK39tR9nbzGR5hrLd0KGJ/48MuGWta34KluO8BNQY/0qvky4V8novfjxwiA8Ua
	httbzRhW9rK74gQ2hGIemDZ2q4yaZmR4u26zfrFGxAuvdf2GIgvcvTMLj751TgOdxs0KPl6aaTF
	kzE8m/IaPSKcTqieAmADnxN3nOoCmw==
X-Received: by 2002:a17:906:3ad4:b0:c49:b6db:1 with SMTP id a640c23a62f3a-c49b6db02ddmr64059366b.12.1793109257428;
        Tue, 27 Oct 2026 06:54:17 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:54:17 -0700 (PDT)
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
	devicetree@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-embedded@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/15] drm/client: splash: follow the connector's orientation
Date: Tue, 27 Oct 2026 14:53:41 +0100
Message-Id: <20261027135342.2003632-15-maximpedraza@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261027135342.2003632-1-maximpedraza@gmail.com>
References: <20261027135342.2003632-1-maximpedraza@gmail.com>
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

A connector can need its picture turned to be seen upright: a panel
mounted turned, as its orientation property says, or a rotation asked
for with video=...,rotate=. On an atomic driver,
drm_client_modeset_commit() turns the plane in hardware when it can,
which is 0 or 180 degrees on a plane with a rotation property, and
nothing turns it otherwise. fbdev makes up for
the rest by turning the console in software; the splash did not. On a
panel mounted upside down, the logo was then upright on a plane that
turns and upside down on one that does not, and a device tree asking
for a turn of 180 degrees to make up for it turned it twice on the
former.

Do what fbdev does: ask drm_client_rotation() what each connector needs
and whether the plane does it, and turn the buffer in software by what
the plane does not do. As for fbdev, the legacy commit leaves every
plane upright, and a reflection, which is not drawn here, means no turn
in software at all. Tiles that share a buffer but need different turns
get none in software, which is what fbdev falls back to; a plane among
them that turns in hardware still does, and a BGRT image is then not
made up for on that tile. The
image is placed and turned as the screen is seen, then moved into the
buffer, so "rotation", "logo-position" and "logo-offset" mean the same
whatever the panel and the plane, a BGRT image apart: the panel's own
orientation belongs to the panel.

A BGRT image is left on the screen the firmware drew it on, unturned
but for the table's own orientation bits: its offsets are given there,
and a logo for a panel mounted turned comes already turned unless those
bits say otherwise. Only the turn the plane does is undone for it.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/drm_splash.c | 162 +++++++++++++++++++--------
 1 file changed, 114 insertions(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index 0bf9d969dd8f..d3ed53cde0f5 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -61,6 +61,12 @@ struct drm_splash_scanout {
 	u32 format;
 	unsigned int width;
 	unsigned int height;
+	/*
+	 * What the connector needs turned to be seen upright (panel orientation
+	 * and video=...,rotate=), and the part of it the plane does not do in
+	 * hardware, which is then done here.
+	 */
+	unsigned int conn_rot, sw_rot;
 	struct drm_client_buffer *buffer;
 	bool bg_drawn;
 	bool img_drawn;
@@ -109,14 +115,20 @@ struct drm_splash {
 	enum drm_splash_source src;
 
 	/*
-	 * Where the image goes, in screen pixels: a coordinate of -1 centres
-	 * it on that axis, and the offset is added afterwards. Only the device
-	 * tree asks for anything but the centre.
+	 * Where the image goes, in pixels as the screen is seen: a coordinate
+	 * of -1 centres it on that axis, and the offset is added afterwards.
+	 * Only the device tree asks for anything but the centre; a BGRT image
+	 * goes at the table offsets, on the firmware's screen.
 	 */
 	s32 pos_x, pos_y;
 	s32 off_x, off_y;
-	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
+	/*
+	 * One of DRM_MODE_ROTATE_*: turns the image as it is seen, whichever
+	 * way the panel is mounted.
+	 */
 	unsigned int rotation;
+	/* What the BGRT bits ask for: the turn of the firmware's own picture */
+	unsigned int bgrt_rot;
 	/* RGB888, from the image source or the kernel's default */
 	u32 bg_color;
 };
@@ -529,6 +541,12 @@ static int drm_splash_fill_solid_color(struct drm_client_buffer *buffer,
 }
 
 #if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_BMP_SUPPORT)
+/* Two DRM_MODE_ROTATE_* turns, one after the other */
+static unsigned int drm_splash_rotate_add(unsigned int a, unsigned int b)
+{
+	return BIT((ilog2(a) + ilog2(b)) & 3);
+}
+
 /*
  * Place the image along one axis of the screen. @pos is the coordinate asked
  * for, or -1 to centre on that axis, and @off is added afterwards. Both may
@@ -659,8 +677,11 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	bool bmp_invert_y;
 	u32 bitmap_offset;
 	size_t row_len, pixels_len, end;
+	bool bgrt = splash->src == DRM_SPLASH_SRC_BGRT;
 	unsigned int x_pad, y_pad, img_w, img_h;
+	unsigned int frame, rot, vw, vh, x, y, w, h;
 	const u8 *image_data;
+	bool quarter;
 	struct iosys_map map;
 	struct drm_rect r;
 	u32 *img;
@@ -724,36 +745,41 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	}
 	bmp_pitch = row_len & ~(size_t)3;
 
-	/* The room the image takes up on screen, once turned */
+	/*
+	 * Work as the screen is seen, then move the result into the buffer,
+	 * which is turned from what is seen by whatever the connector needs
+	 * and the plane does not do. A BGRT image is seen as the firmware drew
+	 * it: on the unturned screen, but for the table's own orientation
+	 * bits, where its offsets are given and where a logo for a panel
+	 * mounted turned comes already turned unless the bits say otherwise.
+	 */
+	frame = bgrt ? BIT((ilog2(splash->bgrt_rot) + ilog2(scanout->sw_rot) -
+			    ilog2(scanout->conn_rot)) & 3) : scanout->sw_rot;
+	rot = drm_splash_rotate_add(splash->rotation, frame);
+	quarter = frame & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270);
+	vw = quarter ? scanout->height : scanout->width;
+	vh = quarter ? scanout->width : scanout->height;
+
+	/* The room the image takes up as seen, once turned */
 	if (splash->rotation & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270)) {
-		img_w = bmp_height;
-		img_h = bmp_width;
+		w = bmp_height;
+		h = bmp_width;
 	} else {
-		img_w = bmp_width;
-		img_h = bmp_height;
+		w = bmp_width;
+		h = bmp_height;
 	}
 
-	if (img_w > scanout->width || img_h > scanout->height) {
+	if (w > vw || h > vh) {
 		drm_err(client->dev, "splash: BMP image is too big for the screen\n");
 		return -EINVAL;
 	}
 
-	if (splash->src == DRM_SPLASH_SRC_BGRT) {
-		/*
-		 * The BGRT offsets place the upright image on the upright
-		 * screen, which for a panel mounted turned is not the frame
-		 * the buffer is scanned out in. Work in that frame, then move
-		 * the image's rectangle into the buffer's.
-		 */
-		bool quarter = splash->rotation &
-			       (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270);
-		unsigned int lw = quarter ? scanout->height : scanout->width;
-		unsigned int lh = quarter ? scanout->width : scanout->height;
+	/* A BGRT image goes where the table says, on the firmware's screen */
+	if (bgrt) {
 		unsigned int xo = efi_bgrt_image_offset_x();
 		unsigned int yo = efi_bgrt_image_offset_y();
 
-		if (xo > lw || bmp_width > lw - xo ||
-		    yo > lh || bmp_height > lh - yo) {
+		if (xo > vw - w || yo > vh - h) {
 			drm_err(client->dev, "splash: BGRT image would overflow\n");
 			return -EINVAL;
 		}
@@ -769,36 +795,40 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		 * edge of the display, looking quite bad.
 		 */
 
-		if (xo != (lw - bmp_width) / 2) {
+		if (xo != (vw - w) / 2) {
 			drm_err(client->dev, "splash: BGRT sanity check failed\n");
 			return -EINVAL;
 		}
 #endif
 
-		switch (splash->rotation) {
-		case DRM_MODE_ROTATE_90:
-			x_pad = yo;
-			y_pad = lw - xo - bmp_width;
-			break;
-		case DRM_MODE_ROTATE_180:
-			x_pad = lw - xo - bmp_width;
-			y_pad = lh - yo - bmp_height;
-			break;
-		case DRM_MODE_ROTATE_270:
-			x_pad = lh - yo - bmp_height;
-			y_pad = xo;
-			break;
-		default:
-			x_pad = xo;
-			y_pad = yo;
-			break;
-		}
+		x = xo;
+		y = yo;
 	} else {
-		x_pad = drm_splash_place_axis(splash->pos_x, splash->off_x,
-					      scanout->width, img_w);
-		y_pad = drm_splash_place_axis(splash->pos_y, splash->off_y,
-					      scanout->height, img_h);
+		x = drm_splash_place_axis(splash->pos_x, splash->off_x, vw, w);
+		y = drm_splash_place_axis(splash->pos_y, splash->off_y, vh, h);
+	}
+
+	/* Into the buffer: turn the rectangle as the buffer is turned */
+	switch (frame) {
+	case DRM_MODE_ROTATE_90:
+		x_pad = y;
+		y_pad = vw - x - w;
+		break;
+	case DRM_MODE_ROTATE_180:
+		x_pad = vw - x - w;
+		y_pad = vh - y - h;
+		break;
+	case DRM_MODE_ROTATE_270:
+		x_pad = vh - y - h;
+		y_pad = x;
+		break;
+	default:
+		x_pad = x;
+		y_pad = y;
+		break;
 	}
+	img_w = quarter ? h : w;
+	img_h = quarter ? w : h;
 
 	image_data = data + bitmap_offset;
 
@@ -807,7 +837,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	if (!img)
 		return -ENOMEM;
 	drm_splash_bmp_decode(img, image_data, bmp_pitch, bmp_width, bmp_height,
-			      bmp_invert_y, splash->rotation);
+			      bmp_invert_y, rot);
 
 	ret = drm_client_buffer_vmap_local(buffer, &map);
 	if (ret) {
@@ -868,7 +898,7 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
 	}
 
 	if (drm_splash_bgrt_available(splash)) {
-		splash->rotation = drm_splash_bgrt_rotation();
+		splash->bgrt_rot = drm_splash_bgrt_rotation();
 		return DRM_SPLASH_SRC_BGRT;
 	}
 
@@ -987,10 +1017,31 @@ static void drm_splash_modeset_off(struct drm_device *dev,
 	modeset->fb = NULL;
 }
 
+/*
+ * What the connector needs turned to be seen upright, and the part of it
+ * left for the splash to do. As fbdev: only an atomic commit turns the
+ * plane, and a reflection, which is not drawn here, means no turn at all.
+ */
+static void drm_splash_rotation(struct drm_client_dev *client,
+				struct drm_mode_set *modeset,
+				unsigned int *conn_rot, unsigned int *sw_rot)
+{
+	unsigned int rot = DRM_MODE_ROTATE_0;
+	bool hw = drm_client_rotation(modeset, &rot) &&
+		  drm_drv_uses_atomic_modeset(client->dev);
+
+	if (!hw && (rot & ~DRM_MODE_ROTATE_MASK))
+		rot = DRM_MODE_ROTATE_0;
+
+	*conn_rot = rot & DRM_MODE_ROTATE_MASK;
+	*sw_rot = hw ? DRM_MODE_ROTATE_0 : *conn_rot;
+}
+
 static int drm_splash_init_client(struct drm_splash *splash)
 {
 	struct drm_client_dev *client = &splash->client;
 	struct drm_mode_set *modeset;
+	unsigned int conn_rot, sw_rot;
 	unsigned int fb_count = 0;
 	unsigned int i, k;
 	int err = -ENODEV;
@@ -1046,6 +1097,16 @@ static int drm_splash_init_client(struct drm_splash *splash)
 				tiled->height = max(tiled->height, modeset->y +
 						    modeset->mode->vdisplay);
 				tiled->modesets |= BIT(idx);
+
+				/*
+				 * One buffer cannot suit tiles that need different
+				 * turns: as fbdev, turn none of them in software
+				 */
+				drm_splash_rotation(client, modeset, &conn_rot, &sw_rot);
+				if (conn_rot != tiled->conn_rot || sw_rot != tiled->sw_rot) {
+					tiled->conn_rot = DRM_MODE_ROTATE_0;
+					tiled->sw_rot = DRM_MODE_ROTATE_0;
+				}
 				continue;
 			}
 
@@ -1080,6 +1141,11 @@ static int drm_splash_init_client(struct drm_splash *splash)
 		scanout->format = format;
 		scanout->width = modeset->x + modeset->mode->hdisplay;
 		scanout->height = modeset->y + modeset->mode->vdisplay;
+		drm_splash_rotation(client, modeset, &scanout->conn_rot,
+				    &scanout->sw_rot);
+		drm_dbg(client->dev, "splash: scanout %u: connector turned %u, here %u\n",
+			splash->n_scanout - 1, 90 * ilog2(scanout->conn_rot),
+			90 * ilog2(scanout->sw_rot));
 	}
 
 	/* Now that the sizes are known, allocate one buffer per scanout */
-- 
2.39.5

