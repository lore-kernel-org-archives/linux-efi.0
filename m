From: Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: [PATCH] arch: x86: platform: efi: Disabling interrupt around kmalloc
Date: Tue, 3 Mar 2015 08:28:04 +0530
Message-ID: <20150303025804.GA24587@kt-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tapaswenipathak@gmail.com
List-Id: linux-efi@vger.kernel.org

Disabling interrupts around kmalloc() is less than ideal. Move it
after the kmalloc().

Found using Coccinelle.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Suggested-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 17e80d8..5d6af59 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -88,10 +88,10 @@ void __init efi_call_phys_prolog(void)
 		return;

 	early_code_mapping_set_exec(1);
-	local_irq_save(efi_flags);

 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
 	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
+	local_irq_save(efi_flags);

 	for (pgd = 0; pgd < n_pgds; pgd++) {
 		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
--
1.7.9.5
