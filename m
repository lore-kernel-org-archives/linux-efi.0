From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] x86,efi: Check max_size only if it is non-zero.
Date: Wed, 10 Apr 2013 10:59:34 +0200
Message-ID: <1365584375-9372-1-git-send-email-richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt.fleming@intel.com
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.garrett@nebula.com, Richard Weinberger <richard@nod.at>
List-Id: linux-efi@vger.kernel.org

Some EFI implementations return always a MaximumVariableSize of 0,
check against max_size only if it is non-zero.
My Intel DQ67SW desktop board has such an implementation.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/platform/efi/efi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c89c245..3f96a48 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1018,7 +1018,12 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
+	if (!max_size && remaining_size > size)
+		printk_once(KERN_ERR FW_BUG "Broken EFI implementation"
+			    " is returning MaxVariableSize=0\n");
+
+	if (!storage_size || size > remaining_size ||
+	    (max_size && size > max_size) ||
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
-- 
1.8.1.4
