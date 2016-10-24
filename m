From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [tip:x86/asm] x86/mm/64: Enable vmapped stacks
 (CONFIG_HAVE_ARCH_VMAP_STACK=y)
Date: Mon, 24 Oct 2016 14:09:31 +0100
Message-ID: <20161024130931.GC20387@codeblueprint.co.uk>
References: <c88f3e2920b18e6cc621d772a04a62c06869037e.1470907718.git.luto@kernel.org>
 <tip-e37e43a497d5a8b7c0cc1736d56986f432c394c9@git.kernel.org>
 <20161021123243.GC27807@codeblueprint.co.uk>
 <CALCETrUqhRg_G1fia=oFKrsxpF_YobEJLs1KpA3UF2Pnt6-u+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUqhRg_G1fia=oFKrsxpF_YobEJLs1KpA3UF2Pnt6-u+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 21 Oct, at 05:18:30PM, Andy Lutomirski wrote:
> 
> This is asking for trouble if any of the variable length parameters
> are on the stack.  How about adding a "size_t size" parameter and
> doing:
> 
> if (!va) {
>   return 0;
> } else if (virt_addr_valid(va)) {
>   return virt_to_phys(va);
> } else {
>   /* A fully aligned variable on the stack is guaranteed not to cross
> a page boundary. */
>   WARN_ON(!IS_ALIGNED((uintptr_t)va, size) || size > PAGE_SIZE);
>   return slow_virt_to_phys(va);
> }

Ah, good catch. Something like this?

---

>From d2c17f46686076677da3bf04caa2f69d654f8d8a Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Date: Thu, 20 Oct 2016 22:17:21 +0100
Subject: [PATCH] x86/efi: Prevent mixed mode boot corruption with
 CONFIG_VMAP_STACK

Booting an EFI mixed mode kernel has been crashing since commit:

  e37e43a497d5 ("x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)")

The user-visible effect in my test setup was the kernel being unable
to find the root file system ramdisk. This was likely caused by silent
memory or page table corruption.

Enabling CONFIG_DEBUG_VIRTUAL immediately flagged the thunking code as
abusing virt_to_phys() because it was passing addresses that were not
part of the kernel direct mapping.

Use the slow version instead, which correctly handles all memory
regions by performing a page table walk.

Suggested-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 79 +++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 24 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 58b0f801f66f..010544293dda 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/slab.h>
+#include <linux/ucs2_string.h>
 
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -211,11 +212,36 @@ void efi_sync_low_kernel_mappings(void)
 	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
 }
 
+/*
+ * Wrapper for slow_virt_to_phys() that handles NULL addresses.
+ */
+static inline phys_addr_t
+virt_to_phys_or_null_size(void *va, unsigned long size)
+{
+	if (!va)
+		return 0;
+
+	if (virt_addr_valid(va))
+		return virt_to_phys(va);
+
+	/*
+	 * A fully aligned variable on the stack is guaranteed not to
+	 * cross a page bounary.
+	 */
+	WARN_ON(!IS_ALIGNED((unsigned long)va, size) || size > PAGE_SIZE);
+
+	return slow_virt_to_phys(va);
+}
+
+#define virt_to_phys_or_null(addr)				\
+	virt_to_phys_or_null_size((addr), sizeof(*(addr)))
+
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long pfn, text;
 	struct page *page;
 	unsigned npages;
+	void *addr;
 	pgd_t *pgd;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
@@ -251,7 +277,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (!page)
 		panic("Unable to allocate EFI runtime stack < 4GB\n");
 
-	efi_scratch.phys_stack = virt_to_phys(page_address(page));
+	addr = page_address(page);
+	efi_scratch.phys_stack = virt_to_phys_or_null_size(addr, PAGE_SIZE);
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
 	npages = (_etext - _text) >> PAGE_SHIFT;
@@ -494,8 +521,8 @@ static efi_status_t efi_thunk_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 
 	spin_lock(&rtc_lock);
 
-	phys_tm = virt_to_phys(tm);
-	phys_tc = virt_to_phys(tc);
+	phys_tm = virt_to_phys_or_null(tm);
+	phys_tc = virt_to_phys_or_null(tc);
 
 	status = efi_thunk(get_time, phys_tm, phys_tc);
 
@@ -511,7 +538,7 @@ static efi_status_t efi_thunk_set_time(efi_time_t *tm)
 
 	spin_lock(&rtc_lock);
 
-	phys_tm = virt_to_phys(tm);
+	phys_tm = virt_to_phys_or_null(tm);
 
 	status = efi_thunk(set_time, phys_tm);
 
@@ -529,9 +556,9 @@ efi_thunk_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
 
 	spin_lock(&rtc_lock);
 
-	phys_enabled = virt_to_phys(enabled);
-	phys_pending = virt_to_phys(pending);
-	phys_tm = virt_to_phys(tm);
+	phys_enabled = virt_to_phys_or_null(enabled);
+	phys_pending = virt_to_phys_or_null(pending);
+	phys_tm = virt_to_phys_or_null(tm);
 
 	status = efi_thunk(get_wakeup_time, phys_enabled,
 			     phys_pending, phys_tm);
@@ -549,7 +576,7 @@ efi_thunk_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 
 	spin_lock(&rtc_lock);
 
-	phys_tm = virt_to_phys(tm);
+	phys_tm = virt_to_phys_or_null(tm);
 
 	status = efi_thunk(set_wakeup_time, enabled, phys_tm);
 
@@ -558,6 +585,10 @@ efi_thunk_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	return status;
 }
 
+static unsigned long efi_name_size(efi_char16_t *name)
+{
+	return ucs2_strsize(name, EFI_VAR_NAME_LEN) + 1;
+}
 
 static efi_status_t
 efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
@@ -567,11 +598,11 @@ efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 	u32 phys_name, phys_vendor, phys_attr;
 	u32 phys_data_size, phys_data;
 
-	phys_data_size = virt_to_phys(data_size);
-	phys_vendor = virt_to_phys(vendor);
-	phys_name = virt_to_phys(name);
-	phys_attr = virt_to_phys(attr);
-	phys_data = virt_to_phys(data);
+	phys_data_size = virt_to_phys_or_null(data_size);
+	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
+	phys_attr = virt_to_phys_or_null(attr);
+	phys_data = virt_to_phys_or_null_size(data, *data_size);
 
 	status = efi_thunk(get_variable, phys_name, phys_vendor,
 			   phys_attr, phys_data_size, phys_data);
@@ -586,9 +617,9 @@ efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 
-	phys_name = virt_to_phys(name);
-	phys_vendor = virt_to_phys(vendor);
-	phys_data = virt_to_phys(data);
+	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
+	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_data = virt_to_phys_or_null_size(data, data_size);
 
 	/* If data_size is > sizeof(u32) we've got problems */
 	status = efi_thunk(set_variable, phys_name, phys_vendor,
@@ -605,9 +636,9 @@ efi_thunk_get_next_variable(unsigned long *name_size,
 	efi_status_t status;
 	u32 phys_name_size, phys_name, phys_vendor;
 
-	phys_name_size = virt_to_phys(name_size);
-	phys_vendor = virt_to_phys(vendor);
-	phys_name = virt_to_phys(name);
+	phys_name_size = virt_to_phys_or_null(name_size);
+	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_name = virt_to_phys_or_null_size(name, *name_size);
 
 	status = efi_thunk(get_next_variable, phys_name_size,
 			   phys_name, phys_vendor);
@@ -621,7 +652,7 @@ efi_thunk_get_next_high_mono_count(u32 *count)
 	efi_status_t status;
 	u32 phys_count;
 
-	phys_count = virt_to_phys(count);
+	phys_count = virt_to_phys_or_null(count);
 	status = efi_thunk(get_next_high_mono_count, phys_count);
 
 	return status;
@@ -633,7 +664,7 @@ efi_thunk_reset_system(int reset_type, efi_status_t status,
 {
 	u32 phys_data;
 
-	phys_data = virt_to_phys(data);
+	phys_data = virt_to_phys_or_null_size(data, data_size);
 
 	efi_thunk(reset_system, reset_type, status, data_size, phys_data);
 }
@@ -661,9 +692,9 @@ efi_thunk_query_variable_info(u32 attr, u64 *storage_space,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	phys_storage = virt_to_phys(storage_space);
-	phys_remaining = virt_to_phys(remaining_space);
-	phys_max = virt_to_phys(max_variable_size);
+	phys_storage = virt_to_phys_or_null(storage_space);
+	phys_remaining = virt_to_phys_or_null(remaining_space);
+	phys_max = virt_to_phys_or_null(max_variable_size);
 
 	status = efi_thunk(query_variable_info, attr, phys_storage,
 			   phys_remaining, phys_max);
-- 
2.10.0
