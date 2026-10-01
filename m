Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BE251CF46
	for <linux-efi@vger.kernel.org>; Thu,  1 Oct 2026 19:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884758; cv=none; b=Qx+TW7m0oMAb6Xzv0vJJYKeWdFesn1aVmkP4uYdvXV/S6cbK8D8MmM6kQQ5Swhrp7dEDjClb2+OKBvOcPuIIdCbgCn9llvHaf1cTfhG+XmntuAlp6Kc5Ws/1HbBolISgdyXBD+4pWpnizgkP7ksp+LN8e7NiZapI+mK7wkQ1e2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884758; c=relaxed/simple;
	bh=qG8UzuDcZ64WrR4bdPr+wECAUBeSYE1XoeEczL4GqnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOfnsgVHYtT40e3cep+t+VxiVTK3IkyhQBfg1CITYDmyQBMIFCOY4TCUAmwDvsRFon3ujHRsJTlkmZ+YdoP/H9Vou5qKlVii7Uip0w9t8bKEIuHq0/kDKP9p8Xt+eLpFDixBgiv8qXydwYplk5ONQoqyQ5n+4z2mJ5WpgwnBJDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hF6hjJ1Q; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hF6hjJ1Q"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7bcb94d3so52517225e9.2
        for <linux-efi@vger.kernel.org>; Thu, 01 Oct 2026 12:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790884752; x=1791489552; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XVc+fU/zcPUru0u/1bv2Cu0U8wgH+3PGO04gz/Rcw/g=;
        b=hF6hjJ1QQ1jq110jwclgCbvcLgwfI3gdFXB/J+ndOa6dwoi8vp6K/K5Qjb0VAx1Zvs
         Uh35xxvNMmprmr4FjMfcL1W9sZAvovkpoQjmhLA58vnOXiV5wC+2+8KrII/7KdP55sFJ
         yA3LN5LIGxSUL3lufZ8MUIivHSSHGHyWcYHtdAFrqCfOwrKYfdl8kgximPDIh0UVgMKr
         T2QwLDPWFxFtVxEWnkoqiPOVqJZJKbv5JCx3G4OpYiOKq93mIuLV9h4e199esYC+pCNa
         85HkXRrgb1hAbnPJ8TeSnzZwiCRILaax+98rC3liq8A+285q7as42bFTBPUII2dhEVeA
         KxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790884752; x=1791489552;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XVc+fU/zcPUru0u/1bv2Cu0U8wgH+3PGO04gz/Rcw/g=;
        b=WPJS6mhzYtAMkcQpC9ZaEEGAQzpOJlPzIBd4EMQ7B2vKpfIWFlbGVFYcoWiC1iYmji
         mabQ9xLzqjBR7yZAQe70qB5iVxFuGdCvO8JNjGzBytF/5OvtzpOD+nkathdUwcVO6v4x
         r9ejqZFQ6HrvZnAz8DHwOfrvlma21Qy/5vGfjSPkBQ1WdrfJsnDdHOBgYjPD0C42M/hL
         8A2WcAbnZ1S6RQGOYpAdXij1+0o2ObM+5i/jRDg2BhOTk8xPsDnfAcw/0rTCTBSSEDl4
         Su7Whx/SPHNIKbp+c+tWw30uSYv++QJPVkQfVOsv7nPCG6HFBh0hQYiHaHWJcEa6394I
         uJUA==
X-Forwarded-Encrypted: i=1; AKwUvBxqfa5n7VBem5mAKlVbgK9ktzLN2TscUxEn8oXFHd7FKw5eqg2D4XWRsJl8IA5ob30PEtrFowbtCok=@vger.kernel.org
X-Gm-Message-State: AFuF++l/ZiDbi/mNu6JN1yiuGEcLX0afxit5LwiYH0i+tYw3VOJ8UOag
	+myrvXn19m0g/lfBHi/tHBWtxnVr+fnfhNqS+8KW58pE3xyJ5RRyEr4A
X-Gm-Gg: AYBFou0SZkASDWtljT1mStgZAN+kSJg8UGuTx/ApiO1wgvVA8pohHlb6Xn5vhfRKffq
	Hz9WA52T76W+j9wez2e8FuIpNlH4IQ+KWk/8RMWyZidEiVHY5/4lLzdjsNckGh4ULffT6BbDbu0
	k6LYZoHfCJ9EfFpR2svlGOkpp3d9ucwlzkkLHfCD2iA/z/97VnigVHs5KdOSV8KOfAcVs6RJmZ3
	PWlOdrckKYJZ4w+jCt0010ThhhjKW9wTQoo6yuJO6j3epxYoTSsFVIE7nMXS8JVk9WBFxCaYP/H
	xvGI6JYb7KXbEkIyx6lC0nZAJPyrIGq9a+qkQ3wE7CAIEM7oD4VKkkg4OB5s+mYQ+jW4NEVp+fG
	8YKHZkZieFQkDF9U3L2HwNTR9zcOjNppLhhbjhQRT7NpKC3lLlhntwGjX6xCYeeRwlZ7EGW0CZE
	uOPp3qB136VP6RYyoU0KbyPkU9wLoP1X+4ao6MPR4nE3yqb4a5H5dsVztEZ0pAinO/z7N34wwFV
	icZTBLLwx/yuBKbXSigMIQe7TT3ntlrRgjC
X-Received: by 2002:a05:600c:3b01:b0:49f:ce72:e930 with SMTP id 5b1f17b1804b1-4a02758eed8mr12271135e9.34.1790884751563;
        Thu, 01 Oct 2026 12:59:11 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0276f92d9sm15031045e9.4.2026.10.01.12.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 12:59:11 -0700 (PDT)
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
Subject: [PATCH RFC v4 11/13] drm/client: splash: turn the BGRT image on panels mounted turned
Date: Thu,  1 Oct 2026 21:58:45 +0200
Message-Id: <20261001195847.141192-12-maximpedraza@gmail.com>
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

Since ACPI 6.2, bits 1-2 of the BGRT status tell that the firmware
image is not pre-rotated and how far it has to be turned to show
upright on a panel mounted turned. The client skipped such images
altogether, so tablets and 2-in-1s with a portrait panel got no splash.

Turn the image as the bits say. The values count 90 degree steps
counter clockwise, as Plymouth, the main user of the BGRT, applies
them, and as DRM_MODE_ROTATE_* count, which is what they become.

The offsets need more care. For such an image the firmware gives them
on the upright screen, while the client draws into the buffer as it is
scanned out, which on a panel mounted turned is the upright screen
turned the other way. Check them and apply the efifb sanity check in
the upright frame, then move the image's rectangle into the buffer's
frame. An image without the bits is drawn at its offsets as before:
the buffer is the frame the firmware drew it in, so a pre-rotated image
needs none of the guessing userspace has to do for it.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/drm_splash.c | 77 ++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index 30ba6573424e..34f3c3910be1 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -388,14 +388,14 @@ static bool drm_splash_bgrt_available(struct drm_splash *splash)
 		return false;
 	}
 
-	if (bgrt_tab.status & ACPI_BGRT_ORIENTATION_OFFSET) {
-		drm_info(client->dev, "splash: BGRT rotation bits set, skipping");
-		return false;
-	}
-
 	return true;
 }
 
+static inline u8 drm_splash_bgrt_get_status(void)
+{
+	return bgrt_tab.status;
+}
+
 static inline unsigned int drm_splash_bgrt_get_xoffset(void)
 {
 	return bgrt_tab.image_offset_x;
@@ -445,6 +445,11 @@ static inline unsigned int drm_splash_bgrt_get_yoffset(void)
 	return 0;
 }
 
+static inline u8 drm_splash_bgrt_get_status(void)
+{
+	return 0;
+}
+
 static inline int drm_splash_bgrt_load(struct drm_splash *splash,
 				       const u8 **data, size_t *size)
 {
@@ -452,6 +457,26 @@ static inline int drm_splash_bgrt_load(struct drm_splash *splash,
 }
 #endif // CONFIG_DRM_CLIENT_SPLASH_SRC_BGRT
 
+/*
+ * Since ACPI 6.2, bits 1-2 of the BGRT status say that the image is not
+ * pre-rotated for a panel mounted turned, and by how much it has to be
+ * turned to show upright on it: 0, 90, 180 or 270 degrees, which firmware
+ * and userspace (Plymouth) apply counter clockwise, as DRM counts them.
+ */
+static unsigned int drm_splash_bgrt_rotation(void)
+{
+	switch ((drm_splash_bgrt_get_status() & ACPI_BGRT_ORIENTATION_OFFSET) >> 1) {
+	case 1:
+		return DRM_MODE_ROTATE_90;
+	case 2:
+		return DRM_MODE_ROTATE_180;
+	case 3:
+		return DRM_MODE_ROTATE_270;
+	default:
+		return DRM_MODE_ROTATE_0;
+	}
+}
+
 static u32 drm_splash_find_usable_format(struct drm_plane *plane,
 					 u32 preferred_format)
 {
@@ -709,11 +734,21 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 	}
 
 	if (splash->src == DRM_SPLASH_SRC_BGRT) {
-		x_pad = drm_splash_bgrt_get_xoffset();
-		y_pad = drm_splash_bgrt_get_yoffset();
-
-		if ((x_pad + bmp_width) > scanout->width ||
-		    (y_pad + bmp_height) > scanout->height) {
+		/*
+		 * The BGRT offsets place the upright image on the upright
+		 * screen, which for a panel mounted turned is not the frame
+		 * the buffer is scanned out in. Work in that frame, then move
+		 * the image's rectangle into the buffer's.
+		 */
+		bool quarter = splash->rotation &
+			       (DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_270);
+		unsigned int lw = quarter ? scanout->height : scanout->width;
+		unsigned int lh = quarter ? scanout->width : scanout->height;
+		unsigned int xo = drm_splash_bgrt_get_xoffset();
+		unsigned int yo = drm_splash_bgrt_get_yoffset();
+
+		if (xo > lw || bmp_width > lw - xo ||
+		    yo > lh || bmp_height > lh - yo) {
 			drm_err(client->dev, "splash: BGRT image would overflow");
 			return -EINVAL;
 		}
@@ -730,11 +765,30 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		 * the display looking quite bad.
 		 */
 
-		if (x_pad != (scanout->width - bmp_width) / 2) {
+		if (xo != (lw - bmp_width) / 2) {
 			drm_err(client->dev, "splash: BGRT sanity check failed");
 			return -EINVAL;
 		}
 #endif
+
+		switch (splash->rotation) {
+		case DRM_MODE_ROTATE_90:
+			x_pad = yo;
+			y_pad = lw - xo - bmp_width;
+			break;
+		case DRM_MODE_ROTATE_180:
+			x_pad = lw - xo - bmp_width;
+			y_pad = lh - yo - bmp_height;
+			break;
+		case DRM_MODE_ROTATE_270:
+			x_pad = lh - yo - bmp_height;
+			y_pad = xo;
+			break;
+		default:
+			x_pad = xo;
+			y_pad = yo;
+			break;
+		}
 	} else {
 		x_pad = drm_splash_place_axis(splash->pos_x, splash->off_x,
 					      scanout->width, img_w);
@@ -818,6 +872,7 @@ static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
 	/* The BGRT carries no colour: firmware splashes sit on black */
 	if (drm_splash_bgrt_available(splash)) {
 		splash->bg_color = CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR;
+		splash->rotation = drm_splash_bgrt_rotation();
 		return DRM_SPLASH_SRC_BGRT;
 	}
 
-- 
2.39.5

