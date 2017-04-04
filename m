From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL 0/2] EFI fixes for v4.11
Date: Tue,  4 Apr 2017 16:27:42 +0100
Message-ID: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello all,

Please pull these fixes for EFI framebuffer support on ARM/arm64 systems.

The following changes since commit 822f5845f710e57d7e2df1fd1ee00d6e19d334fe:

  efi/esrt: Cleanup bad memory map log messages (2017-03-17 18:53:12 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to e73c2811538bd36ec1340d01bafdc080af31914e:

  efifb: Avoid reconfiguration of BAR that covers the framebuffer (2017-04-04 15:56:43 +0100)

----------------------------------------------------------------
Two fixes related to the EFI framebuffer driver:
- Ignore Graphics Output Protocol (GOP) implementations that are marked as
  BLT-only -- the framebuffer base address is invalid in this case, and the
  Blt() method is not accessible to the kernel.
- If the GOP framebuffer base address coincides with a memory BAR of a PCI
  device that has memory decoding enabled, claim the memory resource so that
  the PCI core will not attempt to move it later on.

----------------------------------------------------------------
Ard Biesheuvel (1):
      efifb: Avoid reconfiguration of BAR that covers the framebuffer

Cohen, Eugene (1):
      efi/libstub: Skip GOP with PIXEL_BLT_ONLY format

 drivers/firmware/efi/libstub/gop.c |  6 ++--
 drivers/video/fbdev/efifb.c        | 66 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 3 deletions(-)
