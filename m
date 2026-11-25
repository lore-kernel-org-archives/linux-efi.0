Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.154.239.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626231;
	b=f0wJ+ot+GoSMa5FrlsGn5uW5VBqHn+XFHcRk6fF4WAmcHF7WSjbbu+kfXaPnmmKx/nto
	 WGvdUPpaqSCqdBjtwnqF9KVg4Wk8ZQWLcVHnf3XJWqOWWPplcc6DpsDPfOZSoiTVD1B0h
	 x1Dzg55YuqHrTVxwjV/somRJ7fPwB6M7t4B01UZyD5NN1bmHFnGml2mb3qNK4iJhynZAU
	 0mfkQhckYeN8Gz5gkLLHc9DmizS1ycLD0Bg+xT9KHGnhTu6+yBVYWFvCcuwTWyghVa5y6
	 q8gVQnlSHI5AKJRMFS7qyZRNDumToKSt+NYE0K6P0qRS39zrWMJGX6V++rkQ5R2EHbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626231;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=4GN2NjoUctxblUXPoG785/QR7v7He6l/la/VsAFii1g=;
	b=3s0p9/Cmpd3WQaCbNYy8btgSKM6GFTMvIzJCvpwLr6a+2nJFhw5yPxAQkOe7VtVE9cf5
	 Q4OHBh9igzpdqyB1sk4Tk7d0Cs2uJzx0/uf0Ooyq/0fFzD4XhZgK9lQZqdMRSl2wMb9Z4
	 s5xQs0bCmiL/LBaz/A0nVsNxHy7/79SgaApqbg0VA0TF8NoVByaYcfGO50ZB8GOczbi/n
	 N5ujI+HrMO31sVhllB9UFKakMubrOSySQDHTna/WjB9Xo059cAQ1Q15qmmJU2i77zYEPP
	 Cv7jxVs3i0HB5oq8X2gqU9QxH8kt+mz/2Qc/K1vM/Bj/GA5ru8HbDTiJ/HNuvzJAEXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b="tr+/S78R";
	arc=none smtp.remote-ip=178.154.239.207
Received: from forwardcorp2d.mail.yandex.net (forwardcorp2d.mail.yandex.net [178.154.239.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EBE606A323;
	Wed, 25 Nov 2026 17:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0EBE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=tr+/S78R
Received: from mail-nwsmtp-smtp-corp-main-80 (mail-nwsmtp-smtp-corp-main-80.yp-c.yandex.net)
	by forwardcorp2d.mail.yandex.net (postfix) with ESMTPS id 7884F80CDF;
	Wed, 25 Nov 2026 20:03:42 +0300 (MSK)
Received: from [127.0.1.1]
	by mail-nwsmtp-smtp-corp-main-80 with ESMTPSA id a3lrP22Zo8c0-dbNcXmfJ;
	Wed, 25 Nov 2026 20:03:41 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1795626221;
	bh=4GN2NjoUctxblUXPoG785/QR7v7He6l/la/VsAFii1g=;
	h=Cc:In-Reply-To:Message-Id:To:Date:References:From:Subject;
	b=tr+/S78R89GjelvqFKXJtvE39HfzS258I7qbcE+SIz9fkWHuD6ChISJm4o+nh/it1
	 7fIP7xpIoaVM1U7VNt3l/UsvhSFH+VnjnMYnkKY0mo0FWLf3QXXPSZ/N9LcJYkwDp1
	 Wz2bkhoF/3mRjabxVywEThlQ0M7/2jsaqyRX/5vM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80; dkim=pass header.i=@yandex-team.ru
From: Mikhail Rudenko <xyzzy@yandex-team.ru>
Date: Wed, 25 Nov 2026 20:03:26 +0300
Subject: [PATCH 2/3] video: acquire firmware framebuffer apertures before
 mapping
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-efi-earlycon-v1-2-49ac2c0a430b@yandex-team.ru>
References: <20261125-efi-earlycon-v1-0-49ac2c0a430b@yandex-team.ru>
In-Reply-To: <20261125-efi-earlycon-v1-0-49ac2c0a430b@yandex-team.ru>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Peter Jones <pjones@redhat.com>, 
 Helge Deller <deller@gmx.de>, Hans de Goede <hansg@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, 
 linux-doc@vger.kernel.org, Mikhail Rudenko <xyzzy@yandex-team.ru>
X-Mailer: b4 0.15.2

efifb and simplefb acquire their framebuffer apertures after mapping the
framebuffer. Move acquisition ahead of mapping, so each driver claims
the range before accessing it.

Also check the framebuffer size against the memory resource before
simpledrm acquires the aperture.

Signed-off-by: Mikhail Rudenko <xyzzy@yandex-team.ru>
---
 drivers/gpu/drm/sysfb/simpledrm.c | 28 ++++++++++++++--------------
 drivers/video/fbdev/efifb.c       | 12 +++++++-----
 drivers/video/fbdev/simplefb.c    | 11 ++++++-----
 3 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/sysfb/simpledrm.c b/drivers/gpu/drm/sysfb/simpledrm.c
index 21ddf4502ecc8..af4ce286fd6c8 100644
--- a/drivers/gpu/drm/sysfb/simpledrm.c
+++ b/drivers/gpu/drm/sysfb/simpledrm.c
@@ -747,6 +747,13 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 	if (mem) {
 		void *screen_base;
 
+		if (size > resource_size(mem)) {
+			drm_err(dev,
+				"framebuffer size of %llu exceeds memory range %pr\n",
+				size, mem);
+			return ERR_PTR(-EINVAL);
+		}
+
 		ret = devm_aperture_acquire_for_platform_device(pdev, mem->start,
 								resource_size(mem));
 		if (ret) {
@@ -756,13 +763,6 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 
 		drm_dbg(dev, "using system memory framebuffer at %pr\n", mem);
 
-		if (size > resource_size(mem)) {
-			drm_err(dev,
-				"framebuffer size of %llu exceeds memory range %pr\n",
-				size, mem);
-			return ERR_PTR(-EINVAL);
-		}
-
 		screen_base = devm_memremap(dev->dev, mem->start, resource_size(mem), MEMREMAP_WC);
 		if (IS_ERR(screen_base))
 			return screen_base;
@@ -775,6 +775,13 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 		if (!res)
 			return ERR_PTR(-EINVAL);
 
+		if (size > resource_size(res)) {
+			drm_err(dev,
+				"framebuffer size of %llu exceeds memory range %pr\n",
+				size, res);
+			return ERR_PTR(-EINVAL);
+		}
+
 		ret = devm_aperture_acquire_for_platform_device(pdev, res->start,
 								resource_size(res));
 		if (ret) {
@@ -796,13 +803,6 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 			mem = res;
 		}
 
-		if (size > resource_size(mem)) {
-			drm_err(dev,
-				"framebuffer size of %llu exceeds memory range %pr\n",
-				size, mem);
-			return ERR_PTR(-EINVAL);
-		}
-
 		screen_base = devm_ioremap_wc(&pdev->dev, mem->start, resource_size(mem));
 		if (!screen_base)
 			return ERR_PTR(-ENOMEM);
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 6361861b3ccf3..28295829932b1 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -478,6 +478,13 @@ static int efifb_probe(struct platform_device *dev)
 			mem_flags &= md.attribute;
 		}
 	}
+
+	err = devm_aperture_acquire_for_platform_device(dev, par->base, par->size);
+	if (err) {
+		pr_err("efifb: cannot acquire aperture\n");
+		goto err_release_fb;
+	}
+
 	if (mem_flags & EFI_MEMORY_WC)
 		info->screen_base = ioremap_wc(efifb_fix.smem_start,
 					       efifb_fix.smem_len);
@@ -569,11 +576,6 @@ static int efifb_probe(struct platform_device *dev)
 		goto err_unmap;
 	}
 
-	err = devm_aperture_acquire_for_platform_device(dev, par->base, par->size);
-	if (err) {
-		pr_err("efifb: cannot acquire aperture\n");
-		goto err_fb_dealloc_cmap;
-	}
 	err = devm_register_framebuffer(&dev->dev, info);
 	if (err < 0) {
 		pr_err("efifb: cannot register framebuffer\n");
diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 60e5dcec201ff..f682ead384bf6 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -599,6 +599,12 @@ static int simplefb_probe(struct platform_device *pdev)
 	par->size = info->fix.smem_len;
 
 	info->fbops = &simplefb_ops;
+	ret = devm_aperture_acquire_for_platform_device(pdev, par->base, par->size);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to acquire aperture: %d\n", ret);
+		goto error_fb_release;
+	}
+
 	info->screen_base = ioremap_wc(info->fix.smem_start,
 				       info->fix.smem_len);
 	if (!info->screen_base) {
@@ -632,11 +638,6 @@ static int simplefb_probe(struct platform_device *pdev)
 	if (mem != res)
 		par->mem = mem; /* release in clean-up handler */
 
-	ret = devm_aperture_acquire_for_platform_device(pdev, par->base, par->size);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to acquire aperture: %d\n", ret);
-		goto error_genpds;
-	}
 	ret = register_framebuffer(info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to register simplefb: %d\n", ret);

-- 
2.56.1

