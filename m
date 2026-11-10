Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301109;
	b=QCp+elxDJreMsoQmVqRMbZ7hSYJtHGlzssD/GXOPAF/9zkyBUvxRAa5uYOxCgFfBx4wk
	 Vqc8iaqvgmt+pUjed58YsNTqLWS8+fan7lrbFpwZLcRdmH3h3QFfKwrBsMp5Ophq81iso
	 HBcWS3cNRMwhTaE/CxgFoBXdeuPzSsgoonAYj2iDILHlaSOTfz7QBzhy2yvgHBstwsZpO
	 yG0Q90QNhU/33HlBiMf7ZHvvv48erlPqrLiQ1nByFieaaRHED8VduGOnWfHUinsKGNoy4
	 sFsBgKWVx82R1A0HJIvzF2qDN8yNud8nyw7F9Bl/JYiI9Ey247Y8QnkdQtPCHJHd0zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301109;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=HIr2gJNYKSV9Po7OTlCzbHRJ4V+/f5BdHK/WDaIaT64=;
	b=4Yafu3nw/IiQPH/iRXFKYWwVbAJZpCbg04zYKgCHmIzdlpE2qiQFvuGIm5ztGA0sfZSs
	 L6yWhwUpJEEdHTqzGX0QVuYci8VDCRvgrvpDvrjjVOHF1Eg6YbDw2Fum0AaeX1kWwdUIe
	 5la7M1NchdAnmDDuDnkOrjnGY2C5XQM4xQpAt/rcpwAYA6XdmrohK1ozUCRyYXsXxP2bf
	 aP70vYkDG2pFMUKMSbPFQu/nwhUoxlzyMGi9sFW9bk3tNBVxF4DS9SapJ1Z66PwCsp46w
	 c9K4KlPD6cO9qAKbKzRHn21NINVMlR5+D26+xPfl9igRtx8aUWiXxdmkPq1mZSP8iWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13DB606A335;
	Tue, 10 Nov 2026 08:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A13DB606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8DxUNGx3PJqhiAeAA--.21795S3;
	Tue, 10 Nov 2026 16:58:25 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxrM6m3PJq83MzAA--.21431S5;
	Tue, 10 Nov 2026 16:58:24 +0800 (CST)
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
Subject: [PATCH v3 3/6] LoongArch/PCI: Remove vga default device override
Date: Tue, 10 Nov 2026 16:56:14 +0800
Message-Id: <20261110085617.2626835-4-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxrM6m3PJq83MzAA--.21431S5
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cw45ZFW7WryDWrWDJF1rKrX_yoW8trW5pF
	9xZFs7KFZ7Gr15GrnFvw18Gr1qyas7C34xuFWUCry8K3W3A34Fq39ayw1kXFW7Ja97XFy8
	ZFZIkF47GF4DtabCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Wrv_ZF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0LNV3UUUU
	U==

From: wuqianhai <wuqianhai@loongson.cn>

pci_fixup_vgadev() forces the VGA default device to a non-Loongson VGA
device whenever a Loongson display controller is present.  This was
added to prefer a discrete graphics card as the default boot device, but
it makes vga_default_device() inconsistent with the firmware boot
display: the firmware framebuffer lives on the integrated controller,
while the override points the default at a discrete card (or leaves it
unset when there is no discrete card).

The fixup runs from pci_bus_add_device(), i.e. after the VGA arbiter has
already selected the default device through the firmware framebuffer, so
it overrides that choice.  Drop it so vga_default_device() consistently
reflects the boot display.

Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
---
 arch/loongarch/pci/pci.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/arch/loongarch/pci/pci.c b/arch/loongarch/pci/pci.c
index f33c7ea1443d..b756a44272ab 100644
--- a/arch/loongarch/pci/pci.c
+++ b/arch/loongarch/pci/pci.c
@@ -8,7 +8,6 @@
 #include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/vgaarb.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/cacheflush.h>
 #include <asm/loongson.h>
@@ -88,23 +87,6 @@ int pcibios_alloc_irq(struct pci_dev *dev)
 	return acpi_pci_irq_enable(dev);
 }
 
-static void pci_fixup_vgadev(struct pci_dev *pdev)
-{
-	struct pci_dev *devp = NULL;
-
-	while ((devp = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, devp))) {
-		if (devp->vendor != PCI_VENDOR_ID_LOONGSON) {
-			vga_set_default_device(devp);
-			dev_info(&pdev->dev,
-				"Overriding boot device as %X:%X\n",
-				devp->vendor, devp->device);
-		}
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC1, pci_fixup_vgadev);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC2, pci_fixup_vgadev);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC3, pci_fixup_vgadev);
-
 #define CRTC_NUM_MAX		2
 #define CRTC_OUTPUT_ENABLE	0x100
 
-- 
2.34.1

