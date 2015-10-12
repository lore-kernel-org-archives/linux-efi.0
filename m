From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fix
Date: Mon, 12 Oct 2015 15:13:55 +0100
Message-ID: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, =?UTF-8?q?K=C5=91v=C3=A1g=C3=B3=2C=20Zolt=C3=A1n?= <DirtY.iCE.hu@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

=46rom: Matt Fleming <matt.fleming@intel.com>

Please pull the following fix from Zolt=C3=A1n which addresses a bug th=
at
resulted in the the secondary GOP display being garbled when booting
using the EFI boot stub.

The following changes since commit 825fcfce81921c9cc4ef801d844793815721=
e458:

  MAINTAINERS: Change Matt Fleming's email address (2015-10-11 09:54:29=
 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/e=
fi-urgent

for you to fetch changes up to dc1ea95fd23c36dd6be284334a0c8327d11d8c52=
:

  x86/efi: Fix multiple GOP device support (2015-10-11 11:40:54 +0100)

----------------------------------------------------------------
 * Fix booting using the EFI boot stub on platforms with multiple
   Graphics Output Protocol devices because currently the secondary
   display will be garbled on such systems - Zolt=C3=A1n K=C5=91v=C3=A1=
g=C3=B3

----------------------------------------------------------------
K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n (1):
      x86/efi: Fix multiple GOP device support

 arch/x86/boot/compressed/eboot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
