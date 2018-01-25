From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/4] efi/arm64: marshall runtime services arguments via buffer in TTBR0
Date: Thu, 25 Jan 2018 10:31:30 +0000
Message-ID: <20180125103131.19168-4-ard.biesheuvel@linaro.org>
References: <20180125103131.19168-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125103131.19168-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org
Cc: joakim.bech-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If we want to unmap the kernel while executing UEFI runtime services,
we need to ensure that all arguments passed to those services are
valid during that time, and this includes pointer arguments to
string buffers and other data. So we have to do the rather tedious
job of replacing each generic runtime wrapper with one that takes the
above into account.

Fortunately, UEFI runtime services are not reentrant, so we can create
a static buffer with fields for each runtime service, and a separate
buffer for get/set_variable. This does limit variable names to 1024
characters and the variables themselves to 64 KB, but this should not
be a limitation in practice.

Note that capsule update is omitted for now - this will be addressed
in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/Kconfig           |   1 -
 arch/arm64/include/asm/efi.h |   5 +
 arch/arm64/kernel/efi.c      | 475 +++++++++++++++++++-
 3 files changed, 479 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index de83b53c7e19..f2224566cc75 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1196,7 +1196,6 @@ config EFI
 	select LIBFDT
 	select UCS2_STRING
 	select EFI_PARAMS_FROM_FDT
-	select EFI_RUNTIME_WRAPPERS
 	select EFI_STUB
 	select EFI_ARMSTUB
 	default y
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index b9b09a734719..b96bc4836c37 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -165,4 +165,9 @@ int __init efi_allocate_runtime_regions(struct mm_struct *mm);
 #define EFI_CODE_BASE		0x200000
 #define EFI_CODE_SIZE		PAGE_SIZE
 
+#define EFI_VARBUFFER_BASE	0x210000
+#define EFI_VARBUFFER_SIZE	SZ_64K
+
+#define EFI_DATA_BASE		0x220000
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 68c920b2f4f0..cd23c20fba39 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -11,9 +11,15 @@
  *
  */
 
+#define pr_fmt(fmt)	"efi: " fmt
+
+#include <linux/bug.h>
 #include <linux/efi.h>
 #include <linux/init.h>
-
+#include <linux/irqflags.h>
+#include <linux/mutex.h>
+#include <linux/semaphore.h>
+#include <linux/stringify.h>
 #include <asm/efi.h>
 
 /*
@@ -136,6 +142,63 @@ bool on_efi_stack(unsigned long sp)
 	return sp >= EFI_STACK_BASE && sp < (EFI_STACK_BASE + EFI_STACK_SIZE);
 }
 
+#define MAX_CAPSULES	16
+#define MAX_VARNAME_LEN	1024
+
+#define EFI_ADDR(arg)	(&((typeof(__efi_rt_marshall_data)*)EFI_DATA_BASE)->arg)
+#define EFI_DATA(arg)	(__efi_rt_marshall_data.arg)
+
+static union {
+	struct {
+		efi_time_t	tm;
+		efi_time_cap_t	tc;
+	} get_time;
+
+	struct {
+		efi_time_t	tm;
+	} set_time;
+
+	struct {
+		efi_bool_t	enabled;
+		efi_bool_t	pending;
+		efi_time_t	tm;
+	} get_wakeup_time;
+
+	struct {
+		efi_char16_t	name[MAX_VARNAME_LEN];
+		efi_guid_t	vendor;
+		u32		attr;
+		unsigned long	data_size;
+		void		*data;
+	} get_variable;
+
+	struct {
+		unsigned long	name_size;
+		efi_char16_t	name[MAX_VARNAME_LEN];
+		efi_guid_t	vendor;
+	} get_next_variable;
+
+	struct {
+		u64		storage_space;
+		u64		remaining_space;
+		u64		max_variable_size;
+	} query_variable_info;
+
+	struct {
+		u32		count;
+	} get_next_high_mono_count;
+
+	struct {
+		efi_capsule_header_t	capsules[MAX_CAPSULES];
+		efi_capsule_header_t	*capsule_headers[MAX_CAPSULES];
+		u64			max_size;
+		int			reset_type;
+	} query_capsule_caps;
+
+} __efi_rt_marshall_data __page_aligned_bss;
+
+static u8 __efi_rt_varbuffer[EFI_VARBUFFER_SIZE] __page_aligned_bss;
+
 int __init efi_allocate_runtime_regions(struct mm_struct *mm)
 {
 	static u8 stack[EFI_STACK_SIZE] __page_aligned_bss;
@@ -152,5 +215,415 @@ int __init efi_allocate_runtime_regions(struct mm_struct *mm)
 			   __pgprot(pgprot_val(PAGE_KERNEL_ROX) | PTE_NG),
 			   false);
 
+	/* map the marshall data struct */
+	create_pgd_mapping(mm, __pa_symbol(&__efi_rt_marshall_data),
+			   EFI_DATA_BASE, sizeof(__efi_rt_marshall_data),
+			   __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
+			   false);
+
+	/* map the varbuffer */
+	create_pgd_mapping(mm, __pa_symbol(__efi_rt_varbuffer),
+			   EFI_VARBUFFER_BASE, EFI_VARBUFFER_SIZE,
+			   __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
+			   false);
+
 	return 0;
 }
+
+/*
+ * Wrap around the new efi_call_virt_generic() macros so that the
+ * code doesn't get too cluttered:
+ */
+#define efi_call_virt(f, args...)   \
+	efi_call_virt_pointer(efi.systab->runtime, f, args)
+#define __efi_call_virt(f, args...) \
+	__efi_call_virt_pointer(efi.systab->runtime, f, args)
+
+void efi_call_virt_check_flags(unsigned long flags, const char *call)
+{
+	unsigned long cur_flags, mismatch;
+
+	local_save_flags(cur_flags);
+
+	mismatch = flags ^ cur_flags;
+	if (!WARN_ON_ONCE(mismatch & ARCH_EFI_IRQ_FLAGS_MASK))
+		return;
+
+	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_NOW_UNRELIABLE);
+	pr_err_ratelimited(FW_BUG "IRQ flags corrupted (0x%08lx=>0x%08lx) by EFI %s\n",
+			   flags, cur_flags, call);
+	local_irq_restore(flags);
+}
+
+static int strlen16(efi_char16_t const *name)
+{
+	int ret = 0;
+
+	while (*name++)
+		ret++;
+
+	return ret;
+}
+
+static DEFINE_SEMAPHORE(efi_runtime_lock);
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	efi_status_t status;
+
+	if (!tm)
+		return EFI_INVALID_PARAMETER;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+	status = efi_call_virt(get_time,
+			       EFI_ADDR(get_time.tm),
+			       tc ? EFI_ADDR(get_time.tc): NULL);
+
+	*tm = EFI_DATA(get_time.tm);
+	if (tc)
+		*tc = EFI_DATA(get_time.tc);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_set_time(efi_time_t *tm)
+{
+	efi_status_t status;
+
+	if (!tm)
+		return EFI_INVALID_PARAMETER;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	EFI_DATA(set_time.tm) = *tm;
+
+	status = efi_call_virt(set_time,
+			       EFI_ADDR(set_time.tm));
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
+					     efi_bool_t *pending,
+					     efi_time_t *tm)
+{
+	efi_status_t status;
+
+	if (!enabled || !pending || !tm)
+		return EFI_INVALID_PARAMETER;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+	status = efi_call_virt(get_wakeup_time,
+			       EFI_ADDR(get_wakeup_time.enabled),
+			       EFI_ADDR(get_wakeup_time.pending),
+			       EFI_ADDR(get_wakeup_time.tm));
+
+	*enabled = EFI_DATA(get_wakeup_time.enabled);
+	*pending = EFI_DATA(get_wakeup_time.pending);
+	*tm = EFI_DATA(get_wakeup_time.tm);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	efi_status_t status;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	EFI_DATA(set_time.tm) = *tm;
+
+	status = efi_call_virt(set_wakeup_time, enabled,
+			       EFI_ADDR(set_time.tm));
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_get_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size,
+					  void *data)
+{
+	efi_status_t status;
+	int l = strlen16(name) + 1;
+
+	if (!name || !vendor || !data_size)
+		return EFI_INVALID_PARAMETER;
+
+	if (*data_size > EFI_VARBUFFER_SIZE || l > MAX_VARNAME_LEN)
+		return EFI_NOT_READY;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	memcpy(EFI_DATA(get_variable.name), name, l * sizeof(efi_char16_t));
+	EFI_DATA(get_variable.vendor) = *vendor;
+	EFI_DATA(get_variable.data_size) = *data_size;
+
+	status = efi_call_virt(get_variable,
+			       EFI_ADDR(get_variable.name),
+			       EFI_ADDR(get_variable.vendor),
+			       attr ? EFI_ADDR(get_variable.attr) : NULL,
+			       EFI_ADDR(get_variable.data_size),
+			       data ? (void *)EFI_VARBUFFER_BASE : NULL);
+
+	if (attr)
+		*attr = EFI_DATA(get_variable.attr);
+	*data_size = EFI_DATA(get_variable.data_size);
+	if (data)
+		memcpy(data, __efi_rt_varbuffer, *data_size);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	efi_status_t status;
+
+	if (*name_size > MAX_VARNAME_LEN)
+		return EFI_NOT_READY;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	EFI_DATA(get_next_variable.name_size) = *name_size;
+	memcpy(EFI_DATA(get_next_variable.name), name, *name_size);
+	EFI_DATA(get_next_variable.vendor) = *vendor;
+
+	status = efi_call_virt(get_next_variable,
+			       EFI_ADDR(get_next_variable.name_size),
+			       EFI_ADDR(get_next_variable.name),
+			       EFI_ADDR(get_next_variable.vendor));
+
+	*name_size = EFI_DATA(get_next_variable.name_size);
+	memcpy(name, EFI_DATA(get_next_variable.name), *name_size);
+	*vendor = EFI_DATA(get_next_variable.vendor);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_set_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 attr,
+					  unsigned long data_size,
+					  void *data)
+{
+	efi_status_t status;
+	int l = strlen16(name) + 1;
+
+	if (!name || !vendor)
+		return EFI_INVALID_PARAMETER;
+
+	if (data_size > EFI_VARBUFFER_SIZE || l > MAX_VARNAME_LEN)
+		return EFI_NOT_READY;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	memcpy(EFI_DATA(get_variable.name), name, l * sizeof(efi_char16_t));
+	EFI_DATA(get_variable.vendor) = *vendor;
+	if (data)
+		memcpy(__efi_rt_varbuffer, data, data_size);
+
+	status = efi_call_virt(set_variable,
+			       EFI_ADDR(get_variable.name),
+			       EFI_ADDR(get_variable.vendor),
+			       attr,
+			       data_size,
+			       data ? (void *)EFI_VARBUFFER_BASE : NULL);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t
+virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
+				  u32 attr, unsigned long data_size,
+				  void *data)
+{
+	efi_status_t status;
+	int l = strlen16(name) + 1;
+
+	if (!name || !vendor)
+		return EFI_INVALID_PARAMETER;
+
+	if (data_size > EFI_VARBUFFER_SIZE || l > MAX_VARNAME_LEN)
+		return EFI_NOT_READY;
+
+	if (down_trylock(&efi_runtime_lock))
+		return EFI_NOT_READY;
+
+	memcpy(EFI_DATA(get_variable.name), name, l * sizeof(efi_char16_t));
+	EFI_DATA(get_variable.vendor) = *vendor;
+	if (data)
+		memcpy(__efi_rt_varbuffer, data, data_size);
+
+	status = efi_call_virt(set_variable,
+			       EFI_ADDR(get_variable.name),
+			       EFI_ADDR(get_variable.vendor),
+			       attr,
+			       data_size,
+			       data ? (void *)EFI_VARBUFFER_BASE : NULL);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+
+static efi_status_t virt_efi_query_variable_info(u32 attr,
+						 u64 *storage_space,
+						 u64 *remaining_space,
+						 u64 *max_variable_size)
+{
+	efi_status_t status;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	status = efi_call_virt(query_variable_info,
+			       attr,
+			       EFI_ADDR(query_variable_info.storage_space),
+			       EFI_ADDR(query_variable_info.remaining_space),
+			       EFI_ADDR(query_variable_info.max_variable_size));
+
+	*storage_space	= EFI_DATA(query_variable_info.storage_space);
+	*remaining_space = EFI_DATA(query_variable_info.remaining_space);
+	*max_variable_size = EFI_DATA(query_variable_info.max_variable_size);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t
+virt_efi_query_variable_info_nonblocking(u32 attr,
+					 u64 *storage_space,
+					 u64 *remaining_space,
+					 u64 *max_variable_size)
+{
+	efi_status_t status;
+
+	if (down_trylock(&efi_runtime_lock))
+		return EFI_NOT_READY;
+
+	status = efi_call_virt(query_variable_info,
+			       attr,
+			       EFI_ADDR(query_variable_info.storage_space),
+			       EFI_ADDR(query_variable_info.remaining_space),
+			       EFI_ADDR(query_variable_info.max_variable_size));
+
+	*storage_space	= EFI_DATA(query_variable_info.storage_space);
+	*remaining_space = EFI_DATA(query_variable_info.remaining_space);
+	*max_variable_size = EFI_DATA(query_variable_info.max_variable_size);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
+{
+	efi_status_t status;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+	status = efi_call_virt(get_next_high_mono_count,
+			       EFI_ADDR(get_next_high_mono_count.count));
+
+	*count = EFI_DATA(get_next_high_mono_count.count);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+static void virt_efi_reset_system(int reset_type,
+				  efi_status_t status,
+				  unsigned long data_size,
+				  efi_char16_t *data)
+{
+	/* we don't use 'data' in the kernel */
+	pr_warn("efi_reset_system: ignoring 'data' argument\n");
+
+	if (down_interruptible(&efi_runtime_lock)) {
+		pr_warn("failed to invoke the reset_system() runtime service:\n"
+			"could not get exclusive access to the firmware\n");
+		return;
+	}
+	__efi_call_virt(reset_system, reset_type, status, 0, NULL);
+	up(&efi_runtime_lock);
+}
+
+static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
+					    unsigned long count,
+					    unsigned long sg_list)
+{
+//	efi_status_t status;
+
+	return EFI_NOT_READY;
+
+//	if (down_interruptible(&efi_runtime_lock))
+//		return EFI_ABORTED;
+//	status = efi_call_virt(update_capsule, capsules, count, sg_list);
+//	up(&efi_runtime_lock);
+//	return status;
+}
+
+static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+						unsigned long count,
+						u64 *max_size,
+						int *reset_type)
+{
+	efi_status_t status;
+	int i;
+
+	if (count > MAX_CAPSULES)
+		return EFI_NOT_READY;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	for (i = 0; i < count; i++) {
+		EFI_DATA(query_capsule_caps.capsules[i]) = *capsules[i];
+		EFI_DATA(query_capsule_caps.capsule_headers[i]) =
+				EFI_ADDR(query_capsule_caps.capsules[i]);
+	}
+
+	status = efi_call_virt(query_capsule_caps,
+			       EFI_ADDR(query_capsule_caps.capsule_headers),
+			       count,
+			       EFI_ADDR(query_capsule_caps.max_size),
+			       EFI_ADDR(query_capsule_caps.reset_type));
+
+	*max_size = EFI_DATA(query_capsule_caps.max_size);
+	*reset_type = EFI_DATA(query_capsule_caps.reset_type);
+
+	up(&efi_runtime_lock);
+	return status;
+}
+
+void efi_native_runtime_setup(void)
+{
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.set_variable_nonblocking = virt_efi_set_variable_nonblocking;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.query_variable_info_nonblocking = virt_efi_query_variable_info_nonblocking;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+}
-- 
2.11.0
