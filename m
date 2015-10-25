From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI changes for v4.4
Date: Sun, 25 Oct 2015 10:49:03 +0000
Message-ID: <1445770144-22280-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@intel.com>, Glenn P Williamson <glenn.p.williamson@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Ricardo Neri <ricardo.neri@intel.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following bugfix from Sai which prevents a
kernel panic when booting an EFI machine with CONFIG_DEBUG_VIRTUAL
enabled.

This bug was reported last year by Dave Hansen,

  https://lkml.kernel.org/r/5462999A.7090706@intel.com

and since nobody else has reported it, and given that it's only
triggerable with a debug config option, I figured this should be
targeted at v4.4.

The following changes since commit 0f96a99dab366333439e110d6ad253bc7c557c09:

  efi: Add "efi_fake_mem" boot option (2015-10-12 14:20:09 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 2c66e24d75d424919c42288b418d2e593fa818b1:

  x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled (2015-10-25 10:22:25 +0000)

----------------------------------------------------------------
 * Fix a kernel panic by not passing EFI virtual mapping addresses to
   __pa() in the x86 pageattr code. Since these virtual addreses are
  not part of the direct mapping or kernel text mapping, passing them
  to __pa() will trigger a BUG_ON() when CONFIG_DEBUG_VIRTUAL is
  enabled - Sai Praneeth Prakhya

----------------------------------------------------------------
Sai Praneeth (1):
      x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled

 arch/x86/mm/pageattr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)
