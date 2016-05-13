From: Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to 3.12-stable] x86/sysfb_efi: Fix valid BAR address range check
Date: Fri, 13 May 2016 15:09:58 +0200
Message-ID: <1463145007-20409-13-git-send-email-jslaby@suse.cz>
References: <1463145007-20409-1-git-send-email-jslaby@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1463145007-20409-1-git-send-email-jslaby@suse.cz>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Wang YanQing <udknight@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Herrmann <dh.herrmann@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-efi@vger.kernel.org

From: Wang YanQing <udknight@gmail.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

commit c10fcb14c7afd6688c7b197a814358fecf244222 upstream.

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
[ Rewrote changelog. ]
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Peter Jones <pjones@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/1462454061-21561-2-git-send-email-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.8.2
