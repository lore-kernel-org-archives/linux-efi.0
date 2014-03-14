From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Fri, 14 Mar 2014 23:02:01 +0000
Message-ID: <20140314230201.GF5834@console-pimps.org>
References: <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
 <20140310073753.GA4658@gmail.com>
 <531D7BA80200007800122349@nat28.tlf.novell.com>
 <20140310075306.GB4939@gmail.com>
 <531D84670200007800122375@nat28.tlf.novell.com>
 <20140310104328.GG10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140310104328.GG10262@console-pimps.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>, kernel-janitors@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 10 Mar, at 10:43:28AM, Matt Fleming wrote:
> 
> I think we're all pretty much agreed that at the very least
> phys_efi_get_time() can go in the bin. Whatever the outcome of this
> thread that'll happen. The question is whether it makes sense to rip out
> all of the time stuff in one go.

OK, I'm chickening out of doing the full delete for v3.15. How about
something like this instead?

---

>From 697c512d44415794396773533715dff45785c585 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Thu, 13 Mar 2014 19:41:08 +0000
Subject: [PATCH] x86/efi: Rip out phys_efi_get_time()

Dan reported that phys_efi_get_time() is doing kmalloc(..., GFP_KERNEL)
under a spinlock which is very clearly a bug. Since phys_efi_get_time()
has no users let's just delete it instead of trying to fix it.

Note that since there are no users of phys_efi_get_time(), it is not
possible to actually trigger a GFP_KERNEL alloc under the spinlock.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 395decedfa2b..872214435e9d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -256,21 +256,6 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
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
 int efi_set_rtc_mmss(const struct timespec *now)
 {
 	unsigned long nowtime = now->tv_sec;
@@ -604,16 +589,9 @@ static int __init efi_runtime_init32(void)
 	 * EFI runtime services before set_virtual_address_map
 	 * is invoked.
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
@@ -635,16 +613,9 @@ static int __init efi_runtime_init64(void)
 	 * EFI runtime services before set_virtual_address_map
 	 * is invoked.
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
 	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
 
 	return 0;
-- 
1.8.5.3

-- 
Matt Fleming, Intel Open Source Technology Center
