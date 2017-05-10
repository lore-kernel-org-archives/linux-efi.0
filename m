From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] x86/efi: Add EFI_PGT_DUMP support for x86_32, kexec and efi=old_map
Date: Wed, 10 May 2017 15:49:05 -0700
Message-ID: <1494456545-26300-1-git-send-email-sai.praneeth.prakhya@intel.com>
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
---
 arch/x86/platform/efi/efi.c    | 2 ++
 arch/x86/platform/efi/efi_32.c | 9 ++++++++-
 arch/x86/platform/efi/efi_64.c | 5 ++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 217dc166c649..a6d6cd8fe78a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -890,6 +890,8 @@ static void __init kexec_enter_virtual_mode(void)
 	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
 
+	efi_dump_pagetable();
+
 	/* clean DUMMY object */
 	efi_delete_dummy_variable();
 #endif
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
