From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 27/29] x86/efi: Use kmalloc_array() in efi_call_phys_prolog()
Date: Fri,  9 Sep 2016 16:18:49 +0100
Message-ID: <20160909151851.27577-28-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Markus Elfring <elfring@users.sourceforge.net>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Julia Lawall <julia.lawall@lip6.fr>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus reuse the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index e1ca71259468..d65cdadaa6b6 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -85,7 +85,7 @@ pgd_t * __init efi_call_phys_prolog(void)
 	early_code_mapping_set_exec(1);
 
 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
-	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
+	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
 
 	for (pgd = 0; pgd < n_pgds; pgd++) {
 		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
-- 
2.9.3
