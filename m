From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/7] arm: efi: use strcmp instead of strncmp for fdt parsing
Date: Fri, 18 Jul 2014 15:00:51 +0100
Message-ID: <1405692053-7514-6-git-send-email-leif.lindholm@linaro.org>
References: <1405692053-7514-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405692053-7514-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The existing shared EFI arm/arm64 stub code uses strncmp when parsing
the device tree. Since this function is missing from arm zImage, use
strcmp instead, rather than growing the zImage further.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/fdt.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a56bb35..399374b 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -58,14 +58,13 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	prev = 0;
 	for (;;) {
 		const char *type;
-		int len;
 
 		node = fdt_next_node(fdt, prev, NULL);
 		if (node < 0)
 			break;
 
-		type = fdt_getprop(fdt, node, "device_type", &len);
-		if (type && strncmp(type, "memory", len) == 0) {
+		type = fdt_getprop(fdt, node, "device_type", NULL);
+		if (type && strcmp(type, "memory") == 0) {
 			fdt_del_node(fdt, node);
 			continue;
 		}
-- 
1.7.10.4
