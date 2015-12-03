From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Subject: [PATCH 2/2] x86: Fix error in kernel_map_pages_in_pgd() when
 booting with XD disabled
Date: Thu, 3 Dec 2015 23:58:36 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A0288E2E6@BPXM09GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

If either the eXecute Disable (XD) bit is set to disabled in uEFI
firmware or noexec=off option is given as kernel boot parameter, the
system comes up with the error message
  Error ident-mapping new memmap (0x13b0ac000)!
and EFI runtime service is unavailable.

This is because kernel_map_pages_in_pgd() checks __supported_pte_mask
and returns an error if _PAGE_NX is not available.  As a result,
efi_setup_page_tables() prints the error message and
__efi_enter_virtual_mode() clears the EFI_RUNTIME_SERVICES bit in
efi.flags.

This patch changes kernel_map_pages_in_pgd() to set up the pte without
_PAGE_NX if the nx capability is unavailable instead of returning an
error.

Signed-off-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
---
 arch/x86/mm/pageattr.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a3137a4..3417c26 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1951,10 +1951,7 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 		.flags = 0,
 	};
 
-	if (!(__supported_pte_mask & _PAGE_NX))
-		goto out;
-
-	if (!(page_flags & _PAGE_NX))
+	if ((__supported_pte_mask & _PAGE_NX) && !(page_flags & _PAGE_NX))
 		cpa.mask_clr = __pgprot(_PAGE_NX);
 
 	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
@@ -1962,7 +1959,6 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 	retval = __change_page_attr_set_clr(&cpa, 0);
 	__flush_tlb_all();
 
-out:
 	return retval;
 }
 
