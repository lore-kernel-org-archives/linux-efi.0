From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fix
Date: Thu, 11 Jun 2015 13:47:58 +0100
Message-ID: <20150611124758.GA19243@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Guenter Roeck <linux@roeck-us.net>, "Luck, Tony" <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following build fix from Peter Jones. Guenter
reported that the ESRT driver doesn't build properly on ia64. The
problem was discovered in linux-next.

The following changes since commit c208358c2cc832eeb5b341a465eee30be19cd5a0:

  efi: Add 'systab' information to Documentation/ABI (2015-05-27 15:40:20 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 3846c15820a1841225d0245afda4875af23dfbbe:

  efi: Work around ia64 build problem with ESRT driver (2015-06-08 10:51:31 +0100)

----------------------------------------------------------------
 * Fix ESRT build breakage on ia64 reported by Guenter Roeck - Peter Jones

----------------------------------------------------------------
Peter Jones (1):
      efi: Work around ia64 build problem with ESRT driver

 drivers/firmware/efi/Kconfig  | 5 +++++
 drivers/firmware/efi/Makefile | 3 ++-
 include/linux/efi.h           | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
Matt Fleming, Intel Open Source Technology Center
