From: dyoung@redhat.com
Subject: efi: remove unused variables in __map_region
Date: Mon, 25 Nov 2013 16:47:00 +0800
Message-ID: <20131125084805.769680812@dhcp-16-126.nay.redhat.com>
References: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=01-remove-unused-var-in-map-region.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com, Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

variables size and end is useless in this function, thus remove them.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi_64.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- efi.orig/arch/x86/platform/efi/efi_64.c
+++ efi/arch/x86/platform/efi/efi_64.c
@@ -148,15 +148,11 @@ void efi_setup_page_tables(void)
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-	unsigned long pf = 0, size;
-	u64 end;
+	unsigned long pf = 0;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
 		pf |= _PAGE_PCD;
 
-	size = md->num_pages << PAGE_SHIFT;
-	end  = va + size;
-
 	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
 			   md->phys_addr, va);
