Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109231;
	b=SoK2hLb3DU8hutCaj+QYW+12MTBccoDmfABpZsQv7S92eZ4fflMrytbw0TaNECJOsQMo
	 X+S1yaJpYLqzxe4eDfgMxOLqnOJLht3BXffG/TLDG3kQpswUmfJIbk/VMeyJ0+BNj53vP
	 82rFPuylR2oUsnzE72cWOhre41pJ+WQ9iId12h2+uBGP3mNp2IBeeu0WhFjcV/aigbNID
	 DcRZxzwc2ijdQiDlPE1Zo4LpKcG5KcLqaT0TVdlobP50wjENk1BJmceiT9UDfxk1QRqZ0
	 ZFaIf+0ABsL+iLY9zZnzdY1a9lXhzJfZM3YLeaoFP4z6JLQOwSl2sLcUB3VW9MY1K6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=G1+nfUJ+NP0zqKdPIyJvkG8NMwha03wen6k4s/kDOuc=;
	b=hZl8x1R3AbB4Xs3iV45nhrlYSG6HtHlxfkKVdJSTc6gnQt8fixv/ygRAI7aIHMM6DAY1
	 55/1zcTqkUtP7kqqTnNJ0wT5qXzMphHq8ZCYkQHfiPRJb2/qM8y0vGlJg/hEn8jqcMvl/
	 iVZJTWXYcvDKQ6TZdKj/4OhmQCK50zXI6Yz5/Q0rHDW/T0s1vSnpTRILg84HmRkR6ccjJ
	 AREHBxkDgQ7i8TTkMf5D/YZPzqpGZBmb4ZhqKYuPbSWMzjKL7nA4fGdwmSeNANy0xCiYd
	 AUmPc5Up19RUDCPl8cgA+YHv4IJqxdbP4nR9grQaKwz3jXKCwv6bGHgh2w78jYzxNZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S2JE7Nd8;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB01606A32E
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 13:53:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CB01606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S2JE7Nd8
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso2953975f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 06:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793109230; x=1793714030; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G1+nfUJ+NP0zqKdPIyJvkG8NMwha03wen6k4s/kDOuc=;
        b=S2JE7Nd8OTAHxoXX6BZLIyrug9lS3aM+fOmCTHlOH5CAIMWvEng6vFztONyEQONBdy
         6U0nsYeDQ35b6WSek1fAgeHdpeTYBo+D5PJK/A53gJmbPG6B2KWi4kSxAjhis7z63lHa
         VTwhOjKb0TUkye6vfPvbocaNrgfU5fOrcE9M84tEkkhZli/4vBmfKp75SaCv+h4FwTN/
         EtgzNbV7aphJrZ8dCgJJ0YE/R+1IiRFOPdV1D6GOSd7mCp7UjrZEIzeX9wntDPWIqBRW
         MCObtUrCuy1+OjRKttCmH5cUl6o9wgpDTzpxhx+fVzWDHAMjD2IUkMA1kAucOEcxqznm
         wcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109230; x=1793714030;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G1+nfUJ+NP0zqKdPIyJvkG8NMwha03wen6k4s/kDOuc=;
        b=nr0DQbOn9QrKtC32NFBrKE0p6jHBUqNHVxgr6INEyPaos0xaSoaEqMotId5OWMIviY
         vdzo/jYfAZsZhCPymvPNqxvQGapW7n+dh7XKaOmijxwq5C2nHSOn74GilkLSe2VI6h5C
         HMCLqLpJtlaza7G/Xbjkfmt3a9Z4xWtH6cIdYgLX8o43p65PGMOrJ72SX2dNDSHhCTKX
         IxhP/MKLkvD99F9egobaDqJyrJEG44XdMX/ByDTPdFbbGNKI5pACuZzD93Clx4yKigLs
         0SEppLkIt0yvZdix52rqOvsSVTbDh5O2fDc2xGm9iK0tjOXCCpdaNLXchVidTzzYA/vv
         gL4w==
X-Forwarded-Encrypted: i=1; AKwUvByxUgEWvEgtb4RybJXFjEVxjdW1a512EeOlygrzYgX0mYfmy21AjvgwFEgcQqPk/aYwKKUvQeKun8M=@vger.kernel.org
X-Gm-Message-State: AFq9FYJDZz1nWhsk8jRwaQv13iJJNDKvWNIv3MwR8CaELF7n4I/2XXrJ
	/dcqIAc7lFE9uMoH6TR5AXyuNuxtRH+imQdvhofyjW9jefyhPeNLlQzB
X-Gm-Gg: AYBFou0jqj241oRYhoseaEobUWgpI6+oKDd+arqc6qk92CKweuc0cz+/XbG5PkwOCod
	k/PSnUd8dattfz3aCU8rnfQ3WEvD6Grc0NflSIjxrIGzU00XwSSWX1LKQYQAra9UK0EQloDOBIC
	16Kzz7vWM4S65234tWT+/SkpjoO+r442l/1Z52shjslvrYMjmFDGUUYXJO+YiCgjXozQDgffg8K
	0g+jJhonunOI23OsN+HpAYkSYF0FxJb0lPe2OXiLuVsCkKSS6BiRCJA8t/uI5281bafXe9d2xIj
	PxgJmdALrMZHEalGJNPAPOoAgZ3fzL4gyEJ55a0EVOTAyn7bjM6fbQo48w380aa5BIOgGeTpuNA
	esccPI4LjYC3KrXEdf7yqCVmY2c5F3VZ0GF3lxGlfUFNiuMspZjojywvEPvbpHJul+TlAqEwmvC
	UBRQiBByvlS+5r12dUBhsrj2oz/CbmNMLn2iruX/nLFt52tw4x3tgs/SSgoe5IuTz1XR9Bk2PKJ
	VP1VAjczeKTyetBi8u4BIofwtCUY/sO/h1lSagOTmSkFkRQLZ9skA5Tn1mA17ZrxIpdOLuPvzkU
	kYZY8hc=
X-Received: by 2002:a05:6000:29d5:b0:48e:f47:273c with SMTP id ffacd0b85a97d-48e3eb45747mr11349441f8f.8.1793109229602;
        Tue, 27 Oct 2026 06:53:49 -0700 (PDT)
Received: from ingenieria31.oficinasStQ.local ([79.117.46.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb846sm23128058f8f.25.2026.10.27.06.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:53:48 -0700 (PDT)
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
Subject: [PATCH v6 02/15] efi: bgrt: add accessors for the boot graphics
Date: Tue, 27 Oct 2026 14:53:29 +0100
Message-Id: <20261027135342.2003632-3-maximpedraza@gmail.com>
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
says yes when phys_addr_t can hold it, so that it never disagrees with
efi_bgrt_image_address() on kernels with 32-bit physical addresses.

Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Closes: https://lore.kernel.org/dri-devel/5d7067de-97b7-4232-9cf6-e4b978696482@amd.com/
Suggested-by: Jani Nikula <jani.nikula@linux.intel.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Màxim Pedraza Padilla <maximpedraza@gmail.com>
---
 drivers/firmware/efi/efi-bgrt.c | 75 ++++++++++++++++++++++++++++++++-
 include/linux/efi-bgrt.h        | 39 ++++++++++++++++-
 2 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index 1da451582812..1affe5528139 100644
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
@@ -89,3 +89,74 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 out:
 	memset(bgrt, 0, sizeof(bgrt_tab));
 }
+
+/**
+ * efi_bgrt_has_image() - Whether the firmware left a boot graphic
+ *
+ * Return: true if the BGRT points at a BMP image, which efi_bgrt_init()
+ * checked and reserved, at an address that phys_addr_t can hold.
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
+	return bgrt_tab.image_address;
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
+	return bgrt_image_size;
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

