From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/sysfb_efi: Fix valid BAR address range check
Date: Thu,  5 May 2016 14:14:21 +0100
Message-ID: <1462454061-21561-2-git-send-email-matt@codeblueprint.co.uk>
References: <1462454061-21561-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1462454061-21561-1-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Wang YanQing <udknight@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, David Herrmann <dh.herrmann@gmail.com>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
List-Id: linux-efi@vger.kernel.org

From: Wang YanQing <udknight@gmail.com>

The code for checking whether a BAR address range is valid will break
out of the loop when a start address of 0x0 is encountered.

This behaviour is wrong since by breaking out of the loop we may miss
the BAR that describes the EFI frame buffer in a later iteration.

Because of this bug I can't use video=efifb: boot parameter to get
efifb on my new ThinkPad E550 for my old linux system hard disk with
3.10 kernel. In 3.10, efifb is the only choice due to DRM/I915 not
supporting the GPU.

This patch also add a trivial optimization to break out after we find
the frame buffer address range without testing later BARs.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Reviewed-by: Peter Jones <pjones@redhat.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: <stable@vger.kernel.org>
[ Rewrote changelog. ]
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/kernel/sysfb_efi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index b285d4e8c68e..5da924bbf0a0 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -106,14 +106,24 @@ static int __init efifb_set_system(const struct dmi_system_id *id)
 					continue;
 				for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 					resource_size_t start, end;
+					unsigned long flags;
+
+					flags = pci_resource_flags(dev, i);
+					if (!(flags & IORESOURCE_MEM))
+						continue;
+
+					if (flags & IORESOURCE_UNSET)
+						continue;
+
+					if (pci_resource_len(dev, i) == 0)
+						continue;
 
 					start = pci_resource_start(dev, i);
-					if (start == 0)
-						break;
 					end = pci_resource_end(dev, i);
 					if (screen_info.lfb_base >= start &&
 					    screen_info.lfb_base < end) {
 						found_bar = 1;
+						break;
 					}
 				}
 			}
-- 
2.7.3
