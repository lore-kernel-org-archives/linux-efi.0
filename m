From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 03/40] x86/mm/pat: Document the (currently) EFI-only code path
Date: Mon, 25 Apr 2016 21:06:35 +0100
Message-ID: <1461614832-17633-4-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Linus Torvalds <torvalds@linux-foundation.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

It's not at all obvious that populate_pgd() and friends are only
executed when mapping EFI virtual memory regions or that no other
pageattr callers pass a ->pgd value.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 01be9ec3bf79..a1f0e1d0ddc2 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1125,8 +1125,14 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
 {
-	if (cpa->pgd)
+	if (cpa->pgd) {
+		/*
+		 * Right now, we only execute this code path when mapping
+		 * the EFI virtual memory map regions, no other users
+		 * provide a ->pgd value. This may change in the future.
+		 */
 		return populate_pgd(cpa, vaddr);
+	}
 
 	/*
 	 * Ignore all non primary paths.
-- 
2.7.3
