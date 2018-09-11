From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V6 0/2] Add efi page fault handler to recover from page
Date: Tue, 11 Sep 2018 12:15:20 -0700
Message-ID: <1536693322-8335-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

There may exist some buggy UEFI firmware implementations that access efi
memory regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even after
the kernel has assumed control of the platform. This violates UEFI
specification. Hence, provide a efi specific page fault handler which
recovers from page faults caused by buggy firmware.

Page faults triggered by firmware happen at ring 0 and if unhandled,
hangs the kernel. So, provide an efi specific page fault handler to:
1. Avoid panics/hangs caused by buggy firmware.
2. Shout loud that the firmware is buggy and hence is not a kernel bug.

The efi page fault handler will check if the access is by
efi_reset_system().
1. If so, then the efi page fault handler will reboot the machine
   through BIOS and not through efi_reset_system().
2. If not, then the efi page fault handler will freeze efi_rts_wq and
   schedules a new process.

This issue was reported by Al Stone when he saw that reboot via EFI hangs
the machine. Upon debugging, I found that it's efi_reset_system() that's
touching memory regions which it shouldn't. To reproduce the same
behavior, I have hacked OVMF and made efi_reset_system() buggy. Along
with efi_reset_system(), I have also modified get_next_high_mono_count()
and set_virtual_address_map(). They illegally access both boot time and
other efi regions.

Testing the patch set:
----------------------
1. Download buggy firmware from here [1].
2. Run a qemu instance with this buggy BIOS and boot mainline kernel.
Add reboot=efi to the kernel command line arguments and after the kernel
is up and running, type "reboot". The kernel should hang while rebooting.
3. With the same setup, boot kernel after applying patches and the
reboot should work fine. Also please notice warning/error messages
printed by kernel.

Changes from RFC to V1:
-----------------------
1. Drop "long jump" technique of dealing with illegal access and instead
   use scheduling away from efi_rts_wq.

Changes from V1 to V2:
----------------------
1. Shortened config name to CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS from
   CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES.
2. Made the config option available only to expert users.
3. efi_free_boot_services() should be called only when
   CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS is not enabled. Previously, this
   was part of init/main.c file. As it is an architecture agnostic code,
   moved the change to arch/x86/platform/efi/quirks.c file.

Changes from V2 to V3:
----------------------
1. Drop treating illegal access to EFI_BOOT_SERVICES_<CODE/DATA> regions
   separately from illegal accesses to other regions like
   EFI_CONVENTIONAL_MEMORY or EFI_LOADER_<CODE/DATA>.
   In previous versions, illegal access to EFI_BOOT_SERVICES_<CODE/DATA>
   regions were handled by mapping requested region to efi_pgd but from
   V3 they are handled similar to illegal access to other regions i.e by
   freezing efi_rts_wq and scheduling new process.
2. Change __efi_init_fixup attribute to __efi_init.

Changes from V3 to V4:
----------------------
1. Drop saving original memory map passed by kernel. It also means less
   checks in efi page fault handler.
2. Change the config name to EFI_PAGE_FAULT_HANDLER to reflect it's
   functionality more appropriately.

Changes from V4 to V5:
----------------------
1. Drop config option that enables efi page fault handler, instead make
   it default.
2. Call schedule() in an infinite loop to account for spurious wake ups.
3. Introduce "NONE" as an efi runtime service function identifier so that
   it could be used in efi_recover_from_page_fault() to check if the page
   fault was indeed triggered by an efi runtime service.

Changes from V5 to V6:
----------------------
1. Thanks to 0-day for reporting build error when CONFIG_EFI is not
   enabled. Fixed it by calling efi page fault handler only when
   CONFIG_EFI is enabled.
2. Change return type of efi page fault handler from int to void. void
   return type should do (and int is not needed) because the efi page
   fault handler returns only upon a failure to handle page fault.

Note:
-----
Patch set based on "next" branch in efi tree.

[1] https://drive.google.com/drive/folders/1VozKTms92ifyVHAT0ZDQe55ZYL1UE5wt

Sai Praneeth (2):
  efi: Make efi_rts_work accessible to efi page fault handler
  x86/efi: Add efi page fault handler to recover from page faults caused
        by the firmware

 arch/x86/include/asm/efi.h              |  1 +
 arch/x86/mm/fault.c                     |  9 ++++
 arch/x86/platform/efi/quirks.c          | 78 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c | 61 +++++++-------------------
 include/linux/efi.h                     | 42 ++++++++++++++++++
 5 files changed, 147 insertions(+), 44 deletions(-)

Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

-- 
2.7.4
