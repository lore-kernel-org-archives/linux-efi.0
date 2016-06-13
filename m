From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 074/114] x86/sysfb_efi: Fix valid BAR address range check
Date: Mon, 13 Jun 2016 19:36:37 +0100
Message-ID: <lsq.1465842997.56340922@decadent.org.uk>
References: <lsq.1465842997.838358341@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1465842997.838358341@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, David Herrmann <dh.herrmann@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Wang YanQing <udknight@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

3.16.36-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/sysfb_efi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -106,14 +106,24 @@ static int __init efifb_set_system(const
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
