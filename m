From: Matt Fleming <matt@console-pimps.org>
Subject: [GIT PULL] EFI fixes for v3.10
Date: Fri, 19 Apr 2013 18:38:48 +0100
Message-ID: <51718128.7010405@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi guys,

There's a few bug fixes sitting in the EFI urgent branch. Please
consider pulling.

The following changes since commit ca0ba26fbbd2d81c43085df49ce0abfe34535a90:

  efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE (2013-03-22 20:08:01 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git urgent

for you to fetch changes up to 8c58bf3eec3b8fc8162fe557e9361891c20758f2:

  x86,efi: Implement efi_no_storage_paranoia parameter (2013-04-17 15:13:38 +0100)

----------------------------------------------------------------
Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Matthew Garrett (3):
      Move utf16 functions to kernel core and rename
      efi: Pass boot services variable info to runtime code
      efi: Distinguish between "remaining space" and actually used space

Richard Weinberger (2):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter

Sergey Vlasov (2):
      x86/Kconfig: Make EFI select UCS2_STRING
      efi: Export efi_query_variable_store() for efivars.ko

 Documentation/kernel-parameters.txt   |   6 ++
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/compressed/eboot.c      |  47 ++++++++++
 arch/x86/include/asm/efi.h            |   7 ++
 arch/x86/include/uapi/asm/bootparam.h |   1 +
 arch/x86/platform/efi/efi.c           | 168 +++++++++++++++++++++++++++++++++-
 drivers/firmware/Kconfig              |   1 +
 drivers/firmware/efivars.c            |  98 +++++---------------
 include/linux/efi.h                   |   9 +-
 include/linux/ucs2_string.h           |  14 +++
 lib/Kconfig                           |   3 +
 lib/Makefile                          |   2 +
 lib/ucs2_string.c                     |  51 +++++++++++
 13 files changed, 325 insertions(+), 83 deletions(-)
 create mode 100644 include/linux/ucs2_string.h
 create mode 100644 lib/ucs2_string.c

-- 
Matt Fleming, Intel Open Source Technology Center
