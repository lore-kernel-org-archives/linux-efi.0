From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/11] x86/efi: Move efi_<reserve/free>_boot_services() to arch/x86
Date: Thu, 29 Nov 2018 18:12:25 +0100
Message-ID: <20181129171230.18699-7-ard.biesheuvel@linaro.org>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>

efi_<reserve/free>_boot_services() are x86 specific quirks and as such
should be in asm/efi.h, so move them from linux/efi.h. Also, call
efi_free_boot_services() from __efi_enter_virtual_mode() as it is x86
specific call and ideally shouldn't be part of init/main.c

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/efi.h  | 2 ++
 arch/x86/platform/efi/efi.c | 2 ++
 include/linux/efi.h         | 3 ---
 init/main.c                 | 4 ----
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index eea40d52ca78..d1e64ac80b9c 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -141,6 +141,8 @@ extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
 extern void efi_switch_mm(struct mm_struct *mm);
 extern void efi_recover_from_page_fault(unsigned long phys_addr);
+extern void efi_free_boot_services(void);
+extern void efi_reserve_boot_services(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7ae939e353cd..e1cb01a22fa8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -993,6 +993,8 @@ static void __init __efi_enter_virtual_mode(void)
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
+	efi_free_boot_services();
+
 	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 100ce4a4aff6..2b3b33c83b05 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1000,13 +1000,11 @@ extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec64 *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #ifdef CONFIG_X86
-extern void efi_free_boot_services(void);
 extern efi_status_t efi_query_variable_store(u32 attributes,
 					     unsigned long size,
 					     bool nonblocking);
 extern void efi_find_mirror(void);
 #else
-static inline void efi_free_boot_services(void) {}
 
 static inline efi_status_t efi_query_variable_store(u32 attributes,
 						    unsigned long size,
@@ -1046,7 +1044,6 @@ extern void efi_mem_reserve(phys_addr_t addr, u64 size);
 extern int efi_mem_reserve_persistent(phys_addr_t addr, u64 size);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params);
 extern struct kobject *efi_kobj;
 
diff --git a/init/main.c b/init/main.c
index ee147103ba1b..ccefcd8e855f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -737,10 +737,6 @@ asmlinkage __visible void __init start_kernel(void)
 	arch_post_acpi_subsys_init();
 	sfi_init_late();
 
-	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		efi_free_boot_services();
-	}
-
 	/* Do the rest non-__init'ed, we're now alive */
 	arch_call_rest_init();
 }
-- 
2.19.1
