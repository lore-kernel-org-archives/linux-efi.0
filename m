Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301104;
	b=yUPXAbawxnkNGiTln+WC/33uFZ+6suI2+UstAC6YHgy0vcC8jWMOISejM91lebD/3w5A
	 JXhlGyPa/o9fPmFhFgZsLZbZWrsJwYd1KgC0qP1vWr/PPcUuk37LVo88PUbxZjWi71rvZ
	 AiSzsuwQIzgsN2AwcrWhbf1MH96ounz7tiqrhu3idgLy+U1At3p+GUV4Vwp0fXenln7wG
	 88f7C0Y7+q9mx4szBOHJS6M/LPn06q9VyHe3CLvmfxBQmHE9/aehYyA2fNviqtV+klWLZ
	 WeoNpOHUlL1hhpWfFYJdWEh/w/jdFBJWAeOK+24YKB4Kl3SfyZDsCMNsxckpiB/LiXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301104;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=/BerbQ1LqYXVXHKPiWMSxnG91S54BmhY5Kon5U7NqOY=;
	b=KLTtasSdAHlpUK5/x8q+SQiBWRotaDTmw+WlOB5W7tRUwrm6+zYHqP0M35tkiqDmnd2P
	 vcm7wqLL8LN4tSFZwnlYCehMi3QZcXN3UhwWVPv+MGSA/4/7eVonhAClT7GEmsNFSBpTV
	 sAg49phonh0tPDJKL/bk6ELsBN2UeRAO6Q6L9AbL81fycoX++HZVCbUCbqOx3zXR70osn
	 IgtYGG+CP4VMlVoMqZj/fN/mlPNbCr3mVoBv6etmWxXtYnlaqeOLk0dt7AkNiWvuTRhFe
	 W78sbbi2oZnKjNjz7UwZogsKL9NkGtAfRWKuJw6vlxfGK/aqUzeyKjurBvR+4SRvblQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C8060A260F;
	Tue, 10 Nov 2026 08:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02C8060A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.172])
	by gateway (Coremail) with SMTP id _____8DxTtOt3PJqbyAeAA--.20620S3;
	Tue, 10 Nov 2026 16:58:21 +0800 (CST)
Received: from ubuntu.loongson.cn (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxrM6m3PJq83MzAA--.21431S2;
	Tue, 10 Nov 2026 16:58:14 +0800 (CST)
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
Subject: [PATCH v3 0/6] LoongArch: Identify the firmware/boot display device
Date: Tue, 10 Nov 2026 16:56:11 +0800
Message-Id: <20261110085617.2626835-1-wuqianhai@loongson.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261029033440.973077-1-wuqianhai@loongson.cn>
References: <20261029033440.973077-1-wuqianhai@loongson.cn>
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
X-CM-TRANSID:qMiowJBxrM6m3PJq83MzAA--.21431S2
X-CM-SenderInfo: 5zxtxtpqkdxqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoWxGw17XFy8uF1kWrW7Zw15ZFc_yoWruFWUpF
	4a9a9xJr4kWr4xGryIy34UXFn8Arn7G3yagFWakw18C345Jr18WF93t3yDXa4UJ393J3WF
	qF15Jw1xWF4DuagCm3ZEXasCq-sJn29KB7ZKAUJUUUUD529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
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
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4kucDUUUU

From: wuqianhai <wuqianhai@loongson.cn>

On LoongArch the kernel cannot reliably identify the display device that
was set up by the firmware and used for the boot console.  Two code paths
need this information and currently get it wrong:

  * The PCI VGA arbiter: vga_is_firmware_default() is compiled only on
    x86, so on LoongArch vga_default_device() may select the wrong GPU
    when several are present (for example an integrated display
    controller and a discrete card).

  * The framebuffer console: LoongArch does not implement
    video_is_primary_device(), so with
    CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y the console falls back to
    the generic stub that always returns false and binds to the first
    registered framebuffer instead of the boot display.

This series fixes both by publishing the firmware framebuffer information
through screen_info on LoongArch and consuming it the same way x86 does.

Patch 1 always defines and initializes sysfb_primary_display, and always
provides its EFI stub alias, instead of guarding them behind
SYSFB/EFI_EARLYCON.

Patch 2 refreshes screen_info from the PCI resource-assignment path after
the root-bus resources are assigned, so the framebuffer address is final
before the VGA arbiter and sysfb_init() consume it.  The call is placed
in the LoongArch PCI scan path because only LoongArch has this ordering:
acpi_init() relocates the BAR before vga_arb_device_init() runs.  On x86
the screen_info address is still accurate at that point.  If you would
rather have the helper called from the generic
pci_assign_unassigned_root_bus_resources() path so that all architectures
share it, that can be done instead.

Patch 3 removes pci_fixup_vgadev(), which overrides the VGA default
device to a discrete card after the arbiter has already selected the
firmware framebuffer device, so vga_default_device() consistently
reflects the boot display.

Patch 4 implements video_is_primary_device() for LoongArch by reusing the
VGA default device selected by the arbiter.

Patch 5 lets the EFI stub link directly to sysfb_primary_display on
LoongArch, so the firmware framebuffer information is always populated.

Patch 6 lets the VGA arbiter use CONFIG_SCREEN_INFO instead of an
architecture check and makes VGA_ARB select SCREEN_INFO on LoongArch.

Patches 1-4 are LoongArch-specific.  Patches 5 and 6 touch generic code
(the EFI stub and the PCI VGA arbiter) and are placed last so they can be
reviewed and merged separately.  Patches 3 and 4 depend on patch 6 taking
effect, but are ordered ahead of it only to group the LoongArch changes
together.

Changes since v2:
  - Split the screen_info refresh out of vga_arb_device_init() into the
    LoongArch PCI resource-assignment path (patch 2), following Thomas'
    suggestion to decouple it from sysfb_init().
  - Drop the per-architecture check in vgaarb.c and the select of SYSFB
    in favour of CONFIG_SCREEN_INFO and select SCREEN_INFO (patch 6).
  - Always define and initialize sysfb_primary_display, and let the EFI
    stub link to it directly (patches 1 and 5), instead of guarding them
    behind SYSFB/EFI_EARLYCON.
  - Remove the vga_default_device() override (patch 3) so the arbiter's
    firmware-framebuffer selection takes effect.
  - Implement video_is_primary_device() (patch 4) by reusing the arbiter's
    default device, so FRAMEBUFFER_CONSOLE_DETECT_PRIMARY works.

Build-tested on loongarch64 with GCC 8.3.0.

wuqianhai (6):
  LoongArch: efi: Provide sysfb_primary_display for screen_info users
  LoongArch/PCI: Refresh screen_info after resource assignment
  LoongArch/PCI: Remove vga default device override
  LoongArch: video: Implement primary framebuffer device detection
  efi/libstub: Enable direct sysfb_primary_display access on LoongArch
  PCI/VGA: Enable firmware default device detection on LoongArch

 arch/loongarch/Makefile                       |  3 ++
 arch/loongarch/include/asm/video.h            |  7 +++++
 arch/loongarch/kernel/efi.c                   |  5 +---
 arch/loongarch/kernel/image-vars.h            |  2 --
 arch/loongarch/pci/acpi.c                     |  4 +++
 arch/loongarch/pci/pci.c                      | 18 ------------
 arch/loongarch/video/Makefile                 |  3 ++
 arch/loongarch/video/video-common.c           | 29 +++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub-entry.c |  1 +
 drivers/pci/Kconfig                           |  2 +-
 drivers/pci/vgaarb.c                          |  2 +-
 11 files changed, 50 insertions(+), 26 deletions(-)
 create mode 100644 arch/loongarch/video/Makefile
 create mode 100644 arch/loongarch/video/video-common.c

-- 
2.34.1

