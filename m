From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] urgent EFI fix for v4.9
Date: Tue, 18 Oct 2016 16:53:10 +0100
Message-ID: <1476805991-7160-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Please merge the single fix below: it addresses a build issue on ARM with
less recent toolchain versions, which surfaced now that EFI has been added
to multi_v7_defconfig, the de facto generic defconfig for the most recent
cores.

The following changes since commit b67be92feb486f800d80d72c67fd87b47b79b18e:

  Merge tag 'pwm/for-4.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm (2016-10-12 11:11:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 0d5b726f1009d05657ec71c716ba6529dcc98d2b:

  efi/arm: Fix absolute relocation detection for older toolchains (2016-10-14 10:57:59 +0100)

----------------------------------------------------------------
* Fix a build issue in the ARM version of libstub with slightly older
  toolchains

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm: Fix absolute relocation detection for older toolchains

 drivers/firmware/efi/libstub/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
