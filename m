From: Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/efi: Load fixmap GDT in efi_call_phys_epilog()
Date: Fri, 31 Aug 2018 10:05:38 +0200
Message-ID: <1535702738-10971-1-git-send-email-joro@8bytes.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
List-Id: linux-efi@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When PTI is enabled on x86-32 the kernel uses the GDT mapped
in the fixmap for the simple reason that this address is
also mapped for user-space.

The efi_call_phys_prolog()/efi_call_phys_epilog() wrappers
change the GDT to call EFI runtime services and switch back
to the kernel GDT when they return. But the switch-back uses
the writable GDT, not the fixmap GDT.

When that happened and and the CPU returns to user-space it
switches to the user %cr3 and tries to restore user segment
registers. This fails because the writable GDT is not mapped
in the user page-table, and without a GDT the fault handlers
also can't be launched. The result is a triple fault and
reboot of the machine.

Fix that by restoring the GDT back to the fixmap GDT which
is also mapped in the user page-table.

Fixes: 7757d607c6b3 x86/pti: ('Allow CONFIG_PAGE_TABLE_ISOLATION for x86_32')
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/platform/efi/efi_32.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 324b9332..05ca142 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -85,14 +85,10 @@ pgd_t * __init efi_call_phys_prolog(void)
 
 void __init efi_call_phys_epilog(pgd_t *save_pgd)
 {
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (unsigned long)get_cpu_gdt_rw(0);
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-
 	load_cr3(save_pgd);
 	__flush_tlb_all();
+
+	load_fixmap_gdt(0);
 }
 
 void __init efi_runtime_update_mappings(void)
-- 
2.7.4
