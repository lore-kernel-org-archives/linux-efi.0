Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301173;
	b=fpiN7DDtm7LQfuqQ2r7Ts9sM3c2dWVqGYiIx2eFQIAF1k1XrK+XebgeXn3SjQmholwyQ
	 fzw49GhKrpq1zmpGvjEYe58ZehixpLlh9WEonTTrslJmE6oxbi+Rd3mKDH+nkKv0zCZly
	 TbG1HuofQg47Mpao5/M75I2VQ31XumP6iMmyjjq46d7V97W4vNKFpV5KOis3NI4mAyU1t
	 89B4Zyov87/9JT9tkQZM98yFoBeHyl//t4sqNPfFJ7Zghh2Sy2ggibZYb0gWmnuTnDU3f
	 mqL6RL5YUM+Q/nsIP85ak1aU7YTgxb6rvCsLSTaE64RrqvKYCx49WYBKiFn/OsMzzog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301173;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=UriPUrEKGMPcV1kTeVLDKkGMmTprVWESy8oG8aPSbZo=;
	b=z2UE21Zp/KeGBgqyEECGGrzAnPWtAPLJI3ZVgmQvbI4dB/KEUJIjabso/8JvQV8AzHGL
	 dCKlKYhDe3GfKOSC492zJ9Lhwo5+bkFnCfMzro0D2BDxAfikbaKqFEEb6hdxjsPYqjEZC
	 UWkh0ayBo3/nUMvmMXHQqdiTzp/EYYn0qUGDRfmVOk5rCgSJpw4AEWOgDXpzMBQ/gsQUt
	 wzFehiLtdag2X8ZvgViIAgTsGnlUNrxFukfv6TnkAdeQ1nP0SrL1k8W5evsZJQoo3O/cw
	 MgIeCgV2zdKYSEP0f1+GYp9DXJEKXN5PfgF/UC496ZpHAO3xKpuYkYM+F+pvyGfcRPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B664D606A32A;
	Tue, 10 Nov 2026 08:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B664D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8DxztLy3PJqwiAeAA--.20886S3;
	Tue, 10 Nov 2026 16:59:30 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxa87t3PJqCXQzAA--.20943S3;
	Tue, 10 Nov 2026 16:59:27 +0800 (CST)
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
Subject: [PATCH v3 5/6] efi/libstub: Enable direct sysfb_primary_display access on LoongArch
Date: Tue, 10 Nov 2026 16:57:28 +0800
Message-Id: <20261110085729.2628009-2-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxa87t3PJqCXQzAA--.20943S3
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj9xXoW7GF1fCFW5GrWxCFykWFWxuFX_yoWkCFgEya
	s8urZrWr4j9ryYgr4UKrWfuas0qay0qw1kZF92yrW3tw4jgwn5Ww4kXwn7CF13AryvkrZ8
	A3WDCF9xAr48tosvyTuYvTs0mTUanT9S1TB71UUUUbUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbqAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JF0_JFyl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Wrv_ZF1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4U
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxFksUU
	UUU

From: wuqianhai <wuqianhai@loongson.cn>

alloc_primary_display() returns NULL on LoongArch when neither
CONFIG_EFI_EARLYCON nor CONFIG_SYSFB is enabled, so the EFI stub does not
populate the core kernel's sysfb_primary_display.  Allow LoongArch to link
directly to sysfb_primary_display, like x86, so the firmware framebuffer
information is always available.

Signed-off-by: wuqianhai <wuqianhai@loongson.cn>
---
 drivers/firmware/efi/libstub/efi-stub-entry.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index efa3ab8ad1c6..2ac22720675c 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -20,6 +20,7 @@ struct sysfb_display_info *alloc_primary_display(void)
 		return __alloc_primary_display();
 
 	if (IS_ENABLED(CONFIG_X86) ||
+	    IS_ENABLED(CONFIG_LOONGARCH) ||
 	    IS_ENABLED(CONFIG_EFI_EARLYCON) ||
 	    IS_ENABLED(CONFIG_SYSFB))
 		return kernel_image_addr(&sysfb_primary_display);
-- 
2.34.1

