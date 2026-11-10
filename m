Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301108;
	b=bFpTZA4TIv9tjoxOd11194r+y3Bdc8vEJIMOdMUmUcDHC3WU19CfIC0yazGJW0CKqv6R
	 FZPTNEihgP/V/J0H9+Y5z4R7GM36DcjbLayijkDPD71uGQRZfafEpnPgCUsj/JxAUejq9
	 lQBNB0RP9OpiTUirB++7j3oCGP4n+N0YWvKvvO0oU79SPjAZ0FLFOh9YFTQjKOv77jair
	 ZitxCOurjKSI0pnU1i23FMkzio0vLrvUL6oJkGk+gGrE5J5SHNCJvDax4m9A10pz99Pvp
	 Q+wXPnRX/Ghr4BUzGjSGSetX4qnmsDzn4gn/4pnaDF1CoP74qFA7GLmHLoTDrTVgfhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301108;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=1bfC9N6ELP+5DriqcpxzXRy+3LJItx2+bFeyZEtPwLY=;
	b=RPt47lllDrpP+IxbvJ+CzGMYQODdbUqhFeJ8dYQ7ajnDXefxLiTf5X0+kSdZw/JEjiud
	 lvElHsrxMp7K1pmUfy88ikUJgB8LLPHFXot26gmEpAsE6HxgC7WHe7DGhS58ULqaK0MRb
	 F2Rx2COz5nzd3QZLjOlwaHyiLh1DbfMeEV7I48rNQdEuALvVrmN/H6Yj/HiEIMODqtQ40
	 3Ot8kEjv2r6pYMG3BmLthbG3wEvO9QtW5LUwbdPbaIQeca1Ikobej5CHJZhF5shspIWvk
	 xVn+uFgudIbcNn1AXtzlE5HtdOHgVSi75UE2yq0KS6HE0IexcLcQqOVTrQK5sjIs7aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCA1606A339;
	Tue, 10 Nov 2026 08:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECCA1606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8AxX9Ow3PJqfSAeAA--.21281S3;
	Tue, 10 Nov 2026 16:58:24 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxrM6m3PJq83MzAA--.21431S4;
	Tue, 10 Nov 2026 16:58:22 +0800 (CST)
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
Subject: [PATCH v3 2/6] LoongArch/PCI: Refresh screen_info after resource assignment
Date: Tue, 10 Nov 2026 16:56:13 +0800
Message-Id: <20261110085617.2626835-3-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxrM6m3PJq83MzAA--.21431S4
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uF1DKF13CF18Zr4kArW8AFc_yoW8GFWrpF
	ZIvrsrtrW8GF1xGFs8t34DXr4qqF1v93429FZrKFyrA39Fvrn0q397Crn8WF1DJw4Fva1r
	ZFZxCw4FkF4DAabCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1a6r1DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrWlkUUUUU

From: wuqianhai <wuqianhai@loongson.cn>

PCI resource assignment runs from acpi_init() at subsys_initcall time.
The firmware framebuffer BAR can be relocated, leaving screen_info's
lfb_base stale.  vga_arb_device_init() runs later at subsys_initcall_sync
time and reads screen_info to identify the firmware default VGA device.

Update screen_info through the generic screen_info_apply_fixups() helper
right after the root bus resources have been assigned, so both the VGA
arbiter and sysfb_init() observe the final framebuffer address.

Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
---
 arch/loongarch/pci/acpi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/pci/acpi.c b/arch/loongarch/pci/acpi.c
index ccbcea61fcd9..cb313ff67f7e 100644
--- a/arch/loongarch/pci/acpi.c
+++ b/arch/loongarch/pci/acpi.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/pci-acpi.h>
 #include <linux/pci-ecam.h>
+#include <linux/screen_info.h>
 
 #include <asm/pci.h>
 #include <asm/numa.h>
@@ -256,6 +257,9 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 		 */
 		pci_assign_unassigned_root_bus_resources(bus);
 
+		if (IS_ENABLED(CONFIG_SCREEN_INFO))
+			screen_info_apply_fixups();
+
 		list_for_each_entry(child, &bus->children, node)
 			pcie_bus_configure_settings(child);
 	}
-- 
2.34.1

