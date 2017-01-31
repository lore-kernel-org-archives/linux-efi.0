From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/10] EFI updates for v4.11
Date: Tue, 31 Jan 2017 13:21:32 +0000
Message-ID: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Colin Ian King <colin.king@canonical.com>, Dave Young <dyoung@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, "Lee, Chun-Yi" <jlee@suse.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, Matt Fleming <matt@codeblueprint.co.uk>, Nicolai Stange <nicstange@gmail.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ravi Shankar <ravi.v.shankar@intel.com>, Ricardo Neri <ricardo.neri@intel.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 49def1853334396f948dcb4cedb9347abb318df5:

  Linux 4.10-rc4 (2017-01-15 16:21:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 39d6b56c4c2a41cf4d11c720c05c1396b74920a0:

  efi: libstub: Preserve .debug sections after absolute relocation check (2017-01-31 13:11:19 +0000)

NOTE: the BGRT patch touches drivers/acpi, but lacks an ack from the ACPI
      maintainers. They have been cc'ed on the patch (and on this pull
      request).

----------------------------------------------------------------
* Wire up the UEFI memory attributes table for x86. This eliminates any
  runtime memory regions that are both writable and executable on recent
  firmware versions. (Sai Praneeth)

* Move the BGRT init code to an earlier stage so that we can still use
  efi_mem_reserve() (Dave Young)

* Preserve debug symbols in the ARM/arm64 UEFI stub (Ard)

* Some deduplication work and various other cleanups

----------------------------------------------------------------
Ard Biesheuvel (2):
      efi: Use typed function pointers for runtime services table
      efi: libstub: Preserve .debug sections after absolute relocation check

Colin Ian King (1):
      efi/esrt: Fix spelling mistake "doen't"

Dave Young (2):
      efi/x86: Move EFI BGRT init code to early init code
      efi/x86: Add debug code to print cooked memmap

Lukas Wunner (2):
      efi: Deduplicate efi_file_size() / _read() / _close()
      x86/efi: Deduplicate efi_char16_printk()

Sai Praneeth (3):
      efi: Make EFI_MEMORY_ATTRIBUTES_TABLE initialization common across all architectures
      efi: Introduce EFI_MEM_ATTR bit and set it from memory attributes table
      x86/efi: Add support for EFI_MEMORY_ATTRIBUTES_TABLE

 arch/x86/boot/compressed/eboot.c               | 174 +------------------------
 arch/x86/kernel/acpi/boot.c                    |   9 ++
 arch/x86/platform/efi/efi-bgrt.c               |  59 ++++-----
 arch/x86/platform/efi/efi.c                    |  10 +-
 arch/x86/platform/efi/efi_64.c                 |  64 +++++++--
 drivers/acpi/bgrt.c                            |  28 ++--
 drivers/firmware/efi/arm-init.c                |   1 -
 drivers/firmware/efi/efi.c                     |   2 +
 drivers/firmware/efi/esrt.c                    |   2 +-
 drivers/firmware/efi/libstub/Makefile          |  24 ++--
 drivers/firmware/efi/libstub/arm-stub.c        |  69 ----------
 drivers/firmware/efi/libstub/efi-stub-helper.c |  63 +++++++++
 drivers/firmware/efi/libstub/efistub.h         |   8 --
 drivers/firmware/efi/memattr.c                 |   6 +-
 include/linux/efi-bgrt.h                       |  11 +-
 include/linux/efi.h                            |  45 +++----
 init/main.c                                    |   1 -
 17 files changed, 230 insertions(+), 346 deletions(-)
