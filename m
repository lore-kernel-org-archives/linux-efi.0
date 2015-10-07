From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] efi/libstub: fix deletion of FDT memory nodes
Date: Wed,  7 Oct 2015 09:35:29 +0100
Message-ID: <1444206929-13374-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1444206929-13374-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444206929-13374-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This fixes two issues with the EFI libstub code that removes the memory
nodes from the FDT:
a) fdt_del_node() invalidates the iterator, so we should restart from the
   top after calling it;
b) use fixed length of 6 when matching against 'memory' using strncmp(),
   since otherwise, substrings like 'm' or 'mem' could match as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/fdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 0ef16923b4f0..2c7d09936479 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -200,6 +200,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	 * Delete any memory nodes present. We must delete nodes which
 	 * early_init_dt_scan_memory may try to use.
 	 */
+restart:
 	prev = 0;
 	for (;;) {
 		const char *type;
@@ -210,9 +211,9 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			break;
 
 		type = fdt_getprop(fdt, node, "device_type", &len);
-		if (type && strncmp(type, "memory", len) == 0) {
+		if (type && strncmp(type, "memory", 6) == 0) {
 			fdt_del_node(fdt, node);
-			continue;
+			goto restart;
 		}
 
 		prev = node;
-- 
1.9.1
