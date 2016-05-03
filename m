From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 0/3] EFI urgent fixes
Date: Tue,  3 May 2016 20:29:38 +0100
Message-ID: <1462303781-8686-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, David Herrmann <dh.herrmann@gmail.com>, Josh Boyer <jwboyer@fedoraproject.org>, Josh Triplett <josh@joshtriplett.org>, Mark Rutland <mark.rutland@arm.com>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, Wang YanQing <udknight@gmail.com>
List-Id: linux-efi@vger.kernel.org

Folks, here are a few small fixes. One from Josh to stop the ACPI BGRT
driver wrecking the splash screen even though the "quiet" kernel
parameter is passed, another to fix sysfb_efi on a ThinkPad E550, and
one to MAINTAINERS so that get_maintainer.pl finds the EFI entry for
all subdirectores of drivers/firmware/efi/.
 
The following changes since commit 04974df8049fc4240d22759a91e035082ccd18b4:

  Linux 4.6-rc6 (2016-05-01 15:52:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to c255f4fb93d2d92527ede3f57f90b4eb1698bbec:

  x86/efi-bgrt: Switch all pr_err() to pr_notice() for invalid BGRT (2016-05-03 20:02:25 +0100)

----------------------------------------------------------------
 * Fix sysfb_efi to detect BARs starting at 0x0, which otherwise makes
   video=efifb not work on some the ThinkPad E550 - Wang YanQing

 * Update the MAINTAINERS entry for EFI by removing the trailing
   asterisk characters which was intended to denote "all
   subdirectories" but which breaks get_maintainer.pl - Matt Fleming

 * Convert ACPI BGRT driver messages from pr_err() to pr_notice() to
   avoid spewing messages all over the display and making it
   impossible for users to have a pretty boot experience - Josh Boyer

----------------------------------------------------------------
Josh Boyer (1):
      x86/efi-bgrt: Switch all pr_err() to pr_notice() for invalid BGRT

Matt Fleming (1):
      MAINTAINERS: Remove asterisk from EFI directory names

Wang YanQing (1):
      x86/sysfb_efi: Fix valid BAR address range check

 MAINTAINERS                      |  4 ++--
 arch/x86/kernel/sysfb_efi.c      | 14 ++++++++++++--
 arch/x86/platform/efi/efi-bgrt.c | 18 +++++++++---------
 3 files changed, 23 insertions(+), 13 deletions(-)
