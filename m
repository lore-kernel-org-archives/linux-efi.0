From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 3/3] ia64/efi: Implement efi_enabled()
Date: Wed, 15 Jan 2014 14:28:56 +0000
Message-ID: <1389796136-23479-4-git-send-email-matt@console-pimps.org>
References: <1389796136-23479-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389796136-23479-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony-hKmkhVXvusEnkhFzW7PF62O9nC1t1/YaHZ5vskTnxNA@public.gmane.org, "Luck <tony.luck"@intel.com, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There's no good reason to keep efi_enabled() under CONFIG_X86 anymore,
since nothing about the implementation is specific to x86.

Set EFI feature flags in the ia64 boot path instead of claiming to
support all features. The old behaviour was actually buggy since
efi.memmap never points to a valid memory map, so we shouldn't be
claiming to support EFI_MEMMAP.

Fortunately, this bug was never triggered because EFI_MEMMAP isn't used
outside of arch/x86 currently, but that may not always be the case.

Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/ia64/kernel/efi.c | 7 +++++++
 include/linux/efi.h    | 8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index da5b462e6de6..741b99c1a0b1 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -477,6 +477,9 @@ efi_init (void)
 	char *cp, vendor[100] = "unknown";
 	int i;
 
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+
 	/*
 	 * It's too early to be able to use the standard kernel command line
 	 * support...
@@ -529,6 +532,8 @@ efi_init (void)
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
 	palo_phys      = EFI_INVALID_TABLE_ADDR;
 
 	if (efi_config_init(arch_tables) != 0)
@@ -657,6 +662,8 @@ efi_enter_virtual_mode (void)
 		return;
 	}
 
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
 	/*
 	 * Now that EFI is in virtual mode, we call the EFI functions more
 	 * efficiently:
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b7d4409ca32b..6b18adea5e56 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -656,8 +656,6 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
-
 /*
  * Test whether the above EFI_* bits are enabled.
  */
@@ -665,12 +663,6 @@ static inline bool efi_enabled(int feature)
 {
 	return test_bit(feature, &efi.flags) != 0;
 }
-# else
-static inline bool efi_enabled(int feature)
-{
-	return true;
-}
-# endif
 #else
 static inline bool efi_enabled(int feature)
 {
-- 
1.8.3.1
