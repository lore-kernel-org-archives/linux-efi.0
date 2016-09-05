From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 1/6] efi: Make for_each_efi_memory_desc_in_map() cope with running on Xen
Date: Mon,  5 Sep 2016 15:42:32 +0100
Message-ID: <20160905144237.2361-2-matt@codeblueprint.co.uk>
References: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160905144237.2361-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>

While commit 55f1ea15216 ("efi: Fix for_each_efi_memory_desc_in_map()
for empty memmaps") made an attempt to deal with empty memory maps, it
didn't address the case where the map field never gets set, as is
apparently the case when running under Xen.

Reported-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
Tested-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7+
Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
[ Guard the loop with a NULL check instead of pointer underflow ]
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7f5a58225385..23cd3ced8c1a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -946,7 +946,7 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
+	     (md) && ((void *)(md) + (m)->desc_size) <= (m)->map_end;	   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
-- 
2.9.3
