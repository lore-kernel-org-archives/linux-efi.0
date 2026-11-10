Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301456;
	b=EzqGxXOLCwRTAVgLhRv7RYVzHsBhzQv9TYkQGZ9jskwLvaRmnBrxIhhPAe3lPilmX8jM
	 QybI1/H5a5LtFIqm2SNcUla/PbEb6BVH/6hPeiSZaILJc8CVo4fFTqTLImBvb2qbYY9Qo
	 LZa3bLzDZx/vlK50Pww69n0yscRp4qcNnPDv0CZ0vBxFKS/JP6njvID6UHJexEXd4w90F
	 jN2dbF6mXft57I9EjBjfl8VZ4sc0FRsSkmOpEum1Ju0M5/2LnwKJEpzbDrhStVwyfhQ0l
	 Doxmm4BJDDQIaCZGezPRPZWxTh41wij/hf+LSGmhMbLZSmi8+uaBONIH0YfKWKpjfJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301456;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=HIr2gJNYKSV9Po7OTlCzbHRJ4V+/f5BdHK/WDaIaT64=;
	b=5mOC30d6mHco/xKJRqMPNaf01YdOUjixM9bK1TnGXBQxsvISdFF0QCmMWC8ywR8ZabM0
	 P+Ax3MzZu7O6mAGNZjmwtOW3ojrHv/Gk0G0gPFQ3Qz7n9bAxhVHhnC0qm+v6HKw3gVjpx
	 M5S6WaLwy2CaPySfFTK7a0VHYSMnE/xRydMa6jFXws+qzpLS8RAc9OciMTeUHR5N5jmOe
	 /o7UqfMI5zQHQ5MLzmwAJg1vykIaKV6yF2BU9yB5uIJWxBvfiJesQ0zM1vho+SXiMlYgo
	 //lDNZybCUDOXMRzVcIaTTyK+ejGKgt628cDPuVZloh7wUrePciQEwtSr4zDo7x4JZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF22606BA14;
	Tue, 10 Nov 2026 09:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BF22606BA14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8AxX9MM3vJqgCEeAA--.21292S3;
	Tue, 10 Nov 2026 17:04:12 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJCxe84A3vJqYXQzAA--.22085S5;
	Tue, 10 Nov 2026 17:04:09 +0800 (CST)
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
Date: Tue, 10 Nov 2026 17:02:00 +0800
Message-Id: <20261110090203.2631481-4-wuqianhai@loongson.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110090203.2631481-1-wuqianhai@loongson.cn>
References: <20261029033440.973077-1-wuqianhai@loongson.cn>
 <20261110090203.2631481-1-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJCxe84A3vJqYXQzAA--.22085S5
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cw45ZFW7WryDWrWDJF1rKrX_yoW8trW5pF
	9xZFs7KFZ7Gr15GrnFvw18Gr1qyas7C34xuFWUCry8K3W3A34Fq39ayw1kXFW7Ja97XFy8
	ZFZIkF47GF4DtabCm3ZEXasCq-sJn29KB7ZKAUJUUUj5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUQYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26r4UJVWxJr1ln4kS14v26r4a6rW5M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6Fy26r45twAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
	IYc2Ij64vIr41lF7xvrVCFI7AF6II2Y40_Zr0_Gr1UM4kE6xkIj40Ew7xC0wCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07
	C267AKxVW8ZVWrXwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWDJV
	Cq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJV
	WxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUO4CJPUUUUU==

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

