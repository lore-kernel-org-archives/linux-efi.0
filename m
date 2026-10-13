Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B847ACDD
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884004; cv=none; b=gnOlqYTuLDLYImeGD8uGutiC92AaK4rmKFOIO5wksaYH7KhdDZovupV7zRBN60H7bKpUHig9IpFcvLtg3cmWigCXPhObpxRc6rVN4cNgRgBF1I1pZfBq6laT4cuYyen67JkqnlBw319aL8DNvrdoFDJrokvFkiwdLoTIYsKyvZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884004; c=relaxed/simple;
	bh=ah3Hl4CLaFFRwsWYNPSUD9XYKYZhrftaIXEF/bCYOss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPhH+IKhHkH69hW1F1K9WL9X1AnxjIfPk+FpCp2WSjbDKxnUQQqnpuiwqqRTJMB7jwE5mpEeb32vWcKB9LPqP37FMicjU5LA4uJi+PyJd4K3U7DiWD2J3Pb2/zS6I8vj/otGxk6pTDI1Ri7YtnR8IIDLGlmEQwXeGEY44ci51uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zhsf5JBJ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zhsf5JBJ"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso24751055e9.1
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883999; x=1792488799; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SMrszHPts9jJFmkFoLQcKwLTspqwv7GzQwp5uF+Uup0=;
        b=Zhsf5JBJcXkkuS2zAI4DQhkZqRN4YP45brLE4ZYBI2zu8gX+w8O8Hs5yeUfivdfPM0
         JCjAgRX6CfxfkvQsNs1NvNDjjAUgqM682Ed4DEZ41wsXYBXbAN+74yAdUil2KcYFrOqa
         caAGgcPUyDcbiwtW0rfwQ2WsQsGSbCeco4GG/dbrgh9/rVxhAZiQXFyimQmBGlz92hZt
         g20E9u9BxNKPkfBQLL62UWA9SBX4QcoxWG1bMV9s1lva/mZibaY2oVNNihgMGbwHYahi
         BtBzNJcdkVXjcA+AalQ+WhPNkRuSQV+dIe4TbiclzEsJDQbZMtr0uQ1gDnKOr3cJUFGn
         ugiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883999; x=1792488799;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SMrszHPts9jJFmkFoLQcKwLTspqwv7GzQwp5uF+Uup0=;
        b=aGv6C5rdUATkNLa3/5QO6J+DESXJfgOiI42Ke11N/Qa+gWqJ2ZjXkIcNJ+pk59ONp7
         4RyA2IOYOslhUEANZpfHuUqSdf8QbOjw42Ef2Q9Ml8Kk/xjQxzngRGCC1qxRok+i/2Vp
         S64qK5bOtF+zBY8ONKAietpFVWsl9uu76IBnnFEg4raFYihIihWkQTWsoqn8JZjNYxfM
         cVZP2+nDpQbDf5VYOmMRXY9a1/k531NjJ3DKUdaUHxICMKfMAE9HwhfCHql4BxolNudn
         WjU/WVHecPg+HKKkcfGEkgkkAUZ6ACv1V6GDvYJTJNbh7tRCQGS9LRkhCKUaz/RvDBu/
         6DVA==
X-Forwarded-Encrypted: i=1; AKwUvBwv8MRqGbNqBmlcuLvAgWsntMs2qubga892I25t4/kL3TpWdBdU2nmVniOittTog4IDFabImlLKv0s=@vger.kernel.org
X-Gm-Message-State: AFq9FYLb/cqnRuKq0mAINWcpBufOQmzhBj1Ejdht3sRuYkniXUkPbGIe
	cebYNxVNL1yzdWlBAOX3BSqbV/BhfkVx4OgqeOHtKciuBByCyzoYqVpq
X-Gm-Gg: AYBFou3UWUByI3h7D2oiaMJ88nbPk+7MZz5ErYFffmhxtI+4ViItkDlYNILkKn13KKV
	PVNdvwh+zZJguhzuIKUxcsUggG/sbx0XmAELiFk7tLIEA7Dj3Q1o9prEE0T/REnk1l5099KtM31
	yDbsPx/3cECE/7k0ReUfZx1PWSt1Avz8VO9cWIC4eY3O4FwRD1tqwDgmEjXaEmlv7w62Fq9zpQe
	mxgZHqY8vW3bPT85qocyJ3Aj9zLZ9OSaEzlbHl0OWA5Y5woXX3Z85YIq0y4BpOMEuMJQKMNrhNu
	kqvBmmNe3hrIuNYTqawM4fNJ1Wbdu6uUF5nP84U5OcNtDM4VdnyQtfZuzwxY8TIxcT7Cs1XR9fh
	2T0ejinH4Tqsja46gTh0QPNTYHC3Xg00rUoacdRTCARRuKux0f5AXUzjJ6eGtx2zZQLVu7ZquiA
	RWAWAfwpzuF0KlYWylKyPHcOZTVZRX+AMVj7LwWR9/OIb3ru9jad6gL8kuuZgefEV0fsnvGal4y
	/ccCn9UlOJ5N3ZJBNYGqo2Q
X-Received: by 2002:a05:600c:609b:b0:4a1:83f0:7c91 with SMTP id 5b1f17b1804b1-4a18e4ca1dcmr219812565e9.18.1791883998571;
        Tue, 13 Oct 2026 02:33:18 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:33:18 -0700 (PDT)
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
Subject: [PATCH v5 13/13] drm/client: splash: document the image sources and parameters
Date: Tue, 13 Oct 2026 11:32:43 +0200
Message-Id: <20261013093243.505776-14-maximpedraza@gmail.com>
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

The overview only said that the client draws a colour or an image. By
now the image can come from four places in a set order, be placed and
turned, and every part of that can be overridden from the command line,
each parameter for its own part only. Write it down: the sources and
their order, the image format, placement and rotation, the background,
every parameter with its format, and what a parameter given alone
keeps from the image source.

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
 drivers/gpu/drm/clients/drm_splash.c | 79 +++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 1 deletion(-)

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
index 46faae025ec2..1092143df1f0 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -37,7 +37,84 @@
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
+ * across a short power cycle, and the kernel cannot tell a stale image from a
+ * fresh one: a bootloader that loads no image there disables the node, or
+ * removes it.
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

