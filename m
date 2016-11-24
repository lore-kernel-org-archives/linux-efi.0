From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] one more EFI patch for v4.10
Date: Thu, 24 Nov 2016 18:02:22 +0000
Message-ID: <1480010543-25709-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 9110bc036062fcd31994a35540d63f8deed22efa:

  thunderbolt: Use Device ROM retrieved from EFI (2016-11-12 21:14:43 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to bec0c3c8151b7e1506fa2ae19500a8b8a32a79c0:

  efi/libstub: Make efi_random_alloc() allocate below 4 GB on 32-bit (2016-11-22 09:53:49 +0000)

----------------------------------------------------------------
A single fix, for commit a6a144698d ("efi/libstub: Add random.c to ARM
build") that is queued for v4.10 in efi/core in the tip tree, since it
turned out that the compiler ends up emitting a call to a compiler
intrinsic to perform 64-bit logical shift when called with -Os. Upon
closer inspection of that code, it turned out we should explicitly ensure
that we do not allocate above 4 GB, which is not addressable by the stub
on 32-bit ARM.

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/libstub: Make efi_random_alloc() allocate below 4 GB on 32-bit

 drivers/firmware/efi/libstub/random.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)
