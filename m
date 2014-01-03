From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI kexec fixes
Date: Fri, 3 Jan 2014 22:31:41 +0000
Message-ID: <20140103223141.GB18441@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Peter, please pull these fixes for the EFI kexec patches sitting in
tip/x86/efi-kexec - the kbuild bot reported some build breakage.

The following changes since commit 518548abd61808ea1e31614ccbdae34d3c32dfa4:

  x86/efi: Delete superfluous global variables (2013-12-29 13:09:08 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git kexec

for you to fetch changes up to 5c12af0c41e3417e1939095325920463b5f8e726:

  x86/efi: parse_efi_setup() build fix (2014-01-03 14:38:18 +0000)

----------------------------------------------------------------
Dave Young (2):
      x86: ksysfs.c build fix
      x86/efi: parse_efi_setup() build fix

 arch/x86/include/asm/efi.h | 5 ++---
 arch/x86/kernel/ksysfs.c   | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
