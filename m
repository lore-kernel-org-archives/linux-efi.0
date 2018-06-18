From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2] x86/efi: Free allocated memory if remap fails
Date: Mon, 18 Jun 2018 12:36:54 -0700
Message-ID: <1529350614-15555-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

efi_memmap_alloc(), as the name suggests, allocates memory for a new efi
memory map. It's referenced from couple of places, namely,
efi_arch_mem_reserve() and efi_free_boot_services(). These callers,
after allocating memory, remap it for further use. As usual, a routine
check is performed to confirm successful remap. If the remap fails,
ideally, the allocated memory should be freed but presently we just
return without freeing it up. Hence, fix this bug by freeing up the
memory appropriately.

As efi_memmap_alloc() allocates memory depending on whether mm_init()
has already been invoked or not, similarly, while freeing use
memblock_free() to free memory allocated before invoking mm_init() and
__free_pages() to free memory allocated after invoking mm_init().

It's a fact that memremap() and early_memremap() might never fail and
this code might never get a chance to run but to maintain good kernel
programming semantics, we might need this patch.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

I found this bug when working on a different patch set which uses
efi_memmap_alloc() and then noticed that I never freed the allocated
memory. I found it weird, in the sense that, memory is allocated but is
not freed (upon returning from an error). So, wasn't sure if that should
be treated as a bug or should I just leave it as is because everything
works fine even without this patch. Since the effort for the patch is
very minimal, I just went ahead and posted one, so that I could know
your thoughts on it.

Changes from V1 to V2:
----------------------
1. Fix the bug of freeing memory map that was just installed by correctly
    calling free_pages().
2. Call memblock_free() and __free_pages() directly from the appropriate
    places instead of efi_memmap_free().

Note: Patch based on Linus's mainline tree V4.18-rc1

 arch/x86/platform/efi/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 36c1f8b9f7e0..cfa93af97def 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -285,6 +285,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 	new = early_memremap(new_phys, new_size);
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
+		memblock_free(new_phys, new_size);
 		return;
 	}
 
@@ -429,6 +430,7 @@ void __init efi_free_boot_services(void)
 	new = memremap(new_phys, new_size, MEMREMAP_WB);
 	if (!new) {
 		pr_err("Failed to map new EFI memmap\n");
+		__free_pages(pfn_to_page(PHYS_PFN(new_phys)), get_order(new_size));
 		return;
 	}
 
@@ -452,6 +454,7 @@ void __init efi_free_boot_services(void)
 
 	if (efi_memmap_install(new_phys, num_entries)) {
 		pr_err("Could not install new EFI memmap\n");
+		__free_pages(pfn_to_page(PHYS_PFN(new_phys)), get_order(new_size));
 		return;
 	}
 }
-- 
2.7.4
