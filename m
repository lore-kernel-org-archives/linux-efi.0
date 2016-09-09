From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 12/29] efi/esrt: Use memremap not ioremap to access ESRT table in memory
Date: Fri,  9 Sep 2016 16:18:34 +0100
Message-ID: <20160909151851.27577-13-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909151851.27577-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

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
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
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
2.9.3
