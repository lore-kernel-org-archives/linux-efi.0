From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fix
Date: Wed, 12 Apr 2017 16:27:18 +0100
Message-ID: <20170412152719.9779-1-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Dave Young <dyoung@redhat.com>, Omar Sandoval <osandov@fb.com>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Folks, please pull the single below fix from Omar which fixes a kexec
boot regression.

I've based the pull on tip/efi/urgent since the EFI urgent queue
hasn't reached Linus' tree yet.

The following changes since commit 55d728a40d368ba80443be85c02e641fc9082a3f:

  efi/fb: Avoid reconfiguration of BAR that covers the framebuffer (2017-04-05 12:25:53 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 09ca0b10e8100a48aa94eb8649f4c6c904e5d196:

  x86/efi: Don't try to reserve runtime regions (2017-04-12 16:17:20 +0100)

----------------------------------------------------------------
 - Fix a crash on kexec boot introduced by the recent
   efi_mem_reserve() code in the ESRT driver, which double-reserved
   EFI runtime regions - Omar Sandoval

----------------------------------------------------------------
Omar Sandoval (1):
      x86/efi: Don't try to reserve runtime regions

 arch/x86/platform/efi/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)
