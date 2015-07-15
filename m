From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fix
Date: Wed, 15 Jul 2015 15:31:11 +0100
Message-ID: <20150715143111.GB6955@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Folks,

Please pull the following fix from Tony that addresses a bug in the EFI
CPER driver preventing it from working with memory error records as
described in the UEFI 2.2 spec.

The following changes since commit d67e199611b986b345ea3087ee2e4a15da1c98b3:

  efi: Fix error handling in add_sysfs_runtime_map_entry() (2015-05-05 16:20:13 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 4c62360d7562a20c996836d163259c87d9378120:

  efi: Handle memory error structures produced based on old versions of standard (2015-07-15 13:30:38 +0100)

----------------------------------------------------------------
 * Fix a bug in the Common Platform Error Record (CPER) driver that
   caused old UEFI spec (< 2.3) versions of the memory error record
   structure to be declared invalid - Tony Luck

----------------------------------------------------------------
Tony Luck (1):
      efi: Handle memory error structures produced based on old versions of standard

 drivers/firmware/efi/cper.c | 15 ++++++++++++---
 include/linux/cper.h        | 22 +++++++++++++++++++++-
 2 files changed, 33 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
