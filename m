From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/8] efi: add support for non-standard capsule headers
Date: Wed,  5 Apr 2017 10:23:09 +0100
Message-ID: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a followup to Jan's series [0] to add support for the non-standard
and awkward capsule header layout that is used by the Quark platform.

While we would prefer to adhere to the standard rigorously, the reality
(and common practice) in Linux is that we sometimes have to deal with
quirks. So while Jan's aim is to get Quark to work, the reason for my
involvement is to try and accommodate this in a flexible way without
putting any handling specific to this quirk in the common code.

Patches #1 to #4 are minor preparatory cleanups.

Patch #5 reworks the capsule loader code to use a cached copy of the
header rather than load it from memory multiple times (which may involve
a kmap/kunmap sequence if it is in highmem). This also allows some mangling
to be performed by quirks code.

Patch #6 splits up efi_capsule_setup_info() into a primary part called
__efi_capsule_setup_info(), and a __weak wrapper under the original name,
allowing it to be overridden externally.

Patch #7 changes the array of struct page pointers maintained by the capsule
loader into an array of physical addresses. This allows special versions of
efi_capsule_setup_info() to mangle the contents of the capsule (and skip
headers by moving pointers around) without putting any intimate knowledge
of the quirks handling into the common code.

Patch #8 is Jan's original patch to add the Quark specific quirk to arch/x86,
but reworked to take advantage of the facilities added in #6 and #7.

This has been tested by Jan on Quark, but this needs testing on other
platforms to ensure that the common code still works as expected on
conforming firmware implementations.

Ard Biesheuvel (3):
  efi/capsule-loader: use cached copy of capsule header
  efi/capsule-loader: indirect calls to efi_capsule_setup_info via weak
    alias
  efi/capsule-loader: use page addresses rather than struct page
    pointers

Jan Kiszka (5):
  efi/capsule: Fix return code on failing kmap/vmap
  efi/capsule: Remove pr_debug on ENOMEM or EFAULT
  efi/capsule: Clean up pr_err/info messages
  efi/capsule: Adjust return type of efi_capsule_setup_info
  efi/capsule: Add support for Quark security header

 arch/x86/platform/efi/quirks.c        | 112 ++++++++++++++++++++
 drivers/firmware/efi/Kconfig          |   9 ++
 drivers/firmware/efi/capsule-loader.c | 111 ++++++++-----------
 drivers/firmware/efi/capsule.c        |   7 +-
 include/linux/efi.h                   |  14 ++-
 5 files changed, 184 insertions(+), 69 deletions(-)

-- 
2.9.3
