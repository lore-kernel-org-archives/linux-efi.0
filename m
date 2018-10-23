From: Waiman Long <longman@redhat.com>
Subject: [PATCH] efi: Fix debugobjects warning on efi_rts_work
Date: Tue, 23 Oct 2018 10:18:27 -0400
Message-ID: <1540304307-2806-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Waiman Long <longman@redhat.com>
List-Id: linux-efi@vger.kernel.org

The commit 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi
page fault handler") converted efi_rts_work from an auto variable to a
global variable. However, when submitting the work, INIT_WORK_ONSTACK()
was still used causing the following complaint from debugobjects:

ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760,
but annotated.

Change the macro to just INIT_WORK() to eliminate the warning.

Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")

Signed-off-by: Waiman Long <longman@redhat.com>
---
 drivers/firmware/efi/runtime-wrappers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index a19d845..8903b9c 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -67,7 +67,7 @@
 	}								\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
-	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
+	INIT_WORK(&efi_rts_work.work, efi_call_rts);			\
 	efi_rts_work.arg1 = _arg1;					\
 	efi_rts_work.arg2 = _arg2;					\
 	efi_rts_work.arg3 = _arg3;					\
-- 
1.8.3.1
