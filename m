Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D7237B3F2
	for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773611600; cv=none; b=nr/EmKqHdaSrZwQVGJah/qxdrZ2U5tDifJS6n6KBrvxrHrVQyJ5fzuhyotAkPYwU298jXBA078fAnySSqCwsRMkxuUEBI1Q6khJSo0FPdS3Cz6kPu8QerasWK9VkJfjCyzTb4q/uoCbICQ3PsCq//bspT85TIPamore55JkGrGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773611600; c=relaxed/simple;
	bh=d4jChEeUUc0f0rEMKPi4UAZuovkMFjwzj0INK1YLEaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS3s2Juiw+lQUPKRaaFcr6J0Cq/mb6dVhhrWjnfW2cXh+F6zGoOr3sUJHAYPHrahQJjJBW6Q23UkkDuwn7SbacLRuraTiwKsJqbOtftex4s5qH/brPF52BiBBrdxvm3b80s8OxwqCP4xRMA/JhK3gXQudgsOXN2v62C7oRz+cWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PnRfJkl5; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PnRfJkl5"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35b95a7444bso423128a91.1
        for <linux-efi@vger.kernel.org>; Sun, 15 Mar 2026 14:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773611598; x=1774216398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6JQWklIlJSZA3P4ZxqqueLAj4IsTzAWLg/HK7yKGJM=;
        b=PnRfJkl5cG6QDT2F+yTcDk3/uBzdacQUw4nTbBHCnjSV0dmzIGTusuRWBYIUcSbgt4
         BNdTsh+ae2VLCuu/BYCOQDXzS/rfvHXCr2l6jQmOg7pbhIRio9rmI4WGJJBnEP4L1W3R
         xRZRL5mOeYx7rD//CQZVlLOSITfbBW4D9maC0KVv/S7d8ITEeuzpMRetj/xjy0VeKFLO
         FzlQwYjhACGsMSFFbY66fIs0WpOW853QbtgbFU9q62fE8M1/axNDaRjp6aa3jDQNO/T2
         YBQHGhVIYfBZS5WFJkWY+hphMWrjIEBEP3RO+OlJZVtD0UqoPWRWuXofkeDEcj42bNov
         CNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773611598; x=1774216398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R6JQWklIlJSZA3P4ZxqqueLAj4IsTzAWLg/HK7yKGJM=;
        b=IGexFk5rr4W+d8sHmj8NcdjMdOHuoRhFw/7iQ/FtWn4IIvulyFK3MHaG8CJL+3Vhpl
         LSajYlkGivZY5MqFLONR/0cfc5rQH0+GoMYRTh15xvOwVn0ZXxwvYkY+RAdaZl/q6Cai
         avtTx2U27bxqjF7LlAPeJzbJH82LamJvsW8PkN0ZN9QHdADwddYf0qoo5d+QxEOCV0mn
         JsVVFNfZnT2bGN+4QYybcOzr5ThOprBFuDXH6rK7qufe+3c/lGJ7LRaO1oaEOKqSReU1
         Xb08vwb7kTQjclZ1qmAUslyOnBmuUyXgAz/3NpAqlIBf646MlPl2gIDnb2ZH+bI3Yyst
         JEwA==
X-Forwarded-Encrypted: i=1; AJvYcCV+Jw82mXtmscPeokkW0ZgtKwM2mMhZNfGyUfFQ6fc8mEb8BIYjzme8QcL7wkOXKfm1VNYcfsPmufw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF5iv17ZvNsYBWZcCcL2dsTqpt2brliojiiTh9Nvp0M+jASTKa
	evKB9+QF8mQ7y8wlpAKtutF+ayEDPuIEm3QxFMuAoROe3/8sX6BepCs=
X-Gm-Gg: ATEYQzxdl3ti6k5bIEzMoAE7PHz+OtfdM1jAimhAxNTXxJre1U1ElMtJQDJuHYA3pct
	CJJpTv7ZU4Bei2k0bJngTDWc7nerVasyTmSo6bqe2rWa3Rk4RkiPAsz+j5nvxDJjr6E2hcY1Gjc
	Blyj7noHdf+expv4trwy0pUA/i57D+vipzwTYwgYjGoBxwtU3dKTfA9mWE8WhCXL7xVxo2/hArU
	WcluzfHNPS15c+nCpDTWDTclAdw6QhiZzwpTH/FFk9NDnbsPbpcVn7sVfp5GCoNsKYrEc0W9Z6l
	VBcxvJ68CyhskLhBo3bQfy19hAYHbLPHKyIJ92x7HGZ2H6UFfwBEmN0IJhFpn+tOnSE/yS+JVH5
	oP8RhW9gs94nOeiRVvGwH1hRYLs1Dz/nrgYce3qIqPgeOvz9qLhT8PMiqiglDQyzzDhz+Q6bbal
	58A0eX9Wk2C7EM7IVZKbVC/OkoyHvlmwo8TU2tZm31oWp9wAPDunV333Gvx0W//t0=
X-Received: by 2002:a17:90b:28cc:b0:359:fc88:fa99 with SMTP id 98e67ed59e1d1-35a22055572mr8857270a91.26.1773611597857;
        Sun, 15 Mar 2026 14:53:17 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b9303eb9bsm3074980a91.8.2026.03.15.14.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 14:53:17 -0700 (PDT)
From: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
To: 
Cc: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 1/2] efi: Save Brightness using EFI on Macs
Date: Mon, 16 Mar 2026 03:22:41 +0530
Message-ID: <20260315215302.24087-2-atharvatiwarilinuxdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260315215302.24087-1-atharvatiwarilinuxdev@gmail.com>
References: <20260315215302.24087-1-atharvatiwarilinuxdev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently when a Mac reboots, the brightness is not the same
as the previous boot instead its the same as the last time the
Mac booted macOS.

We can fix this issue by saving the brightness level to the efivar
backlight-level.

(tested on iMac20,1)

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
---
 drivers/firmware/efi/Kconfig                  | 10 +++
 drivers/firmware/efi/Makefile                 |  1 +
 drivers/firmware/efi/apple-brightness.c       | 67 +++++++++++++++++++
 .../linux/platform_data/apple-brightness.h    | 20 ++++++
 4 files changed, 98 insertions(+)
 create mode 100644 drivers/firmware/efi/apple-brightness.c
 create mode 100644 include/linux/platform_data/apple-brightness.h

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5..dd0a9c9a772a 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -167,6 +167,16 @@ config APPLE_PROPERTIES
 
 	  If unsure, say Y if you have a Mac.  Otherwise N.
 
+config APPLE_BRIGHTNESS
+	bool "Apple Backlight control for EFI"
+	depends on X86
+	help
+	  This will save the brightness level to EFI, so brightness
+	  level is preserved across reboots and shutdows. allowing
+	  for improved support of Apple hardware.
+
+	  If unsure, say Y if you have a Mac, Otherwise N.
+
 config RESET_ATTACK_MITIGATION
 	bool "Reset memory attack mitigation"
 	depends on EFI_STUB
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 8efbcf699e4f..1f5705cc87a2 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_TEST)			+= test/
 obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
 obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
+obj-$(CONFIG_APPLE_BRIGHTNESS)		+= apple-brightness.o
 obj-$(CONFIG_EFI_RCI2_TABLE)		+= rci2-table.o
 obj-$(CONFIG_EFI_EMBEDDED_FIRMWARE)	+= embedded-firmware.o
 obj-$(CONFIG_LOAD_UEFI_KEYS)		+= mokvar-table.o
diff --git a/drivers/firmware/efi/apple-brightness.c b/drivers/firmware/efi/apple-brightness.c
new file mode 100644
index 000000000000..b060861b0795
--- /dev/null
+++ b/drivers/firmware/efi/apple-brightness.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * apple-brightness.c - EFI brightness saver on Macs
+ * Copyright (C) 2026 Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/backlight.h>
+#include <linux/efi.h>
+#include <linux/platform_data/apple-brightness.h>
+
+static u32 efi_attr;
+static u16 last_saved_level;
+
+static int (*get_brightness)(struct backlight_device *bl);
+static struct backlight_device *bl_dev;
+
+void apple_brightness_shutdown(void)
+{
+	u16 level;
+	efi_status_t status;
+
+	level = (u16)get_brightness(bl_dev);
+
+	if (level == last_saved_level)
+		return;
+
+	status = efivar_set_variable(APPLE_BRIGHTNESS_NAME, &APPLE_BRIGHTNESS_GUID,
+				efi_attr, sizeof(level), &level);
+	if (status != EFI_SUCCESS)
+		pr_debug("Unable to set brightness: 0x%lx\n", status);
+}
+EXPORT_SYMBOL(apple_brightness_shutdown);
+
+int apple_brightness_probe(struct backlight_device *bl,
+	int (*get_brightnessfn)(struct backlight_device *bl))
+{
+	efi_status_t status;
+	unsigned long size = sizeof(last_saved_level);
+	int ret;
+
+	bl_dev = bl;
+	get_brightness = get_brightnessfn;
+
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE))
+		return -ENODEV;
+
+	ret = efivar_lock();
+	if (ret)
+		return ret;
+
+	status = efivar_get_variable(APPLE_BRIGHTNESS_NAME, &APPLE_BRIGHTNESS_GUID,
+				&efi_attr, &size, &last_saved_level);
+
+	efivar_unlock();
+
+	if (status != EFI_SUCCESS)
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL(apple_brightness_probe);
+
+MODULE_AUTHOR("Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>");
+MODULE_DESCRIPTION("EFI Brightness saver for Macs");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/include/linux/platform_data/apple-brightness.h b/include/linux/platform_data/apple-brightness.h
new file mode 100644
index 000000000000..54e3f3f8aa1c
--- /dev/null
+++ b/include/linux/platform_data/apple-brightness.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+/*
+ * apple-brightness.h - EFI brightness saver for Macs
+ * Copyright (C) 2026 Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
+ */
+
+#ifndef _APPLE_BL_H_
+#define _APPLE_BL_H_
+
+#include <linux/backlight.h>
+#include <linux/efi.h>
+
+#define APPLE_BRIGHTNESS_NAME           L"backlight-level"
+#define APPLE_BRIGHTNESS_GUID           EFI_GUID(0x7c436110, 0xab2a, 0x4bbb, 0xa8, 0x80, 0xfe, 0x41, 0x99, 0x5c, 0x9f, 0x82)
+
+int apple_brightness_probe(struct backlight_device *bl,
+	int (*get_brightnessfn)(struct backlight_device *bl));
+
+void apple_brightness_shutdown(void);
+#endif /* _APPLE_BL_H */
-- 
2.43.0

