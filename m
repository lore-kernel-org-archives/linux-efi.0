From: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [3.19.y-ckt stable] Patch "x86/sysfb_efi: Fix valid BAR address range check" has been added to the 3.19.y-ckt tree
Date: Mon,  9 May 2016 17:03:43 -0700
Message-ID: <1462838623-30345-1-git-send-email-kamal@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, kernel-team-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    x86/sysfb_efi: Fix valid BAR address range check

to the linux-3.19.y-queue branch of the 3.19.y-ckt extended stable tree 
which can be found at:

    https://git.launchpad.net/~canonical-kernel/linux/+git/linux-stable-ckt/log/?h=linux-3.19.y-queue

This patch is scheduled to be released in version 3.19.8-ckt21.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.19.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From 1dc34f46c56dc5548d48405d0b591d6e06c247f6 Mon Sep 17 00:00:00 2001
From: Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, 5 May 2016 14:14:21 +0100
Subject: x86/sysfb_efi: Fix valid BAR address range check

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

Signed-off-by: Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
[ Rewrote changelog. ]
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Reviewed-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1462454061-21561-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 arch/x86/kernel/sysfb_efi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index b285d4e..5da924b 100644
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
2.7.4
