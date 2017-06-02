From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 12/13] x86/efi: Add EFI_PGT_DUMP support for x86_32 and kexec
Date: Fri,  2 Jun 2017 13:52:06 +0000
Message-ID: <20170602135207.21708-13-ard.biesheuvel@linaro.org>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

EFI_PGT_DUMP, as the name suggests dumps efi page tables to dmesg during
kernel boot. This feature is very useful while debugging page
faults/null pointer dereferences to efi related addresses. Presently,
this feature is limited only to x86_64, so let's extend it to other efi
configurations like kexec kernel, efi=old_map and to x86_32 as well.
This doesn't effect normal boot path because this config option should
be used only for debug purposes.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi.c    | 3 ++-
 arch/x86/platform/efi/efi_32.c | 9 ++++++++-
 arch/x86/platform/efi/efi_64.c | 5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dc2da5e2c7e4..3cf8536e803b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1012,7 +1012,6 @@ static void __init __efi_enter_virtual_mode(void)
 	 * necessary relocation fixups for the new virtual addresses.
 	 */
 	efi_runtime_update_mappings();
-	efi_dump_pagetable();
 
 	/* clean DUMMY object */
 	efi_delete_dummy_variable();
@@ -1027,6 +1026,8 @@ void __init efi_enter_virtual_mode(void)
 		kexec_enter_virtual_mode();
 	else
 		__efi_enter_virtual_mode();
+
+	efi_dump_pagetable();
 }
 
 /*
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 403a987d06c7..fe18c5d32bf0 100644
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
index 6fbf6c47e603..0d8180811445 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -528,7 +528,10 @@ void __init efi_runtime_update_mappings(void)
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
2.9.3
