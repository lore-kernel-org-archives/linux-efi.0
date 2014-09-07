From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH 1/4] x86/efi: Remove unused efi_call* macros
Date: Sun,  7 Sep 2014 19:42:14 +0200
Message-ID: <1410111737-5220-2-git-send-email-minipli@googlemail.com>
References: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410111737-5220-1-git-send-email-minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Complement commit 62fa6e69a436 ("x86/efi: Delete most of the efi_call*
macros") and delete the stub macros for the !CONFIG_EFI case, too. In
fact, there are no EFI calls in this case so we don't need a dummy for
efi_call() even.

Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 arch/x86/include/asm/efi.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 044a2fd3c5fe..8aee01536c6c 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -186,16 +186,6 @@ extern struct efi_config *efi_early;
 extern bool efi_reboot_required(void);
 
 #else
-/*
- * IF EFI is not configured, have the EFI calls return -ENOSYS.
- */
-#define efi_call0(_f)					(-ENOSYS)
-#define efi_call1(_f, _a1)				(-ENOSYS)
-#define efi_call2(_f, _a1, _a2)				(-ENOSYS)
-#define efi_call3(_f, _a1, _a2, _a3)			(-ENOSYS)
-#define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
-#define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
-#define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
 static inline bool efi_reboot_required(void)
 {
-- 
1.7.10.4
