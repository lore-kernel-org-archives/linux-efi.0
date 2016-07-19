From: Wei Yongjun <weiyj_lk-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH -next] x86/efi: Remove duplicated include from efi_64.c
Date: Tue, 19 Jul 2016 12:02:04 +0000
Message-ID: <1468929724-8820-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 677e29e..3c63640 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -24,7 +24,6 @@
 #include <linux/spinlock.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/mc146818rtc.h>
 #include <linux/efi.h>
 #include <linux/uaccess.h>
