Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794302787;
	b=fxx1CWjD4zBn9ELx3e/6uHRFtM3QhDdK5mc3scYiD65Zp+XtEWkxHBtrexKX83Nkpfcl
	 gFX7KzwO0JtTqsyKK800vEBec+InfsTFAkI/j/BWNPGclGCkGlKsJoF8qrsZRTFpgvJkT
	 rScrtPtmg2ZPyWXsrNUcjj3TE6lXOeGuZQUOYSGyUXiGbqiwkXE5fy4CypkadK09SvXGz
	 kgiYmtKAbU2OB2f9carvg1owMSKcTasyshhQsBHZZ1kL4kLRcPtgDR2qojNZwVIOvDYXK
	 TGeJL2bm8FLR0OpA+8mUgXHPEHs8sjTKgzY6/5qWnUgnPm7B4xd98xAf1V0TNndTlHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794302787;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=tJNhHzwB5LcleXTM/9uMvCleiUrNIQKHQSO/1T92eLo=;
	b=pN0nE7G/lYCn45VEC8xsso5HB3nb2wQ61TeUd7Nqu9kaITaBJS/kvNkYGq+b8K4idESs
	 aDcJer0vGhYOAK3pUtpa0ZBSRCZmVP0mLJ2AQng+X1B9vK6u0DzQwgy7Pn2hJRIpmeLrr
	 29PrZvSmVqQ9vq0g00Uv8PyIHsG1UfF4xm+GTKUmuuksyGthWbiDLkemqT5lmRl9wB4JC
	 HAWlPSBjWY3Y3jckLhbX54cbPBw5DzJVu0tKekePIWDFPWlbFxQ7B97z8YERUoJVQMsVK
	 eqODIQK6NB/4yn/S0yFIz3sNr6nEm3U5nK/wnG2w+rKoKyAEdcEVaLXuLEBfO9mWXUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD66606B16F;
	Tue, 10 Nov 2026 09:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BD66606B16F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8Cxf9M_4_JqVCMeAA--.21363S3;
	Tue, 10 Nov 2026 17:26:23 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxrM4_4_JqmHUzAA--.21469S2;
	Tue, 10 Nov 2026 17:26:23 +0800 (CST)
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
Subject: [PATCH v3 6/6] PCI/VGA: Enable firmware default device detection on LoongArch
Date: Tue, 10 Nov 2026 17:24:26 +0800
Message-Id: <20261110092426.2647976-1-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxrM4_4_JqmHUzAA--.21469S2
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cw1kJr1kKr1xWr4kJw1fGrX_yoW8Wr1fpF
	WkJFyIyF48XFs8J3y7X34kWF98uan7CFyIkFWYkwnxua43A3yjk34ftasxtr9rXrs5ZF1S
	vFn3t3WUAayrGFgCm3ZEXasCq-sJn29KB7ZKAUJUUUjr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUmCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1q6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVW8ZVWrXwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lF7xvrVCFI7AF6II2Y40_Zr0_Gr1UM4kE6xkIj40Ew7xC0wCY1x0262kKe7AK
	xVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267
	AKxVW8ZVWrXwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5Jw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07bcManUUUUU=

From: wuqianhai <wuqianhai@loongson.cn>

Use CONFIG_SCREEN_INFO rather than an architecture-specific condition to
guard vga_is_firmware_default().  LoongArch now provides
sysfb_primary_display whenever CONFIG_SCREEN_INFO is enabled, so have
VGA_ARB select SCREEN_INFO on LoongArch as well.

The screen_info staleness is handled by the PCI resource-assignment path
in the previous patch, so vga_arb_device_init() no longer has to refresh
screen_info itself.

Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
---
 drivers/pci/Kconfig  | 2 +-
 drivers/pci/vgaarb.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0c7408509ba2..01e6378effae 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -255,7 +255,7 @@ config VGA_ARB
 	bool "VGA Arbitration" if EXPERT
 	default y
 	depends on !S390
-	select SCREEN_INFO if X86
+	select SCREEN_INFO if X86 || LOONGARCH
 	help
 	  Some "legacy" VGA devices implemented on PCI typically have the same
 	  hard-decoded addresses as they did on ISA. When multiple PCI devices
diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index 3e58b2c05c85..4528ad038610 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -566,7 +566,7 @@ EXPORT_SYMBOL(vga_put);
 
 static bool vga_is_firmware_default(struct pci_dev *pdev)
 {
-#if defined CONFIG_X86
+#ifdef CONFIG_SCREEN_INFO
 	return pdev == screen_info_pci_dev(&sysfb_primary_display.screen);
 #else
 	return false;
-- 
2.34.1

