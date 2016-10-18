From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 4/8] efi/efi_test: Fix the uninitialized value datasize
Date: Tue, 18 Oct 2016 15:33:14 +0100
Message-ID: <20161018143318.15673-5-matt@codeblueprint.co.uk>
References: <20161018143318.15673-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161018143318.15673-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Fix the minor issue found by CoverityScan
CID 1358931 (#1 of 1): Uninitialized scalar variable (UNINIT)9.
uninit_use: Using uninitialized value datasize.
199        prev_datasize = datasize;
200        status = efi.get_variable(name, vd, at, dz, data);

Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/test/efi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index ae51268737cc..348efc9cf59f 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -155,7 +155,7 @@ static long efi_runtime_get_variable(unsigned long arg)
 {
 	struct efi_getvariable __user *getvariable_user;
 	struct efi_getvariable getvariable;
-	unsigned long datasize, prev_datasize, *dz;
+	unsigned long datasize = 0, prev_datasize, *dz;
 	efi_guid_t vendor_guid, *vd = NULL;
 	efi_status_t status;
 	efi_char16_t *name = NULL;
-- 
2.10.0
