Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784937;
	b=q6wV81B9irtySyq0Z6Q1w+DN5jYC7EZL5+NL8rYlCIApDwjqv7n0YBkj6Nl4g5qZduTc
	 0iZbQ9RhIDMRoZt3Mciof1tSSXDwm9EH64eMRhlAdb33rSHo0LyzNyOmcRYfbyYnGJ4h4
	 CiZHAAT0Nzxlhy88ONHuwUBFwOz6aQuscqw92OiCEsaY685G6MwOWO6UnF/FlE8FIWRjH
	 s1kCjgkxzfH+WOnKiG0v0RMON9GC/wvSAAgUysZpgt1jGbbkOuFDj3aJ3vFDGEiH5EkUu
	 g8mmG8bH9rq8OhOwzdRyo3irdJNvUE3dh4yDDgWd2AmLycICoLOrcsDUaus47dKO0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Erdyei72788KVv8pLaqul7iSgCQZTDqlNCfVWoF2cUc=;
	b=QXacYTHvfut0O+1R2IKWdKnyOuIBl50gZykj3eWC5pSBeaRcD1ZPVwBk1JMlUraJsEqA
	 won/11yNnS6iGJhMYHCqmEmBnkI7FaLCIPm1oMQuF4CMY6SrJObIhADToPr9c5AELrQ0b
	 3oyp5yJ+EVgofdLEPjE0eump0dpcolmohVxoB6fIbao8mSi3TLoqpc3SLb6n3SFgQDnUe
	 NaFICpyfmkUX/nJReqeuO09Q2KYXAZ1rxok0b1EnQzSwxJlSR36shpa2+pIobH3CQG7E2
	 5W5YSyeLFjZACMXyRcajPUiJZENRex+hZdbQH8/Hw0K/NyxU02nb+PlAQbwzK2tqE2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LopHEaxb;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9076D606A8A2
	for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 23:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9076D606A8A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LopHEaxb
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so2737995e9.1
        for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 15:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794784935; x=1795389735; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Erdyei72788KVv8pLaqul7iSgCQZTDqlNCfVWoF2cUc=;
        b=LopHEaxbU8qluG0bNr0X7YSDk+c0OsgMfGYigZ//YqyCiIDFOvvTCgvq4FYIvzWR5L
         2WxbabMKUv2GXxZwVT777BbykE9Pt73WrQ3c8jH0H6c+Yk/nSQLHK/ROeiv3Tw72dKXm
         8LOi/aISgXUGLQTrQ+bZsiW+vtc3Hlkwm+8czErJfQgaIxkrhqXzLcNubNchYhvq9ORX
         7d32GFh8QvbGh3Tp662n1q2rwQFnjBYjEYczFxotThVDzUblLAEP6ycMVbZ8UwQTCNZ5
         xI2aLRfs9lVYfboicZmB1tcl1R+v80EYEwjVpU7PH63NTXJXLv7CFu1m6U9UeZmjcqNe
         gZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794784935; x=1795389735;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Erdyei72788KVv8pLaqul7iSgCQZTDqlNCfVWoF2cUc=;
        b=G0wEiH7bI75IhoAapjlMm0t2ihPHsacRYgCw6QFweAIsdKl2RxYkQRqFCvVR/KK1o8
         XsXsT9zVYQQTvay8QdtSDig6qnEPc0MkDQam5Yb2dAwD2yB3p8x8BHWfXR77Ghzh7y4D
         DatiX3YGjtI827CbfGktRnU2N1JRdaJdfgTSL5iuVLpF23Cw2EpIKqUKwkNJlm7tzI0S
         8gLh+nOGQc/zLd4bClW7UT9A6BpHgj/3mepkSXm0kWLjSUHBZa4mVNIW5K+SOHH42FT7
         EgwQc1hxMt8EtFfB8OSxCVIYdkGdt0uZ7P5Lvtv43jlFuOuGZd21yXmw9pRwdf+xkyNq
         f6sw==
X-Forwarded-Encrypted: i=1; AL+hErEWWwVcRj6YeUkHFUjR7yVhiePTrVv2JZBs8gDwnwXwF50DoZBM5DXB2yrxs+IYVE9B5fizY975kRo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8NLzrP5zQY3M5ruu2jMpW4hodLNOtr7zh41Zo0+BCWg1GTBhtT
	mx8T952MmGFAkRfG8hhzCtEahrvXnwnxrp57+s/18v92RSTMb2o4YtBr
X-Gm-Gg: AYBFou2fLhbaYTw5Ht0sT+z4Wx3giTnucJSVwwV0uVVxShicWnmgaQzXFHas/5J4MIa
	vlv7EozxP03ufwnGec3n9lDagkrfKsidDr+tFWz6PTNz3lnSXU9rUpvtmI1t3TNbjWVmtkKNlaO
	hPau08ZI0mPGaCqnWpUazkwgRQSzfxqk1AewMttVagtmTt74GHBHwzhowW1efoAHzqjj4IKXGvO
	tnrP9S4U85SJij5ddDSufhcjxwosPf9Axk1takstPXl0UACMj6p99ZONV4k1y05RBGBa4XqrVUV
	JNjc8mN0v/+VauVKP7ml0p1Yak0Zx8QtSnh5v2NcGjP3I+ZWvAd1EXRLCcidzAXvCMNxDAKyD2Y
	6oA+mk8GtTmdMEwEkKSNVZbIzizu6f3PVt3Qxty4xkDaA9AuoEy8yS1Sia03c4ZnSDF5CQ+979n
	4Qg25fS3niTsQVsx5OZJCC6lLx9052j8Va3MnAgo5IJO8eqLFO4xXYfxGW7IGUzbUrvwXROCxk1
	glaou3XYvhv/dTRgUYNTl33mIHtRzyrsWLfWhh/5J8kINZlChu95UnCgK/m9uAkRk7ol9S9vdwY
	o6HTiyocjlIMimxQlchJPsEqxJUOJb40aWF10yVkM13iOU1rFDqEcl8=
X-Received: by 2002:a05:600c:3509:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4bb559f2cc3mr183275325e9.2.1794784934909;
        Sun, 15 Nov 2026 15:22:14 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f976esm127920955e9.3.2026.11.15.15.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 15:22:14 -0800 (PST)
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
Subject: [PATCH v7 6/6] drm/client: splash: pick the image source in one place
Date: Mon, 16 Nov 2026 01:21:56 +0100
Message-Id: <20261116002156.1027726-7-maximpedraza@gmail.com>
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

The client chooses between two sources with a boolean: the BGRT if the
firmware left one, otherwise the BMP loaded as firmware. A third one is
coming, and with it an order of preference that a boolean cannot hold.

Name the source in use with an enum, picked once by
drm_splash_pick_source(), and have drm_splash_image_load() switch on
it. No functional change.

v7:
- DRM_SPLASH_SRC_FW for DRM_SPLASH_SRC_BMP: the BGRT is a BMP too

Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/drm_splash.c | 46 ++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index d54cf628cf17..fbbdc034e417 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -39,6 +39,16 @@
  * a static image.
  */
 
+/*
+ * Where the image comes from. drm_splash_pick_source() sets the order of
+ * preference; NONE is zero, so that a new splash starts without a source.
+ */
+enum drm_splash_source {
+	DRM_SPLASH_SRC_NONE,
+	DRM_SPLASH_SRC_BGRT,
+	DRM_SPLASH_SRC_FW,
+};
+
 struct drm_splash_scanout {
 	int id;
 	/* Modesets scanning this buffer out, by position in the list */
@@ -91,7 +101,7 @@ struct drm_splash {
 	const struct firmware *fw;
 	void *map_data;
 
-	bool use_bgrt;
+	enum drm_splash_source src;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -439,7 +449,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		return -EINVAL;
 	}
 
-	if (splash->use_bgrt) {
+	if (splash->src == DRM_SPLASH_SRC_BGRT) {
 		x_pad = efi_bgrt_image_offset_x();
 		y_pad = efi_bgrt_image_offset_y();
 
@@ -509,13 +519,31 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
 				 size_t *img_data_len)
 {
-	if (splash->use_bgrt)
+	switch (splash->src) {
+	case DRM_SPLASH_SRC_BGRT:
 		return drm_splash_bgrt_load(splash, img_data, img_data_len);
+	case DRM_SPLASH_SRC_FW:
+		return drm_splash_fw_load(splash, img_data, img_data_len);
+	case DRM_SPLASH_SRC_NONE:
+		break;
+	}
 
-	if (!IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_FW))
-		return -ENOENT;
+	return -ENOENT;
+}
+
+/*
+ * Pick the one source the image will come from: the BGRT is whatever the
+ * firmware shows, and the BMP loaded as firmware is the fallback. With
+ * neither, only the background colour is drawn.
+ */
+static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
+{
+	if (drm_splash_bgrt_available(splash))
+		return DRM_SPLASH_SRC_BGRT;
+	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_FW))
+		return DRM_SPLASH_SRC_FW;
 
-	return drm_splash_fw_load(splash, img_data, img_data_len);
+	return DRM_SPLASH_SRC_NONE;
 }
 
 /* At unregister, once nothing else can use the image */
@@ -858,10 +886,10 @@ static void drm_splash_rebuild(struct drm_splash *splash)
 
 	if (!splash->source_picked) {
 		splash->source_picked = true;
-		splash->use_bgrt = drm_splash_bgrt_available(splash);
+		splash->src = drm_splash_pick_source(splash);
 
-		/* If no other image has been loaded, try to load a BMP as firmware */
-		if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_FW) && !splash->use_bgrt) {
+		/* The BMP loaded as firmware is the only source that arrives later */
+		if (splash->src == DRM_SPLASH_SRC_FW) {
 			ret = drm_splash_fw_request(splash);
 			splash->fw_requested = !ret;
 			if (ret)
-- 
2.39.5

