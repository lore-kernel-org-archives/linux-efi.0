From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2] x86/efi: Add EFI_PGT_DUMP support for x86_32, kexec
Date: Thu, 11 May 2017 12:20:33 -0700
Message-ID: <1494530433-19503-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

EFI_PGT_DUMP, as the name suggests dumps efi page tables to dmesg during
kernel boot. This feature is very useful while debugging page
faults/null pointer dereferences to efi related addresses. Presently,
this feature is limited only to x86_64, so let's extend it to other efi
configurations like kexec kernel, efi=old_map and to x86_32 as well.
This doesn't effect normal boot path because this config option should
be used only for debug purposes.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changes since v1:
1. Call efi_dump_pagetable() only once from efi_enter_virtual_mode() -
as suggested by Boris

---
 arch/x86/platform/efi/efi.c    | 3 ++-
 arch/x86/platform/efi/efi_32.c | 9 ++++++++-
 arch/x86/platform/efi/efi_64.c | 5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 217dc166c649..87835c97611f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1011,7 +1011,6 @@ static void __init __efi_enter_virtual_mode(void)
 	 * necessary relocation fixups for the new virtual addresses.
 	 */
 	efi_runtime_update_mappings();
-	efi_dump_pagetable();
 
 	/* clean DUMMY object */
 	efi_delete_dummy_variable();
@@ -1026,6 +1025,8 @@ void __init efi_enter_virtual_mode(void)
 		kexec_enter_virtual_mode();
 	else
 		__efi_enter_virtual_mode();
+
+	efi_dump_pagetable();
 }
 
 /*
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 9b1abcf6e7bb..9477653c78f8 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -44,7 +44,14 @@ int __init efi_alloc_page_tables(void)
 }
 
 void efi_sync_low_kernel_mappings(void) {}
-void __init efi_dump_pagetable(void) {}
+
+void __init efi_dump_pagetable(void)
+{
+#ifdef CONFIG_EFI_PGT_DUMP
+	ptdump_walk_pgd_level(NULL, swapper_pg_dir);
+#endif
+}
+
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	return 0;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 76e1cd6b74dd..3bde2589fdb9 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -510,7 +510,10 @@ void __init efi_runtime_update_mappings(void)
 void __init efi_dump_pagetable(void)
 {
 #ifdef CONFIG_EFI_PGT_DUMP
-	ptdump_walk_pgd_level(NULL, efi_pgd);
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		ptdump_walk_pgd_level(NULL, swapper_pg_dir);
+	else
+		ptdump_walk_pgd_level(NULL, efi_pgd);
 #endif
 }
 
-- 
2.1.4
