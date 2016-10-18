From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/8] EFI changes for v4.10
Date: Tue, 18 Oct 2016 15:33:10 +0100
Message-ID: <20161018143318.15673-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, please queue up the following small changes for v4.10.

Note that there is a patch to MAINTAINERS in this pull request that
adds Ard as EFI co-maintainer. It'd probably be a good idea to send
that to Linus before v4.10.

The following changes since commit 92dc33501bfba74655dbf3ec63ea82d040fd6d58:

  x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE (2016-09-20 15:43:31 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to a8226a73b82256b82c167956b0f4d3cd39312531:

  efi: efivar_ssdt_load: Don't return success on allocation failure (2016-10-13 11:55:40 +0100)

----------------------------------------------------------------
 * Add Ard as EFI co-maintainer in MAINTAINERS

 * Misc cleanups for efi_test driver - Ivan Hu and Wei Yongjun

 * Fix an early_memremap() leak for ARM/arm64 - Yisheng Xie

 * Return an error code on failure instead of success in
   efivar_ssdt_load() - Dan Carpenter

 * Expose EFI framebuffer configuration, which allows rendering
   localized status strings during firmware updates - Peter Jones

----------------------------------------------------------------
Ard Biesheuvel (1):
      MAINTAINERS: add myself as EFI maintainer

Dan Carpenter (1):
      efi: efivar_ssdt_load: Don't return success on allocation failure

Ivan Hu (3):
      efi/efi_test: Fix the uninitialized value datasize
      efi/efi_test: Fix the uninitialized value rv
      efi/efi_test: Use memdup_user() as a cleanup

Peter Jones (1):
      efifb: show framebuffer layout as device attributes

Wei Yongjun (1):
      efi: Remove unused including <linux/version.h>

Yisheng Xie (1):
      efi/arm*: efi_init() error handling fix

 MAINTAINERS                          |  3 +-
 drivers/firmware/efi/arm-init.c      |  4 ++-
 drivers/firmware/efi/efi.c           |  4 ++-
 drivers/firmware/efi/test/efi_test.c | 15 +++------
 drivers/video/fbdev/efifb.c          | 59 ++++++++++++++++++++++++++++--------
 5 files changed, 59 insertions(+), 26 deletions(-)
