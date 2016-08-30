From: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2] efi: fix handling error value in fdt_find_uefi_params
Date: Tue, 30 Aug 2016 12:41:37 +0200
Message-ID: <1472553697-27984-1-git-send-email-a.hajda@samsung.com>
References: <20160830100742.GA32579@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20160830100742.GA32579-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "open list:EXTENSIBLE FIRMWARE INTERFACE
        EFI" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

of_get_flat_dt_subnode_by_name can return negative value in case of error.
Assigning the result to unsigned variable and checking if the variable
is lesser than zero is incorrect and always false.
The patch fixes it by using signed variable to check the result.

The problem has been detected using semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci

Signed-off-by: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5a2631a..7dd2e2d 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -657,9 +657,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 		}
 
 		if (subnode) {
-			node = of_get_flat_dt_subnode_by_name(node, subnode);
-			if (node < 0)
+			int err = of_get_flat_dt_subnode_by_name(node, subnode);
+
+			if (err < 0)
 				return 0;
+
+			node = err;
 		}
 
 		return __find_uefi_params(node, info, dt_params[i].params);
-- 
1.9.1
