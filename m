Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C936A31F988
	for <linux-efi@vger.kernel.org>; Mon, 16 Mar 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675266; cv=none; b=B4J57+5ohHn1rhdVRbZMTOX9wM77aVsGNKUCAOCT6wjsD4iAxI+aaa6zQWpgvaqzZ5XiktYS4ZB0niUSAbfThiaBK8nmq6QFZzlaTX2YstYc0AJkouv184iACgSrocLLpe+NsCiVjznyTy175gcDLVFFADTnzmOyoQOxAOi96Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675266; c=relaxed/simple;
	bh=LLhiZ5FX8IIzUP55FXN9kMQNcPa8k1lZx7Q++ivYoEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ6AlLUl3Rclw5JcckB07aig2nV1KUsjibFuhX49DWwuyq5+62oQQqogPH75jVdim2eFJfx/UW6BJOuDxwgnX83A2Az1+UtzoMZ2UOSSAV0/zeUqdniOb5J3Vf5nVGr72ktwJvLwxDkmfjfj5A5fHgT7B+o4zZsJBk2eLElhph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qpj94jU+; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qpj94jU+"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35ba749f441so592021a91.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Mar 2026 08:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773675264; x=1774280064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjMa+jqjA5+TcVEkQU5jdnLuBqhO1REK2DuRHZyX1uY=;
        b=Qpj94jU+u9DOtwfmnRBnUc16yq/+cX0tNd+r1g4WZdp51voI/H4r+0DEPard+ui+2N
         xKZlgJz3QCRVct/VxZ3D4Z/Jxcj64eBjey74qWk+n6V/duZ5VoxbNrN8+85Mhi16H9Os
         /+hIDGQ1u0RJ8x6TCjKonp2uoIsa8ODSkNmkHIM9O2BH9FdkwfbL2eMZIXRpQRsOr9jJ
         D4d42iIIU5jHsf9wSkJm0OjqO0ZwwLJyqLf0MytBub4kW8pbq0OhGHFHFPTXXh3xkixZ
         8IKHe7hXHwWx7ty71G/x4/m4AmmJfMQGIDX2zjxghAFBNgnPiqBbZtMD7UuBmOSRyeyv
         0HbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773675264; x=1774280064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SjMa+jqjA5+TcVEkQU5jdnLuBqhO1REK2DuRHZyX1uY=;
        b=SiVfcQVM4ZrnHKe+XmSZhaLg/WpNGHoSp67xxY2UdUCtKFYHWTjhIF3Jj16dfNdYAo
         xul5pBaYVRdK6h450riIoaaZv+efAKgSY/MwN1084m14JOAs9SxLnMIo2NllUbmukmJn
         rqVaBNYaDqM/2U0myZvFhH2uO941ZaHFuVzz46eIWy+pQxHmdJm8icGmO4TNl+mX0rCt
         k+7V//a8ufLMnkQJ8jpPHLKMhjA/lK7KN6+uCPfDgzTsKRDk0e2y+yJ7rLwZnYdfQ1Fi
         /IortKdx0uGTONQ+moh6GKQtdJq684m+Ib+CV+c7T5vyS+gfwi4yWuWbeZQFyMZb66fB
         Pz2w==
X-Forwarded-Encrypted: i=1; AJvYcCXV+xl76M+7lRZ+J6/Fwwkudl7PZWDYWojeGJe0q6MDom+QrOUJwfr9jro/h9av02aOpD/qiZVoSxA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtXGJdd9WkztfV7leV+IopDMBHdbtd7AdmXCPVkw1ZUEgqdOVD
	xsNzVge+CWmESk2/7zJT+Xz3x2C/3LUVtkw/C33ryXNU5eLjxLUghMs=
X-Gm-Gg: ATEYQzyOnOh/ARWZB5ZzO4nyRBYGYKmMJ8oc/D8aQNMSCnyG2dUi/yiWLdJpE6etvrf
	4+BZndfbSkt8MGwu/Rv4pK2Jg1QJ/gszrLt5w9EGsOx+XwnSuXj2i1mMJQlPRYmpT1dMR8VazaJ
	xcAHF5oDlN9GN2jIfhr/kEbT0qm3S5VpwLgrwSw5KcEjPNpAeuWbpK/P7vyHttd8iVKYuaQjR4Z
	kkPfS+mlVDvyZcjBjom5MoSKdEbpAw8KooIi368zPhRUhlg+ATRbgZyXol2TPYKxEPPXRKh93mP
	BuprWi2fuudg3t7edOybwzMJ4i7vLOePbOKsHvUB/i4f4lEqFHE/HsMz/agFL8V10qXZ3qDpQzf
	sVuqZVhq3KKBs9XPkwj7nzHnuZtWOSYlvo1lxp7qw+de/beDTDz07lPnJLprbikdN+06LrLMgmx
	h57wH0/aUZkEf1NMhRRI89lJQYk80hI2lo1mDqkFByyMYGcv4sL57xW84jfjaROSY=
X-Received: by 2002:a17:90b:3943:b0:359:915b:81f8 with SMTP id 98e67ed59e1d1-35a21fdd4fcmr12294858a91.18.1773675263998;
        Mon, 16 Mar 2026 08:34:23 -0700 (PDT)
Received: from at-Standard-PC-Q35-ICH9-2009.. ([171.61.163.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badb906c6sm2685a91.9.2026.03.16.08.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:34:22 -0700 (PDT)
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
Subject: [PATCH v4 1/2] efi: Save Brightness using EFI on Macs
Date: Mon, 16 Mar 2026 21:03:46 +0530
Message-ID: <20260316153407.1781-2-atharvatiwarilinuxdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
References: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com>
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
index 29e0729299f5..243499a5d7b7 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -167,6 +167,16 @@ config APPLE_PROPERTIES
 
 	  If unsure, say Y if you have a Mac.  Otherwise N.
 
+config APPLE_BRIGHTNESS
+	bool "Apple Backlight control for EFI"
+	depends on X86
+	help
+	  This will save the brightness level to EFI, so brightness
+	  level is preserved across reboots and shutdowns. allowing
+	  for improved support of Apple hardware.
+
+	  If unsure, say Y if you have a Mac, otherwise N.
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

