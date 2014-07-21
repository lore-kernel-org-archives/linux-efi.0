From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 09/10] arm64/efi: enable minimal UEFI Runtime Services for big endian
Date: Mon, 21 Jul 2014 17:16:24 +0200
Message-ID: <1405955785-13477-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405955785-13477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This enables the UEFI Runtime Services needed to manipulate the
non-volatile variable store when running under a BE kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h       |   2 +
 arch/arm64/kernel/efi-be-call.S    |  55 ++++++++++++++++++++
 arch/arm64/kernel/efi-be-runtime.c | 104 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/efi.c            |  15 ++++++
 4 files changed, 176 insertions(+)
 create mode 100644 arch/arm64/kernel/efi-be-call.S
 create mode 100644 arch/arm64/kernel/efi-be-runtime.c

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a34fd3b12e2b..44e642b6ab61 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -44,4 +44,6 @@ extern void efi_idmap_init(void);
 
 #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
 
+extern void efi_be_runtime_setup(void);
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/efi-be-call.S b/arch/arm64/kernel/efi-be-call.S
new file mode 100644
index 000000000000..24c92a4c352b
--- /dev/null
+++ b/arch/arm64/kernel/efi-be-call.S
@@ -0,0 +1,55 @@
+
+#include <linux/linkage.h>
+
+	.text
+	.align		3
+ENTRY(efi_be_phys_call)
+	/*
+	 * Entered at physical address with 1:1 mapping enabled.
+	 */
+	stp	x29, x30, [sp, #-96]!
+	mov	x29, sp
+	str	x27, [sp, #16]
+
+	ldr	x8, =efi_be_phys_call	// virt address of this function
+	adr	x9, efi_be_phys_call	// phys address of this function
+	sub	x9, x8, x9		// calculate virt to phys offset in x9
+
+	/* preserve all inputs */
+	stp	x0, x1, [sp, #32]
+	stp	x2, x3, [sp, #48]
+	stp	x4, x5, [sp, #64]
+	stp	x6, x7, [sp, #80]
+
+	/* get phys address of stack */
+	sub	sp, sp, x9
+
+	/* switch to LE, disable MMU and D-cache but leave I-cache enabled */
+	mrs	x27, sctlr_el1
+	bic	x8, x27, #1 << 2	// clear SCTLR.C
+	msr	sctlr_el1, x8
+
+	bl	flush_cache_all
+
+	/* restore inputs but rotated by 1 register */
+	ldp	x7, x0, [sp, #32]
+	ldp	x1, x2, [sp, #48]
+	ldp	x3, x4, [sp, #64]
+	ldp	x5, x6, [sp, #80]
+
+	bic	x8, x27, #1 << 2	// clear SCTLR.C
+	bic	x8, x8, #1 << 0		// clear SCTLR.M
+	bic	x8, x8, #1 << 25	// clear SCTLR.EE
+	msr	sctlr_el1, x8
+	isb
+
+	blr	x7
+
+	/* switch back to BE and reenable MMU and D-cache */
+	msr	sctlr_el1, x27
+
+	mov	sp, x29
+	ldr	x27, [sp, #16]
+	ldp	x29, x30, [sp], #96
+	ret
+ENDPROC(efi_be_phys_call)
diff --git a/arch/arm64/kernel/efi-be-runtime.c b/arch/arm64/kernel/efi-be-runtime.c
new file mode 100644
index 000000000000..62e6c441b77b
--- /dev/null
+++ b/arch/arm64/kernel/efi-be-runtime.c
@@ -0,0 +1,104 @@
+
+#include <linux/efi.h>
+#include <linux/spinlock.h>
+#include <asm/efi.h>
+#include <asm/neon.h>
+#include <asm/tlbflush.h>
+
+static efi_runtime_services_t *runtime;
+static efi_status_t (*efi_be_call)(phys_addr_t func, ...);
+
+static DEFINE_SPINLOCK(efi_be_rt_lock);
+
+static unsigned long efi_be_call_pre(void)
+{
+	unsigned long flags;
+
+	kernel_neon_begin();
+	spin_lock_irqsave(&efi_be_rt_lock, flags);
+	cpu_switch_mm(idmap_pg_dir, &init_mm);
+	flush_tlb_all();
+	return flags;
+}
+
+static void efi_be_call_post(unsigned long flags)
+{
+	cpu_switch_mm(current, current->active_mm);
+	flush_tlb_all();
+	spin_unlock_irqrestore(&efi_be_rt_lock, flags);
+	kernel_neon_end();
+}
+
+static efi_status_t efi_be_get_variable(efi_char16_t *name,
+					efi_guid_t *vendor,
+					u32 *attr,
+					unsigned long *data_size,
+					void *data)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	*data_size = cpu_to_le64(*data_size);
+	flags = efi_be_call_pre();
+	status = efi_be_call(le64_to_cpu(runtime->get_variable),
+			     virt_to_phys(name), virt_to_phys(vendor),
+			     virt_to_phys(attr), virt_to_phys(data_size),
+			     virt_to_phys(data));
+	efi_be_call_post(flags);
+	*attr = le32_to_cpu(*attr);
+	*data_size = le64_to_cpu(*data_size);
+	return status;
+}
+
+static efi_status_t efi_be_get_next_variable(unsigned long *name_size,
+					     efi_char16_t *name,
+					     efi_guid_t *vendor)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	*name_size = cpu_to_le64(*name_size);
+	flags = efi_be_call_pre();
+	status = efi_be_call(le64_to_cpu(runtime->get_next_variable),
+			     virt_to_phys(name_size), virt_to_phys(name),
+			     virt_to_phys(vendor));
+	efi_be_call_post(flags);
+	*name_size = le64_to_cpu(*name_size);
+	return status;
+}
+
+static efi_status_t efi_be_set_variable(efi_char16_t *name,
+					efi_guid_t *vendor,
+					u32 attr,
+					unsigned long data_size,
+					void *data)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	flags = efi_be_call_pre();
+	status = efi_be_call(le64_to_cpu(runtime->set_variable),
+			     virt_to_phys(name), virt_to_phys(vendor),
+			     cpu_to_le32(attr), cpu_to_le64(data_size),
+			     virt_to_phys(data));
+	efi_be_call_post(flags);
+	return status;
+}
+
+void efi_be_runtime_setup(void)
+{
+	extern u8 efi_be_phys_call[];
+
+	runtime = ioremap_cache(le64_to_cpu(efi.systab->runtime),
+				sizeof(efi_runtime_services_t));
+	if (!runtime) {
+		pr_err("Failed to set up BE wrappers for UEFI Runtime Services!\n");
+		return;
+	}
+
+	efi_be_call = (void *)virt_to_phys(efi_be_phys_call);
+
+	efi.get_variable = efi_be_get_variable;
+	efi.get_next_variable = efi_be_get_next_variable;
+	efi.set_variable = efi_be_set_variable;
+}
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 96df58824189..21e98810c5dd 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -406,6 +406,21 @@ static int __init arm64_enter_virtual_mode(void)
 
 	efi.memmap = &memmap;
 
+	if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)) {
+		efi.systab = ioremap_cache(efi_system_table,
+					   sizeof(efi_system_table_t));
+		if (!efi.systab) {
+			pr_err("Failed to remap EFI system table!\n");
+			return -1;
+		}
+		free_boot_services();
+		efi_be_runtime_setup();
+
+		set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return 0;
+	}
+
 	/* Map the runtime regions */
 	virtmap = kmalloc(mapsize, GFP_KERNEL);
 	if (!virtmap) {
-- 
1.8.3.2
