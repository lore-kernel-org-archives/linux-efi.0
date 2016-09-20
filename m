From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI fix for v4.9 queue
Date: Tue, 20 Sep 2016 15:46:49 +0100
Message-ID: <20160920144650.30615-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Mike Krinkin <krinkin.m.u@gmail.com>, Peter Jones <pjones@redhat.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following fix for the v4.9 EFI queue sat in
tip/efi/core.

The following changes since commit 5465fe0fc3316f7cdda66732a7986f4ebe76d949:

  Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into efi/core (2016-09-13 20:21:55 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 92dc33501bfba74655dbf3ec63ea82d040fd6d58:

  x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE (2016-09-20 15:43:31 +0100)

----------------------------------------------------------------
 * Fix a boot crash reported by Mike Galbraith and Mike Krinkin. The
   new EFI memory map reservation code didn't align reservations to
   EFI_PAGE_SIZE boundaries causing bogus regions to be inserted into
   the global EFI memory map - Matt Fleming

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE

 arch/x86/platform/efi/quirks.c |  6 +++++-
 drivers/firmware/efi/memmap.c  | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)
