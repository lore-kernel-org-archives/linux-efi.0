From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/2] EFI urgent fixes
Date: Tue, 31 May 2016 11:23:42 +0100
Message-ID: <1464690224-4503-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following urgent patches which fix a boot crash
when using the "noefi" parameter and the debug output on arm.

The following changes since commit 1a695a905c18548062509178b98bc91e67510864:

  Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 1f0cf3892caeab20a99c19f5523499be77b533cd:

  efi/arm: Fix the format of debug message from efi (2016-05-30 22:51:53 +0100)

----------------------------------------------------------------
 * Fix crash when booting with the "noefi" kernel parameter, caused by
   recent changes to for_each_efi_memory_desc_in_map() - Vitaly Kuznetsov

 * Unscramble the debug output on arm when efi=debug and memblock=debug
   is passed on the kernel cmdline - Dennis Chen

----------------------------------------------------------------
Dennis Chen (1):
      efi/arm: Fix the format of debug message from efi

Vitaly Kuznetsov (1):
      efi: Fix for_each_efi_memory_desc_in_map() for empty memmaps

 drivers/firmware/efi/arm-init.c | 14 ++++++--------
 include/linux/efi.h             |  2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)
