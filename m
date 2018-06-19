From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V2] x86/efi: Free allocated memory if remap fails
Date: Tue, 19 Jun 2018 09:21:28 +0200
Message-ID: <CAKv+Gu-yeXwLjd1Sp0jc41-9zVFOuxSBqMiHkivTLmT-u3Upjg@mail.gmail.com>
References: <1529350614-15555-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529350614-15555-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 18 June 2018 at 21:36, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> efi_memmap_alloc(), as the name suggests, allocates memory for a new efi
> memory map. It's referenced from couple of places, namely,
> efi_arch_mem_reserve() and efi_free_boot_services(). These callers,
> after allocating memory, remap it for further use. As usual, a routine
> check is performed to confirm successful remap. If the remap fails,
> ideally, the allocated memory should be freed but presently we just
> return without freeing it up. Hence, fix this bug by freeing up the
> memory appropriately.
>
> As efi_memmap_alloc() allocates memory depending on whether mm_init()
> has already been invoked or not, similarly, while freeing use
> memblock_free() to free memory allocated before invoking mm_init() and
> __free_pages() to free memory allocated after invoking mm_init().
>
> It's a fact that memremap() and early_memremap() might never fail and
> this code might never get a chance to run but to maintain good kernel
> programming semantics, we might need this patch.
>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Lee Chun-Yi <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>
> I found this bug when working on a different patch set which uses
> efi_memmap_alloc() and then noticed that I never freed the allocated
> memory. I found it weird, in the sense that, memory is allocated but is
> not freed (upon returning from an error). So, wasn't sure if that should
> be treated as a bug or should I just leave it as is because everything
> works fine even without this patch. Since the effort for the patch is
> very minimal, I just went ahead and posted one, so that I could know
> your thoughts on it.
>
> Changes from V1 to V2:
> ----------------------
> 1. Fix the bug of freeing memory map that was just installed by correctly
>     calling free_pages().
> 2. Call memblock_free() and __free_pages() directly from the appropriate
>     places instead of efi_memmap_free().
>
> Note: Patch based on Linus's mainline tree V4.18-rc1
>
>  arch/x86/platform/efi/quirks.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 36c1f8b9f7e0..cfa93af97def 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -285,6 +285,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>         new = early_memremap(new_phys, new_size);
>         if (!new) {
>                 pr_err("Failed to map new boot services memmap\n");
> +               memblock_free(new_phys, new_size);
>                 return;
>         }
>
> @@ -429,6 +430,7 @@ void __init efi_free_boot_services(void)
>         new = memremap(new_phys, new_size, MEMREMAP_WB);
>         if (!new) {
>                 pr_err("Failed to map new EFI memmap\n");
> +               __free_pages(pfn_to_page(PHYS_PFN(new_phys)), get_order(new_size));
>                 return;
>         }
>
> @@ -452,6 +454,7 @@ void __init efi_free_boot_services(void)
>
>         if (efi_memmap_install(new_phys, num_entries)) {
>                 pr_err("Could not install new EFI memmap\n");
> +               __free_pages(pfn_to_page(PHYS_PFN(new_phys)), get_order(new_size));
>                 return;
>         }
>  }
> --
> 2.7.4
>

Thank you Sai.

But this is not really what I meant.

How about we modify efi_memmap_alloc() like this

@@ -39,10 +39,12 @@ static phys_addr_t __init
__efi_memmap_alloc_late(unsigned long size)
  * Returns the physical address of the allocated memory map on
  * success, zero on failure.
  */
-phys_addr_t __init efi_memmap_alloc(unsigned int num_entries)
+phys_addr_t __init efi_memmap_alloc(unsigned int num_entries, bool *late)
 {
        unsigned long size = num_entries * efi.memmap.desc_size;

+       if (late)
+               *late = slab_is_available();
        if (slab_is_available())
                return __efi_memmap_alloc_late(size);

and introduce efi_memmap_free() as before, but pass it the 'late'
parameter you received from efi_memmap_alloc(). That way, it is the
caller's job to take care of this.

Also, it seems to me that efi_arch_mem_reserve() leaks the old memory
map every time you create a new one, no? That is a separate issue that
you may want to look into, but it affects the design of this API as
well.
