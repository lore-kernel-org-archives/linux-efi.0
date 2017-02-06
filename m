From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL 0/7] EFI updates for v4.11 part 2
Date: Mon,  6 Feb 2017 11:22:39 +0000
Message-ID: <1486380166-31868-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

These are patches that were still being discussed when I sent the first pull
request last week, but we feel they are now in shape to be merged.

Please pull.

The following changes since commit a21a300289bb5a582cc96be23446fa35236a6a9a:

  efi: libstub: Preserve .debug sections after absolute relocation check (2017-01-31 11:47:39 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to dfe7b0e7e1ab9dc02d754c7dd11e465be0944603:

  efi: libstub: Make file I/O chunking x86-specific (2017-02-03 17:01:06 +0000)

----------------------------------------------------------------
Some more EFI changes we've queued up for v4.11:
* Changes to the EFI init code to infer from various EFI and shim variables
  whether secure boot authentication was performed at boot time. (Note that
  this is the uncontroversial part: I expect some fierce debate about future
  patches that impose or relax certain restrictions based on this information,
  but collecting it is useful in itself.)
* Disable a x86 specific file I/O chunking workaround on ARM so it does not
  spuriously trigger build time checks in the ARM decompressor.

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: libstub: Make file I/O chunking x86-specific

David Howells (5):
      x86/efi: Allow invocation of arbitrary runtime services
      arm/efi: Allow invocation of arbitrary runtime services
      efi: Add SHIM and image security database GUID definitions
      efi: Get the secure boot status
      efi: Print the secure boot status in x86 setup_arch()

Josh Boyer (1):
      efi: Disable secure boot if shim is in insecure mode

 Documentation/x86/zero-page.txt                |  2 +
 arch/arm/include/asm/efi.h                     |  1 +
 arch/arm64/include/asm/efi.h                   |  1 +
 arch/x86/boot/compressed/eboot.c               |  8 +++
 arch/x86/boot/compressed/head_32.S             |  6 +-
 arch/x86/boot/compressed/head_64.S             |  8 +--
 arch/x86/include/asm/efi.h                     |  5 ++
 arch/x86/include/uapi/asm/bootparam.h          |  3 +-
 arch/x86/kernel/asm-offsets.c                  |  1 +
 arch/x86/kernel/setup.c                        | 14 +++++
 drivers/firmware/efi/libstub/Makefile          |  2 +-
 drivers/firmware/efi/libstub/arm-stub.c        | 63 ++-----------------
 drivers/firmware/efi/libstub/efi-stub-helper.c | 12 +++-
 drivers/firmware/efi/libstub/secureboot.c      | 86 ++++++++++++++++++++++++++
 include/linux/efi.h                            | 11 ++++
 15 files changed, 156 insertions(+), 67 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c
