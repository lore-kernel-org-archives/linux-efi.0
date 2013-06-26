From: Matt Fleming <matt@console-pimps.org>
Subject: [GIT PULL] EFI changes for v3.11
Date: Wed, 26 Jun 2013 13:23:31 +0100
Message-ID: <20130626122331.GK22026@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

The following changes since commit d3768d885c6ccbf8a137276843177d76c49033a7:

  x86, efi: retry ExitBootServices() on failure (2013-06-11 07:51:54 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 5d32cf1e590bcdc879f8f862e836c542f6ba7ecb:

  [IA64] sim: Add casts to avoid assignment warnings (2013-06-21 11:22:21 +0100)

----------------------------------------------------------------
 * Add casts to avoid compiler warnings about assignments making
   pointers from integers of different types. The warnings were
   introduced with Borislav's patch to move the EFI runtime service
   pointers to void * - Tony Luck

----------------------------------------------------------------
Tony Luck (1):
      [IA64] sim: Add casts to avoid assignment warnings

 arch/ia64/hp/sim/boot/fw-emu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
