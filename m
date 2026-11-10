Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794302787;
	b=XNCvrFNIYiLJgrFR2mMKfx4YXM4jD0StFfttS2iv+0QWaMzqL5YmD8EGs9TbksjQVqex
	 vnQTszlY8fxnbArVGIfUy7N+BSjsxP3nCRNET9CiX2FSP21uznC4ci737RS3CPI4244DN
	 6UrpgRM/Y9DyqHB9BE7o5n1t8Vp0zxaEd/CcSUYNpyOciiio12L6pZ4I8B5eOoH4Hn6r2
	 JVsK54asOxXdjj7e9A3hfH7dkzC0wez8OswskMRNRnWsuI49up++W1LVMeRDs76yRr+4f
	 92uZ6ngZDh4+L6MKbfRX1UFbuuZbJhjN5m+lyP7AeymvfGZTuT+vQjm/Y4WiSD4INZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794302787;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=bnII0DF8BaZXT0t528ffy71g+QEopq5IXdLrMPJAYhk=;
	b=hDWkTi+Jy40zWT9jXEKc3bbtx60E4qkiEHY/s2FvYZ3RdYNPRBAeeVqLD81VICnIv/+z
	 FfxZQZyRey8LMLoI80p9K/u6JyPeRkLu92QZ23Ir+Y1Pz4agCxY+NRhyYSaVjcuJjxaw2
	 41wTKoR8L6BjZ4H5Lj5CCzuUL6P+pPIwQktk2DHx7Dj2lOsUDCjvPWU7ldxc5o02GUGx4
	 uqwSqK0Fx7zqEKyVmFsFeBUdOMZgJ8sJAYjo1iLcMMZ8zUE6qFRPhO7uyPR/rtcFMCYJZ
	 fevHaIhLg+7rSZwfLWEWc06zyznIyEjJ2bZKTYOa5kNqSSCUm82rSf+GMa/KlfgiWaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C7B606B2E5;
	Tue, 10 Nov 2026 09:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9C7B606B2E5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8CxfdJA4_JqWSMeAA--.21315S3;
	Tue, 10 Nov 2026 17:26:24 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJDxDc824_JqlHUzAA--.21861S2;
	Tue, 10 Nov 2026 17:26:14 +0800 (CST)
From: wuqianhai@loongson.cn
To: chenhuacai@kernel.org,
	kernel@xen0n.name,
	tzimmermann@suse.de,
	deller@gmx.de,
	bhelgaas@google.com
Cc: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	javierm@redhat.com,
	loongarch@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-efi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wuqianhai <wuqianhai@loongson.cn>
Subject: [PATCH v3 4/6] LoongArch: video: Implement primary framebuffer device detection
Date: Tue, 10 Nov 2026 17:24:18 +0800
Message-Id: <20261110092418.2647821-1-wuqianhai@loongson.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110090203.2631481-1-wuqianhai@loongson.cn>
References: <20261110090203.2631481-1-wuqianhai@loongson.cn>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxDc824_JqlHUzAA--.21861S2
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr4rCFy8Cw13uF43XrWUGFX_yoW5tFWDpF
	1DAF95Jr4kWrn7G3sxJa43Zr15Jr1kGr1agFyI9Fy8CrnxXrn5Zr93tryDJa4UJ398JFWF
	qF9xGw13WF45XabCm3ZEXasCq-sJn29KB7ZKAUJUUUjr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUmCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVW8ZVWrXwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lF7xvrVCFI7AF6II2Y40_Zr0_Gr1UM4kE6xkIj40Ew7xC0wCY1x0262kKe7AK
	xVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267
	AKxVW8ZVWrXwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7Jw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07bT_M-UUUUU=

From: wuqianhai <wuqianhai@loongson.cn>

The LoongArch port does not implement video_is_primary_device(), so it
falls back to the generic stub that always returns false.  As a result,
with CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y the framebuffer console
cannot map itself to the primary display device and instead binds to the
first registered framebuffer, which is not necessarily the one the
firmware used for the boot console.

Implement video_is_primary_device() by returning whether the device is
the VGA default device.  This reuses the VGA arbiter's choice instead of
matching the firmware framebuffer by address, so it is stable across BAR
resizing: the default device is fixed before any driver runs.

Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
---
 arch/loongarch/Makefile             |  3 +++
 arch/loongarch/include/asm/video.h  |  7 +++++++
 arch/loongarch/video/Makefile       |  3 +++
 arch/loongarch/video/video-common.c | 29 +++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+)
 create mode 100644 arch/loongarch/video/Makefile
 create mode 100644 arch/loongarch/video/video-common.c

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index 4b22f95aaafb..7fca93298cef 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -166,6 +166,9 @@ bootvars-y	= VMLINUX_LOAD_ADDRESS=$(load-y)
 
 drivers-$(CONFIG_PCI)		+= arch/loongarch/pci/
 
+# framebuffer console primary device detection
+drivers-$(CONFIG_VIDEO)		+= arch/loongarch/video/
+
 KBUILD_AFLAGS	+= $(cflags-y)
 KBUILD_CFLAGS	+= $(cflags-y)
 KBUILD_CPPFLAGS += -DVMLINUX_LOAD_ADDRESS=$(load-y)
diff --git a/arch/loongarch/include/asm/video.h b/arch/loongarch/include/asm/video.h
index 9f76845f2d4f..7b38881ea1d6 100644
--- a/arch/loongarch/include/asm/video.h
+++ b/arch/loongarch/include/asm/video.h
@@ -8,6 +8,13 @@
 #include <linux/compiler.h>
 #include <linux/string.h>
 
+struct device;
+
+#ifdef CONFIG_VIDEO
+bool video_is_primary_device(struct device *dev);
+#define video_is_primary_device video_is_primary_device
+#endif
+
 static inline void fb_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
 	memcpy(to, (void __force *)from, n);
diff --git a/arch/loongarch/video/Makefile b/arch/loongarch/video/Makefile
new file mode 100644
index 000000000000..f1b2a7e54033
--- /dev/null
+++ b/arch/loongarch/video/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_VIDEO)		+= video-common.o
diff --git a/arch/loongarch/video/video-common.c b/arch/loongarch/video/video-common.c
new file mode 100644
index 000000000000..6fea46661cb6
--- /dev/null
+++ b/arch/loongarch/video/video-common.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Loongson Technology Corporation Limited
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/vgaarb.h>
+
+#include <asm/video.h>
+
+bool video_is_primary_device(struct device *dev)
+{
+	struct pci_dev *pdev;
+
+	if (!dev_is_pci(dev))
+		return false;
+
+	pdev = to_pci_dev(dev);
+
+	if (!pci_is_display(pdev))
+		return false;
+
+	return pdev == vga_default_device();
+}
+EXPORT_SYMBOL(video_is_primary_device);
+
+MODULE_DESCRIPTION("LoongArch video helpers");
+MODULE_LICENSE("GPL");
-- 
2.34.1

