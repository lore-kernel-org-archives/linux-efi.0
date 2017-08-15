From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 0/3] Use mm_struct and switch_mm() instead of manually
Date: Tue, 15 Aug 2017 12:18:23 -0700
Message-ID: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jlee@suse.com, bp@alien8.de, luto@kernel.org, mst@redhat.com, ricardo.neri@intel.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, ravi.v.shankar@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, in x86, to invoke any efi function like
efi_set_virtual_address_map() or any efi_runtime_service() the code path
typically involves read_cr3() (save previous pgd), write_cr3()
(write efi_pgd) and calling efi function. Likewise after returning from
efi function the code path typically involves read_cr3() (save efi_pgd),
write_cr3() (write previous pgd). We do this couple of times in efi
subsystem of Linux kernel, so we can use a function (efi_switch_mm())
to do this. This improves readability and maintainability. Also, instead
of maintaining a separate struct "efi_scratch" to store/restore efi_pgd,
we can use mm_struct to do this.

I have tested this patch set against LUV, so I think I didn't break
any existing configurations. I have tested this patch set for
1. x86_64,
2. x86_32,
3. Mixed mode
with efi=old_map and for kexec kernel. Please let me know if I have
missed any other configurations.

Special thanks to Matt for his initial review.

Matt,
I have implemented efi_switch_mm() in "arch/x86/platform/efi/efi_64.c"
because it's used only by x86_64. Please let me know if you think it
should be in "drivers/firmware/efi/efi.c"

Andy and Michael,
As I am twiddling with memory management for the first time and I think
you are mm experts, could you please review efi_switch_mm() function
in "x86/efi: Use efi_switch_mm() rather than manually twiddling with cr3"

Sai Praneeth (3):
  efi: Use efi_mm in x86 as well as ARM
  x86/efi: Replace efi_pgd with efi_mm.pgd
  x86/efi: Use efi_switch_mm() rather than manually twiddling with cr3

 arch/x86/include/asm/efi.h           | 30 +++++++++----------
 arch/x86/platform/efi/efi_64.c       | 57 ++++++++++++++++++++++--------------
 arch/x86/platform/efi/efi_thunk_64.S |  2 +-
 drivers/firmware/efi/arm-runtime.c   |  9 ------
 drivers/firmware/efi/efi.c           |  9 ++++++
 include/linux/efi.h                  |  2 ++
 6 files changed, 62 insertions(+), 47 deletions(-)

-- 
2.1.4
