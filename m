From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Fri, 19 Sep 2014 11:33:05 +0100
Message-ID: <20140919103305.GE18635@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi guys,

Please consider pulling the following urgent fix from Dave. It fixes an
earlyprintk=efi regression introduced in v3.16. Due to changes in the
early ACPI code we run out of early_ioremap slots when earlyprintk=efi
is specified on the command line, resulting in a hang during kernel
boot.

This patch is clearly a core x86 change, but since it is a fix for an
EFI code issue I picked it up in my urgent queue. Let me know if you'd
like to route this some other way.

The following changes since commit 0ceac9e094b065fe3fec19669740f338d3480498:

  efi/arm64: Fix fdt-related memory reservation (2014-09-09 07:51:09 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 3eddc69ffeba092d288c386646bfa5ec0fce25fd:

  x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8 (2014-09-14 15:24:31 +0100)

----------------------------------------------------------------
 * Increase the number of early_ioremap slots to fix a regression with
   earlyprintk=efi after recent changes to the ACPI code - Dave Young

----------------------------------------------------------------
Dave Young (1):
      x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

 arch/x86/include/asm/fixmap.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
