From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 0/2] Unmap EFI boot services code/data regions after boot.
Date: Fri, 26 Oct 2018 14:38:43 -0700
Message-ID: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

CC'ing x86 folks because this patch touches x86/mm which I am no expert of.

[Copied from Patch 1]
Ideally, after kernel assumes control of the platform, firmware shouldn't access
EFI boot services code/data regions. But, it's noticed that this is not so true
in many x86 platforms. Hence, during boot, kernel reserves EFI boot services
code/data regions [1] and maps [2] them to efi_pgd so that call to
set_virtual_address_map() doesn't fail. After returning from
set_virtual_address_map(), kernel frees the reserved regions [3] but they still
remain mapped.

This means that any code that's running in efi_pgd address space (e.g: any EFI
runtime service) would still be able to access EFI boot services code/data
regions but the contents of these regions would have long been over written by
someone else as they are freed by efi_free_boot_services(). So, it's important
to unmap these regions. After unmapping EFI boot services code/data regions, any
illegal access by buggy firmware to these regions would result in page fault
which will be handled by efi specific fault handler.

Unmapping EFI boot services code/data regions will result in clearing
PAGE_PRESENT bit and it shouldn't bother L1TF cases because it's already handled
by protnone_mask() at arch/x86/include/asm/pgtable-invert.h.

[1] Please see efi_reserve_boot_services()
[2] Please see efi_map_region() -> __map_region()
[3] Please see efi_free_boot_services()

Testing the patch set:
----------------------
1. Download buggy firmware (which accesses boot regions even after kernel has
booted) from here [1].
2. Without the patch set, you shouldn't see any kernel warning/error messages
(i.e. kernel allows accesses to EFI boot services code/data regions even after
call to set_virtual_address_map()).
3. With the patch set, you should see a kernel warning about buggy firmware,
efi_rts_wq beeing freezed and disabling runtime services forever.

Please note that this patch will change kernel's existing behavior for some EFI
runtime services but I think it's OK because kernel should have never allowed
those accesses in the first place.

Also please note that this patch set needs lot of real time trashing as I just
tested it out with OVMF.

Note:
-----
Patch set based on "next" branch in efi tree.

Changes from V1 -> v2:
----------------------
1. Rewrite the cpa initializer in a more readable fashion.
2. Don't use cpa->pfn while unmapping, as it's not useful.
3. Unmap regions before freeing them up.
4. Fix spelling nits.

Sai Praneeth (2):
  x86/efi: Unmap EFI boot services code/data regions from efi_pgd
  x86/efi: Move efi_<reserve/free>_boot_services() to arch/x86

 arch/x86/include/asm/efi.h           |  2 ++
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/pageattr.c               | 26 ++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |  2 ++
 arch/x86/platform/efi/quirks.c       | 25 +++++++++++++++++++++++++
 include/linux/efi.h                  |  3 ---
 init/main.c                          |  4 ----
 7 files changed, 57 insertions(+), 7 deletions(-)

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

-- 
2.19.1
