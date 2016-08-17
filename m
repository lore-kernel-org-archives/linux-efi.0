From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] efi: fix handling error value in fdt_find_uefi_params
Date: Wed, 17 Aug 2016 12:00:40 +0200
Message-ID: <1471428040-23463-1-git-send-email-a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, "open list:EXTENSIBLE FIRMWARE INTERFACE
	EFI" <linux-efi@vger.kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

of_get_flat_dt_subnode_by_name can return negative value in case of error.

The problem has been detected using semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
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
