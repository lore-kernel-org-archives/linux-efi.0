From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V4 1/3] x86/efi: Call efi_delete_dummy_variable() during efi subsystem initialization
Date: Fri, 25 May 2018 15:05:01 -0700
Message-ID: <1527285903-31799-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1527285903-31799-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527285903-31799-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Invoking efi_runtime_services() through efi_rts_wq (efi runtime
services workqueue) means all accesses to efi_runtime_services() should
be done after efi_rts_wq has been created. efi_delete_dummy_variable()
calls set_variable(), hence efi_delete_dummy_variable() should be called
after efi_rts_wq has been created.

Presently, efi_delete_dummy_variable() is called from
efi_enter_virtual_mode() which is early in the boot phase (efi_rts_wq
isn't created yet), so call efi_delete_dummy_variable() later in the
boot phase. Another and the most important reason for calling
efi_delete_dummy_variable() late in the boot process is, if called
before rest_init(), kernel prints stack trace with a warning "bad:
scheduling from the idle thread!". Hence, call from efisubsys_init()
which is called during rest_init().

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Naresh Bhat <naresh.bhat@linaro.org>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 arch/x86/include/asm/efi.h  | 1 -
 arch/x86/platform/efi/efi.c | 6 ------
 drivers/firmware/efi/efi.c  | 6 ++++++
 include/linux/efi.h         | 3 +++
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index cec5fae23eb3..0e61b771b93d 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -138,7 +138,6 @@ extern void __init efi_runtime_update_mappings(void);
 extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
-extern void efi_delete_dummy_variable(void);
 extern void efi_switch_mm(struct mm_struct *mm);
 
 struct efi_setup_data {
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 9061babfbc83..a3169d14583f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -893,9 +893,6 @@ static void __init kexec_enter_virtual_mode(void)
 
 	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
-
-	/* clean DUMMY object */
-	efi_delete_dummy_variable();
 #endif
 }
 
@@ -1015,9 +1012,6 @@ static void __init __efi_enter_virtual_mode(void)
 	 * necessary relocation fixups for the new virtual addresses.
 	 */
 	efi_runtime_update_mappings();
-
-	/* clean DUMMY object */
-	efi_delete_dummy_variable();
 }
 
 void __init efi_enter_virtual_mode(void)
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 232f4915223b..1176af664013 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -337,6 +337,12 @@ static int __init efisubsys_init(void)
 	if (!efi_enabled(EFI_BOOT))
 		return 0;
 
+	/*
+	 * Clean DUMMY object calls EFI Runtime Service, set_variable(), so
+	 * it should be invoked only after efi_rts_wq is ready.
+	 */
+	efi_delete_dummy_variable();
+
 	/* We register the efi directory at /sys/firmware/efi */
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3016d8c456bc..1b79939d0b1e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -994,6 +994,7 @@ extern efi_status_t efi_query_variable_store(u32 attributes,
 					     unsigned long size,
 					     bool nonblocking);
 extern void efi_find_mirror(void);
+extern void efi_delete_dummy_variable(void);
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
@@ -1004,6 +1005,8 @@ static inline efi_status_t efi_query_variable_store(u32 attributes,
 {
 	return EFI_SUCCESS;
 }
+
+static inline void efi_delete_dummy_variable(void) {}
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 
-- 
2.7.4
