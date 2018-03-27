From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.15 086/105] x86/efi: Free efi_pgd with free_pages()
Date: Tue, 27 Mar 2018 18:28:06 +0200
Message-ID: <20180327162803.520307492@linuxfoundation.org>
References: <20180327162757.813009222@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327162757.813009222@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

4.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit 06ace26f4e6fcf747e890a39193be811777a048a upstream.

The efi_pgd is allocated as PGD_ALLOCATION_ORDER pages and therefore must
also be freed as PGD_ALLOCATION_ORDER pages with free_pages().

Fixes: d9e9a6418065 ("x86/mm/pti: Allocate a separate user PGD")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1521746333-19593-1-git-send-email-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -228,7 +228,7 @@ int __init efi_alloc_page_tables(void)
 	if (!pud) {
 		if (CONFIG_PGTABLE_LEVELS > 4)
 			free_page((unsigned long) pgd_page_vaddr(*pgd));
-		free_page((unsigned long)efi_pgd);
+		free_pages((unsigned long)efi_pgd, PGD_ALLOCATION_ORDER);
 		return -ENOMEM;
 	}
 
