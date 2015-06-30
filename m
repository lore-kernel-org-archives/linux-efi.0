From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] efi: Check for null efi kernel parameters
Date: Tue, 30 Jun 2015 16:13:33 -0700
Message-ID: <1435706013-20375-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Even though it is documented how to specify efi parameters,
it is possible to cause a kernel panic due to a NULL pointer
derreference if no efi parameter is passed. Thus, check whether
there is any parameters at all before parsing and warn the user.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 4 ++++
 drivers/firmware/efi/efi.c  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 51a689d..f60af0c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -948,6 +948,10 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 
 static int __init arch_parse_efi_cmdline(char *str)
 {
+	if (!str) {
+		pr_warn("need at least one option\n");
+		return -EINVAL;
+	}
 	if (parse_option_str(str, "old_map"))
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 	if (parse_option_str(str, "debug"))
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3c457db..c1b3fdb 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -58,6 +58,10 @@ bool efi_runtime_disabled(void)
 
 static int __init parse_efi_cmdline(char *str)
 {
+	if (!str) {
+		pr_warn("need at least one option\n");
+		return -EINVAL;
+	}
 	if (parse_option_str(str, "noruntime"))
 		disable_runtime = true;
 
-- 
1.9.1
