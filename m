From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 0/2] EFI urgent fixes
Date: Sat, 12 Nov 2016 21:04:22 +0000
Message-ID: <20161112210424.5157-1-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following two EFI patches. The first fixes a
build warning for PAE that Boris hit. The second makes mixed-mode EFI
boot again after the vmap'd stack changes introduced during the merge
window.

The following changes since commit bc33b0ca11e3df467777a4fa7639ba488c9d4911:

  Linux 4.9-rc4 (2016-11-05 16:23:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 044ddf3d3e3cb62671f22fa837a2164d4786d867:

  x86/efi: Prevent mixed mode boot corruption with CONFIG_VMAP_STACK (2016-11-12 21:00:18 +0000)

----------------------------------------------------------------
 * Fix memory corruption when booting EFI mixed mode due to the recent
   vmap'd stack changes - Matt Fleming

 * Build warning fix in the EFI memmap code when CONFIG_X86_PAE and
   CONFIG_PHYS_ADDR_T_64BIT are enabled - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Fix EFI memmap pointer size warning

Matt Fleming (1):
      x86/efi: Prevent mixed mode boot corruption with CONFIG_VMAP_STACK

 arch/x86/platform/efi/efi.c    |  2 +-
 arch/x86/platform/efi/efi_64.c | 80 ++++++++++++++++++++++++++++++------------
 2 files changed, 58 insertions(+), 24 deletions(-)
