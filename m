From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 0/3] Generic efi_enabled() support
Date: Wed, 15 Jan 2014 14:28:53 +0000
Message-ID: <1389796136-23479-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony-hKmkhVXvusEnkhFzW7PF62O9nC1t1/YaHZ5vskTnxNA@public.gmane.org, "Luck <tony.luck"@intel.com, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ARM EFI patches show the clear need to have a more generic
efi_enabled() implementation, lest we duplicate all the code or
introduce new CONFIG_* symbols.

This patch series finally implements proper efi_enabled() support for
ia64 and moves the EFI feature flags to the global 'struct efi', which
is well established as the central place for the EFI state of the
running machine.

Matt Fleming (3):
  efi: Move facility flags to struct efi
  efi: Set feature flags inside feature init functions
  ia64/efi: Implement efi_enabled()

 arch/ia64/kernel/efi.c      |  7 +++++++
 arch/x86/include/asm/efi.h  |  1 -
 arch/x86/kernel/setup.c     |  6 +++---
 arch/x86/platform/efi/efi.c | 26 +++++++-------------------
 drivers/firmware/efi/efi.c  |  3 +++
 include/linux/efi.h         | 16 ++++++++--------
 6 files changed, 28 insertions(+), 31 deletions(-)

-- 
1.8.3.1
