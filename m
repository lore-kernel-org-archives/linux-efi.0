From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 43/76] x86/sysfb_efi: Fix valid BAR address range check
Date: Thu, 19 May 2016 11:08:05 +0200
Message-ID: <edfad738252de419a11a332131f8b31c776c9326.1463648873.git.jslaby@suse.cz>
References: <c4ec97c341630e22e546c1a628a3664f17f7ffc8.1463648873.git.jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c4ec97c341630e22e546c1a628a3664f17f7ffc8.1463648873.git.jslaby@suse.cz>
In-Reply-To: <cover.1463648873.git.jslaby@suse.cz>
References: <cover.1463648873.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wang YanQing <udknight@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Herrmann <dh.herrmann@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-efi@vger.kernel.org

From: Wang YanQing <udknight@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

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
