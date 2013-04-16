From: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/2] efi: Export efi_query_variable_store() for efivars.ko
Date: Tue, 16 Apr 2013 18:31:09 +0400
Message-ID: <1366122669-20898-2-git-send-email-vsu@altlinux.ru>
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
 <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366122669-20898-1-git-send-email-vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
"x86, efivars: firmware bug workarounds should be in platform code".

Signed-off-by: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4959e3f..4f364c7 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1144,3 +1144,4 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 
 	return EFI_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(efi_query_variable_store);
-- 
1.8.1.1
