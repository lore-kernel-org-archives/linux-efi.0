From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v8 0/2] x86/boot/KASLR: Restrict kernel to be randomized in mirror regions
Date: Fri,  4 Aug 2017 15:26:45 +0800
Message-ID: <1501831607-6776-1-git-send-email-bhe@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org, fanc.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Patch 1/2 is newly added to add efi_memdesc_ptr helper to wrap the
open code which gets the start of efi memmap descriptor and also
explain why it need be done like that, Ingo suggested it. 

And also replace several places of the open code with efi_memdesc_ptr
helper.

And also use efi_memdesc_ptr in process_efi_entries() which handle efi
mirror issue during KASLR.


Change:
v7->v8:
    Add efi_memdesc_ptr helper to wrap the open code which gets the
    start of map descriptor according to Ingo's suggestion.

v6->v7:
  Ingo pointed out several incorrect line break issues and unclear
  description of patch log. Correct them and rewrite patch log.

  And also rewrite the EFI warning message that if EFI memmap is above
  4G in 32bit system since 32bit system can not handle data above 4G at
  kernel decompression stage. This is suggested by Ingo too.

v5->v6:
  Code style issue fix according to Kees's comment.

  This is based on tip/x86/boot, patch 1,2,3/4 in v5 post has
  been put into tip/x86/boot now.



Baoquan He (2):
  efi: Introduce efi_memdesc_ptr to get pointer to memmap descriptor
  x86/boot/KASLR: Restrict kernel to be randomized in mirror regions

 arch/x86/boot/compressed/eboot.c               |  2 +-
 arch/x86/boot/compressed/kaslr.c               | 68 +++++++++++++++++++++++++-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  4 +-
 include/linux/efi.h                            | 19 +++++++
 4 files changed, 88 insertions(+), 5 deletions(-)

-- 
2.5.5
