From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 09/10] arm64/efi: enable minimal UEFI Runtime Services
 for big endian
Date: Wed, 23 Jul 2014 19:52:32 +0200
Message-ID: <53CFF660.4000409@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>	<1405955785-13477-10-git-send-email-ard.biesheuvel@linaro.org>	<20140723093409.GB2714@leverpostej> <CAKv+Gu8DgAAoxb58K9dtQAKyt0zfRV5naAzMTi=7OLYD-ZZd9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8DgAAoxb58K9dtQAKyt0zfRV5naAzMTi=7OLYD-ZZd9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 07/23/2014 12:59 PM, Ard Biesheuvel wrote:
> On 23 July 2014 11:34, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> Hi Ard,
>>
>> This is certainly a neat feature, and I definitely want to be able to
>> boot BE kernels via UEFI.
>>
> 
> Good!
> 
>> However, I'm wary of calling EFI in a physical (i.e. idmap with dcaches
>> off) context. I'm not sure anyone else does that, and I'm not sure
>> whether that's going to work (both because of the cache maintenance
>> requirements and the expectations of a given UEFI implementation w.r.t.
>> memory cacheability).
>>
> 
> I have developed an alternate version in the mean time that switches
> to a LE idmap (so with D-cache enabled), but this is an imperfect
> solution as well, as (like in the MMU off case), the vector base
> virtual address cannot be resolved when the EE bit is cleared (as
> TTBR1 points to a BE page table) so any exception taken locks the
> machine hard. I am not sure if this can be solved in any way other
> than changing exception levels. Or install an alternate vector table
> for the duration of the runtime services call that flips the EE bit
> back, restores VBAR to its original address, and jumps into it. None
> of this is very sexy, though ...
> 
>> I'd hoped we'd be able to use a LE EL0 context to call the runtime
>> services in, but I'm not sure that's possible by the spec :(
>>
> 
> Nope, they should be called at the exception level UEFI was started in
> (as Leif tells me)
> 
>> As I understand it, we shouldn't need these runtime services to simply
>> boot a BE kernel.
>>
> 
> Well, the significance of the variable store related Runtime Services
> is that they are used by an installer (through efibootmgr) to program
> the kernel command line. Hence the choice for just these services in
> the minimal implementation.
> 

The below patch is an alternate approach with a LE id mapping in
efi_pg_dir. (Patch that sets it up omitted).

This dodges all the concerns related to caching, hopefully, as the LE id
mapping and the BE id mapping in idmap_pg_dir should agree on the memory
attributes of all common mappings.

This also addresses the FIQ and exception concerns, although I fully
realise that this is likely too controversial. Suggestions for less
controversial approaches are highly appreciated. As said, booting a BE
kernel is useful by itself, but without being able to use efibootmgr it
is a bit crippled.

-- 
Ard.


diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a34fd3b12e2b..2eeae5ae55b2 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -44,4 +44,6 @@ extern void efi_idmap_init(void);

 #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)

+extern int efi_be_runtime_setup(void);
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/efi-be-call.S
b/arch/arm64/kernel/efi-be-call.S
new file mode 100644
index 000000000000..8da53a225fab
--- /dev/null
+++ b/arch/arm64/kernel/efi-be-call.S
@@ -0,0 +1,129 @@
+
+#include <linux/linkage.h>
+
+	.macro	flush_tlb_all
+	dsb	ishst
+	tlbi	vmalle1is
+	dsb	ish
+	isb
+	.endm
+
+	.text
+	/*
+	 * Alternate vector table so we can trap exceptions while in LE mode
+	 * and make the world sane again before letting the kernel handle the
+	 * exception as usual. Clobbers x30.
+	 */
+	.align	12
+.Lvectors:
+	.irpc	i, 0123456789abcdef
+	.align	7
+	/* switch back to BE and temporarily disable MMU */
+	mrs	x30, sctlr_el1
+	bic	x30, x30, #1 << 0	// clear SCTLR.M
+	orr	x30, x30, #1 << 25	// set SCTLR.EE
+	msr	sctlr_el1, x30
+	isb
+
+	/* needed as TLBs are permitted to cache the EE bit */
+	flush_tlb_all
+
+	/* re-install BE idmap */
+	adrp	x30, idmap_pg_dir
+	msr	ttbr0_el1, x30
+	mrs	x30, sctlr_el1
+	orr	x30, x30, #1 << 0	// set SCTLR.M
+	msr	sctlr_el1, x30		// re-enable MMU
+	isb
+
+	/*
+	 * Use the virtual and physical addresses of 'vectors' to restore the
+	 * virtual offset of sp.
+	 */
+	adrp	x30, vectors
+	add	x30, x30, #:lo12:vectors
+	sub	sp, sp, x30
+	ldr	x30, =vectors
+	add	sp, sp, x30
+
+	/* reinstall vector table */
+	msr	vbar_el1, x30		// restore VBAR to 'vectors'
+	isb
+
+	add	x30, x30, #(0x\i * 0x80) // jump to real vector
+	ret
+	.endr
+
+ENTRY(efi_be_phys_call)
+	/*
+	 * Entered at physical address with 1:1 mapping enabled and interrupts
+	 * disabled.
+	 */
+	stp	x29, x30, [sp, #-48]!
+	mov	x29, sp
+	stp	x25, x26, [sp, #16]
+	stp	x27, x28, [sp, #32]
+
+	ldr	x8, =efi_be_phys_call	// virt address of this function
+	adr	x9, efi_be_phys_call	// phys address of this function
+	sub	x9, x8, x9		// calculate virt to phys offset in x9
+
+	/* get phys address of stack */
+	sub	sp, sp, x9
+
+	/* mask FIQs */
+	mrs	x25, daif
+	msr	daifset, #8
+
+	/* install alternate vector table */
+	mrs	x28, vbar_el1
+	adrp	x8, .Lvectors
+	msr	vbar_el1, x8
+
+	/* switch to LE and temporarily disable MMU */
+	mrs	x27, sctlr_el1
+	bic	x8, x27, #1 << 25	// clear SCTLR.EE
+	bic	x9, x8, #1 << 0		// clear SCTLR.M
+	msr	sctlr_el1, x9
+	isb
+
+	/* needed as TLBs are permitted to cache the EE bit */
+	flush_tlb_all
+
+	/* install LE idmap */
+	adrp	x9, efi_pg_dir
+	msr	ttbr0_el1, x9
+	msr	sctlr_el1, x8		// re-enable MMU
+	isb
+
+	/* restore inputs but rotated by 1 register */
+	mov	x6, x0
+	mov	x0, x1
+	mov	x1, x2
+	mov	x2, x3
+	mov	x3, x4
+	mov	x4, x5
+	blr	x6
+
+	/* switch back to BE and temporarily disable MMU */
+	bic	x9, x27, #1 << 0	// clear SCTLR.M
+	msr	sctlr_el1, x9
+	isb
+
+	/* needed as TLBs are permitted to cache the EE bit */
+	flush_tlb_all
+
+	/* re-install BE idmap */
+	adrp	x8, idmap_pg_dir
+	msr	ttbr0_el1, x8
+	msr	sctlr_el1, x27		// re-enable MMU
+	msr	vbar_el1, x28		// restore VBAR
+	msr	daif, x25
+	isb
+
+	mov	sp, x29
+	ldp	x25, x26, [sp, #16]
+	ldp	x27, x28, [sp, #32]
+	ldp	x29, x30, [sp], #48
+	ret
+ENDPROC(efi_be_phys_call)
diff --git a/arch/arm64/kernel/efi-be-runtime.c
b/arch/arm64/kernel/efi-be-runtime.c
new file mode 100644
index 000000000000..abcc275481bd
--- /dev/null
+++ b/arch/arm64/kernel/efi-be-runtime.c
@@ -0,0 +1,105 @@
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
+			     attr, data_size, virt_to_phys(data));
+	efi_be_call_post(flags);
+	return status;
+}
+
+int efi_be_runtime_setup(void)
+{
+	extern u8 efi_be_phys_call[];
+
+	runtime = ioremap_cache(le64_to_cpu(efi.systab->runtime),
+				sizeof(efi_runtime_services_t));
+	if (!runtime) {
+		pr_err("Failed to set up BE wrappers for UEFI Runtime Services!\n");
+		return -EFAULT;
+	}
+
+	efi_be_call = (void *)virt_to_phys(efi_be_phys_call);
+
+	efi.get_variable = efi_be_get_variable;
+	efi.get_next_variable = efi_be_get_next_variable;
+	efi.set_variable = efi_be_set_variable;
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index c65c6a50395d..3f28854e96a9 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -426,6 +426,20 @@ static int __init arm64_enter_virtual_mode(void)

 	efi.memmap = &memmap;

+	if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)) {
+		efi.systab = ioremap_cache(efi_system_table,
+					   sizeof(efi_system_table_t));
+		if (!efi.systab) {
+			pr_err("Failed to remap EFI system table!\n");
+			return -1;
+		}
+		free_boot_services();
+		set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+		if (efi_be_runtime_setup() == 0)
+			set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return 0;
+	}
+
 	/* Map the runtime regions */
 	virtmap = kmalloc(mapsize, GFP_KERNEL);
 	if (!virtmap) {
