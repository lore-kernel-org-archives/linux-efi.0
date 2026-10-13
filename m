Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC75414423
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 09:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883992; cv=none; b=kculx0FEXCv+SJRIVK3fHsAeSuxR5fJjmilTSNA+9cWSZYvCEcKnIa0MPAbvU9RSOI+RqCJDt0AoqEiOShPEL349OQHDmivdDsxEzTkNKInWoCSJq8vNig1h1rYne+sSnV0zn1NNEWrqHIOpddUvP9ozedGtQis2WzHmSSuKWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883992; c=relaxed/simple;
	bh=R5d61cBjlmI8uZAYwWmWvsr2JGajaUnhrCAJQgi3A6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1MnEp8pQomWtMjZ7iIbKANVu4q8rDndZYdm4kbU0rZbn+FP1EH4KzeaQbiYb9/2FLgTOICFqaYQdE2c5ZhwM6DZlJONTo1fOQDNbnE4zYr3/IL4By1wgVocBHIvR2I/4Frw3uh9BAZTA7Wv9r0bGutrvzAVkyY3odGsk8vxVEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AIgC1X/B; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AIgC1X/B"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4649b3aaso1661393f8f.2
        for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 02:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883985; x=1792488785; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xsGsod/8Ns3+BDNQx7Seu3RbdQl0ClLIgl4wgQX5q9E=;
        b=AIgC1X/BFvrzxulDKIWvqEZTHcc/O9ZLro/9Q0uI2AQYyb99laB9ic1NKwcExVJ3W/
         nqqaMXf1kmI2aX18Abb1yxkWwz4tUPRCqVi2FILNohTRfcjLTYCVxWj+wQN257p0qdU2
         FOtSDuyt4zpt8tJ2KXD4qO5Z51P2E2VwNv6lSRV8RqGm+AZMOEgjBDnfOiSNAB/57Le/
         okFOSyia8taRg+8dvL99+HtDhbSv4caPLLP0rB1twoAOIlau4fUk69ilqh7PvQgUPEyr
         0yVj0ypqXwqRxKbbLJzhc9sAR+9AMwue4E2muHQODLQkO16e5/FThpRnecjCzsclRgKn
         LN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883985; x=1792488785;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xsGsod/8Ns3+BDNQx7Seu3RbdQl0ClLIgl4wgQX5q9E=;
        b=SuueihbyAJNr/9rEdM2m+x2z1nx9eE3aj/aeoHp+sAnm8uZV/WonXKQrtp4Skgj7i2
         3wCx1zGj3Cyh3YzP9hIEQGn7m8/B59+hdQSKPKJiCMe/HcFbNjR2mz6bsucnGdj7nMhp
         XaIjszXszHwWC6HDzTqZsfs33QNuSUI1wYrILWIMZRsijUIFmYyYt50NleTkf1XG41s9
         nucQbslTr1fkXbnlybZwHfTEM7vKUaDwz2iShSlgUKozUNSlMtIUJfvhv/j3s6GCwupX
         TkBl6Itka1dptcEJqbCB4AMEfQWYusA+bNnEZ8r3htojokz/g0uUJkOYSZVBQGAKTF/I
         84EA==
X-Forwarded-Encrypted: i=1; AKwUvBzytVLursnKWDzGsq+KVZotYeVIyzl2VtgMYqvq0I+Ed9HBcStJM8BCiSAiPjp6XUUz98578y1jaYI=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ46ZEjmqerckBeMtFHsRon7kBsINI4JdsKmyimgv8lRyNW27zV
	hQbHif63MhFCF9cmbEI9XlcaDoCnetVL3yRahFpOjFP9f8VvrISN+enn
X-Gm-Gg: AYBFou3sP1N0YBUavBN9tZtMuoKRbytvPD3tEoYfZpBEI3sP9blKs0miH7v/wTAlkKM
	9npeEN/V9AWaI23AXR72ymaM6jIlI+llEkFFDDZf6pIhTtcrM4g9XimUMR83i6zavo7OcQAvpgy
	AMBA9+q3AUwXUoX7vrF4hMZhw/8JA7jO2DnQitChTh/2fqv8g0xeBIad0JXQ52Cion2KIwf2j8T
	AzGSJzNVeoYoQkx4hSf9y5eNQ8B96upwhztNR9MSbuPU1amgnOZ0fAI4u61/hfEOPo/tMVqJx1+
	yOUKaG90ZRkpO2U0HUcPja/Z1YFtCGFqjU1pPoS+NiUgPNPAEyaUHWYiGs7kBK/d7U63vbHZtKW
	9+TcAQVURvG3X9eZRg8i+2+TbVeB3jN1CTZ3Hu3QuPgO1w9u2KG0OM9wYtEPO0/k7sprc/jrEGC
	V3YzCD/M0bhM8ACaaVh0PjcGxeKafrIUQ2v8puhtwC+SGDjl+xEK1+m7akt4naU9GS5COWa6Cl2
	6agXraBKprufhs/H2OsUSQ6
X-Received: by 2002:a5d:420f:0:b0:48c:4553:790b with SMTP id ffacd0b85a97d-48dbacf46e9mr16300132f8f.48.1791883984846;
        Tue, 13 Oct 2026 02:33:04 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.112.15.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc4ec6sm3986774f8f.48.2026.10.13.02.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:33:04 -0700 (PDT)
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
Subject: [PATCH v5 07/13] drm/client: splash: add a device tree image source
Date: Tue, 13 Oct 2026 11:32:37 +0200
Message-Id: <20261013093243.505776-8-maximpedraza@gmail.com>
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

Embedded products often share one kernel image and one board support
package across several models that differ in branding. The splash
client can show the firmware's BGRT image or a BMP loaded as firmware,
but a device tree system has no BGRT, and a BMP loaded as firmware is
either built into the kernel, which means one kernel per logo, or read
from a filesystem that is not there yet when the display comes up. With
U-Boot's Falcon mode the SPL starts the kernel directly, and the device
tree is the only thing that reaches it.

Add a source that takes the image from a "boot-logo" node under /chosen.
The BMP either sits in the node itself, in an "image" property that dtc
fills in with /incbin/, or in a reserved memory region the bootloader
loaded it into, named by "memory-region". Exactly one of the two must be
present; a node with both or neither is ignored with a warning.

The image in the node is used where it is: the device tree stays in
memory, so there is nothing to copy or release. The region is mapped
like the BGRT image, and the BMP header is checked against its size.

A node is only there if someone put it there for that board, so the
device tree goes first, then the BGRT, then the BMP loaded as firmware.
The boolean that chose between the latter two becomes an enum naming
the one source in use.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/gpu/drm/clients/Kconfig      |  15 +++
 drivers/gpu/drm/clients/drm_splash.c | 166 ++++++++++++++++++++++++---
 2 files changed, 165 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/clients/Kconfig b/drivers/gpu/drm/clients/Kconfig
index cbe271c3a23f..aef3781cc110 100644
--- a/drivers/gpu/drm/clients/Kconfig
+++ b/drivers/gpu/drm/clients/Kconfig
@@ -108,6 +108,21 @@ config DRM_CLIENT_SPLASH_BACKGROUND_COLOR
 	  The color can be overridden through the drm_client_lib.splash_color
 	  kernel command line parameter.
 
+config DRM_CLIENT_SPLASH_SRC_DT
+	bool "Device tree as splash source"
+	depends on DRM_CLIENT_SPLASH
+	depends on OF
+	select DRM_CLIENT_SPLASH_BMP_SUPPORT
+	help
+	  Use a BMP image described by a "boot-logo" node under /chosen in
+	  the device tree, either carried in the node itself or placed by the
+	  bootloader in a reserved memory region. This lets one kernel image
+	  show a different logo on each board or product, chosen by the
+	  device tree it boots with.
+
+	  When present, the device tree image is preferred over the other
+	  sources.
+
 config DRM_CLIENT_SPLASH_SRC_BGRT
 	bool "EFI BGRT as splash source"
 	depends on DRM_CLIENT_SPLASH
diff --git a/drivers/gpu/drm/clients/drm_splash.c b/drivers/gpu/drm/clients/drm_splash.c
index a7d627954158..50842922a7f8 100644
--- a/drivers/gpu/drm/clients/drm_splash.c
+++ b/drivers/gpu/drm/clients/drm_splash.c
@@ -9,9 +9,12 @@
 #include <linux/efi-bgrt.h>
 #include <linux/firmware.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/iosys-map.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/overflow.h>
 #include <linux/types.h>
 #include <linux/unaligned.h>
@@ -71,6 +74,14 @@ struct bmp_dib_header {
 	__le32 colors_important;
 } __packed;
 
+/* Where the image comes from, in order of preference */
+enum drm_splash_source {
+	DRM_SPLASH_SRC_NONE,
+	DRM_SPLASH_SRC_DT,
+	DRM_SPLASH_SRC_BGRT,
+	DRM_SPLASH_SRC_BMP,
+};
+
 struct drm_splash_scanout {
 	int id;
 	/* Modesets scanning this buffer out, by position in the list */
@@ -110,7 +121,7 @@ struct drm_splash {
 	bool render_done;
 	void *map_data;
 
-	bool use_bgrt;
+	enum drm_splash_source src;
 };
 
 static struct drm_splash *client_to_drm_splash(struct drm_client_dev *client)
@@ -212,6 +223,114 @@ static int drm_splash_fw_request_bmp(struct drm_splash *splash)
 }
 #endif // CONFIG_DRM_CLIENT_SPLASH_SRC_BMP
 
+#if IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_DT)
+#define DRM_SPLASH_DT_COMPATIBLE "boot-logo"
+
+/*
+ * The boot logo node, if the device tree has a usable one. Only a child of
+ * /chosen is considered, not anything compatible anywhere in the tree: the
+ * image is configuration handed over by the firmware, not a device.
+ */
+static struct device_node *drm_splash_dt_node(struct drm_splash *splash)
+{
+	struct drm_client_dev *client = &splash->client;
+	struct device_node *np;
+	bool image, region;
+
+	np = of_get_compatible_child(of_chosen, DRM_SPLASH_DT_COMPATIBLE);
+	if (!np)
+		return NULL;
+
+	if (!of_device_is_available(np))
+		goto out_put;
+
+	image = of_property_present(np, "image");
+	region = of_property_present(np, "memory-region");
+	if (image == region) {
+		drm_warn(client->dev,
+			 "splash: %pOF needs exactly one of image or memory-region",
+			 np);
+		goto out_put;
+	}
+
+	return np;
+
+out_put:
+	of_node_put(np);
+	return NULL;
+}
+
+static bool drm_splash_dt_available(struct drm_splash *splash)
+{
+	struct device_node *np = drm_splash_dt_node(splash);
+
+	of_node_put(np);
+
+	return np;
+}
+
+static int drm_splash_dt_load(struct drm_splash *splash, const u8 **data,
+			      size_t *size)
+{
+	struct drm_client_dev *client = &splash->client;
+	struct device_node *np;
+	struct resource res;
+	const void *prop;
+	int len, ret = 0;
+
+	np = drm_splash_dt_node(splash);
+	if (!np)
+		return -ENOENT;
+
+	/*
+	 * An image in the node is used in place: the device tree stays in
+	 * memory for as long as the system runs, so there is nothing to copy
+	 * and nothing to release.
+	 */
+	prop = of_get_property(np, "image", &len);
+	if (prop) {
+		*data = prop;
+		*size = len;
+		goto out_put;
+	}
+
+	/* Otherwise the bootloader loaded it into a reserved region */
+	ret = of_reserved_mem_region_to_resource(np, 0, &res);
+	if (ret) {
+		drm_warn(client->dev, "splash: %pOF: no usable memory-region: %d",
+			 np, ret);
+		goto out_put;
+	}
+
+	splash->map_data = memremap(res.start, resource_size(&res),
+				    MEMREMAP_WB);
+	if (!splash->map_data) {
+		drm_warn(client->dev, "splash: failed to map %pR", &res);
+		ret = -ENOMEM;
+		goto out_put;
+	}
+
+	/* The BMP header, checked against this size, says how much is image */
+	*data = splash->map_data;
+	*size = resource_size(&res);
+
+out_put:
+	of_node_put(np);
+	return ret;
+}
+#else
+static bool drm_splash_dt_available(struct drm_splash *splash)
+{
+	return false;
+}
+
+static int drm_splash_dt_load(struct drm_splash *splash,
+			      const u8 **data, size_t *size)
+{
+	return -EOPNOTSUPP;
+}
+#endif // CONFIG_DRM_CLIENT_SPLASH_SRC_DT
+
 static bool drm_splash_bgrt_available(struct drm_splash *splash)
 {
 	struct drm_client_dev *client = &splash->client;
@@ -489,7 +608,7 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 		return -EINVAL;
 	}
 
-	if (splash->use_bgrt) {
+	if (splash->src == DRM_SPLASH_SRC_BGRT) {
 		x_pad = efi_bgrt_image_offset_x();
 		y_pad = efi_bgrt_image_offset_y();
 
@@ -582,19 +701,34 @@ static int drm_splash_bmp_to_scanout(struct drm_splash *splash,
 static int drm_splash_image_load(struct drm_splash *splash, const u8 **img_data,
 				 size_t *img_data_len)
 {
-	int ret = 0;
-
-	if (splash->use_bgrt) {
-		ret = drm_splash_bgrt_load(splash, img_data, img_data_len);
-		if (ret)
-			splash->use_bgrt = false;
+	switch (splash->src) {
+	case DRM_SPLASH_SRC_DT:
+		return drm_splash_dt_load(splash, img_data, img_data_len);
+	case DRM_SPLASH_SRC_BGRT:
+		return drm_splash_bgrt_load(splash, img_data, img_data_len);
+	case DRM_SPLASH_SRC_BMP:
+		return drm_splash_fw_load(splash, img_data, img_data_len);
+	default:
+		return -ENOENT;
 	}
+}
 
-	/* BGRT failed to load */
-	if (!splash->use_bgrt)
-		ret = drm_splash_fw_load(splash, img_data, img_data_len);
-
-	return ret;
+/*
+ * Pick the one source the image will come from. A device tree node is only
+ * there if someone put it there for this board, so it goes first; the BGRT
+ * is whatever the firmware shows, and the BMP loaded as firmware is the
+ * fallback. With none of them, only the background colour is drawn.
+ */
+static enum drm_splash_source drm_splash_pick_source(struct drm_splash *splash)
+{
+	if (drm_splash_dt_available(splash))
+		return DRM_SPLASH_SRC_DT;
+	if (drm_splash_bgrt_available(splash))
+		return DRM_SPLASH_SRC_BGRT;
+	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP))
+		return DRM_SPLASH_SRC_BMP;
+
+	return DRM_SPLASH_SRC_NONE;
 }
 
 static void drm_splash_image_cleanup(struct drm_splash *splash)
@@ -909,10 +1043,10 @@ static int drm_splash_client_hotplug(struct drm_client_dev *client)
 	get_task_struct(thread);
 	splash->thread = thread;
 
-	splash->use_bgrt = drm_splash_bgrt_available(splash);
+	splash->src = drm_splash_pick_source(splash);
 
-	/* If no other image has been loaded, try to load a BMP as firmware */
-	if (IS_ENABLED(CONFIG_DRM_CLIENT_SPLASH_SRC_BMP) && !splash->use_bgrt) {
+	/* The BMP loaded as firmware is the only source that arrives later */
+	if (splash->src == DRM_SPLASH_SRC_BMP) {
 		WRITE_ONCE(splash->fw_pending, true);
 		ret = drm_splash_fw_request_bmp(splash);
 		splash->fw_requested = !ret;
-- 
2.39.5

