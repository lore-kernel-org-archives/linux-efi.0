Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B318B43BDC7
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884002; cv=none; b=WhhPVKpzQ97/NLrrtR6h8PQwjIn0L4NOkIa7eyBJ82yZ7sF6Bk1bU0ad7gr54xDE5uLgyK1nW4oWZWl0DLhI5U2szAq4OkovS3v5NTWyD0/NvsmxDbb4KstfuPb0oaf1/y+boV+bxGWfSsZJjD84HnWCsztrayqBxWXpusD8vZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884002; c=relaxed/simple;
	bh=JLtLDG7pzcUhMJ1HCheawsUFfpTJksu8wLVP2F6oNPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHvzulG8ZJXySKzb5URhCoo44owuxwYLKA0n6/U3QeAbgBt72a7hTH8BcWwA5THd9BbPM+Gi/olckIMQBYruDL00R3xOUGAPvNNEy06Ztf47ZIgNm3bBnIdKQcvg7fLZgrFtjju6zL5fulofzLY4vDApgDCNJCNZBdM51GDUkZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A5BlnVs8; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A5BlnVs8"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a16c399641so27438815e9.2
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883990; x=1792488790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WIZOjfH4g9TJIO6yRXsuZIW5fOgxe6tnSJshq6lf5e0=;
        b=A5BlnVs86GHqXFixv2x05o2/5iv718/MRV5vB86lXbueHbHLEyDDCDp6/v31glO7ND
         HugThj8vvGyzibpw1r/Kr5hV4LCyr09G9mMMfN21vqDcgF6wWNe9aGOsxuQ4vknD/gXw
         NJHCNEx2J5WxaxE65NyWafdrFyTTO9o8XvvkGHCTwj9wkZpKesbHFAWO1rt8rc5smc/8
         vlO0QUydqLgJOH802n1Fdj/HLDfEA5b6S8UiUaYmmEgI9E+rAvvc7EWQY49zy3c3zJ3W
         ml2g9aFn2ppbdvd6uJ/E/8RZ+cO3MyOLe7anwsVdcPUd2D0nuihRhFJ+zWp54xDhMrha
         Tl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883990; x=1792488790;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WIZOjfH4g9TJIO6yRXsuZIW5fOgxe6tnSJshq6lf5e0=;
        b=DsJn6OSgziMgE7Iil44YHQiwjs8qUaoB0Xe0pmQyeXbWUzXvMa7jksu+c+D7oZt44q
         LBk8YLJLZvxu3UV4DE7O0tCOp7O/14olZPaRm3FKJDwtqLUof90tmbXrSfJBwVd+l+cH
         TSpu71eyKAaxbuOFWwaFkU1UyiBJYbT9enBvIpoa83UoNVKEcXvXm2Wmy5A85NEzgQHa
         Rzc2u5FhnW2a6BmKOuDyXKuwgLjujImVupgzfk8uGazDnvrkhZmyAf/nlon3CHnbMatW
         nkPFp5SH7PpqalMHD79aVcz3AiHPeaputkcxLv+qVeuJq8v5RyfDUo+126U7QrfIQIBX
         x38g==
X-Forwarded-Encrypted: i=1; AKwUvBy8enCt/z2YcG3KtxLO+B8goAZ1Sd4CJO5GOmTPmdoLCyE5fEPejHuJGVXrqwLJ+Bp2eQcStSf5x1c=@vger.kernel.org
X-Gm-Message-State: AFq9FYJad6xmaHPkhm5IflmlwEb6nZpnyOh9BdxGmax5bBXMgyCjDSFJ
	58ELltyP+GJ6UCY54flJW00myLmFoBCobAqEyJPjIlCaUwru4lsclD5b
X-Gm-Gg: AYBFou2QpRDCD51TPocgaMzhnbXC2zvSH7u2X7f6S0VVHyyWTfu3BnXg1DtSJg4Gm/z
	Tu5z9HemKwNNDqdzFgIoYZJNgyMM9lGkuapJ8V5VsI8VMRaf0/oP5ZI3rnUc1rr1T1dvmk7BhOH
	OVhkLKHCsr8yAhsCEQzzUmHSbJxS5J37QgwMhDb96ElKJrsEmBT7jZ97MqeN78gb4z/uOuf+8EH
	hMB1zzzRi6fjGHrnU6x9ViSNU3HxTOBMRG+2eRcIKii1DNlfBk76PKJXHKMCVGZD5/oY3x11yKu
	gpFyJKRBQ285apu6ln9iNBzoBiqqfQHPup5vUglTkcBXR9W43/K5SJSKn8aL5PeM7j1YfpMmEam
	ltCeDKq4GqW+5alyl4myrOiV/l5jbjKlWf4CnMsQJuieV2xejs+GGRG67QWzs4coyOqFH1ezMNV
	dXWXr5g7mJ0oTYA0IJx+A0JX5i+erz97HX/QzR/zsYsG+/D1hPgpXER7Nt+zBgpi8h/RWU3Rx2S
	QQW9M4jNNWcEbu43Hg9PjPM
X-Received: by 2002:a05:600c:8105:b0:49f:fdca:c361 with SMTP id 5b1f17b1804b1-4a18e483818mr241872985e9.12.1791883989899;
        Tue, 13 Oct 2026 02:33:09 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:33:09 -0700 (PDT)
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
Subject: [PATCH v5 09/13] drm/client: splash: turn the device tree image as it asks
Date: Tue, 13 Oct 2026 11:32:39 +0200
Message-Id: <20261013093243.505776-10-maximpedraza@gmail.com>
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

The same board is often fitted with the same panel mounted in more than
one orientation. Let the device tree node ask for the image to be turned,
with a "rotation" property counting degrees counter clockwise, as panels
already do and as DRM_MODE_ROTATE_* count, which is what it is kept as.

The rotation turns the image and not the screen: "logo-position" and
"logo-offset" stay in screen pixels, and a quarter turn only swaps how
much room the image takes up. Placing it in a frame that turned with it
would make the same pair of coordinates mean different places on the
same panel, decided by a property that describes the image.

The three blitters, one per destination pixel size, become one that
reads the source pixel through the rotation and writes it according to
the pixel size. Each source pixel is read as three bytes rather than as
an unaligned u32: a BMP row is only padded as a whole, so with 3 * width
already a multiple of four the last pixel of the image was read one byte
past its end. An upright image going to an RGB888 buffer is still copied
a row at a time.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/drm_splash.c | 206 ++++++++++++++-------------
 1 file changed, 110 insertions(+), 96 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index 8561d00a5b96..fdf398987007 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -25,6 +25,7 @@
 #include <drm/drm_drv.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
+#include <drm/drm_mode.h>
 #include <drm/drm_plane.h>
 #include <drm/drm_print.h>
 
@@ -130,6 +131,8 @@ struct drm_splash {
 	 */
 	s32 pos_x, pos_y;
 	s32 off_x, off_y;
+	/* One of DRM_MODE_ROTATE_*: turns the image, not the screen */
+	unsigned int rotation;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -283,6 +286,28 @@ static void drm_splash_dt_placement(struct drm_splash *splash,
 		splash->off_x = (s32)val[0];
 		splash->off_y = (s32)val[1];
 	}
+
+	/* Degrees counter clockwise, as for panels, and as DRM counts them */
+	if (!of_property_read_u32(np, "rotation", &val[0])) {
+		switch (val[0]) {
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
+				 "splash: %pOF: unsupported rotation %u",
+				 np, val[0]);
+		}
+	}
 }
 
 static int drm_splash_dt_load(struct drm_splash *splash, const u8 **data,
@@ -479,73 +504,68 @@ static unsigned int drm_splash_place_axis(s32 pos, s32 off, unsigned int span,
 	return clamp_t(s64, coord + off, 0, last);
 }
 
-static void drm_splash_blit_pix16(struct iosys_map *map, unsigned int dpitch,
-				  unsigned int x_pad, unsigned int y_pad,
-				  const u8 *sbuf8, unsigned int spitch,
-				  unsigned int width, unsigned int height,
-				  bool invert_y, u32 format)
-{
-	unsigned int x, y, src_offset, dst_offset;
-	u32 scolor, dcolor, wr_off;
-
-	for (y = 0; y < height; y++) {
-		src_offset = (invert_y ? (height - y - 1) : y) * spitch;
-		dst_offset = (y_pad + y) * dpitch;
-
-		for (x = 0; x < width; x++) {
-			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
-			dcolor = drm_draw_color_from_xrgb8888(scolor, format);
-			wr_off = dst_offset + (x_pad + x) * sizeof(u16);
-
-			iosys_map_wr(map, wr_off, u16, dcolor);
-		}
-	}
-}
-
-static void drm_splash_blit_pix24(struct iosys_map *map, unsigned int dpitch,
-				  unsigned int x_pad, unsigned int y_pad,
-				  const u8 *sbuf8, unsigned int spitch,
-				  unsigned int width, unsigned int height,
-				  bool invert_y, u32 format)
-{
-	unsigned int x, y, src_offset, dst_offset;
-	u32 scolor, dcolor, wr_off;
-
-	for (y = 0; y < height; y++) {
-		src_offset = (invert_y ? (height - y - 1) : y) * spitch;
-		dst_offset = (y_pad + y) * dpitch;
-
-		for (x = 0; x < width; x++) {
-			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
-			dcolor = drm_draw_color_from_xrgb8888(scolor, format);
-			wr_off = dst_offset + (x_pad + x) * 3;
-
-			iosys_map_wr(map, wr_off, u8, (dcolor & 0x000000FF) >> 0);
-			iosys_map_wr(map, wr_off + 1, u8, (dcolor & 0x0000FF00) >> 8);
-			iosys_map_wr(map, wr_off + 2, u8, (dcolor & 0x00FF0000) >> 16);
-		}
-	}
-}
-
-static void drm_splash_blit_pix32(struct iosys_map *map, unsigned int dpitch,
-				  unsigned int x_pad, unsigned int y_pad,
-				  const u8 *sbuf8, unsigned int spitch,
-				  unsigned int width, unsigned int height,
-				  bool invert_y, u32 format)
+/*
+ * Copy the BMP pixels into the buffer, converted to its format and turned by
+ * @rotation, one of DRM_MODE_ROTATE_*, which count counter clockwise. The
+ * rotation turns the image, not the screen: a quarter turn swaps how much
+ * room the image takes up, and @x_pad and @y_pad place that room on screen.
+ *
+ * Each source pixel is three bytes read on their own, since a BMP row is
+ * only padded to four bytes as a whole and the image need not be aligned.
+ */
+static void drm_splash_blit(struct iosys_map *map, unsigned int dpitch,
+			    u32 format, unsigned int cpp,
+			    unsigned int x_pad, unsigned int y_pad,
+			    const u8 *sbuf8, unsigned int spitch,
+			    unsigned int width, unsigned int height,
+			    bool invert_y, unsigned int rotation)
 {
-	unsigned int x, y, src_offset, dst_offset;
-	u32 scolor, dcolor, wr_off;
-
-	for (y = 0; y < height; y++) {
-		src_offset = (invert_y ? (height - y - 1) : y) * spitch;
-		dst_offset = (y_pad + y) * dpitch;
+	bool quarter = rotation & (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270);
+	unsigned int dw = quarter ? height : width;
+	unsigned int dh = quarter ? width : height;
+	unsigned int x, y, sx, sy, row, off;
+	u32 scolor, dcolor;
+
+	for (y = 0; y < dh; y++) {
+		for (x = 0; x < dw; x++) {
+			switch (rotation) {
+			case DRM_MODE_ROTATE_90:
+				sx = width - 1 - y;
+				sy = x;
+				break;
+			case DRM_MODE_ROTATE_180:
+				sx = width - 1 - x;
+				sy = height - 1 - y;
+				break;
+			case DRM_MODE_ROTATE_270:
+				sx = y;
+				sy = height - 1 - x;
+				break;
+			default:
+				sx = x;
+				sy = y;
+				break;
+			}
 
-		for (x = 0; x < width; x++) {
-			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
+			/* A positive BMP height stores the rows bottom up */
+			row = invert_y ? height - 1 - sy : sy;
+			scolor = get_unaligned_le24(&sbuf8[row * spitch + 3 * sx]);
 			dcolor = drm_draw_color_from_xrgb8888(scolor, format);
-			wr_off = dst_offset + (x_pad + x) * sizeof(u32);
+			off = (y_pad + y) * dpitch + (x_pad + x) * cpp;
 
-			iosys_map_wr(map, wr_off, u32, dcolor);
+			switch (cpp) {
+			case 2:
+				iosys_map_wr(map, off, u16, dcolor);
+				break;
+			case 3:
+				iosys_map_wr(map, off, u8, dcolor & 0xff);
+				iosys_map_wr(map, off + 1, u8, (dcolor >> 8) & 0xff);
+				iosys_map_wr(map, off + 2, u8, (dcolor >> 16) & 0xff);
+				break;
+			case 4:
+				iosys_map_wr(map, off, u32, dcolor);
+				break;
+			}
 		}
 	}
 }
@@ -584,7 +604,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	bool bmp_invert_y;
 	u32 bitmap_offset;
 	size_t row_len, pixels_len, end;
-	unsigned int x_pad, y_pad;
+	unsigned int x_pad, y_pad, img_w, img_h;
 	const u8 *image_data;
 	struct iosys_map map;
 	struct drm_rect r;
@@ -644,7 +664,16 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
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
 		drm_err(client->dev, "splash: BMP image is too big for the screen");
 		return -EINVAL;
 	}
@@ -678,9 +707,9 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
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
@@ -691,40 +720,24 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		return ret;
 	}
 
-	r = DRM_RECT_INIT(x_pad, y_pad, bmp_width, bmp_height);
+	r = DRM_RECT_INIT(x_pad, y_pad, img_w, img_h);
 
-	/* In case the target format is RGB888, source data can be copied to
-	 * the video buffer line by line, avoiding some overhead.
+	/*
+	 * An unturned image going to an RGB888 buffer has the same byte order
+	 * as the BMP, so it is copied a row at a time.
 	 */
-	if (scanout->format == DRM_FORMAT_RGB888) {
+	if (scanout->format == DRM_FORMAT_RGB888 &&
+	    splash->rotation == DRM_MODE_ROTATE_0) {
 		drm_splash_blit_rgb888(&map, fb->pitches[0], x_pad, y_pad,
 				       image_data, bmp_pitch, bmp_width,
 				       bmp_height, bmp_invert_y);
+	} else if (px_width >= 2 && px_width <= 4) {
+		drm_splash_blit(&map, fb->pitches[0], scanout->format, px_width,
+				x_pad, y_pad, image_data, bmp_pitch, bmp_width,
+				bmp_height, bmp_invert_y, splash->rotation);
 	} else {
-		switch (px_width) {
-		case 2:
-			drm_splash_blit_pix16(&map, fb->pitches[0], x_pad,
-					      y_pad, image_data, bmp_pitch,
-					      bmp_width, bmp_height,
-					      bmp_invert_y, scanout->format);
-			break;
-		case 3:
-			drm_splash_blit_pix24(&map, fb->pitches[0], x_pad,
-					      y_pad, image_data, bmp_pitch,
-					      bmp_width, bmp_height,
-					      bmp_invert_y, scanout->format);
-			break;
-		case 4:
-			drm_splash_blit_pix32(&map, fb->pitches[0], x_pad,
-					      y_pad, image_data, bmp_pitch,
-					      bmp_width, bmp_height,
-					      bmp_invert_y, scanout->format);
-			break;
-		default:
-			drm_warn_once(client->dev,
-				      "splash: can't blit with pixel width %d",
-				      px_width);
-		}
+		drm_warn_once(client->dev, "splash: can't blit with pixel width %d",
+			      px_width);
 	}
 
 	drm_client_buffer_vunmap_local(buffer);
@@ -1193,9 +1206,10 @@ void drm_splash_register(struct drm_device *dev,
 	spin_lock_init(&splash->fw_lock);
 	init_completion(&splash->fw_done);
 
-	/* Centred unless the image source asks otherwise */
+	/* Centred and upright unless the image source asks otherwise */
 	splash->pos_x = -1;
 	splash->pos_y = -1;
+	splash->rotation = DRM_MODE_ROTATE_0;
 
 	if (format && format->num_planes == 1)
 		splash->preferred_format = format->format;
-- 
2.39.5

