From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] x86/efi: Preface all print statements with efi* tag
Date: Sun, 25 Oct 2015 10:26:35 +0000
Message-ID: <1445768795-5472-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The pr_*() calls in the x86 EFI code may or may not include a
subsystem tag, which makes it difficult to grep the kernel log for all
relevant EFI messages and leads users to miss important information.

Recently, a bug reporter provided all the EFI print messages from the
kernel log when trying to diagnose an issue but missed the following
statement because it wasn't prefixed with anything indicating it was
related to EFI,

  pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);

Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi-bgrt.c | 3 +++
 arch/x86/platform/efi/efi_64.c   | 2 ++
 arch/x86/platform/efi/quirks.c   | 4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index ea48449b2e63..9a52b5c4438f 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -10,6 +10,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a0ac0f9c307f..d347e854a5e4 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) "efi: " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/mm.h>
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380da65ff..6452070f3025 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) "efi: " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -256,7 +258,7 @@ void __init efi_apply_memmap_quirks(void)
 	 * services.
 	 */
 	if (!efi_runtime_supported()) {
-		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		pr_info("Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
 
-- 
2.6.0
