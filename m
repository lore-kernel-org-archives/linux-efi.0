From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: fix for_each_efi_memory_desc_in_map() for empty memmaps
Date: Wed, 25 May 2016 16:36:55 +0200
Message-ID: <1464187015-5640-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 78ce248faa3c ("efi: Iterate over efi.memmap in
for_each_efi_memory_desc()") introduced a regression for systems booted
with 'noefi' kernel option. In particular, I observe early kernel hang in
efi_find_mirror() on for_each_efi_memory_desc() call. As we don't have
efi memmap we enter this iterator with the following parameters:

efi.memmap.map = 0, efi.memmap.map_end = 0, efi.memmap.desc_size = 28

for_each_efi_memory_desc_in_map() does the following comparison:

(md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size);

where md = 0, (m)->map_end = 0 and (m)->desc_size = 28 but when we subtract
something from a NULL pointer wrap around happens and we end up returning
invalid pointer.

Fixes: 78ce248faa3c ("efi: Iterate over efi.memmap in for_each_efi_memory_desc()")
Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/efi.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index c2db3ca..229ccb5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1005,7 +1005,8 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     (efi_memory_desc_t *)((md) + (m)->desc_size) <=		   \
+		     (efi_memory_desc_t *)(m)->map_end;			   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
-- 
2.5.5
