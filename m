From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v6 9/9] arch/x86: Remove efi_set_rtc_mmss()
Date: Fri, 20 Jun 2014 23:29:28 +0200
Message-ID: <1403299768-9955-10-git-send-email-daniel.kiper@oracle.com>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: mjg59@srcf.ucam.org, jeremy@goop.org, matt.fleming@intel.com, ian.campbell@citrix.com, andrew.cooper3@citrix.com, stefano.stabellini@eu.citrix.com, mingo@redhat.com, david.vrabel@citrix.com, jbeulich@suse.com, hpa@zytor.com, boris.ostrovsky@oracle.com, tglx@linutronix.de, eshelton@pobox.com
List-Id: linux-efi@vger.kernel.org

efi_set_rtc_mmss() is never used to set RTC due to bugs found
on many EFI platforms. It is set directly by mach_set_rtc_mmss().
Hence, remove unused efi_set_rtc_mmss() function.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
v6 - suggestions/fixes:
   - remove efi_set_rtc_mmss() instead of commenting out it
     (suggested by Stefano Stabellini, Juergen Gross,
     H. Peter Anvin and Matt Fleming).
---
 arch/x86/platform/efi/efi.c |   36 ------------------------------------
 include/linux/efi.h         |    1 -
 2 files changed, 37 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index da15df9..d569eea 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -244,42 +244,6 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
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
 void efi_get_time(struct timespec *now)
 {
 	efi_status_t status;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 713a4f1..322366b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -870,7 +870,6 @@ extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
-extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
-- 
1.7.10.4
