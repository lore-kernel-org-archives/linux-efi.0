From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Sun, 9 Mar 2014 16:20:20 +0000
Message-ID: <20140309161946.GA10262@console-pimps.org>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140307122103.GM4774@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Jan Beulich <JBeulich@suse.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 07 Mar, at 03:25:37PM, Dan Carpenter wrote:
> 
> You're on your own for fixing the complicated stuff like layering
> violations. I just do static checker stuff and sed fixes.  ;)

Thanks for the patch Dan. Nice catch.

But I'm wondering if we can simply delete phys_efi_get_time() to avoid
the whole problem of doing GFP_KERNEL allocations under a spinlock.

In fact, the whole EFI time stuff is looking a bit crusty.

I only see two direct users of efi.get_time() outside of arch,

  drivers/char/efirtc.c
  drivers/rtc/rtc-efi.c

which are both "depends on IA64". For x86, all other callers are inside
arch/x86/platform/efi/efi.c,

  efi_set_rtc_mmss()
  efi_get_time()

neither of which have any callers - it all appears to be dead code. The
diff stat of deleting all this dead code isn't too bad either,

 arch/x86/platform/efi/efi.c    | 151 ++---------------------------------------
 arch/x86/platform/efi/efi_64.c |  90 ------------------------
 2 files changed, 5 insertions(+), 236 deletions(-)

Thoughts?

---

>From c17c2275d1969e99f4a6427293af1a533f2e5242 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Sun, 9 Mar 2014 14:18:10 +0000
Subject: [PATCH] x86/efi: Remove EFI time functions

Dan reported that phys_efi_get_time() is doing kmalloc(..., GFP_KERNEL)
under a spinlock which is very clearly a bug. However, the EFI time
functions have been dead code for x86 since commit 04bf9ba720fc ("x86,
efi: Don't use (U)EFI time services on 32 bit").

We have tried to use the time functions before, with little success
because of various bugs in the runtime implementations, e.g. see commit
bacef661acdb ("x86-64/efi: Use EFI to deal with platform wall clock")
and commit bd52276fa1d4 ("x86-64/efi: Use EFI to deal with platform wall
clock (again)").

Let's rip them out. If we find a need for them in the future, and if the
runtime implementations of the time services improve considerably, the
code can be put back.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c    | 151 ++---------------------------------------
 arch/x86/platform/efi/efi_64.c |  90 ------------------------
 2 files changed, 5 insertions(+), 236 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 43e7cf6c6111..fc1a8f639f7b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -40,14 +40,12 @@
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
-#include <linux/time.h>
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
-#include <asm/time.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
@@ -104,54 +102,6 @@ static int __init setup_storage_paranoia(char *arg)
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 
-static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(get_time, tm, tc);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_set_time(efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt1(set_time, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
-					     efi_bool_t *pending,
-					     efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt3(get_wakeup_time,
-				enabled, pending, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(set_wakeup_time,
-				enabled, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
 static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  efi_guid_t *vendor,
 					  u32 *attr,
@@ -194,11 +144,6 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 			      remaining_space, max_variable_size);
 }
 
-static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
-{
-	return efi_call_virt1(get_next_high_mono_count, count);
-}
-
 static void virt_efi_reset_system(int reset_type,
 				  efi_status_t status,
 				  unsigned long data_size,
@@ -246,72 +191,6 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
-					     efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
-				virt_to_phys(tc));
-	efi_call_phys_epilog();
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-int efi_set_rtc_mmss(const struct timespec *now)
-{
-	unsigned long nowtime = now->tv_sec;
-	efi_status_t	status;
-	efi_time_t	eft;
-	efi_time_cap_t	cap;
-	struct rtc_time	tm;
-
-	status = efi.get_time(&eft, &cap);
-	if (status != EFI_SUCCESS) {
-		pr_err("Oops: efitime: can't read time!\n");
-		return -1;
-	}
-
-	rtc_time_to_tm(nowtime, &tm);
-	if (!rtc_valid_tm(&tm)) {
-		eft.year = tm.tm_year + 1900;
-		eft.month = tm.tm_mon + 1;
-		eft.day = tm.tm_mday;
-		eft.minute = tm.tm_min;
-		eft.second = tm.tm_sec;
-		eft.nanosecond = 0;
-	} else {
-		pr_err("%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
-		       __func__, nowtime);
-		return -1;
-	}
-
-	status = efi.set_time(&eft);
-	if (status != EFI_SUCCESS) {
-		pr_err("Oops: efitime: can't write time!\n");
-		return -1;
-	}
-	return 0;
-}
-
-void efi_get_time(struct timespec *now)
-{
-	efi_status_t status;
-	efi_time_t eft;
-	efi_time_cap_t cap;
-
-	status = efi.get_time(&eft, &cap);
-	if (status != EFI_SUCCESS)
-		pr_err("Oops: efitime: can't read time!\n");
-
-	now->tv_sec = mktime(eft.year, eft.month, eft.day, eft.hour,
-			     eft.minute, eft.second);
-	now->tv_nsec = 0;
-}
-
 /*
  * Tell the kernel about the EFI memory map.  This might include
  * more than the max 128 entries that can fit in the e820 legacy
@@ -588,20 +467,12 @@ static int __init efi_runtime_init32(void)
 	}
 
 	/*
-	 * We will only need *early* access to the following two
-	 * EFI runtime services before set_virtual_address_map
-	 * is invoked.
+	 * We will only need *early* access to the following EFI runtime
+	 * service before set_virtual_address_map is invoked.
 	 */
-	efi_phys.get_time = (efi_get_time_t *)
-			(unsigned long)runtime->get_time;
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	/*
-	 * Make efi_get_time can be called before entering
-	 * virtual mode.
-	 */
-	efi.get_time = phys_efi_get_time;
 	early_iounmap(runtime, sizeof(efi_runtime_services_32_t));
 
 	return 0;
@@ -619,20 +490,13 @@ static int __init efi_runtime_init64(void)
 	}
 
 	/*
-	 * We will only need *early* access to the following two
-	 * EFI runtime services before set_virtual_address_map
-	 * is invoked.
+	 * We will only need *early* access to the following EFI runtime
+	 * service before set_virtual_address_map is invoked.
 	 */
-	efi_phys.get_time = (efi_get_time_t *)
-			(unsigned long)runtime->get_time;
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	/*
-	 * Make efi_get_time can be called before entering
-	 * virtual mode.
-	 */
-	efi.get_time = phys_efi_get_time;
+
 	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
 
 	return 0;
@@ -880,14 +744,9 @@ void __init old_map_region(efi_memory_desc_t *md)
 
 static void native_runtime_setup(void)
 {
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
 	efi.get_variable = virt_efi_get_variable;
 	efi.get_next_variable = virt_efi_get_next_variable;
 	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.query_variable_info = virt_efi_query_variable_info;
 	efi.update_capsule = virt_efi_update_capsule;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 7e7f195aa5cf..468444157e3c 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -39,7 +39,6 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/realmode.h>
-#include <asm/time.h>
 
 static pgd_t *save_pgd __initdata;
 static unsigned long efi_flags __initdata;
@@ -389,78 +388,6 @@ efi_status_t efi_thunk_set_virtual_address_map(
 	return status;
 }
 
-static efi_status_t efi_thunk_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	efi_status_t status;
-	u32 phys_tm, phys_tc;
-
-	spin_lock(&rtc_lock);
-
-	phys_tm = virt_to_phys(tm);
-	phys_tc = virt_to_phys(tc);
-
-	status = efi_thunk(get_time, phys_tm, phys_tc);
-
-	spin_unlock(&rtc_lock);
-
-	return status;
-}
-
-static efi_status_t efi_thunk_set_time(efi_time_t *tm)
-{
-	efi_status_t status;
-	u32 phys_tm;
-
-	spin_lock(&rtc_lock);
-
-	phys_tm = virt_to_phys(tm);
-
-	status = efi_thunk(set_time, phys_tm);
-
-	spin_unlock(&rtc_lock);
-
-	return status;
-}
-
-static efi_status_t
-efi_thunk_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
-			  efi_time_t *tm)
-{
-	efi_status_t status;
-	u32 phys_enabled, phys_pending, phys_tm;
-
-	spin_lock(&rtc_lock);
-
-	phys_enabled = virt_to_phys(enabled);
-	phys_pending = virt_to_phys(pending);
-	phys_tm = virt_to_phys(tm);
-
-	status = efi_thunk(get_wakeup_time, phys_enabled,
-			     phys_pending, phys_tm);
-
-	spin_unlock(&rtc_lock);
-
-	return status;
-}
-
-static efi_status_t
-efi_thunk_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
-{
-	efi_status_t status;
-	u32 phys_tm;
-
-	spin_lock(&rtc_lock);
-
-	phys_tm = virt_to_phys(tm);
-
-	status = efi_thunk(set_wakeup_time, enabled, phys_tm);
-
-	spin_unlock(&rtc_lock);
-
-	return status;
-}
-
-
 static efi_status_t
 efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 		       u32 *attr, unsigned long *data_size, void *data)
@@ -517,18 +444,6 @@ efi_thunk_get_next_variable(unsigned long *name_size,
 	return status;
 }
 
-static efi_status_t
-efi_thunk_get_next_high_mono_count(u32 *count)
-{
-	efi_status_t status;
-	u32 phys_count;
-
-	phys_count = virt_to_phys(count);
-	status = efi_thunk(get_next_high_mono_count, phys_count);
-
-	return status;
-}
-
 static void
 efi_thunk_reset_system(int reset_type, efi_status_t status,
 		       unsigned long data_size, efi_char16_t *data)
@@ -588,14 +503,9 @@ efi_thunk_query_capsule_caps(efi_capsule_header_t **capsules,
 
 void efi_thunk_runtime_setup(void)
 {
-	efi.get_time = efi_thunk_get_time;
-	efi.set_time = efi_thunk_set_time;
-	efi.get_wakeup_time = efi_thunk_get_wakeup_time;
-	efi.set_wakeup_time = efi_thunk_set_wakeup_time;
 	efi.get_variable = efi_thunk_get_variable;
 	efi.get_next_variable = efi_thunk_get_next_variable;
 	efi.set_variable = efi_thunk_set_variable;
-	efi.get_next_high_mono_count = efi_thunk_get_next_high_mono_count;
 	efi.reset_system = efi_thunk_reset_system;
 	efi.query_variable_info = efi_thunk_query_variable_info;
 	efi.update_capsule = efi_thunk_update_capsule;
-- 
1.8.5.3

-- 
Matt Fleming, Intel Open Source Technology Center
