From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/5] EFI urgent fixes
Date: Fri, 26 May 2017 12:36:46 +0100
Message-ID: <20170526113652.21339-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frank Ramsay <frank.ramsay-ZPxbGqLxI0U@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lee Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi folks,

Please pull the following fixes. There are patches that resolve a few
boot crashes and some minor build and boot log cleanups.

The following changes since commit 08332893e37af6ae779367e78e444f8f9571511d:

  Linux 4.12-rc2 (2017-05-21 19:30:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 5d36982a80248b2dcce395e7fa4ba342e814ced1:

  efi/bgrt: Skip efi_bgrt_init in case of non-efi boot (2017-05-26 11:27:38 +0100)

----------------------------------------------------------------
 - Make the boot console quiet when using Xen on EFI by deleting a
   pointless error message - Juergen Gross

 - Silence harmless warnings emitted with GCC 7 - Arnd Bergmann

 - Prevent a crash when booting kexec with the efi=old_map kernel
   command line parameter by disabling EFI runtime services - Sai Praneeth

 - Fix boot crash when using kaslr and efi=old_map. The crash is
   caused because of assumptions about PAGE_OFFSET alignment which are
   not true with kaslr enabled - Baoquan He

 - Fix boot regression when a machine has an ACPI BGRT table and is
   booted using BIOS, not EFI.  - Dave Young

----------------------------------------------------------------
Arnd Bergmann (1):
      efi: Remove duplicate 'const' specifiers

Baoquan He (1):
      x86/efi: Correct ident mapping of efi old_map when kalsr enabled

Dave Young (1):
      efi/bgrt: Skip efi_bgrt_init in case of non-efi boot

Juergen Gross (1):
      efi: Don't issue error message when booted under xen

Sai Praneeth (1):
      x86/efi: Disable runtime services on kexec kernel if booted with efi=old_map

 arch/x86/platform/efi/efi.c               |  6 ++-
 arch/x86/platform/efi/efi_64.c            | 79 +++++++++++++++++++++++++++----
 arch/x86/platform/efi/quirks.c            |  3 ++
 drivers/firmware/efi/efi-bgrt.c           |  3 ++
 drivers/firmware/efi/libstub/secureboot.c |  4 +-
 5 files changed, 83 insertions(+), 12 deletions(-)
