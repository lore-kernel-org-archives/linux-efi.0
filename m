From: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH] efi: simply the fdt_find_uefi_params
Date: Mon, 22 Aug 2016 15:59:21 +0800
Message-ID: <1471852761-9913-1-git-send-email-shawn.lin@rock-chips.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Remove the check of node as it should never be
less then zero dut to its tupe is unsigned long.

Signed-off-by: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---

 drivers/firmware/efi/efi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5a2631a..96261ce 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -656,11 +656,8 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 			continue;
 		}
 
-		if (subnode) {
+		if (subnode)
 			node = of_get_flat_dt_subnode_by_name(node, subnode);
-			if (node < 0)
-				return 0;
-		}
 
 		return __find_uefi_params(node, info, dt_params[i].params);
 	}
-- 
2.3.7
