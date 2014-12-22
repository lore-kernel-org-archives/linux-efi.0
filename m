From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/8] memblock: add physmem to memblock_dump_all() output
Date: Mon, 22 Dec 2014 19:08:37 +0000
Message-ID: <1419275322-29811-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419275322-29811-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If CONFIG_HAVE_MEMBLOCK_PHYS_MAP is set, there is a third memblock
map called 'physmem'. Add it to the output of memblock_dump_all().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 mm/memblock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 252b77bdf65e..c27353beb260 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1522,6 +1522,9 @@ void __init_memblock __memblock_dump_all(void)
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+	memblock_dump(&memblock.physmem, "physmem");
+#endif
 }
 
 void __init memblock_allow_resize(void)
-- 
1.8.3.2
