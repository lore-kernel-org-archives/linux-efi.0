From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 2/3] efi: Set feature flags inside feature init functions
Date: Wed, 15 Jan 2014 14:28:55 +0000
Message-ID: <1389796136-23479-3-git-send-email-matt@console-pimps.org>
References: <1389796136-23479-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389796136-23479-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony-hKmkhVXvusEnkhFzW7PF62O9nC1t1/YaHZ5vskTnxNA@public.gmane.org, "Luck <tony.luck"@intel.com, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It makes more sense to set the feature flag in the success path of the
detection function than it does to rely on the caller doing it. Apart
from it being more logical to group the code and data together, it sets
a much better example for new EFI architectures.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 13 ++++++-------
 drivers/firmware/efi/efi.c  |  3 +++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 15cc68bc88f1..47a74c7837c5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -560,6 +560,8 @@ static int __init efi_systab_init(void *phys)
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
 	return 0;
 }
 
@@ -595,6 +597,8 @@ static int __init efi_runtime_init(void)
 	efi.get_time = phys_efi_get_time;
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
 	return 0;
 }
 
@@ -612,6 +616,8 @@ static int __init efi_memmap_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	set_bit(EFI_MEMMAP, &efi.flags);
+
 	return 0;
 }
 
@@ -638,8 +644,6 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
 	/*
 	 * Show what we know for posterity
 	 */
@@ -659,8 +663,6 @@ void __init efi_init(void)
 	if (efi_config_init(arch_tables))
 		return;
 
-	set_bit(EFI_CONFIG_TABLES, &efi.flags);
-
 	/*
 	 * Note: We currently don't support runtime services on an EFI
 	 * that doesn't match the kernel 32/64-bit mode.
@@ -671,14 +673,11 @@ void __init efi_init(void)
 	else {
 		if (disable_runtime || efi_runtime_init())
 			return;
-		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 	}
 
 	if (efi_memmap_init())
 		return;
 
-	set_bit(EFI_MEMMAP, &efi.flags);
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2e2fbdec0845..187bdd401fda 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -270,5 +270,8 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 	}
 	pr_cont("\n");
 	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+
+	set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
 	return 0;
 }
-- 
1.8.3.1
