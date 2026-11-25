Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.77.172.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626232;
	b=12j3GWgeFEVAA6wiSFToUuO4XobTyEju+BgqcENzWfSO4zRJPGdigRA+Ry6Nc3vZKdom
	 g3/NjYgc67mj1BZmorFGPdwIDpDayxJMtvOZyrorDfYWWheWSipRy9qt9sMcQGx1ljYoW
	 E3Q9dNEuxdvHrv10WAaRgUM/HdWKyyQ7rkJf/Ftbyq/VeB+mSSsLitnQw8MJwGm94jhPw
	 4b1qKBG3ZteZu+Ito+701RReuq3hvQblsaiNYWJpNxfUlblLE4atoy401eO4yRHdhiFYw
	 gzAen42oDLZGhbD8UMq2hMgGZXTqR1xAuHxt8Maspt99AhrqRsg/F3Kk6R832OnF+tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626232;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=D6e784RAfl1zWvIKf8VvIP9R0Xn4wVs0JRUhlpHhbJQ=;
	b=Rh+n5F3Gmn4QhwPCOhQHGLoEMuVdIZ4Rc2X2mfLgVayPslGMk4YJ19sNiHlGqvREA652
	 Td0kW1vys5F92pbXR+8kYATpwXC9bUw0SuOufNNl/T5uOugIQRKTP8GROISJrfTrL+icF
	 lT4rcqKgkBdLQvHh+JWPijuZXQG8J8lF8RzYtSTPAvh7puaX4R6qi1v7mU8WaDK2TYeNz
	 qODPIbyQXJ5+8DbhxsWdSdcjJCswyHnxh6lbI2JO+2ODwW5Ri2fV5bnwpsITL0iIGhy0E
	 P/iGFK7EdpG/2l1Mh2JBxFVolB/BnHCY/gSKe91LkUobnox1hy51raatF1KwDFfGUUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=ifVmvqKT;
	arc=none smtp.remote-ip=93.77.172.4
Received: from forwardcorp1e.mail.yandex.net (forwardcorp1e.mail.yandex.net [93.77.172.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD5606A33D;
	Wed, 25 Nov 2026 17:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7CD5606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=ifVmvqKT
Received: from mail-nwsmtp-smtp-corp-main-80 (mail-nwsmtp-smtp-corp-main-80.yp-c.yandex.net)
	by forwardcorp1e.mail.yandex.net (postfix) with ESMTPS id A80E8100336;
	Wed, 25 Nov 2026 20:03:43 +0300 (MSK)
Received: from [127.0.1.1]
	by mail-nwsmtp-smtp-corp-main-80 with ESMTPSA id a3lrP22Zo8c0-sRAf1WTV;
	Wed, 25 Nov 2026 20:03:42 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1795626222;
	bh=D6e784RAfl1zWvIKf8VvIP9R0Xn4wVs0JRUhlpHhbJQ=;
	h=Cc:In-Reply-To:Message-Id:To:Date:References:From:Subject;
	b=ifVmvqKT+7d8cLgAMMnVyYRRibQhivvzVTfOsbHcwGY6thKnU6SohPfAebPCA5IEc
	 7PK52KMI7IMwADqJ25ILkCbacC70sVC0GIW8AVFA0sPa65dm8lYp9FjEZZjdDy2bTR
	 PIQplQ8qdAO1AkGxZBGrZbFrYhZZ500fP9Tz8cl4=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80; dkim=pass header.i=@yandex-team.ru
From: Mikhail Rudenko <xyzzy@yandex-team.ru>
Date: Wed, 25 Nov 2026 20:03:27 +0300
Subject: [PATCH 3/3] video: aperture: hand off EFI earlycon on aperture
 ackquisition
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
Message-Id: <20261125-efi-earlycon-v1-3-49ac2c0a430b@yandex-team.ru>
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

With keep_bootcon, EFI earlycon can keep writing to the firmware
framebuffer while a graphics driver takes over. Add a handoff option
that unregisters it after framebuffer/drm device successfully acquires
its aperture or when a conflicting-device removal helper is
called. The option opt-in, default behavior is preserved.

When handoff option is effective, unregister the EFI earlycon when a
graphics device driver ackquires aperture (unless it was unregistered
earlier).

Signed-off-by: Mikhail Rudenko <xyzzy@yandex-team.ru>
---
 Documentation/admin-guide/kernel-parameters.txt |  5 +++-
 drivers/firmware/efi/earlycon.c                 | 37 ++++++++++++++++++++++++-
 drivers/video/aperture.c                        | 13 ++++++++-
 include/linux/efi.h                             |  7 +++++
 4 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..829bb01cc10d0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1532,7 +1532,10 @@ Kernel parameters
 			memory mapped framebuffer (if available). On cache
 			coherent non-x86 systems that use system memory for
 			the framebuffer, pass the 'ram' option so that it is
-			mapped with the correct attributes.
+			mapped with the correct attributes. Pass 'handoff' with
+			keep_bootcon to retain EFI earlycon until a graphics
+			driver acquires a firmware framebuffer aperture. Options
+			may be combined, e.g. earlycon=efifb,ram,handoff.
 
 		linflex,<addr>
 			Use early console provided by Freescale LINFlexD UART
diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index 3a6eaf5481f40..9d65777d225e1 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -21,8 +21,20 @@ static u32 efi_x_array[1024];
 static u32 efi_x, efi_y;
 static u64 fb_base;
 static bool fb_wb;
+static bool fb_handoff;
 static void *efi_fb;
 
+void efi_earlycon_unregister(void)
+{
+	struct console *con = READ_ONCE(earlycon_console);
+
+	if (!con || !fb_handoff)
+		return;
+
+	if (console_is_registered(con))
+		unregister_console(con);
+}
+
 /*
  * EFI earlycon needs to use early_memremap() to map the framebuffer.
  * But early_memremap() is not usable for 'earlycon=efifb keep_bootcon',
@@ -219,6 +231,29 @@ efi_earlycon_write(struct console *con, const char *str, unsigned int num)
 
 static bool __initdata fb_probed;
 
+static void __init efi_earlycon_parse_options(const char *opt)
+{
+	/* Reprobe has no options; retain those parsed on the first attempt. */
+	if (!opt)
+		return;
+
+	fb_wb = false;
+	fb_handoff = false;
+
+	while (*opt) {
+		size_t len = strcspn(opt, ",");
+
+		if (len == 3 && !strncmp(opt, "ram", len))
+			fb_wb = true;
+		else if (len == 7 && !strncmp(opt, "handoff", len))
+			fb_handoff = true;
+
+		opt += len;
+		if (*opt)
+			opt++;
+	}
+}
+
 void __init efi_earlycon_reprobe(void)
 {
 	if (fb_probed)
@@ -232,7 +267,7 @@ static int __init efi_earlycon_setup(struct earlycon_device *device,
 	u16 xres, yres;
 	u32 i;
 
-	fb_wb = opt && !strcmp(opt, "ram");
+	efi_earlycon_parse_options(opt);
 
 	if (si->orig_video_isVGA != VIDEO_TYPE_EFI) {
 		fb_probed = true;
diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index 2b5a1e666e9b2..249b037562103 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -2,6 +2,7 @@
 
 #include <linux/aperture.h>
 #include <linux/device.h>
+#include <linux/efi.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
@@ -240,7 +241,13 @@ int devm_aperture_acquire_for_platform_device(struct platform_device *pdev,
 					      resource_size_t base,
 					      resource_size_t size)
 {
-	return devm_aperture_acquire(&pdev->dev, base, size, aperture_detach_platform_device);
+	int ret;
+
+	ret = devm_aperture_acquire(&pdev->dev, base, size, aperture_detach_platform_device);
+	if (!ret)
+		efi_earlycon_unregister();
+
+	return ret;
 }
 EXPORT_SYMBOL(devm_aperture_acquire_for_platform_device);
 
@@ -284,6 +291,8 @@ static void aperture_detach_devices(resource_size_t base, resource_size_t size)
 int aperture_remove_conflicting_devices(resource_size_t base, resource_size_t size,
 					const char *name)
 {
+	efi_earlycon_unregister();
+
 	/*
 	 * If a driver asked to unregister a platform device registered by
 	 * sysfb, then can be assumed that this is a driver for a display
@@ -349,6 +358,8 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
 	resource_size_t base, size;
 	int bar, ret = 0;
 
+	efi_earlycon_unregister();
+
 	sysfb_disable(&pdev->dev);
 
 	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc1df1577d5fb..44cff6fe53f90 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -720,6 +720,13 @@ efi_guid_to_str(const efi_guid_t *guid, char *out)
 
 extern void efi_init (void);
 extern void efi_earlycon_reprobe(void);
+#ifdef CONFIG_EFI_EARLYCON
+void efi_earlycon_unregister(void);
+#else
+static inline void efi_earlycon_unregister(void)
+{
+}
+#endif
 #ifdef CONFIG_EFI
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #else

-- 
2.56.1

