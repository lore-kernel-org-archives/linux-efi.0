From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access ESRT table in memory
Date: Mon, 11 Jul 2016 21:00:45 +0200
Message-ID: <1468263646-28184-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1468263646-28184-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468263646-28184-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On ARM and arm64, ioremap() and memremap() are not interchangeable like
on x86, and the use of ioremap() on ordinary RAM is typically flagged
as an error if the memory region being mapped is also covered by the
linear mapping, since that would lead to aliases with conflicting
cacheability attributes.

Since what we are dealing with is not an I/O region with side effects,
using ioremap() here is arguably incorrect anyway, so let's replace
it with memremap() instead.

Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/esrt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index b93cd11f9bcc..14914074f716 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
@@ -387,9 +388,9 @@ static int __init esrt_sysfs_init(void)
 	if (!esrt_data || !esrt_data_size)
 		return -ENOSYS;
 
-	esrt = ioremap(esrt_data, esrt_data_size);
+	esrt = memremap(esrt_data, esrt_data_size, MEMREMAP_WB);
 	if (!esrt) {
-		pr_err("ioremap(%pa, %zu) failed.\n", &esrt_data,
+		pr_err("memremap(%pa, %zu) failed.\n", &esrt_data,
 		       esrt_data_size);
 		return -ENOMEM;
 	}
-- 
1.9.1
