From: Waiman Long <longman@redhat.com>
Subject: [PATCH] x86/efi: Free efi_pgd with free_pages()
Date: Thu, 22 Mar 2018 15:18:53 -0400
Message-ID: <1521746333-19593-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Waiman Long <longman@redhat.com>
List-Id: linux-efi@vger.kernel.org

The efi_pgd is allocated as PGD_ALLOCATION_ORDER pages and so should
also be freed as PGD_ALLOCATION_ORDER pages with free_pages().

Fixes: d9e9a6418065 ("x86/mm/pti: Allocate a separate user PGD")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c310a82..f9cfbc0 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -227,7 +227,7 @@ int __init efi_alloc_page_tables(void)
 	if (!pud) {
 		if (CONFIG_PGTABLE_LEVELS > 4)
 			free_page((unsigned long) pgd_page_vaddr(*pgd));
-		free_page((unsigned long)efi_pgd);
+		free_pages((unsigned long)efi_pgd, PGD_ALLOCATION_ORDER);
 		return -ENOMEM;
 	}
 
-- 
1.8.3.1
