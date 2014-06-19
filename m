From: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: fix build warning about of_get_flat_dt_prop
Date: Thu, 19 Jun 2014 20:22:32 +0800
Message-ID: <1403180552-9272-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

commit 9d0c4dfed(of/fdt: update of_get_flat_dt_prop in prep for libfdt)
change the of_get_flat_dt_prop, so update related variable to fix build
warning. Btw, remove unused variable 'name'.

Signed-off-by: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efi.c |    5 ++---
 drivers/firmware/efi/fdt.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb..e6da090 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -353,10 +353,9 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info = data;
-	void *prop, *dest;
-	unsigned long len;
+	const void *prop, *dest;
+	int len, i;
 	u64 val;
-	int i;
 
 	if (depth != 1 ||
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 5c6a8e8..82d7741 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -63,7 +63,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	 */
 	prev = 0;
 	for (;;) {
-		const char *type, *name;
+		const char *type;
 		int len;
 
 		node = fdt_next_node(fdt, prev, NULL);
-- 
1.7.1
