From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] x86: efi: Replace GFP_ATOMIC with GFP_KERNEL in efi_query_variable_store
Date: Thu, 25 Jan 2018 10:29:46 +0800
Message-ID: <1516847386-5291-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-efi@vger.kernel.org

The function kzalloc here is not called in atomic context.
If nonblocking in efi_query_variable_store is true, 
namely it is in atomic context, efi_query_variable_store will return before
this kzalloc is called.
Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 arch/x86/platform/efi/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 8a99a2e..b6dcb52 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -177,7 +177,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
 		 * that by attempting to use more space than is available.
 		 */
 		unsigned long dummy_size = remaining_size + 1024;
-		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
+		void *dummy = kzalloc(dummy_size, GFP_KERNEL);
 
 		if (!dummy)
 			return EFI_OUT_OF_RESOURCES;
-- 
1.7.9.5
