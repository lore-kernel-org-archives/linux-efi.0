From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 01/14] efi: Expose non-blocking set_variable() wrapper to efivars
Date: Mon,  1 Feb 2016 22:06:55 +0000
Message-ID: <1454364428-494-2-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Commit 6d80dba1c9fe ("efi: Provide a non-blocking SetVariable()
operation") implemented a non-blocking alternative for the UEFI
SetVariable() invocation performed by efivars, since it may occur
in atomic context. However, this version of the function was never
exposed via the efivars struct, so the non-blocking versions was
not actually callable. Fix that.

Fixes: 6d80dba1c9fe ("efi: Provide a non-blocking SetVariable() operation")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e9c458ba9353..0cd8f039602e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -180,6 +180,7 @@ static int generic_ops_register(void)
 {
 	generic_ops.get_variable = efi.get_variable;
 	generic_ops.set_variable = efi.set_variable;
+	generic_ops.set_variable_nonblocking = efi.set_variable_nonblocking;
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_store = efi_query_variable_store;
 
-- 
2.6.2
