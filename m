From: Ding Tianhong <dingtianhong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] firmware: fix the compiller warning
Date: Fri, 20 Jun 2014 12:19:49 +0800
Message-ID: <53A3B665.3080308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When I compile the kernel, found this warning:

In file included from arch/arm64/kernel/efi-stub.c:44:0:
arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c: In function update_fdt:
arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c:66:22: warning: unused variable name [-Wunused-variable]
   const char *type, *name;

so remove the unused variable and clean this warning.

Signed-off-by: Ding Tianhong <dingtianhong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.8.0
