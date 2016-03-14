From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/mm/pat: Fix boot crash when 1GB pages are not supported by cpu
Date: Mon, 14 Mar 2016 10:33:01 +0000
Message-ID: <1457951581-27353-2-git-send-email-matt@codeblueprint.co.uk>
References: <1457951581-27353-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457951581-27353-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Peter Zijlstra <peterz@infradead.org>, Raphael Hertzog <hertzog@debian.org>, Roger Shimizu <rogershimizu@gmail.com>, Scott Ashcroft <scott.ashcroft@talk21.com>
List-Id: linux-efi@vger.kernel.org

Scott reports that with the new separate EFI page tables he's seeing
the following error on boot, caused by setting reserved bits in the
page table structures (fault code is PF_RSVD | PF_PROT),

  swapper/0: Corrupted page table at address 17b102020
  PGD 17b0e5063 PUD 1400000e3
  Bad pagetable: 0009 [#1] SMP

On first inspection the PUD is using a 1GB page size (_PAGE_PSE) and
looks fine but that's only true if support for 1GB PUD pages
("pdpe1gb") is present in the cpu.

Scott's Intel Celeron N2820 does not have that feature and so the
_PAGE_PSE bit is reserved. Fix this issue by making the 1GB mapping
code in conditional on "cpu_has_gbpages".

This issue didn't come up in the past because the required mapping for
the faulting address (0x17b102020) will already have been setup by the
kernel in early boot before we got to efi_map_regions(), but we no
longer use the standard kernel page tables during EFI calls.

Reported-by: Scott Ashcroft <scott.ashcroft@talk21.com>
Tested-by: Scott Ashcroft <scott.ashcroft@talk21.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raphael Hertzog <hertzog@debian.org>
Cc: Roger Shimizu <rogershimizu@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 14c38ae80409..fcf8e290740a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1055,7 +1055,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
-	while (end - start >= PUD_SIZE) {
+	while (cpu_has_gbpages && end - start >= PUD_SIZE) {
 		set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
 				   massage_pgprot(pud_pgprot)));
 
-- 
2.6.2
