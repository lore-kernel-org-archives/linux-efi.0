From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: fix boundary checking in efi_high_alloc()
Date: Thu, 19 Feb 2015 20:18:03 -0800
Message-ID: <1424405883-19842-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

While adding support loading kernel and initrd above 4G to grub2 in legacy
mode, I was referring to efi_high_alloc().
That will allocate buffer for kernel and then initrd, and initrd will
use kernel buffer start as limit.

During testing found two buffers will be overlapped when initrd size is
very big like 400M.

It turns out efi_high_alloc() boundary checking is not right.
end - size will be the new start, and should not compare new
start with max, we need to make sure end is smaller than max.

Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
 drivers/firmware/efi/libstub/efi-stub-helper.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
===================================================================
--- linux-2.6.orig/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -183,12 +183,12 @@ again:
 		start = desc->phys_addr;
 		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
 
-		if ((start + size) > end || (start + size) > max)
-			continue;
-
-		if (end - size > max)
+		if (end > max)
 			end = max;
 
+		if ((start + size) > end)
+			continue;
+
 		if (round_down(end - size, align) < start)
 			continue;
 
