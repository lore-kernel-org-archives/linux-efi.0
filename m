Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301103;
	b=xKHAhhenkS58aic+GKjD9mWIv/r799aIUlcknIfr/KYfi4Au/eCN6JZ3nRnuKyar1u6A
	 KgwyJ5rwghlvJxDz3K1EZkivsSd4jHTLH2Mb4P43YwGPIOAWssGSGiisL/1BLYvWNxjQE
	 /pK8hpGO0rXEHV3fgyq4B9kbprnTJPFCeQ2PnjGYPznS+JYcivZdJdgTEx/4glYpAbCyu
	 Px7SuaiTQ6hRUX+iRxNkbFFuf39oOzF2FerKUW48ng6Y+uX/7sB7J+19QIPmOsFqvXmnQ
	 7eDa4WzUkrIhp/KWHCbOGZ5IamXHW9IMBIqzjUyJtN1wClzgUOlacwftnUksfSYRv1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301103;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=4dIt1AfgIDEeFJWlP0nlFpcsbLLfzKQxu18qQOXeU/w=;
	b=qyumbmVACdEm+n+cb0BFZzrTFINkQ7csxqcDrkWwlARaegk1w1OC/B7cUqGBjo1tUc7x
	 qBey/jCRDGnmMf1WEetHlEsaIJM0uw7Ria8QmqlLWxH1ZgDEA5v5Oi91RYzWeX0Z7AURw
	 r0ojbg/9EHYUd2XGNCqRTnk64kmZnFLjn1lFFnq85pPfzOzM3OWiliMI9aWPdyDOgAHD+
	 V7nc5KKaBPF/nWEW1/XY0frn7XcTIi1/Ubk3cCkBAvJlnzbTE1SG2tShEGoab2DgOotyg
	 QK3VHt8L1uKolCm/CAdymHrJn9JtYPDlbuTUHvgoF451oAwGsGpDfEh+DtMYVe/WHLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF70606A33F;
	Tue, 10 Nov 2026 08:58:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BF70606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8DxD9Or3PJqayAeAA--.21534S3;
	Tue, 10 Nov 2026 16:58:19 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxrM6m3PJq83MzAA--.21431S3;
	Tue, 10 Nov 2026 16:58:17 +0800 (CST)
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
Subject: [PATCH v3 1/6] LoongArch: efi: Provide sysfb_primary_display for screen_info users
Date: Tue, 10 Nov 2026 16:56:12 +0800
Message-Id: <20261110085617.2626835-2-wuqianhai@loongson.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110085617.2626835-1-wuqianhai@loongson.cn>
References: <20261029033440.973077-1-wuqianhai@loongson.cn>
 <20261110085617.2626835-1-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxrM6m3PJq83MzAA--.21431S3
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uryfWF1ftrWDXrW7Ww18tFc_yoW8trW8p3
	srAF4ktr48GFs8Jryvy3s7urW5Gr95G342gFnxCa4rAw1qqr4kXr1ktryDXFyqqa1FkayF
	qF1rXa1avF4DCwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcNBMDUUUU

From: wuqianhai <wuqianhai@loongson.cn>

LoongArch defines and initializes sysfb_primary_display only when
CONFIG_SYSFB or CONFIG_EFI_EARLYCON is enabled.  The PCI VGA arbiter and
the framebuffer console need the firmware framebuffer information through
screen_info whenever CONFIG_SCREEN_INFO is enabled, even if neither of
those options is set.

Drop the guards so sysfb_primary_display is always defined and
initialized, and its EFI stub alias is always provided, mirroring x86.
This avoids selecting SYSFB just to obtain the symbol.

Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
---
 arch/loongarch/kernel/efi.c        | 5 +----
 arch/loongarch/kernel/image-vars.h | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 69dd83f8082f..e491a82b2e0d 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -74,10 +74,8 @@ bool efi_poweroff_required(void)
 
 unsigned long __initdata primary_display_table = EFI_INVALID_TABLE_ADDR;
 
-#if defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON)
 struct sysfb_display_info sysfb_primary_display __section(".data");
 EXPORT_SYMBOL_GPL(sysfb_primary_display);
-#endif
 
 static void __init init_primary_display(void)
 {
@@ -129,8 +127,7 @@ void __init efi_init(void)
 
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
-	if (IS_ENABLED(CONFIG_EFI_EARLYCON) || IS_ENABLED(CONFIG_SYSFB))
-		init_primary_display();
+	init_primary_display();
 
 	if (boot_memmap == EFI_INVALID_TABLE_ADDR)
 		return;
diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e557ebd46c2b..4d1d7978553a 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -11,9 +11,7 @@ __efistub_strcmp		= strcmp;
 __efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display	= sysfb_primary_display;
-#endif
 
 #endif
 
-- 
2.34.1

