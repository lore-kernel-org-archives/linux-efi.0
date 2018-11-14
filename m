From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/5] efi: Fix debugobjects warning on efi_rts_work
Date: Wed, 14 Nov 2018 09:55:40 -0800
Message-ID: <20181114175544.12860-2-ard.biesheuvel@linaro.org>
References: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Waiman Long <longman@redhat.com>

The commit 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi
page fault handler") converted efi_rts_work from an auto variable to a
global variable. However, when submitting the work, INIT_WORK_ONSTACK()
was still used causing the following complaint from debugobjects:

ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760,
but annotated.

Change the macro to just INIT_WORK() to eliminate the warning.

Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index a19d845bdb06..8903b9ccfc2b 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -67,7 +67,7 @@ struct efi_runtime_work efi_rts_work;
 	}								\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
-	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
+	INIT_WORK(&efi_rts_work.work, efi_call_rts);			\
 	efi_rts_work.arg1 = _arg1;					\
 	efi_rts_work.arg2 = _arg2;					\
 	efi_rts_work.arg3 = _arg3;					\
-- 
2.17.1
