Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109253;
	b=JFIH0vHe5AuePH+j3hnmC/FjSfOD72JUDtS/6iZo/beAXB9wZsgrn1h1UFK4MOQobM2d
	 YM/iZOH/zsot6Dcbtwfa7F9FXCw3WQYQbRO6aSeiMQlRTY3a8xrQ7FLlnnyEIFbRKNWOo
	 Vo4zcumIoETxHz4FWSf1mSD1t4DHgmSeYTqNWXgQo6M+gmRbwC4WrgadmvmeMP8Y92vLN
	 rajlJLFslqrsXuQexxYgSXfZTaV0TFmGowq0x5EKaM0npeW/vw6AbvwsdR7O306zNR0Og
	 gCux+FvZWMhJJ3sTSLyyEUztbzIav0G88PlDC0d/7dHQHWllpq45Pze5jUNJuRmZePA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=94apHeDFvaEybH6BDSStfeFodhITURdJ4ustmG0CefA=;
	b=GrFyzTYLKn4EjhqA2wapTao2yFeqF+GKAiGcZGMluyNHJfUaT/e0GpEHHNzyvJlDdJVD
	 URWgIicbW9SwOoYmNKbnrT0uYnWX+OQMMeyeMSj5W0O+iVFpLPyR3+C8p5k3UthWPzeJp
	 p2RNbZvRwsU5+tFaRgzZPt804QhrCaFY6Ph9b/nLr9TQYRWJosGb71jsPJ6ftchMffybr
	 KF4PxcAgdf8i7MfHuYdz2/LF1OSraFMwqvJNkOkc+nT+xSIdTeA+K0t8IqTNzvfxBWNkA
	 pC8puW+mrZ66KrG1c5+5hQwCkK8R+VAMQfpDo6+wgntbbV8yF4bLoRtnaybYkN+IbQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pcnyAaW5;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6F60A262C
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:54:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3F6F60A262C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pcnyAaW5
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e0d1da913so976141f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793109251; x=1793714051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=94apHeDFvaEybH6BDSStfeFodhITURdJ4ustmG0CefA=;
        b=pcnyAaW5zI3XmGTlYo37wpCpn4SQF/ep1gEFA6+XHz2mz+RzgamGls+TbhLKPqLjtr
         psUL6nzGjlNLTViuLKztw4LIXYiSsBtikgqnpgGQwjlzvfHOpN/YXq8ER4dfpqTLq3cz
         thwlK72mFlJH9t3agQNwHN7KCzAf9vCBy+pj3xXqcuNEiRzVh3c4VkNRStaYemrbrWLX
         QO6ZijYLD7Lx5gr2a8sXZ5Skc9+bc1qgVSCMH0u6dEua97oSlSlZLk5w1rp/CQaHe4oA
         MruFJNKRMnujXUiY86ZTtbtNKLESo0Po3VY/WOhTlDSKLvUeMwL3plIWj/cvV4WvNO9K
         l2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109251; x=1793714051;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=94apHeDFvaEybH6BDSStfeFodhITURdJ4ustmG0CefA=;
        b=v9gs/nKvO0mXmLe6uVmQtyxu90uI2oZjPWUt3RkC42xUYrT9J8PeAIM+9OZKk+G4od
         6HOK8kCwu0xUnxp3gZ3I6xT02fZQ95vBttP+/FZYmg+qqCdImVmOy6l+nCet7GaJ1qZE
         6kZ8Px3VvhbnCzovsQZZwGepXbULURVrpxGeejD1x9X6Npin/0gpYMzNj35Vm+Gjp+6z
         jVTc4vSnvbvbB40PCKQ+sl8f9XQzraS+3h3esW94kOsRe1Zx8oWDtek3tnReNwNlxI/N
         k+xfqER5YfqB+XJ8mhk0+FtPcQGstwzvPV3ptpmfq0uYmskOc7sSGGtXZ9l1UvP8LiP+
         Kduw==
X-Forwarded-Encrypted: i=1; AKwUvBzf8iOYD+XWZfKxwE6DP5o+tDQ7ralWxBEY++jiHIbx1IdvxF/NswUO5LO7AxrsJuhU8TyowgNwTqo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJJyrpyHIJTnYRkMWC28rDxKPYFIXoWuZakmxJlWQGMchteSZJw
	wqh07NISCOJUjqe/qXpDUJPygsvzhnWJ7e/UtLe3ckmxlQOoNZDKMYFo
X-Gm-Gg: AYBFou3SIuxWXZ5ifzOyuauWNB/z1HjXkYn7juydA63R9wRViBZ/QIHcT4u366CO0k2
	F/d31c9LwudHfFfzuHZ8hPtupF2W/Uf8Ki550Bv2JASm3goCRQHo/4TQbpO9GUQT3CAk0nr72hl
	xlGbptmypZObqkj9cxNgO4yNUqL4OnXaXNtZkTdDTgdB4NyNAiL8PUcxa1UIgAJvh9TivelOz4N
	ZbqFef7wWf0/v43g2Kfi4lKdZyx5qqcYAUIPA15yVzhEwQM0/5DbxNK8HPCh3pHQd8V/PcwLQ+T
	5qQGWChp9jTDB5RtKdvifLKqzTb0CM5XXDhDZW7VBB6OUpVsP3gijo1nMucnLlgCPlcEUVrq2ip
	jAM31G9ORjBxLlAhgj8u7LjhlrF53D1IQ9eyP4FQO6q2yrleEPHC/9rSZR1nkJt8gmN/hN0saie
	Lim724N4PqrtL4urbwddfYp/Q28U1NvBhMc8OMksOHeEsvPdjiI6QT4HqHuUVAuWv/FRhxZTpsd
	yTVcJfaAAUNNSpgEYgKFqTF0crme4nFWOBEGy5opw3TKocOrO79OuJEFjc+muHw1HoPI3bQURbV
	hH6EJZ1s/zbEKq1HC+c+j3Ulh5w3
X-Received: by 2002:a5d:5f44:0:b0:48e:55bd:9ce2 with SMTP id ffacd0b85a97d-48e55bd9d56mr6249783f8f.20.1793109251114;
        Tue, 27 Oct 2026 06:54:11 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:54:10 -0700 (PDT)
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
Subject: [PATCH v6 11/15] drm/client: splash: turn the device tree image as it asks
Date: Tue, 27 Oct 2026 14:53:38 +0100
Message-Id: <20261027135342.2003632-12-maximpedraza@gmail.com>
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

Let the device tree node ask for the image to be turned, for a logo
drawn in one orientation and meant to be seen in another, with a
"rotation" property counting degrees counter clockwise, as panels
already do and as DRM_MODE_ROTATE_* count, which is what it is kept as.
It describes the image only: a panel mounted turned is described on the
panel, and a later patch in this series makes the splash follow it.

The rotation turns the image and not the screen: "logo-position" and
"logo-offset" stay in screen pixels, and a quarter turn only swaps how
much room the image takes up. Placing it in a frame that turned with it
would make the same pair of coordinates mean different places on the
same panel, decided by a property that describes the image.

The turn happens in the first of the two drawing steps, which reads
the BMP into an XRGB8888 buffer: it walks the source through the
rotation, so the buffer holds the image as it is to be seen. The second
step, into the framebuffer's format, does not change.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/drm_splash.c | 109 +++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index 81070547390f..a50036155763 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -28,6 +28,7 @@
 #include <drm/drm_drv.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
+#include <drm/drm_mode.h>
 #include <drm/drm_plane.h>
 #include <drm/drm_print.h>
 
@@ -114,6 +115,8 @@ struct drm_splash {
 	 */
 	s32 pos_x, pos_y;
 	s32 off_x, off_y;
+	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
+	unsigned int rotation;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -273,10 +276,34 @@ static void drm_splash_dt_pair(struct drm_splash *splash,
 static void drm_splash_dt_placement(struct drm_splash *splash,
 				    struct device_node *np)
 {
+	u32 val;
+
 	drm_splash_dt_pair(splash, np, "logo-position", -1, 65535,
 			   &splash->pos_x, &splash->pos_y);
 	drm_splash_dt_pair(splash, np, "logo-offset", -65535, 65535,
 			   &splash->off_x, &splash->off_y);
+
+	/* Degrees counter clockwise, as for panels, and as DRM counts them */
+	if (!of_property_read_u32(np, "rotation", &val)) {
+		switch (val) {
+		case 0:
+			splash->rotation = DRM_MODE_ROTATE_0;
+			break;
+		case 90:
+			splash->rotation = DRM_MODE_ROTATE_90;
+			break;
+		case 180:
+			splash->rotation = DRM_MODE_ROTATE_180;
+			break;
+		case 270:
+			splash->rotation = DRM_MODE_ROTATE_270;
+			break;
+		default:
+			drm_warn(splash->client.dev,
+				 "splash: %pOF: unsupported rotation %u\n",
+				 np, val);
+		}
+	}
 }
 
 /*
@@ -494,19 +521,59 @@ static unsigned int drm_splash_place_axis(s32 pos, s32 off, unsigned int span,
 	return clamp_t(s64, coord + off, 0, last);
 }
 
-/* The rows of a 24 bpp BMP, bottom up or top down, upright in XRGB8888 */
-static void drm_splash_bmp_decode(u32 *dst, const u8 *src, unsigned int spitch,
+/*
+ * The pixels of a 24 bpp BMP, whose rows go bottom up or top down, into
+ * XRGB8888, turned by @rotation, one of DRM_MODE_ROTATE_*, which count
+ * counter clockwise. A quarter turn swaps width and height in @dst.
+ *
+ * Each source pixel is three bytes read on their own, since a BMP row is
+ * only padded to four bytes as a whole and the image need not be aligned.
+ */
+static void drm_splash_bmp_decode(u32 *dst, const u8 *sbuf8, unsigned int spitch,
 				  unsigned int width, unsigned int height,
-				  bool invert_y)
+				  bool invert_y, unsigned int rotation)
 {
+	bool quarter = rotation & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270);
+	unsigned int dw = quarter ? height : width;
+	unsigned int dh = quarter ? width : height;
+	/* A positive BMP height stores the rows bottom up */
+	ptrdiff_t down = invert_y ? -(ptrdiff_t)spitch : spitch;
+	const u8 *first = sbuf8 + (invert_y ? (height - 1) * spitch : 0);
+	const u8 *last = first + (height - 1) * down;
+	ptrdiff_t step_x, step_y;
+	const u8 *src, *p;
 	unsigned int x, y;
 
-	for (y = 0; y < height; y++) {
-		const u8 *p = src + (invert_y ? height - 1 - y : y) * spitch;
+	/*
+	 * Where the source pixel for the top left of the turned image is, and
+	 * how far one step right and one step down in it move in the source
+	 */
+	switch (rotation) {
+	case DRM_MODE_ROTATE_90:
+		src = first + 3 * (width - 1);
+		step_x = down;
+		step_y = -3;
+		break;
+	case DRM_MODE_ROTATE_180:
+		src = last + 3 * (width - 1);
+		step_x = -3;
+		step_y = -down;
+		break;
+	case DRM_MODE_ROTATE_270:
+		src = last;
+		step_x = -down;
+		step_y = 3;
+		break;
+	default:
+		src = first;
+		step_x = 3;
+		step_y = down;
+		break;
+	}
 
-		for (x = 0; x < width; x++, p += 3)
+	for (y = 0; y < dh; y++, src += step_y)
+		for (x = 0, p = src; x < dw; x++, p += step_x)
 			*dst++ = get_unaligned_le24(p);
-	}
 }
 
 /* An XRGB8888 image into a buffer of another format, at x0, y0 */
@@ -564,7 +631,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	bool bmp_invert_y;
 	u32 bitmap_offset;
 	size_t row_len, pixels_len, end;
-	unsigned int x_pad, y_pad;
+	unsigned int x_pad, y_pad, img_w, img_h;
 	const u8 *image_data;
 	struct iosys_map map;
 	struct drm_rect r;
@@ -629,7 +696,16 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	}
 	bmp_pitch = row_len & ~(size_t)3;
 
-	if (bmp_width > scanout->width || bmp_height > scanout->height) {
+	/* The room the image takes up on screen, once turned */
+	if (splash->rotation & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270)) {
+		img_w = bmp_height;
+		img_h = bmp_width;
+	} else {
+		img_w = bmp_width;
+		img_h = bmp_height;
+	}
+
+	if (img_w > scanout->width || img_h > scanout->height) {
 		drm_err(client->dev, "splash: BMP image is too big for the screen\n");
 		return -EINVAL;
 	}
@@ -662,19 +738,19 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 #endif
 	} else {
 		x_pad = drm_splash_place_axis(splash->pos_x, splash->off_x,
-					      scanout->width, bmp_width);
+					      scanout->width, img_w);
 		y_pad = drm_splash_place_axis(splash->pos_y, splash->off_y,
-					      scanout->height, bmp_height);
+					      scanout->height, img_h);
 	}
 
 	image_data = data + bitmap_offset;
 
-	/* First the image upright in XRGB8888, then into the buffer's format */
+	/* First the image turned in XRGB8888, then into the buffer's format */
 	img = kvmalloc_array(bmp_width, bmp_height * sizeof(*img), GFP_KERNEL);
 	if (!img)
 		return -ENOMEM;
 	drm_splash_bmp_decode(img, image_data, bmp_pitch, bmp_width, bmp_height,
-			      bmp_invert_y);
+			      bmp_invert_y, splash->rotation);
 
 	ret = drm_client_buffer_vmap_local(buffer, &map);
 	if (ret) {
@@ -683,9 +759,9 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		return ret;
 	}
 
-	r = DRM_RECT_INIT(x_pad, y_pad, bmp_width, bmp_height);
+	r = DRM_RECT_INIT(x_pad, y_pad, img_w, img_h);
 	drm_splash_blit(&map, fb->pitches[0], fb->format, x_pad, y_pad, img,
-			bmp_width, bmp_height);
+			img_w, img_h);
 
 	kvfree(img);
 	drm_client_buffer_vunmap_local(buffer);
@@ -1184,9 +1260,10 @@ void drm_splash_register(struct drm_device *dev,
 	mutex_init(&splash->lock);
 	init_completion(&splash->fw_done);
 
-	/* Centred unless the image source asks otherwise */
+	/* Centred and upright unless the image source asks otherwise */
 	splash->pos_x = -1;
 	splash->pos_y = -1;
+	splash->rotation = DRM_MODE_ROTATE_0;
 
 	if (format && format->num_planes == 1) {
 		splash->preferred_format = format->format;
-- 
2.39.5

