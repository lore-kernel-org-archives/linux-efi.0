From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL v2 0/6] EFI urgent fixes
Date: Mon,  5 Sep 2016 15:42:31 +0100
Message-ID: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Jan Beulich <jbeulich@suse.com>, Jeffrey Hugo <jhugo@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Leif Lindholm <leif.lindholm@linaro.org>, lists@ssl-mail.com, Marek Szyprowski <m.szyprowski@samsung.com>, Mark Rutland <mark.rutland@arm.com>, Shawn Lin <shawn.lin@rock-chips.com>, stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
List-Id: linux-efi@vger.kernel.org

Folks, this is v2 of this pull request. Ingo's comments have been
addressed and new patches have been spun. Also now rebased against
v4.8-rc5.

Please pull the following urgent fixes, which prevent an infinite loop
on Xen, a boot failure on Qualcomm platforms and a data type bug in
the fdt code.

The following changes since commit c6935931c1894ff857616ff8549b61236a19148f:

  Linux 4.8-rc5 (2016-09-04 14:31:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to d64934019f6cc39202e2f78063709f61ca5cb364:

  x86/efi: Use efi_exit_boot_services() (2016-09-05 12:40:16 +0100)

----------------------------------------------------------------
 * Make for_each_efi_memory_desc_in_map() safe on Xen and prevent an
   infinte loop - Jan Beulich

 * Fix boot error on arm64 Qualcomm platforms by refactoring and
   improving the ExitBootServices() hack we already for x86 and moving
   it to the libstub - Jeffrey Hugo

 * Use correct return data type for of_get_flat_dt_subnode_by_name()
   so that we correctly handle errors - Andrzej Hajda

----------------------------------------------------------------
Andrzej Hajda (1):
      efi: Fix handling error value in fdt_find_uefi_params

Jan Beulich (1):
      efi: Make for_each_efi_memory_desc_in_map() cope with running on Xen

Jeffrey Hugo (4):
      efi/libstub: Allocate headspace in efi_get_memory_map()
      efi/libstub: Introduce ExitBootServices helper
      efi/libstub: Use efi_exit_boot_services() in FDT
      x86/efi: Use efi_exit_boot_services()

 arch/x86/boot/compressed/eboot.c               | 134 ++++++++++----------
 drivers/firmware/efi/efi.c                     |   7 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 169 ++++++++++++++++++++-----
 drivers/firmware/efi/libstub/fdt.c             |  54 +++++---
 drivers/firmware/efi/libstub/random.c          |  12 +-
 include/linux/efi.h                            |  27 +++-
 6 files changed, 283 insertions(+), 120 deletions(-)
