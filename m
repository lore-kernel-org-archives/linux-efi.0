From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fix
Date: Fri, 27 Mar 2015 19:18:54 +0000
Message-ID: <20150327191854.GC5801@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Folks,

Please pull the following fix from Jean which addresses an integer
overflow issue when calculating the number of entries in an SMBIOS 3.0
DMI table.

The following changes since commit 6d9ff473317245e3e5cd9922b4520411c2296388:

  firmware: dmi_scan: Fix dmi_len type (2015-02-24 18:54:17 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to bfbaafae8519d82d10da6abe75f5766dd5b20475:

  firmware: dmi_scan: Prevent dmi_num integer overflow (2015-03-27 10:53:46 +0000)

----------------------------------------------------------------
Jean Delvare (1):
      firmware: dmi_scan: Prevent dmi_num integer overflow

 drivers/firmware/dmi_scan.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
