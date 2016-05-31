From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 1/2] efi: Fix for_each_efi_memory_desc_in_map() for empty memmaps
Date: Tue, 31 May 2016 11:23:43 +0100
Message-ID: <1464690224-4503-2-git-send-email-matt@codeblueprint.co.uk>
References: <1464690224-4503-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464690224-4503-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index c2db3ca22217..f196dd0b0f2f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1005,7 +1005,7 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
-- 
2.7.3
