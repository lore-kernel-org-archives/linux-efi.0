Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301172;
	b=aO31RFKAlevJMtZy5vLaVkbB1uEbAEap/4ccZSGtusajLr91XT+s3brvtUM/gQdRX+uz
	 Q0+vwvm4Y3okd99/jQUoeIqkvleBBou47C4AR1V1wY8irINuXEMWf84flL+NSCjvttXfK
	 p4kmI2XQL9WKwh7ux4iAW9It/HQoML4Q2skv8fNzaSdnOPF2BvrS3DXfzZral6yfNTtY8
	 /9sGVz9QtTOG7Lvb2/hC+6FqEJLFZc1LXWqTGZ3mQ7S1ovW/lyNVeB/2IuIdZXwE4+hxs
	 TJKN2tfPtqpPeHTTc2ldYvks6CsCifoQ+vJ8e9TL9JXrrNySShmK6X2M1sh1amJokQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301172;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=tJNhHzwB5LcleXTM/9uMvCleiUrNIQKHQSO/1T92eLo=;
	b=AyzNTmNSEyenqrGerekFjrxJU9cH/4hyT3pJCj9WL7YhywxmloyhU8CkraMygA/4wNWA
	 YT2jA7yYT10g2AO8Qd8EasYqfNDBz2iECCXtry5zk5c49k/hURERXs85O2vyePDfRseaO
	 AkQOWZn18/zSVpUdmQ3nSw2QaO7T7YYKzDbd0b0cWFa43LQ8VEilAz254ylCUDaYThoFr
	 wMeZBW8RcKqQihkFNaxaEE9SEdj7mU8VanOdDaLIqAoxQG35FP4asT9TKW1/EsAtJ0hGz
	 1QcR1Reu/uDvwvDDKxP3diSXXvBvHXsF9lnxv/8SgZV6gE9ZGLuTsbImOJl4yho93xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66199606A32E;
	Tue, 10 Nov 2026 08:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66199606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8DxTtPy3PJqvyAeAA--.20623S3;
	Tue, 10 Nov 2026 16:59:30 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxa87t3PJqCXQzAA--.20943S4;
	Tue, 10 Nov 2026 16:59:28 +0800 (CST)
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
Date: Tue, 10 Nov 2026 16:57:29 +0800
Message-Id: <20261110085729.2628009-3-wuqianhai@loongson.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110085729.2628009-1-wuqianhai@loongson.cn>
References: <20261110085729.2628009-1-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxa87t3PJqCXQzAA--.20943S4
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cw1kJr1kKr1xWr4kJw1fGrX_yoW8Wr1fpF
	WkJFyIyF48XFs8J3y7X34kWF98uan7CFyIkFWYkwnxua43A3yjk34ftasxtr9rXrs5ZF1S
	vFn3t3WUAayrGFgCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1q6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6rWY6Fy7McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7JVWDJwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8
	Jr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1Za97
	UUUUU==

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

