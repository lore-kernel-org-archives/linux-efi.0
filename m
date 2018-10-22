From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 0/2] Unmap efi boot services code/data regions after boot.
Date: Sun, 21 Oct 2018 18:35:43 -0700
Message-ID: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

CC'ing x86 folks because this patch touches x86/mm which I am no expert of.

[Copied from Patch 1]
Ideally, after kernel assumes control of the platform firmware shouldn't
access EFI Boot Services Code/Data regions. But, it's noticed that this
is not so true in many x86 platforms. Hence, during boot, kernel
reserves efi boot services code/data regions [1] and maps [2] them to
efi_pgd so that call to set_virtual_address_map() doesn't fail. After
returning from set_virtual_address_map(), kernel frees the reserved
regions [3] but they still remain mapped.

This means that any code that's running in efi_pgd address space (e.g:
any efi runtime service) would still be able to access efi boot services
code/data regions but the contents of these regions would have long been
over written by someone else as they are freed by efi_free_boot_services().
So, it's important to unmap these regions. After unmapping boot services
code/data regions, any illegal access by buggy firmware to these regions
would result in page fault which will be handled by efi specific fault
handler.

[1] Please see efi_reserve_boot_services()
[2] Please see efi_map_region() -> __map_region()
[3] Please see efi_free_boot_services()

Testing the patch set:
----------------------
1. Download buggy firmware (which accesses boot regions even after kernel has
booted) from here [1].
2. Without the patch set, you shouldn't see any kernel warning/error
messages (i.e. kernel allows accesses to efi boot services code/data
regions even after call to set_virtual_address_map()).
3. With the patch set, you should see a kernel warning about buggy
firmware, efi_rts_wq beeing freezed and disabling runtime services forever.

Please note that this patch will change kernel's existing behavior for
some efi runtime services but I think it's OK because kernel should have
never allowed those accesses in the first place.

Also please note that this patch set needs lot of real time trashing as
I just tested it out with OVMF.

Note:
-----
Patch set based on "next" branch in efi tree.

[1] https://drive.google.com/drive/folders/1VozKTms92ifyVHAT0ZDQe55ZYL1UE5wt

Sai Praneeth (2):
  x86/efi: Unmap efi boot services code/data regions from efi_pgd
  x86/efi: Move efi_<reserve/free>_boot_services() to arch/x86

 arch/x86/include/asm/efi.h           |  2 ++
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/pageattr.c               | 21 +++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |  2 ++
 arch/x86/platform/efi/quirks.c       | 26 ++++++++++++++++++++++++++
 include/linux/efi.h                  |  3 ---
 init/main.c                          |  4 ----
 7 files changed, 53 insertions(+), 7 deletions(-)

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
2.7.4
