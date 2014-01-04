From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/2] efi: style neatening
Date: Fri,  3 Jan 2014 16:08:48 -0800
Message-ID: <e0a37bd26a7cd9cee5cd5bb2341e6617783ce069.1388793978.git.joe@perches.com>
References: <cover.1388793978.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1388793978.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Coalesce formats and remove spaces before tabs.
Move __initdata after the variable declaration.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/platform/efi/efi.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ef7b7b4..69c6133 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -67,7 +67,7 @@ static efi_system_table_t efi_systab __initdata;
 
 unsigned long x86_efi_facility;
 
-static __initdata efi_config_table_type_t arch_tables[] = {
+static efi_config_table_type_t arch_tables[] __initdata = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
 #endif
@@ -83,7 +83,7 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
-static bool __initdata disable_runtime = false;
+static bool disable_runtime __initdata = false;
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
@@ -271,9 +271,9 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
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
@@ -291,9 +291,8 @@ int efi_set_rtc_mmss(const struct timespec *now)
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
 
@@ -409,8 +408,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -442,9 +440,8 @@ void __init efi_reserve_boot_services(void)
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
@@ -566,8 +563,7 @@ static int __init efi_systab_init(void *phys)
 		return -EINVAL;
 	}
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		pr_err("Warning: System table version "
-		       "%d.%02d, expected 1.00 or greater!\n",
+		pr_err("Warning: System table version %d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
@@ -857,8 +853,8 @@ void __init efi_enter_virtual_mode(void)
 		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
-		pr_alert("Unable to switch EFI into virtual mode "
-			 "(status=%lx)!\n", status);
+		pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
+			 status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty
