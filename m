From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL 0/2] EFI fixes for v4.14
Date: Wed, 25 Oct 2017 11:04:46 +0100
Message-ID: <20171025100448.26056-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f:

  Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 8509c79af61fc8066fc21c01a0a9403ef2af7397:

  efi/libstub: arm: don't randomize runtime regions when CONFIG_HIBERNATION=y (2017-10-24 21:53:49 +0100)

----------------------------------------------------------------
Two EFI fixes for v4.14:
- avoid OOPSing on a capsule count overflow in the EFI test ioctl interface
- avoid crashing on UEFI runtime services invocations after resume from
  hibernation on ARM

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/libstub: arm: don't randomize runtime regions when CONFIG_HIBERNATION=y

Dan Carpenter (1):
      efi/efi_test: Prevent an Oops in efi_runtime_query_capsulecaps()

 drivers/firmware/efi/libstub/arm-stub.c | 3 ++-
 drivers/firmware/efi/test/efi_test.c    | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)
