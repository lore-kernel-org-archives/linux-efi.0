Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109261;
	b=wTt7jWjcg9gh4xOE2e0aZCYn9idhbCB8A5iirG40AGlWCDHk+KfBy3bVsRQzKtkK/KPT
	 qjb/8gAN1CPArTQ7JTI3jCoEvNlO2Nt/Hn8XQ2gQL9IqZpRQZlox9J9ZJg5S1h3gWwxqb
	 mah1eabPY94ZI949gRzh+cUCp8N8dcbwGW5J1pVHNOq0TO3dNJBCxBGmD4ujTIIRN8x54
	 IqwMvCuWeHRDqq4Px3PCLzZp080hEM+Kt6138330nYNYLmCT3C0VPxoYpxC2e+0FURQiN
	 1P7ATEgCCgNA5DX6PCQ3RabRP3x5EIg/Mdw4sKojshbU7Pj+PawlvAPDNgx0ODqk3lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109261;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kjJRYbm0P/rhDwIhbhLgzvyBgDKoIc1GRXvwAOHpom0=;
	b=nUSuy39cPabXmEgAluT5dy63jHblVZAyWw3vv2njwNSO4c7YadN14Bjs1JAPif+ywARA
	 z8gD1WGJQW6/EUlFlpzYEj4d9iNYKRFKNvCZgCW3DEfHpJz1ej59xNtwio/6Thw1kFC2n
	 wK4RxWCkTXjbu7dU/0ltFvmP1UEiz6L5608haIgzNq4n5T6SUBZSMt6Ei8HjUpxFkfFha
	 R8T6HolWCJBWBleNbPZBeAO/HEJ0NXY57FIHQ60h9TcqvYRqrjP87QQLm9SXRS4/sPQfH
	 RS5TDdvjaCrBjZvX19T8xGMbDJRoCfMkHaki3hNVzRbNbCN0OUFBCXq45RvXwAkkB/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dc5b9Y4f;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E8360A5BE7
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32E8360A5BE7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dc5b9Y4f
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso17188985e9.1
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109260; x=1793714060; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kjJRYbm0P/rhDwIhbhLgzvyBgDKoIc1GRXvwAOHpom0=;
        b=Dc5b9Y4fElW6aD+qlyDx5q58yC3WySxSke+A42Ru3IEaWhIZkmQiS7fEXmuMHJhcTy
         9QA9WruBw7Vd//qzUoXTKsf+u4yO5iKMWbqw0VBOmRLHAekyl7ZTWmmKAsuWIA0KtgrS
         wd4U5Q8i92pyCTSMBgc1IlnjphMnMzS1LpOx9V6tmqiTtvkGauL2sBz8yYkSMkbkqF0g
         mDFOUe5oP8He2HMi4w/e/8KLYXXbUmNEjwZ6iZyT5Aw/392osb5+I0xA4jxg7Su81VmO
         kfXxWF2ekvzBDwgMg2yi3sUndI7aAWI2h4vLFCvPXdG3FTNdBq1o5xN0nk8/sXFi95JN
         WrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109260; x=1793714060;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kjJRYbm0P/rhDwIhbhLgzvyBgDKoIc1GRXvwAOHpom0=;
        b=UxZo/5N9ZyzDTtKAJXoIKSeksexZH0o9Qddf/1+5ZS4FJm3QR4BRAojKt9NHqugP1s
         M1MUgknYQbvLiFD0Pu2x7j5+9SV1t2nR/f//LGfy8vODm51iorinS12xyHlIvqmTdtH1
         CS6FvtkJw3U5culcosby7IPc9KiVGUeVvJrFoeTEkBPXfFDe/XJEnpFijj6sIGhWSRKq
         ORNZ2XQ1kdWwE9APRrFS0s2a7/uJ7AXQjg63z3ft6UPKUDyTHpOD2roEBTane+RrLtz3
         P/Z+e9hcSnXgyecMsv1JlTRUhB9VrvC1MzdOaW+/D78Dq3FUrDaSN+W30xvsbURmkbZi
         gDjw==
X-Forwarded-Encrypted: i=1; AKwUvBwGxJHpg9LmueB+FGkmY2YStcd9CrL9bu90p21ERDRn7CBU0I2AoTBhg0ACnHdr60bq5ZWKIAXn5sY=@vger.kernel.org
X-Gm-Message-State: AFq9FYK0qnSed8CGvT52CS5geHoHuObiUfdAfju6RtVO/A4rjhazZWEG
	TnHnRcuJGL9+xZwF1TiZv6p0rr31ies+t3mxZa94yinPn/y4rhYq6bX4
X-Gm-Gg: AYBFou1WJ+SpU0dX7Ae1wGymnSQf3lDfzRjoCWB/I9BKaZnsOKlmUZTOugivbkFTUoE
	hl8EzCNLP9uKmKpNPVqleK8rqh7Y47GlrpOfE5h1K5LGTcMAwqlIsuLf1/VULMdFwHtyFpee1z0
	Ez892C5kyMOMRQ3T/vkazkCFrqR3y2FCUVEVg1nABz7fB0zZ7kxm71QGyM52llLTIH1q2kAdN70
	qujNn94Dboigac7lKpagqpPhP4VebcTRW8gUxkC4TrwGoYEjFARHm0iClBFKshrVAlw+q3O62si
	3eeD8WOfU8gq31dq0mK8QLqI3+/zOLnxR5ltftQM8qmFQQDQhVE34ZyEUoM8uEHo189ZfJ2HDhl
	P5beZyRbs+5TTVQIMF6PO5feEJT8P2uU22Lk4r+8YfQhvHJoFpbP8bzW62fbQPHN1da488IAoTD
	+YCXt4FSHvTFbHcpOxxE4TeBMDxiR9uGz1Qe0gM6oQdNxLMSN+MIf3+KDJbfQyLP/oKl9CdIzos
	Q+UnR/iGp58mzPPGvYGpCBZbhR2kY6rOWJUku02gflexQfiIeNLzitpUWHtFmgcLUG/BQFe6Q7t
	nnvLSRI=
X-Received: by 2002:a05:600c:620f:b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4a35acc731dmr180025295e9.31.1793109259383;
        Tue, 27 Oct 2026 06:54:19 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:54:19 -0700 (PDT)
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
Subject: [PATCH v6 15/15] drm/client: splash: document the image sources
Date: Tue, 27 Oct 2026 14:53:42 +0100
Message-Id: <20261027135342.2003632-16-maximpedraza@gmail.com>
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

The overview only said that the client draws a colour or an image. By
now the image can come from three places in a set order, and be placed
and turned. Write it down: the sources and their order, the image
format, placement and rotation, and the background.

Also note that the splash rules out fbdev emulation on the same device,
and that a bootloader that loads no image into a reserved region has to
disable or remove the node, since the region can keep the previous
image across a reset and even a short power cycle.

Pull the overview into Documentation/gpu/drm-client.rst, which covers
the in-kernel clients, so that it is published.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 Documentation/gpu/drm-client.rst     |  6 +++
 drivers/gpu/drm/clients/drm_splash.c | 61 +++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/Documentation/gpu/drm-client.rst b/Documentation/gpu/drm-client.rst
index cbcfe30de777..a58d6440d9f2 100644
--- a/Documentation/gpu/drm-client.rst
+++ b/Documentation/gpu/drm-client.rst
@@ -16,3 +16,9 @@ Kernel clients
 
 .. kernel-doc:: drivers/gpu/drm/drm_client_event.c
    :export:
+
+Splash client
+=============
+
+.. kernel-doc:: drivers/gpu/drm/clients/drm_splash.c
+   :doc: overview
diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index d3ed53cde0f5..0fc72a3fe989 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -40,7 +40,66 @@
  * DOC: overview
  *
  * This is a simple graphic bootsplash, able to display either a plain color or
- * a static image.
+ * a static image. It draws once the display driver has registered, and again
+ * on every hotplug, on the outputs there are then, until userspace takes the
+ * display over; when userspace lets it go, the splash is shown again.
+ *
+ * It is selected with ``drm_client_lib.active=splash`` or
+ * CONFIG_DRM_CLIENT_DEFAULT_SPLASH. A device has a single in-kernel client, so
+ * with the splash there is no fbdev emulation: no ``/dev/fb0`` and no
+ * framebuffer console.
+ *
+ * Image sources
+ * -------------
+ *
+ * The image is a BMP with a BITMAPINFOHEADER, or its V4 or V5 extension,
+ * 24 bits per pixel and no compression. It comes from the first of these that
+ * is present, each built in with its CONFIG_DRM_CLIENT_SPLASH_SRC_* option; if
+ * that one then fails to load, only the background is drawn:
+ *
+ * 1. a node compatible with "boot-logo" under ``/chosen`` in the device tree,
+ *    carrying the BMP itself or pointing at a reserved memory region the
+ *    bootloader loaded it into, if that region can be mapped (see
+ *    Documentation/devicetree/bindings/display/boot-logo.yaml);
+ * 2. the EFI BGRT, the image the firmware showed;
+ * 3. the BMP named by CONFIG_DRM_CLIENT_SPLASH_BMP_NAME, ``drm_splash.bmp`` by
+ *    default, loaded as firmware, for instance built into the kernel with
+ *    CONFIG_EXTRA_FIRMWARE.
+ *
+ * With none of them, only the background is drawn.
+ *
+ * A reserved memory region keeps its contents across a reset, and may even
+ * across a short power cycle, and the kernel cannot tell a stale image from a
+ * fresh one: a bootloader that loads no image there disables the node, or
+ * removes it.
+ *
+ * Placement
+ * ---------
+ *
+ * Everything is given as the screen is seen: once turned as its connector
+ * needs, for a panel mounted turned (the panel's orientation) or as asked
+ * with video=...,rotate=. The plane turns it in hardware when it can, and the
+ * splash turns its buffer in software otherwise, as fbdev does with the
+ * console. A panel mounted turned is described on the panel, not here.
+ *
+ * The image is placed at a position in pixels, where -1 centres it on that
+ * axis, and an offset is added afterwards; the result is clamped so that the
+ * whole image stays on screen. A rotation of 90, 180 or 270 degrees counter
+ * clockwise turns the image and not the screen: position and offset stay in
+ * the same pixels, and a quarter turn only swaps how much room the image
+ * takes up.
+ *
+ * A device tree image is placed and turned as its node says, and any other
+ * image is centred and upright. A BGRT image is the exception to the above: it
+ * is drawn at the table offsets on the screen the firmware drew it on,
+ * unturned but for the table's orientation bits.
+ *
+ * Background
+ * ----------
+ *
+ * The rest of the screen is filled with the node's "background-color" for a
+ * device tree image, and with CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR
+ * otherwise.
  */
 
 /*
-- 
2.39.5

