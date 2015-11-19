From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] efi: expose non-blocking set_variable() wrapper to efivars
Date: Thu, 19 Nov 2015 14:36:28 +0100
Message-ID: <1447940191-30705-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447940191-30705-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 6d80dba1c9fe ("efi: Provide a non-blocking SetVariable()
operation") implemented a non-blocking alternative for the UEFI
SetVariable() invocation performed by efivars, since it may occur
in atomic context. However, this version of the function was never
exposed via the efivars struct, so the non-blocking versions was
not actually callable. Fix that.

Fixes: 6d80dba1c9fe ("efi: Provide a non-blocking SetVariable() operation")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 027ca212179f..3b52677f459a 100644
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
1.9.1
