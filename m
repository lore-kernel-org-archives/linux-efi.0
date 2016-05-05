From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL v2] EFI urgent fix
Date: Thu,  5 May 2016 14:14:20 +0100
Message-ID: <1462454061-21561-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, Wang YanQing <udknight@gmail.com>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following with from Wang which includes a
rewritten changelog as compared with the previous pull request.

The following changes since commit 04974df8049fc4240d22759a91e035082ccd18b4:

  Linux 4.6-rc6 (2016-05-01 15:52:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 8491332837eed61cd5d47613b33cba90b809f36a:

  x86/sysfb_efi: Fix valid BAR address range check (2016-05-05 13:14:04 +0100)

----------------------------------------------------------------
 * Fix sysfb_efi to detect BARs starting at 0x0, which otherwise makes
   video=efifb not work on some the ThinkPad E550 - Wang YanQing

----------------------------------------------------------------
Wang YanQing (1):
      x86/sysfb_efi: Fix valid BAR address range check

 arch/x86/kernel/sysfb_efi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)
