From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/1] EFI mixed mode fix for v4.18
Date: Wed, 11 Jul 2018 11:02:34 +0200
Message-ID: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 1e4b044d22517cae7047c99038abb444423243ca:

  Linux 4.18-rc4 (2018-07-08 16:34:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to d7f2e972e702d329fe11d6956df99dfc31211c25:

  efi/x86: remove pointless call to PciIo->Attributes() (2018-07-11 10:52:46 +0200)

----------------------------------------------------------------
A single fix for the x86 PCI I/O protocol handling code that got
broken for mixed mode (64-bit Linux/x86 on 32-bit UEFI) after a
fix was applied in -rc2 to fix it for ordinary 64-bit Linux/x86.

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/x86: remove pointless call to PciIo->Attributes()

 arch/x86/boot/compressed/eboot.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)
