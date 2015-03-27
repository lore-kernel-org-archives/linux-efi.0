From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI changes for v4.1
Date: Fri, 27 Mar 2015 19:16:51 +0000
Message-ID: <20150327191651.GB5801@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Folks,

Please pull the following changes for v4.1.

I rebased my branch on v4.0-rc3 since there were some DMI changes that
caused conflicts when merging. If you want me to base the tree or
something else, just let me know.

The following changes since commit 9eccca0843205f87c00404b663188b88eb248051:

  Linux 4.0-rc3 (2015-03-08 16:09:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 9a14ed32da1efe7e5ecc02eeeed756e63fecf2c1:

  efi/libstub: Retrieve FDT size when loaded from UEFI config table (2015-03-26 14:00:17 +0000)

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/libstub: Retrieve FDT size when loaded from UEFI config table

Borislav Petkov (1):
      x86/efi: Add a "debug" option to the efi= cmdline

Ingo Molnar (2):
      efi: Disable interrupts around EFI calls, not in the epilog/prolog calls
      efi: Clean up the efi_call_phys_[prolog|epilog]() save/restore interaction

Ivan Khoronzhuk (2):
      firmware: dmi_scan: Use full dmi version for SMBIOS3
      firmware: dmi_scan: Use direct access to static vars

Yinghai Lu (1):
      x86, boot: Allow 64bit EFI kernel to be loaded above 4G

 Documentation/kernel-parameters.txt     |  3 ++-
 Documentation/x86/boot.txt              | 18 ++++++++++++++++
 arch/x86/boot/compressed/eboot.c        | 15 ++++++++-----
 arch/x86/boot/compressed/head_64.S      |  7 ++++++-
 arch/x86/boot/header.S                  |  3 ++-
 arch/x86/include/asm/efi.h              |  6 ++++--
 arch/x86/include/uapi/asm/bootparam.h   |  1 +
 arch/x86/kernel/asm-offsets.c           |  1 +
 arch/x86/platform/efi/efi.c             | 17 ++++++++++++---
 arch/x86/platform/efi/efi_32.c          | 22 ++++++++++----------
 arch/x86/platform/efi/efi_64.c          | 29 ++++++++++++++------------
 drivers/firmware/dmi_scan.c             | 37 +++++++++++++++++++--------------
 drivers/firmware/efi/libstub/arm-stub.c |  7 +++----
 drivers/firmware/efi/libstub/efistub.h  |  2 +-
 drivers/firmware/efi/libstub/fdt.c      |  7 ++++++-
 include/linux/efi.h                     |  1 +
 16 files changed, 117 insertions(+), 59 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
