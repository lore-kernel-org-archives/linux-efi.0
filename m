From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 5/6] yx86/efi: fixup faults from UEFI firmware
Date: Sat, 13 Sep 2014 11:36:15 -0700
Message-ID: <1410633376-8822-6-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Glenn P. Williamson" <glenn.p.williamson@intel.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

Buggy UEFI firmware implementations may try to access the
EFI_BOOT_SERVICES_* memory regions even after those regions have been
surrendered to the kernel (after calling ExitBootServices() on the
firmware). If such regions are not mapped, a page fault will be
generated. Fix that up.

We are sure that we will not have false positives as those memory regions
are reserved and the kernel cannot use them.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/mm/fault.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a241946..f084912 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
 #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
+#include <linux/efi.h>			/* fixup for buggy UEFI firmware*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -702,6 +703,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		return;
 
 	/*
+	 * Try to fixup faults caused by illegal access to BOOT_SERVICES_*
+	 * regions by UEFI firmware.
+	 */
+	if (efi_boot_services_fixup(address))
+		return;
+
+	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:
 	 */
-- 
1.9.1
