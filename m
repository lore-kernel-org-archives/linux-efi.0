From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 2/5] efi: Export arch_tables variable
Date: Wed, 26 Mar 2014 14:18:49 +0000
Message-ID: <20140326141849.GH24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-3-git-send-email-daniel.kiper@oracle.com>
 <5332E25F020000780000255A@nat28.tlf.novell.com>
 <20140326140800.GP3454@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140326140800.GP3454-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Mar, at 03:08:00PM, Daniel Kiper wrote:
> 
> Hmmm... I am not sure which approach is better. I saw that
> in many places declarations have annotations. Could you
> point me some docs which states (and explains) that this
> is wrong idea.

Note I've had the following patch from Joe queued up for weeks. It's in
the tip tree and will be sent to Linus during the merge window.

----

commit 9b7d204982cf
Author: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Jan 3 16:08:48 2014 -0800

    x86/efi: Style neatening
    
    Coalesce formats and remove spaces before tabs.
    Move __initdata after the variable declaration.
    
    Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
    Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dc1dd6d09dec..876dc5b9e4a3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -67,7 +67,7 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-static __initdata efi_config_table_type_t arch_tables[] = {
+static efi_config_table_type_t arch_tables[] __initdata = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
 #endif
@@ -76,7 +76,7 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 
 u64 efi_setup;		/* efi setup_data physical address */
 
-static bool __initdata disable_runtime = false;
+static bool disable_runtime __initdata = false;
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
@@ -263,9 +263,9 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 int efi_set_rtc_mmss(const struct timespec *now)
 {
 	unsigned long nowtime = now->tv_sec;
-	efi_status_t 	status;
-	efi_time_t 	eft;
-	efi_time_cap_t 	cap;
+	efi_status_t	status;
+	efi_time_t	eft;
+	efi_time_cap_t	cap;
 	struct rtc_time	tm;
 
 	status = efi.get_time(&eft, &cap);
@@ -283,9 +283,8 @@ int efi_set_rtc_mmss(const struct timespec *now)
 		eft.second = tm.tm_sec;
 		eft.nanosecond = 0;
 	} else {
-		printk(KERN_ERR
-		       "%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
-		       __FUNCTION__, nowtime);
+		pr_err("%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
+		       __func__, nowtime);
 		return -1;
 	}
 
@@ -401,8 +400,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -434,9 +432,8 @@ void __init efi_reserve_boot_services(void)
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
-			memblock_dbg("Could not reserve boot range "
-					"[0x%010llx-0x%010llx]\n",
-						start, start+size-1);
+			memblock_dbg("Could not reserve boot range [0x%010llx-0x%010llx]\n",
+				     start, start+size-1);
 		} else
 			memblock_reserve(start, size);
 	}
@@ -572,8 +569,7 @@ static int __init efi_systab_init(void *phys)
 		return -EINVAL;
 	}
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		pr_err("Warning: System table version "
-		       "%d.%02d, expected 1.00 or greater!\n",
+		pr_err("Warning: System table version %d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
-- 
Matt Fleming, Intel Open Source Technology Center
