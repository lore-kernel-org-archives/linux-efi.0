From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2] EFI: make for_each_efi_memory_desc_in_map() cope
 with running on Xen
Date: Mon, 15 Aug 2016 09:05:45 -0600
Message-ID: <57B1F6690200007800106095@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

While commit 55f1ea15216 ("efi: Fix for_each_efi_memory_desc_in_map()
for empty memmaps") made an attempt to deal with empty memory maps, it
didn't address the case where the desc_size field never gets set, as is
apparently the case when running under Xen.

Reported-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
Tested-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
---
v2: Add comment.
---
 include/linux/efi.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- 4.8-rc2/include/linux/efi.h
+++ 4.8-rc2-EFI-memdesc-iterator-Xen/include/linux/efi.h
@@ -946,7 +946,11 @@ extern int efi_memattr_apply_permissions
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
+	     /*								   \
+	      * Leverage wrapping of the calculation to avoid an infinite  \
+	      * loop when all three values are zero.			   \
+	      */							   \
+	     ((void *)(md) + (m)->desc_size - 1) < (m)->map_end;	   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
