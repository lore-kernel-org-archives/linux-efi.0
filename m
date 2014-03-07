From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Fri, 7 Mar 2014 14:20:56 +0300
Message-ID: <20140307112055.GE2351@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

In phys_efi_get_time() we call efi_call_phys_prelog() with a spin_lock
so this allocation should be atomic.

Fixes: b8f2c21db390 ('efi, x86: Pass a proper identity mapping in efi_call_phys_prelog')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 0c2a234fef1e..f5adcadb381b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -90,7 +90,7 @@ void __init efi_call_phys_prelog(void)
 	local_irq_save(efi_flags);
 
 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
-	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
+	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_ATOMIC);
 
 	for (pgd = 0; pgd < n_pgds; pgd++) {
 		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
