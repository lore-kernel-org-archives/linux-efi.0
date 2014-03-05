From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI mixed kbuild fixes
Date: Wed, 5 Mar 2014 16:03:32 +0000
Message-ID: <20140305160332.GE17362@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Peter, please pull the following two changes that fix build errors
reported by Fengguang's kbuild bot.

The following changes since commit 18c46461d9e42d398536055f31f58cdcd2c6347e:

  x86/efi: Re-disable interrupts after calling firmware services (2014-03-04 21:44:00 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git mixed-mode

for you to fetch changes up to 3db4cafdfd05717dc939780134e53023a3c1f15f:

  x86/boot: Fix non-EFI build (2014-03-05 10:19:07 +0000)

----------------------------------------------------------------
Matt Fleming (2):
      x86, tools: Fix up compiler warnings
      x86/boot: Fix non-EFI build

 arch/x86/boot/compressed/head_32.S | 2 ++
 arch/x86/boot/compressed/head_64.S | 3 +++
 arch/x86/boot/tools/build.c        | 7 ++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
