Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784928;
	b=XwNVlL/lACvp1dG5FWbK3RKzi9WCvxDg8ifFTROlqHqoPEJaqscEeXUSeASO9SlhK/iL
	 5L+0Fd5Iep15POQaY9LgpV3KB0NKeeaFP1fjz6jG3FEnMugUQQ8O3TUvO4yrlVWNOBq+n
	 Yta5IZusuDhBePxn9NN1rWV3lxfR9pwohsJBMl4+LdMm4BMtC/6INcm7xJktQr+pBnuFn
	 f/C60M0yWcRCnn5yiXfVwxSZUZASUCesFP57poIIMTqR4C+yu4YSjYCAjLt7sn26xP0TS
	 WHUcnBIVzgLIJjOQXPLHCOVVi5vU9Nw7/vjW6aPf7WeWKuGQxWlT2N5s6He9Lw3ld4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QRwRXLM89UnoOEjo9EGn9AE3PBFxJ1gHBO963ekwGoI=;
	b=4bBf2hv4LWH4me72GHoEtk+Ts6XasFEBBrgaEM/e6RBsC9m+IHm3UVKxhbRj22ezSYKb
	 P8MQ3IgcCouOx4Avt+9Etvcg+PlbvUVS6dX8IjKJefZbb23dN/q5ITQiuQq/G+GnCmsWa
	 WyjW6lHwCdlMkWZhr2+LwiWcJKnL+i8F2vI+ouhZw1vqV7dV0sUE38OvbihKQVjwtKMIX
	 1/quM6cg8VOqic098sw5RNDOQiYxUOXYxmloIF/jRc166RVcrQwbQKVCF453KK4UHf+vX
	 3O9EhPH70kOprT2IGD+3OoESiclN09w363PdFzCRLIhKgahEHGYP0XyVZhSX8knJhOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="o/6V3BP7";
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29032606A88F
	for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 23:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29032606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o/6V3BP7
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so36361625e9.2
        for <linux-efi@vger.kernel.org>; Sun, 15 Nov 2026 15:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794784926; x=1795389726; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QRwRXLM89UnoOEjo9EGn9AE3PBFxJ1gHBO963ekwGoI=;
        b=o/6V3BP7v5SqnH1VMrlr9rDsiLCgYQkmDJYbwXeHupyhuyuO8FxJKs4J4oRBJTuahd
         8yR24EZfPEELwq0Bq0FO8AYs3S0G+l6VCrCt5h4xOQxnWTYBwLZJPTuS9HgZs9qwESLc
         P/Fj6Z2c3eK7sQHAS4znS6iquVAba4meny19Lx+usXHCVRbMMoHBoPz+pZ6RtTdcd52n
         brs9VdafYl1dr+gkdU/jzM8i8eZtfTCFWTEUTvP+rgnygfCm7YEmlP1RURSsmxiJ8Xhc
         kKkA7LZe/uHCaEMA/JaLARIehM5x97zazZ5XzwIHl3kDoista8BIOTFwyCWI4BtXOVGD
         6s9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794784926; x=1795389726;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QRwRXLM89UnoOEjo9EGn9AE3PBFxJ1gHBO963ekwGoI=;
        b=z6rC9IxPZED36yiUci/8wWtvPFm3ufhzvf61BXlVSUrwc90c5Awl5G9UEB1/ATxBH0
         Ad/EWM0EdZNYNWjwbY0tPnlKLOtskdqM+gXSH1PFr5j2vJus2sb9f8aUMgWYtiGyRDEM
         KyABl8tHIaBkxDzpRBPU2vi8lPN3kF8ZKWJfU4DFnAztnHdPdJnXd5R+2onPT3lmhVT5
         ogCrLIjMXW6ufLLzG/EefcOiuDpbIxpcJSP5McQu0zck8PMMVfKYcroqerP7EmiWU4+x
         dEaMMj/9UPmPyvMNTAB0eDAtna3OMJMx4Ol5V3E+ybkxAwJ7ZzEsL1SKqqw5kpLpm91F
         hnYA==
X-Forwarded-Encrypted: i=1; AL+hErHFIXooQGW9su/MTImmNPEbw0S5Crl3A0DrFumINW0L+Knl083+esTTo7xsvOCnD7daW50mLW2xzyA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8kpicWgF4QcXj3IYjmM0FsDeJH3/GoIa/BnM8mYTP9fhJGiy+c
	WFXiSxb23FT18QYwt1Wqyc9sOUUWdC1uclWQOk8D8bTdEtFDAghylhoY
X-Gm-Gg: AYBFou1m2ebA5WvM3upW9gocSKXFgx4Qwz01EenM9Ephug6+DMjEyBnbsp5t92aEc8H
	vKryCH/w9S1tCVkJ1As0CCND+TP11U3DK0j2cDgWGMlOAsroqhVIvw4OanwV6jd6sECWyTo7nIG
	OKgvElVybxrqRpmjs1csExFRMtb+kAG8lReCvMb0vCMHnuaHq8FuuOCqQe1G/yXoBLelsV+MQTW
	OMrHB9lbXQOQDXWzyPR2c9Eho2H9WWXUvj+kuuA94TEbAN7RcHIi8RASulw49fAqxDJjtAw2nKc
	+Zd6gGzvGqnddEXMlvlevdkRMX8oI1jRtXoTRRz180mmpa1nrh8t0g74ijDMJPF6CEfONqOUPrk
	7a1tgjaj5EyAODyqM9Q70E2eAmtG8gExTJNh9BUvLBv2shmKuOxd3e+3H8zNW5pyT0ksomrxlfO
	IIrNgb6VYWr4FNhIaNUQ8jCsq5LpmSNXqt0JD9jdLvPXE4qYxqNdD0ZL5WlGLRBPvPde0Sphe8o
	BKtYi9v7UeOhqX5BAiYygKRm4Ph8dnogwoQHy+QsEMAzIEc32qmVy2wL32hTqevYl81PQx3MHG4
	0v9oLX39KuVsZn45QtlEwH79igVDhBsMx/M8RqurZz38k9NlL1zDTCY=
X-Received: by 2002:a05:600c:19d2:b0:4bb:60bd:53b2 with SMTP id 5b1f17b1804b1-4bb60bd55eamr134252235e9.6.1794784926397;
        Sun, 15 Nov 2026 15:22:06 -0800 (PST)
Received: from ingenieria31.oficinasStQ.local ([79.117.0.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f976esm127920955e9.3.2026.11.15.15.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 15:22:06 -0800 (PST)
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
Subject: [PATCH v7 2/6] efi: bgrt: add accessors for the boot graphics
Date: Mon, 16 Nov 2026 01:21:52 +0100
Message-Id: <20261116002156.1027726-3-maximpedraza@gmail.com>
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

The DRM splash client shows the boot graphics the firmware left behind,
and needs the image address and size, its offsets and the status bits.
Reading them from bgrt_tab and bgrt_image_size works with drm_client_lib
built in, but it can be a module, and neither is exported:

  ERROR: modpost: drivers/gpu/drm/clients/drm_client_lib.ko: symbol 'bgrt_tab' undefined!
  ERROR: modpost: drivers/gpu/drm/clients/drm_client_lib.ko: symbol 'bgrt_image_size' undefined!

Rather than export the data, add an accessor for each of them, exported
GPL only, with stubs in efi-bgrt.h for CONFIG_ACPI_BGRT=n so that users
need no #ifdef of their own. The variables stay global for
drivers/acpi/bgrt.c, and are only written by efi_bgrt_init(): mark them
__ro_after_init.

The table gives the image address as a u64. efi_bgrt_has_image() only
says yes when phys_addr_t can hold it, and the address and size are 0
when it says no, so that they never disagree on kernels with 32-bit
physical addresses.

Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Closes: https://lore.kernel.org/dri-devel/5d7067de-97b7-4232-9cf6-e4b978696482@amd.com/
Suggested-by: Jani Nikula <jani.nikula@linux.intel.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/firmware/efi/efi-bgrt.c | 76 ++++++++++++++++++++++++++++++++-
 include/linux/efi-bgrt.h        | 39 ++++++++++++++++-
 2 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index 1da451582812..8f5f5edf5ede 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -16,8 +16,8 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 
-struct acpi_table_bgrt bgrt_tab;
-size_t bgrt_image_size;
+struct acpi_table_bgrt bgrt_tab __ro_after_init;
+size_t bgrt_image_size __ro_after_init;
 
 struct bmp_header {
 	u16 id;
@@ -89,3 +89,75 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 out:
 	memset(bgrt, 0, sizeof(bgrt_tab));
 }
+
+/**
+ * efi_bgrt_has_image() - Whether the firmware left a boot graphic
+ *
+ * Return: true if the BGRT points at a BMP image, which efi_bgrt_init()
+ * checked and reserved, at an address that phys_addr_t can hold. The
+ * other accessors only mean something when it returns true.
+ */
+bool efi_bgrt_has_image(void)
+{
+	return bgrt_tab.image_address &&
+	       bgrt_tab.image_address == (phys_addr_t)bgrt_tab.image_address;
+}
+EXPORT_SYMBOL_GPL(efi_bgrt_has_image);
+
+/**
+ * efi_bgrt_image_address() - Physical address of the boot graphic
+ *
+ * Return: the address of the BMP image, or 0 if there is none.
+ */
+phys_addr_t efi_bgrt_image_address(void)
+{
+	return efi_bgrt_has_image() ? bgrt_tab.image_address : 0;
+}
+EXPORT_SYMBOL_GPL(efi_bgrt_image_address);
+
+/**
+ * efi_bgrt_image_size() - Size of the boot graphic
+ *
+ * Return: the size of the BMP image, as its header gives it, or 0 if there
+ * is none.
+ */
+size_t efi_bgrt_image_size(void)
+{
+	return efi_bgrt_has_image() ? bgrt_image_size : 0;
+}
+EXPORT_SYMBOL_GPL(efi_bgrt_image_size);
+
+/**
+ * efi_bgrt_status() - Status field of the BGRT
+ *
+ * Return: the status byte. Bit 0 tells whether the image is still on
+ * screen and, since ACPI 6.2, bits 1-2 how far it has to be turned to show
+ * upright (ACPI_BGRT_ORIENTATION_OFFSET).
+ */
+u8 efi_bgrt_status(void)
+{
+	return bgrt_tab.status;
+}
+EXPORT_SYMBOL_GPL(efi_bgrt_status);
+
+/**
+ * efi_bgrt_image_offset_x() - Horizontal position of the boot graphic
+ *
+ * Return: the X offset, in pixels, at which the firmware drew the image.
+ */
+u32 efi_bgrt_image_offset_x(void)
+{
+	return bgrt_tab.image_offset_x;
+}
+EXPORT_SYMBOL_GPL(efi_bgrt_image_offset_x);
+
+/**
+ * efi_bgrt_image_offset_y() - Vertical position of the boot graphic
+ *
+ * Return: the Y offset, in pixels, at which the firmware drew the image.
+ */
+u32 efi_bgrt_image_offset_y(void)
+{
+	return bgrt_tab.image_offset_y;
+}
+EXPORT_SYMBOL_GPL(efi_bgrt_image_offset_y);
diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
index e6cd51005633..1c287e5fd388 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -9,7 +9,14 @@
 void efi_bgrt_init(struct acpi_table_header *table);
 int __init acpi_parse_bgrt(struct acpi_table_header *table);
 
-/* The BGRT data itself; only valid if bgrt_image != NULL. */
+bool efi_bgrt_has_image(void);
+phys_addr_t efi_bgrt_image_address(void);
+size_t efi_bgrt_image_size(void);
+u8 efi_bgrt_status(void);
+u32 efi_bgrt_image_offset_x(void);
+u32 efi_bgrt_image_offset_y(void);
+
+/* The BGRT data itself; only valid if efi_bgrt_has_image(). */
 extern size_t bgrt_image_size;
 extern struct acpi_table_bgrt bgrt_tab;
 
@@ -21,6 +28,36 @@ static inline int __init acpi_parse_bgrt(struct acpi_table_header *table)
 	return 0;
 }
 
+static inline bool efi_bgrt_has_image(void)
+{
+	return false;
+}
+
+static inline phys_addr_t efi_bgrt_image_address(void)
+{
+	return 0;
+}
+
+static inline size_t efi_bgrt_image_size(void)
+{
+	return 0;
+}
+
+static inline u8 efi_bgrt_status(void)
+{
+	return 0;
+}
+
+static inline u32 efi_bgrt_image_offset_x(void)
+{
+	return 0;
+}
+
+static inline u32 efi_bgrt_image_offset_y(void)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_ACPI_BGRT */
 
 #endif /* _LINUX_EFI_BGRT_H */
-- 
2.39.5

