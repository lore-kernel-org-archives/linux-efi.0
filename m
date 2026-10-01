Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50B52F29E
	for <linux-efi@vger.kernel.org>; Thu,  1 Oct 2026 19:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884760; cv=none; b=VtxM8eMupPWG8mX80EyECXq78huGYyewOHzJNe3SXU6bHZeBV0kPTIz/GUPSug51Ji/Qy80HjLI+yEsxmeXCFFywzrc0bPPHfLVl/9dQe5ribvFu4GfNI8xDnZDRt8a4PJg2/Kt/GzFXGMarRM9fNyGoTTqP/3+NqImRtMapCXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884760; c=relaxed/simple;
	bh=hkVriyjexyRCyWOKDMY74VraG7CnbvsOGSfP7W1sENo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OkrsicMGoqDvsirAAiP+CCHV5FjC4XzT/D59dEtS3hgQeBT/9rhbk2U02bMZ0XlNm0BPCjBOfJdJ6aLI2p/cnQwl5EMZ1KFsmwp3fBAfa5qwdqgkDRCeXRg9NOWzctqDFw6pLx9Twypk7funGeFo4kebIRQxeXqQq3RpKayW8II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emYWmFtB; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emYWmFtB"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so43541595e9.1
        for <linux-efi@vger.kernel.org>; Thu, 01 Oct 2026 12:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790884755; x=1791489555; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6RrSkqTXqNdvcO9If5wraMvoT6iTfXjvMrsjx83kGx8=;
        b=emYWmFtBiAsdML9tt3GpMVS7cD0qM0beXQzDQ+ppklBK2r9g1G/JANk5UwuMRq9bzM
         gj3rLA0uSuSh9wN7TjxIxXS3Zr0+usasBwT+a0+bI4BsEs6rxt5FQ3usdUBxPrdTt91E
         7j838En1AtqfA7+trTC0cSBWpve0Q5zCEWYeXHLeBBYXEOhnn09fb77ofwpgT/O87iz/
         vH6r7QrmNLSRsNUtIdFLirW13Wex25Ak8nDJGeU7ZjoYcU7WhS/JopQKH4jEn79nvYx+
         6lmoQiFKgLPmEJMSW19jtmmu6dQEQr6XwQKEIsFSvj3byA59p9yOcHo0bTkR59FVtfTg
         L/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790884755; x=1791489555;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6RrSkqTXqNdvcO9If5wraMvoT6iTfXjvMrsjx83kGx8=;
        b=iKFhvlgWOVL4mQWAfLZUMZzC97eJjexK+Kdc+XCf2dRo9HLzULa5pepwHx+xNwGyZq
         LxdCVtUfOmcS4rXDmSqT7Uj9IjWKheYOPt/x2DAkCZ+o4ogAh4N68HAl1XmV2s3tdRAG
         IcX/QPeXl1nElvoIwLwHIEaIKMPr35kAvXh2q5q1tr61pSlBXoPcsLMYwpuV220ccOsx
         8Ygvb3R8NgVbJ9PPNX54eIJHa89rbYO8zHwM3lAQ3HLWsWHyqQqSo15Kd8p3djl0Xcgc
         yshG0xmiwsdVJZKoZ6ZDXNDuSE9ZM/ZkKrHcC3xoJK0BfE3K0q3zKq0cRgFexcOyTM9W
         BktA==
X-Forwarded-Encrypted: i=1; AKwUvBxlk1+YKaLCYriyFkYWBPeJiB+1OOwbph9j8CaaVf9oaGXZwQathh4QXeSBwyeuLC+HET9P0pbXWyY=@vger.kernel.org
X-Gm-Message-State: AFuF++m3tPLSywWD7Vbc3BS+VoSdCvpaKP8Gsle5GaF6t2pKFw5gU1JG
	6Exa3KTj11A8njEK8EzYrlGn2pcf25wwG9bbNJHtVJwlUtdjRrM8XeUA
X-Gm-Gg: AYBFou3TMQZtzKIgzmpFLDkeL98MtFmb40YWGs85HygSUi1m/7WYddyg0HjzHgobO17
	XMsT0Op8utUW8ESn7kEVm3oq5Qu8aSQcL7phqN3fE5Oi5rGgNYuUjvUADwWletAuQAwUVaN7JZa
	kxEmjp1ZKsc6A9W/261NfuMsf9PBIMCsiD6wGzOY9k0w0OawgxNQT9VrPjpv56KOdJRI7kAP8C/
	yyF9v9GUpGdSnbURy0shHafFnw5DW+H12FiYO+K+s11ud5+Ez/lp2gs77grY8wIXKvDiZNPUEa/
	UCgbaq94RTf8dQlf9MAzo3CjD36eyOUWfLeHm3TeJNVCRGK86HeahHtFdxO7OBkzZ4Oqmn0sHbk
	7CZfPe48PW/50YfgvdNkHtKBzuxWnrMuEtmOHop6GDWojkze0qO4T8nWnUDAwiri3k/mRv5Vcr3
	oMiFQSWivWofftI7CZA20ab/jC/2KJqRKUeFrB+N6US4ORwbImtvGT9S6c41n8mk6/fcAX/VTbR
	W7ZBMbJPkASJ16bzi7gcrrrXQ==
X-Received: by 2002:a05:600c:6d1:b0:4a0:1d3d:502d with SMTP id 5b1f17b1804b1-4a02755f856mr8018525e9.10.1790884755180;
        Thu, 01 Oct 2026 12:59:15 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0276f92d9sm15031045e9.4.2026.10.01.12.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 12:59:14 -0700 (PDT)
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
Subject: [PATCH RFC v4 13/13] drm/client: splash: document the image sources and parameters
Date: Thu,  1 Oct 2026 21:58:47 +0200
Message-Id: <20261001195847.141192-14-maximpedraza@gmail.com>
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

The overview only said that the client draws a colour or an image. By
now the image can come from four places in a set order, be placed and
turned, and every part of that can be overridden from the command line,
each parameter for its own part only. Write it down: the sources and
their order, the image format, placement and rotation, the background,
every parameter with its format, and what a parameter given alone
keeps from the image source.

Also note that the splash rules out fbdev emulation on the same device,
and that a bootloader that loads no image into a reserved region has to
clear it, since the region can keep the previous image across a reset
and even a short power cycle.

Pull the overview into Documentation/gpu/drm-client.rst, which covers
the in-kernel clients, so that it is published.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 Documentation/gpu/drm-client.rst     |  6 +++
 drivers/gpu/drm/clients/drm_splash.c | 78 +++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

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
index 8d056edfee56..85083337870c 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -37,7 +37,83 @@
  * DOC: overview
  *
  * This is a simple graphic bootsplash, able to display either a plain color or
- * a static image.
+ * a static image. It draws once the display driver has registered, and stays
+ * until userspace takes the display over.
+ *
+ * It is selected with ``drm_client_lib.active=splash`` or
+ * CONFIG_DRM_CLIENT_DEFAULT_SPLASH. A device has a single in-kernel client, so
+ * with the splash there is no fbdev emulation: no ``/dev/fb0`` and no
+ * framebuffer console.
+ *
+ * Image sources
+ * -------------
+ *
+ * The image is a BMP with a 40 byte BITMAPINFOHEADER, 24 bits per pixel and no
+ * compression. It comes from the first of these that provides one:
+ *
+ * 1. a BMP loaded as firmware and named on the command line with
+ *    ``drm_client_lib.splash_bmp=``; ``splash_bmp=none`` asks for no image at
+ *    all, and a named file that is missing gives no image rather than falling
+ *    back to the sources below;
+ * 2. a "boot-logo" node under ``/chosen`` in the device tree, carrying the BMP
+ *    itself or pointing at a reserved memory region the bootloader loaded it
+ *    into (see Documentation/devicetree/bindings/display/boot-logo.yaml);
+ * 3. the EFI BGRT, the image the firmware showed;
+ * 4. ``drm_splash.bmp`` loaded as firmware, for instance built into the kernel
+ *    with CONFIG_EXTRA_FIRMWARE.
+ *
+ * With none of them, only the background is drawn.
+ *
+ * A reserved memory region keeps its contents across a reset, and may even
+ * across a short power cycle, so a bootloader that loads no image there has
+ * to clear it: the kernel cannot tell a stale image from a fresh one.
+ *
+ * Placement
+ * ---------
+ *
+ * The image is placed at a position in screen pixels, where -1 centres it on
+ * that axis, and an offset is added afterwards; the result is clamped so that
+ * the whole image stays on screen. A rotation of 90, 180 or 270 degrees
+ * counter clockwise turns the image and not the screen: position and offset
+ * stay in screen pixels, and a quarter turn only swaps how much room the image
+ * takes up.
+ *
+ * A device tree image is placed and turned as its node says. A BGRT image is
+ * placed at the table offsets and turned as its orientation bits say, the
+ * offsets then being given on the upright screen. Any other image is centred
+ * and upright.
+ *
+ * Background
+ * ----------
+ *
+ * The rest of the screen is filled with the node's "background-color" for a
+ * device tree image, and with CONFIG_DRM_CLIENT_SPLASH_BACKGROUND_COLOR
+ * otherwise.
+ *
+ * Command line
+ * ------------
+ *
+ * What the command line gives wins over every source, each parameter only for
+ * what it says, and only when it is given:
+ *
+ * ``drm_client_lib.splash_bmp=NAME``
+ *   BMP to load as firmware, or ``none`` for no image.
+ * ``drm_client_lib.splash_color=0xRRGGBB``
+ *   background color, whatever the image.
+ * ``drm_client_lib.splash_pos=X,Y``
+ *   position; ``-1,-1`` centres, ``-1,183`` centres horizontally only.
+ * ``drm_client_lib.splash_offset=DX,DY``
+ *   offset added to the position, for instance ``0,80``.
+ * ``drm_client_lib.splash_rotation=DEGREES``
+ *   0, 90, 180 or 270, counter clockwise.
+ *
+ * Positions take both values, or are ignored with a warning. Since each
+ * parameter only replaces its own part, the rest keeps coming from the image
+ * source: ``splash_offset=`` alone moves the image from where the source puts
+ * it, centred for a BMP loaded as firmware, and ``splash_pos=`` alone keeps a
+ * device tree node's "logo-offset". Give both to place the image exactly. A
+ * BGRT image placed from the command line is placed in screen pixels like any
+ * other: the table offsets are then not used.
  */
 
 /*
-- 
2.39.5

