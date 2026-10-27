Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109246;
	b=Rqto3xkN6aiCWrjgU/1blgDXhlTwW36x4wYK5PsBHDFdtgiGXfJ2vryGM4ANqDEd88zT
	 tN9NU4h2LIhYUnsdwDITBjgWtkufi7hOVZJfkY2BmXdcY774OZhRhPrp1SAhN3P5uc5lb
	 9ChmCyryhNNRXuUiY/QIc4uvwTQmV10m1c4DLcvunN9pvdA0wcVtqv/sSIPmhSJba5PPK
	 81e1uCpn/qdP/UY5ggeuUPFAHR3tQm5wB4huNq5ENVu+XpYje/GZWIMKMhMqrppeM7zaR
	 ZDvb8Y9wgu6ccuRuXEpxxlplWSdUHlcSEdn+Fb2Q1diBrdNquseb3hHqbWzTR4XRbKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109246;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x3TRWoAym08EDkUmxJbEElxgHRIsBB4gzy6Y/BELf6M=;
	b=rYWrFiKZKfqalCclnEl7Dph6E7xDh8DyxKlK48Nhr5bGynDlJvNZ3dGAIUM+dsGItjjh
	 eQ382UxwSD4CrdTr69r1QdJ0QdDAaJMKAIkUCpWHfquzfCZAkRlkrrPtxjMvUFMYATdPD
	 DaBXh5DQpFGLYb1ermCi6orSuda38M0K9csnpIH0gOwqGZf/M6eEdbj0lw/OXyuj9Ek1J
	 Z1pMQXmvfcgNlGDrpRKr7jpQBNye0+UaMYeCb5hQ3VRaz0IQlLQSV+kVmMhIpPRyNi/cx
	 B8AcLp3yV0u1EaMBdIp/9/8BcCm/yDop1D2GTEnOxhErbonYiJNCw5KWldhLdEntScg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CXibKdWQ;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774C960A3831
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:54:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 774C960A3831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CXibKdWQ
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48c45111bebso1908959f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109245; x=1793714045; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x3TRWoAym08EDkUmxJbEElxgHRIsBB4gzy6Y/BELf6M=;
        b=CXibKdWQ9F7anjrgC0VMM7aDjT7IZMsjrShnAhjebv9ylc+23J4tWOL8QvB+1moPRX
         +ccoc8d11rCpEb7OtfOrgtPIf/fT8tmb8PVCSRTYx4nbwMkcpY2vtHqVUEpb/OC3PRSX
         n0Ia7Prd8lLKUDe1UZtgqbfo5N4cIvFxQz6SXiyEYg+iyq3EZ/1FhxyWHv5iBM4l7xCx
         7F2ocwI8m+BeAbnle6aJRUD9PWHXDbHOYkGek9AI74WYQgNsj7qt8kMlhNAd0+KVokOO
         6MNd4RtF0WI/55ngrMNg6XmUK6c78cp3ggmzgkKmzUywXESizZ7nCpjNOly4WKzfIN4I
         Qk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109245; x=1793714045;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3TRWoAym08EDkUmxJbEElxgHRIsBB4gzy6Y/BELf6M=;
        b=P1uChqPeLChEOmnrrzm4JP1/XOhzeM3SdvN+gxm7vKhc/GYcPgtCOAkpLj3W+Kd+xn
         IQzZdemn5s5qvJ8o/2Nm4x1Rvs/uJMGJg+VR/6dZvpwVDQkybMNASsasLzvUTLU+d8hA
         tu3h8od7CJW3iK16SHR2qu4NgrosF1SpVapYAdvNMFrH6naEIfzqnCfoXk9/li127n84
         dgMjvUoTvvzOrtPjIgGejbgagVj7Mof+RefRnn8amtojAFP7Wcle6WGX1l+EXfKoUH7S
         fVjevTXK6e92nzrIfRg3nIlfPVJLVscBRE84nzmhjt12pHI/KJW9rSI8ojn7Bje/w+vs
         oYTg==
X-Forwarded-Encrypted: i=1; AKwUvBzT3hVOoIpZYx31PVTZhXdlXUCcZeuzblPurmD4HXSIP+clsivFaJe3T/xkWgG5BSMYRZmDLldW0os=@vger.kernel.org
X-Gm-Message-State: AFq9FYLzaI00sCsyUVzBMp2KdMZJb8SHhtEhJE1h94gQgADSZCqo725V
	yXu+d/AwiVC8eJfALxZddiKAKHqAkinz72L5jdzQiRCHV2gBjIEcsAJD
X-Gm-Gg: AYBFou08Fg8Z8Kyy9C+FjXqXMX2QIbWwNmpm1E/MAICG887OTb8wtGt5CgFVAEQdscB
	0Ay39WiTO9RlhTdzgNcpVVlAgxvkUIKT9LFDG+2C4V8vRYlmopk8IdchARBD2fIK+3foc6ig2e/
	qv/e2eLmM2whtUwL9ahg5/wseu7Inx/vQBdrgpvMjUwyq9hEAb4nbPMdKNyTD+lBDmfGu+TBsRN
	1xX21sQyCwrxvMZ2zhPv4BSusLNmBZb1r3X6nfL2K0ZmAMilkHphdBhScmBczYUVn+hgOCTvdo0
	S1VApdsKb/Ob1fVPJw9AlOuoJb6/Tffe2Q+8RNTzXsopojT4yUpmSmLZS4IVrDkSduFA4pm2Bmb
	kcEaPY5VQBZfzA141Pm1R+s588OCJNYNZNGRD/lhmhBkqjrV99ef5bWctyb+NS288TJk+4gWX3z
	ik0Vug9ADNk4OHNBEXrbKeLLoiEkuieBM2a6SwDjGkepTqNAuH+JbD5Xa8peFRsvFrpyyQDe+vC
	SzkKQQ/0Qu7Fm7pJknlJwEjzMsoYKF4nWatLZQ3KEQyDCa7TVyCs1eAJxPN7QdfBLBLeZSTPk0o
	NAxsrt3knMfMAh9nwztDZdJKkHQ7
X-Received: by 2002:a5d:5d10:0:b0:48e:1c72:abc with SMTP id ffacd0b85a97d-48e3eb9890amr18924302f8f.35.1793109244645;
        Tue, 27 Oct 2026 06:54:04 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:54:04 -0700 (PDT)
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
Subject: [PATCH v6 08/15] drm/client: splash: pick the image source in one place
Date: Tue, 27 Oct 2026 14:53:35 +0100
Message-Id: <20261027135342.2003632-9-maximpedraza@gmail.com>
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

The client chooses between two sources with a boolean: the BGRT if the
firmware left one, otherwise the BMP loaded as firmware. A third one is
coming, and with it an order of preference that a boolean cannot hold.

Name the source in use with an enum, picked once by
drm_splash_pick_source(), and have drm_splash_image_load() switch on
it. No functional change.

Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/drm_splash.c | 45 +++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index 337c7160c4a1..911149b92a52 100644
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
+	DRM_SPLASH_SRC_BMP,
+};
+
 struct drm_splash_scanout {
 	int id;
 	/* Modesets scanning this buffer out, by position in the list */
@@ -87,7 +97,7 @@ struct drm_splash {
 	const struct firmware *fw;
 	void *map_data;
 
-	bool use_bgrt;
+	enum drm_splash_source src;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -429,7 +439,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		return -EINVAL;
 	}
 
-	if (splash->use_bgrt) {
+	if (splash->src == DRM_SPLASH_SRC_BGRT) {
 		x_pad = efi_bgrt_image_offset_x();
 		y_pad = efi_bgrt_image_offset_y();
 
@@ -498,10 +508,31 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
 				 size_t *img_data_len)
 {
-	if (splash->use_bgrt)
+	switch (splash->src) {
+	case DRM_SPLASH_SRC_BGRT:
 		return drm_splash_bgrt_load(splash, img_data, img_data_len);
+	case DRM_SPLASH_SRC_BMP:
+		return drm_splash_fw_load(splash, img_data, img_data_len);
+	case DRM_SPLASH_SRC_NONE:
+		break;
+	}
+
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
+	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
+		return DRM_SPLASH_SRC_BMP;
 
-	return drm_splash_fw_load(splash, img_data, img_data_len);
+	return DRM_SPLASH_SRC_NONE;
 }
 
 /* At unregister, once nothing else can use the image */
@@ -818,10 +849,10 @@ static int drm_splash_client_hotplug(struct drm_client_dev *client)
 
 	if (!splash->source_picked) {
 		splash->source_picked = true;
-		splash->use_bgrt = drm_splash_bgrt_available(splash);
+		splash->src = drm_splash_pick_source(splash);
 
-		/* If no other image has been loaded, try to load a BMP as firmware */
-		if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP) && !splash->use_bgrt) {
+		/* The BMP loaded as firmware is the only source that arrives later */
+		if (splash->src == DRM_SPLASH_SRC_BMP) {
 			ret = drm_splash_fw_request_bmp(splash);
 			splash->fw_requested = !ret;
 			if (ret)
-- 
2.39.5

