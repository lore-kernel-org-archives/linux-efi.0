From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 00/10] efi: Constify all the things
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Artur Paszkiewicz <artur.paszkiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When disassembling the EFI stub I noticed that GUIDs and efi_char16_t
strings are not placed in rodata but generated on the stack at runtime.
GUIDs occupy up to 80 bytes of text instead of just 16 bytes rodata
which annoyed me enough to go down the rabbit hole of fixing it.
This series constifies all GUIDs and EFI-related strings I could find.

The most important patch is [10/10] to constify the EFI_GUID() macro.
This has to be at the end of the series to avoid compiler warnings.
Reviewers may want to read its commit message first as it contains
background information.  In particular it explains why this series
only fixes the kernel side of things.  Additional work is necessary
on the compiler side to actually have all the GUIDs and strings in
rodata.  At the moment both gcc and clang achieve that only partially.

Ard Biesheuvel expressed an interest in these patches in November but
stressed the importance that arguments to EFI boot/runtime/protocol
services may only be declared const if the spec marks them "IN":
https://lkml.org/lkml/2016/11/21/459

Hence I've split the series by boot/runtime/protocol services to allow
for easy verification of this fact.  Constification of GetVariable() /
SetVariable() is further split in one patch for the function signatures
and another for the actual arguments because changing the function
signatures is quite involved in this case.

efi.git/next needs to be rebased on v4.10-rc1 before this series can be
applied because it requires commits f6697df36bdf ("x86/efi: Prevent mixed
mode boot corruption with CONFIG_VMAP_STACK=y") and 2fbadc3002c5
("arm/arm64: xen: Move shared architecture headers to include/xen/arm").

Unfortunately I was not able to compile-test on ia64, there's no cross-
compiler package available on Debian. :-(  I did not receive complaints
from 0-day, so I'm cautiously optimistic that I didn't cause breakage
there.

I've pushed the patches to GitHub to ease reviewing/fetching:
https://github.com/l1k/linux/commits/efi_const_v1

Thanks,

Lukas


Ard Biesheuvel (1):
  efi: use typed function pointers for runtime services table

Lukas Wunner (9):
  efi: Constify GetVariable() / SetVariable() signatures
  efi: Constify GetVariable() / SetVariable() arguments
  efi: Constify HandleProtocol() / LocateHandle() / LocateProtocol()
  efi: Constify InstallConfigurationTable()
  efi: Constify EFI_FILE_PROTOCOL.GetInfo()
  efi: Constify EFI_RNG_PROTOCOL.GetRNG()
  efi: Constify EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString()
  efi: Constify efi_guidcmp() arguments
  uuid: Constify UUID compound literals

 arch/ia64/kernel/efi.c                         | 24 ++++------
 arch/x86/boot/compressed/eboot.c               | 50 ++++++++++-----------
 arch/x86/include/asm/xen/interface.h           |  1 +
 arch/x86/platform/efi/efi_64.c                 | 18 ++++----
 arch/x86/platform/efi/quirks.c                 |  2 +-
 drivers/firmware/efi/efi-pstore.c              | 10 ++---
 drivers/firmware/efi/efibc.c                   |  3 +-
 drivers/firmware/efi/libstub/arm-stub.c        | 17 +++----
 drivers/firmware/efi/libstub/arm32-stub.c      |  2 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  7 ++-
 drivers/firmware/efi/libstub/efistub.h         |  2 +-
 drivers/firmware/efi/libstub/fdt.c             |  3 +-
 drivers/firmware/efi/libstub/gop.c             | 12 +++--
 drivers/firmware/efi/libstub/random.c          | 16 +++----
 drivers/firmware/efi/runtime-wrappers.c        | 15 ++++---
 drivers/firmware/google/gsmi.c                 | 10 ++---
 drivers/infiniband/hw/hfi1/efivar.c            |  6 +--
 drivers/scsi/isci/probe_roms.c                 |  2 +-
 drivers/xen/efi.c                              | 12 ++---
 include/linux/efi.h                            | 61 ++++++++++++++------------
 include/uapi/linux/uuid.h                      |  4 +-
 include/xen/arm/interface.h                    |  1 +
 include/xen/interface/platform.h               | 11 ++++-
 include/xen/xen-ops.h                          | 12 ++---
 24 files changed, 143 insertions(+), 158 deletions(-)

-- 
2.11.0
