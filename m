Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301450;
	b=CpOO0kPxfwWSVFuJk49kzSftnt7a4JQUyaw6A1/qhH9lE1YjVs00r8miIHQ7rgEQfp6N
	 UnafaFwyBE0lQDHhgqabLavy9ooIKKgNBxZSCJWRgicllLb2p7dGdYxf/dcUYrwv6rRIR
	 SQ3UnCOPpqA1YQITsRzD8OAD7xYzRPGwefOxQFvMQSuN7y0TsOr5BvaMcSfmE9QjOjxX6
	 7Kau0kYN7C5FSeiAPUOb0Z49aS+xBnl+ll/CIy81GO4fCPixez+lznWUdlHq+48YKHcPz
	 vwzdiSUgqB54jk4ATdIVGN3IAtyswRxrLWhf58I7MxGjOcK8W6B41CTuduGs2oP3T3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301450;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=1bfC9N6ELP+5DriqcpxzXRy+3LJItx2+bFeyZEtPwLY=;
	b=mI8iAA+KeJrLyuS+8N5pjsxZ+vkT9woOo1d5tU6TAGwou9wzobFQQ1FDRBXuIGYfkP/K
	 5y6s5qbvnMnZcxuvLU95DOEHMSxxTsoeNIBPKCWlI51M1fYoXZjr+zCL2rXcuOvK9skib
	 sggpEIXFRUMuBTF7lZuhAP3QVph5Y0rne4YVbnljcBwqJETdXgynqIhYZEFNPZKNbBLjA
	 SkYZ3PsuPzL1cl9CAX8PsNm3eLrV9Dby92jmRPTbxBJzCWOhJ/FVUNgM1PUHw1X652Ldh
	 S9swcwQ+Rl8yszTUwBlkDr+BsdMz8ZdxwREYdOza13WgjqE8572u2AQxDGPWjpwmsRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9990D60A3808;
	Tue, 10 Nov 2026 09:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9990D60A3808
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8BxhvAI3vJqdiEeAA--.21068S3;
	Tue, 10 Nov 2026 17:04:08 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJCxe84A3vJqYXQzAA--.22085S4;
	Tue, 10 Nov 2026 17:04:06 +0800 (CST)
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
Date: Tue, 10 Nov 2026 17:01:59 +0800
Message-Id: <20261110090203.2631481-3-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJCxe84A3vJqYXQzAA--.22085S4
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uF1DKF13CF18Zr4kArW8AFc_yoW8GFWrpF
	ZIvrsrtrW8GF1xGFs8t34DXr4qqF1v93429FZrKFyrA39Fvrn0q397Crn8WF1DJw4Fva1r
	ZFZxCw4FkF4DAabCm3ZEXasCq-sJn29KB7ZKAUJUUUjr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPmb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26r4UJVWxJr1ln4kS14v26r4a6rW5M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6Fy26r45twAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0x
	vY0x0EwIxGrwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_GFv_Wrylx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j
	6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU5
	24EtUUUUU==

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

