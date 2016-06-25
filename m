From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/7] EFI changes for v4.8
Date: Sat, 25 Jun 2016 08:20:23 +0100
Message-ID: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks, please pull the v4.8 EFI queue. Included are some cleanups and
fixes for SGI/UV BIOS calls.

The following changes since commit 5edb56491d4812c42175980759da53388e5d86f5:

  Linux 4.7-rc3 (2016-06-12 07:20:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to bc6e082f7a4bec4efde100b5b6528f5a2ea82106:

  x86/efi: Remove unused efi_get_time function (2016-06-23 14:32:14 +0100)

----------------------------------------------------------------
 * Improve error messages in the efibc driver by providing more
   information about why the errors occurred - Jeremy Compostella

 * Document the formatting of the EFI GUID constants - Peter Jones

 * Remove an unused variable to fix a clang build warning - Colin King

 * Refactor the EFI runtime services code so that it can be used for
   function pointers outside of efi.systab->runtime, e.g. during
   SGI/UV BIOS and EFI mixed mode calls - Alex Thorlton

 * Remove the unused efi_get_time() function which also suffers from
   the 32-bit time_t overflow in 2038 issue - Arnd Bergmann

----------------------------------------------------------------
Alex Thorlton (3):
      efi: Convert efi_call_virt to efi_call_virt_pointer
      x86/uv: Update uv_bios_call to use efi_call_virt_pointer
      x86/efi: Update efi_thunk to use the the arch_efi_call_virt* macros

Arnd Bergmann (1):
      x86/efi: Remove unused efi_get_time function

Colin Ian King (1):
      x86/efi: Remove unused variable efi

Compostella, Jeremy (1):
      efibc: Report more information in the error messages

Peter Jones (1):
      efi: Document #define FOO_PROTOCOL_GUID layout

 arch/arm/include/asm/efi.h              |  4 +-
 arch/arm64/include/asm/efi.h            |  4 +-
 arch/x86/boot/compressed/eboot.c        |  2 -
 arch/x86/include/asm/efi.h              |  9 ++---
 arch/x86/platform/efi/efi.c             | 15 -------
 arch/x86/platform/efi/efi_64.c          | 11 ++----
 arch/x86/platform/uv/bios_uv.c          |  3 +-
 drivers/firmware/efi/efibc.c            |  6 ++-
 drivers/firmware/efi/runtime-wrappers.c | 53 +++++--------------------
 include/linux/efi.h                     | 69 ++++++++++++++++++++++++++++++++-
 10 files changed, 93 insertions(+), 83 deletions(-)
