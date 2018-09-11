From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] x86/efi: Load fixmap GDT in efi_call_phys_epilog() before setting %cr3
Date: Tue, 11 Sep 2018 11:18:12 -0700
Message-ID: <1536689892-21538-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, Andy Lutomirski <luto@amacapital.net>, Joerg Roedel <jroedel@suse.de>
List-Id: linux-efi@vger.kernel.org

Commit eeb89e2bb1ac ("x86/efi: Load fixmap GDT in efi_call_phys_epilog()")
moved loading the fixmap in efi_call_phys_epilog() after load_cr3()
since it was assumed to be more logical.

Turns out this is incorrect: In efi_call_phys_prolog(), we load the gdt
with its physical address, and when we reload the %cr3 in _epilog from
initial_page_table to swapper_pg_dir again the gdt is no longer mapped.
This results in a triple fault if an interrupt occurs after load_cr3()
and before load_fixmap_gdt(0). Calling load_fixmap_gdt(0) first restores
the execution order prior to commit eeb89e2bb1ac and fixes the problem.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Joerg Roedel <jroedel@suse.de>
Fixes: eeb89e2bb1ac ("x86/efi: Load fixmap GDT in efi_call_phys_epilog()")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/x86/platform/efi/efi_32.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 05ca14222463..9959657127f4 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -85,10 +85,9 @@ pgd_t * __init efi_call_phys_prolog(void)
 
 void __init efi_call_phys_epilog(pgd_t *save_pgd)
 {
+	load_fixmap_gdt(0);
 	load_cr3(save_pgd);
 	__flush_tlb_all();
-
-	load_fixmap_gdt(0);
 }
 
 void __init efi_runtime_update_mappings(void)
-- 
2.7.4
