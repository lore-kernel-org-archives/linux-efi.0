From: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH] efi: fix the wrong check for the offset of subnode
Date: Wed, 24 Aug 2016 10:18:10 +0800
Message-ID: <1472005090-5871-1-git-send-email-shawn.lin@rock-chips.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

of_get_flat_dt_subnode_by_name return the offset of
the subnode, and we should check if it's valid. But
the original code use the unsigned type to check it,
which makes the we always get subnode successfully
even if returning -FDT_ERR_BADPATH etc. Let's fix it
by adding offset variable.

Suggested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---

 drivers/firmware/efi/efi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5a2631a..7a5964e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -647,6 +647,7 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 {
 	struct param_info *info = data;
 	int i;
+	int offset = node;
 
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		const char *subnode = dt_params[i].subnode;
@@ -657,12 +658,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 		}
 
 		if (subnode) {
-			node = of_get_flat_dt_subnode_by_name(node, subnode);
-			if (node < 0)
+			offset = of_get_flat_dt_subnode_by_name(node, subnode);
+			if (offset < 0)
 				return 0;
 		}
 
-		return __find_uefi_params(node, info, dt_params[i].params);
+		return __find_uefi_params(offset, info, dt_params[i].params);
 	}
 
 	return 0;
-- 
2.3.7
