From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [tip:x86/asm] x86/mm/64: Enable vmapped stacks
 (CONFIG_HAVE_ARCH_VMAP_STACK=y)
Date: Fri, 21 Oct 2016 13:32:43 +0100
Message-ID: <20161021123243.GC27807@codeblueprint.co.uk>
References: <c88f3e2920b18e6cc621d772a04a62c06869037e.1470907718.git.luto@kernel.org>
 <tip-e37e43a497d5a8b7c0cc1736d56986f432c394c9@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <tip-e37e43a497d5a8b7c0cc1736d56986f432c394c9-Ckxz5ZWcFp/9qxiX1TGQuw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 24 Aug, at 06:03:04AM, tip-bot for Andy Lutomirski wrote:
> Commit-ID:  e37e43a497d5a8b7c0cc1736d56986f432c394c9
> Gitweb:     http://git.kernel.org/tip/e37e43a497d5a8b7c0cc1736d56986f432c394c9
> Author:     Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> AuthorDate: Thu, 11 Aug 2016 02:35:23 -0700
> Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CommitDate: Wed, 24 Aug 2016 12:11:42 +0200
> 
> x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)
> 
> This allows x86_64 kernels to enable vmapped stacks by setting
> HAVE_ARCH_VMAP_STACK=y - which enables the CONFIG_VMAP_STACK=y
> high level Kconfig option.
> 
> There are a couple of interesting bits:

This commit broke booting EFI mixed mode kernels. Here's what I've got
queued up to fix it.

---
>From acf11e55bfcef7a1dca7d1735f4a780e0cdb1c89 Mon Sep 17 00:00:00 2001
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
 arch/x86/platform/efi/efi_64.c | 59 +++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 58b0f801f66f..e3569a00885b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -211,6 +211,17 @@ void efi_sync_low_kernel_mappings(void)
 	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
 }
 
+/*
+ * Wrapper for slow_virt_to_phys() that handles NULL addresses.
+ */
+static inline phys_addr_t virt_to_phys_or_null(void *va)
+{
+	if (!va)
+		return 0;
+
+	return slow_virt_to_phys(va);
+}
+
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long pfn, text;
@@ -251,7 +262,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (!page)
 		panic("Unable to allocate EFI runtime stack < 4GB\n");
 
-	efi_scratch.phys_stack = virt_to_phys(page_address(page));
+	efi_scratch.phys_stack = virt_to_phys_or_null(page_address(page));
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
 	npages = (_etext - _text) >> PAGE_SHIFT;
@@ -494,8 +505,8 @@ static efi_status_t efi_thunk_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 
 	spin_lock(&rtc_lock);
 
-	phys_tm = virt_to_phys(tm);
-	phys_tc = virt_to_phys(tc);
+	phys_tm = virt_to_phys_or_null(tm);
+	phys_tc = virt_to_phys_or_null(tc);
 
 	status = efi_thunk(get_time, phys_tm, phys_tc);
 
@@ -511,7 +522,7 @@ static efi_status_t efi_thunk_set_time(efi_time_t *tm)
 
 	spin_lock(&rtc_lock);
 
-	phys_tm = virt_to_phys(tm);
+	phys_tm = virt_to_phys_or_null(tm);
 
 	status = efi_thunk(set_time, phys_tm);
 
@@ -529,9 +540,9 @@ efi_thunk_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
 
 	spin_lock(&rtc_lock);
 
-	phys_enabled = virt_to_phys(enabled);
-	phys_pending = virt_to_phys(pending);
-	phys_tm = virt_to_phys(tm);
+	phys_enabled = virt_to_phys_or_null(enabled);
+	phys_pending = virt_to_phys_or_null(pending);
+	phys_tm = virt_to_phys_or_null(tm);
 
 	status = efi_thunk(get_wakeup_time, phys_enabled,
 			     phys_pending, phys_tm);
@@ -549,7 +560,7 @@ efi_thunk_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 
 	spin_lock(&rtc_lock);
 
-	phys_tm = virt_to_phys(tm);
+	phys_tm = virt_to_phys_or_null(tm);
 
 	status = efi_thunk(set_wakeup_time, enabled, phys_tm);
 
@@ -567,11 +578,11 @@ efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 	u32 phys_name, phys_vendor, phys_attr;
 	u32 phys_data_size, phys_data;
 
-	phys_data_size = virt_to_phys(data_size);
-	phys_vendor = virt_to_phys(vendor);
-	phys_name = virt_to_phys(name);
-	phys_attr = virt_to_phys(attr);
-	phys_data = virt_to_phys(data);
+	phys_data_size = virt_to_phys_or_null(data_size);
+	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_name = virt_to_phys_or_null(name);
+	phys_attr = virt_to_phys_or_null(attr);
+	phys_data = virt_to_phys_or_null(data);
 
 	status = efi_thunk(get_variable, phys_name, phys_vendor,
 			   phys_attr, phys_data_size, phys_data);
@@ -586,9 +597,9 @@ efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 
-	phys_name = virt_to_phys(name);
-	phys_vendor = virt_to_phys(vendor);
-	phys_data = virt_to_phys(data);
+	phys_name = virt_to_phys_or_null(name);
+	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_data = virt_to_phys_or_null(data);
 
 	/* If data_size is > sizeof(u32) we've got problems */
 	status = efi_thunk(set_variable, phys_name, phys_vendor,
@@ -605,9 +616,9 @@ efi_thunk_get_next_variable(unsigned long *name_size,
 	efi_status_t status;
 	u32 phys_name_size, phys_name, phys_vendor;
 
-	phys_name_size = virt_to_phys(name_size);
-	phys_vendor = virt_to_phys(vendor);
-	phys_name = virt_to_phys(name);
+	phys_name_size = virt_to_phys_or_null(name_size);
+	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_name = virt_to_phys_or_null(name);
 
 	status = efi_thunk(get_next_variable, phys_name_size,
 			   phys_name, phys_vendor);
@@ -621,7 +632,7 @@ efi_thunk_get_next_high_mono_count(u32 *count)
 	efi_status_t status;
 	u32 phys_count;
 
-	phys_count = virt_to_phys(count);
+	phys_count = virt_to_phys_or_null(count);
 	status = efi_thunk(get_next_high_mono_count, phys_count);
 
 	return status;
@@ -633,7 +644,7 @@ efi_thunk_reset_system(int reset_type, efi_status_t status,
 {
 	u32 phys_data;
 
-	phys_data = virt_to_phys(data);
+	phys_data = virt_to_phys_or_null(data);
 
 	efi_thunk(reset_system, reset_type, status, data_size, phys_data);
 }
@@ -661,9 +672,9 @@ efi_thunk_query_variable_info(u32 attr, u64 *storage_space,
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
