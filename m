From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] correct call to free_pages to specify memory size in pages, not bytes.
Date: Wed, 24 Jul 2013 17:48:43 -0700
Message-ID: <1374713324-23670-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I found this bug while working on the EFI stub for ARM - free_pages
is being passed memory size in bytes instead of pages.  Since this is 
unrelated to ARM, I am submitting this separately from the patch set
that adds EFI stub support for ARM.  Those patches will depend on this
one, since the code in question is moved to a shared location and shared
by both x86 and ARM EFI stubs.

Roy Franz (1):
  correct call to free_pages to specify memory size in pages, not
    bytes.

 arch/x86/boot/compressed/eboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4
