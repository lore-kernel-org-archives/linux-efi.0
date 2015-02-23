From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: fix boundary checking in efi_high_alloc()
Date: Mon, 23 Feb 2015 13:32:15 +0000
Message-ID: <20150223133215.GA19367@codeblueprint.co.uk>
References: <1424405883-19842-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424405883-19842-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Feb, at 08:18:03PM, Yinghai Lu wrote:
> While adding support loading kernel and initrd above 4G to grub2 in legacy
> mode, I was referring to efi_high_alloc().
> That will allocate buffer for kernel and then initrd, and initrd will
> use kernel buffer start as limit.
> 
> During testing found two buffers will be overlapped when initrd size is
> very big like 400M.
> 
> It turns out efi_high_alloc() boundary checking is not right.
> end - size will be the new start, and should not compare new
> start with max, we need to make sure end is smaller than max.
> 
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> ---
>  drivers/firmware/efi/libstub/efi-stub-helper.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

The patch looks fine but this changelog could do with some finessing
because I spent 30 minutes trying to understand what the bug was, and
more specifically, what values to feed into the allocation algorithm to
trigger it.

Basically, with the current efi_high_alloc() code it's possible to
allocate memory above 'max', because efi_high_alloc() doesn't check that
the tail of the allocation is below 'max'.

If you have an EFI memory map with a single entry that looks like so,

 [0xc0000000-0xc0004000]

And want to allocate 0x3000 bytes below 0xc0003000 the current code will
allocate [0xc0001000-0xc0004000], not [0xc0000000-0xc0003000] like you
would expect.

I've queued up the below patch. If the Linaro/ARM gang could test it out
I'd really appreciate it.

---

>From 1e7295b5d4c5226a160a9167e61b581e388f7f9a Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 19 Feb 2015 20:18:03 -0800
Subject: [PATCH] efi/libstub: Fix boundary checking in efi_high_alloc()

While adding support loading kernel and initrd above 4G to grub2 in legacy
mode, I was referring to efi_high_alloc().
That will allocate buffer for kernel and then initrd, and initrd will
use kernel buffer start as limit.

During testing found two buffers will be overlapped when initrd size is
very big like 400M.

It turns out efi_high_alloc() boundary checking is not right.
end - size will be the new start, and should not compare new
start with max, we need to make sure end is smaller than max.

[ Basically, with the current efi_high_alloc() code it's possible to
  allocate memory above 'max', because efi_high_alloc() doesn't check
  that the tail of the allocation is below 'max'.

  If you have an EFI memory map with a single entry that looks like so,

   [0xc0000000-0xc0004000]

  And want to allocate 0x3000 bytes below 0xc0003000 the current code
  will allocate [0xc0001000-0xc0004000], not [0xc0000000-0xc0003000]
  like you would expect. - Matt ]

Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 9bd9fbb5bea8..c927bccd92bd 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -170,12 +170,12 @@ again:
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
 
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
