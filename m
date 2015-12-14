From: ard <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 5/7] efi: runtime-wrappers: remove out of date comment regarding in_nmi()
Date: Mon, 14 Dec 2015 11:40:29 +0100
Message-ID: <1450089631-26791-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1450089631-26791-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450089631-26791-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

This code is long gone, so remove the comment as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 26 --------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index e9f2867f0d91..311f415bff51 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -62,32 +62,6 @@
 static DEFINE_SPINLOCK(efi_runtime_lock);
 
 /*
- * Some runtime services calls can be reentrant under NMI, even if the table
- * above says they are not. (source: UEFI Specification v2.4A)
- *
- * Table 32. Functions that may be called after Machine Check, INIT and NMI
- * +----------------------------+------------------------------------------+
- * | Function			| Called after Machine Check, INIT and NMI |
- * +----------------------------+------------------------------------------+
- * | GetTime()			| Yes, even if previously busy.		   |
- * | GetVariable()		| Yes, even if previously busy		   |
- * | GetNextVariableName()	| Yes, even if previously busy		   |
- * | QueryVariableInfo()	| Yes, even if previously busy		   |
- * | SetVariable()		| Yes, even if previously busy		   |
- * | UpdateCapsule()		| Yes, even if previously busy		   |
- * | QueryCapsuleCapabilities()	| Yes, even if previously busy		   |
- * | ResetSystem()		| Yes, even if previously busy		   |
- * +----------------------------+------------------------------------------+
- *
- * In order to prevent deadlocks under NMI, the wrappers for these functions
- * may only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
- * However, not all of the services listed are reachable through NMI code paths,
- * so the the special handling as suggested by the UEFI spec is only implemented
- * for QueryVariableInfo() and SetVariable(), as these can be reached in NMI
- * context through efi_pstore_write().
- */
-
-/*
  * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
  * the EFI specification requires that callers of the time related runtime
  * functions serialize with other CMOS accesses in the kernel, as the EFI time
-- 
2.5.0
