From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] arm64: efi: always map runtime services code and data
 regions down to pages
Date: Fri, 22 Jul 2016 18:45:24 +0200
Message-ID: <CAKv+Gu9qE1wezDn+uF8AVR=2eHormcSQO_6TPiRF=h8KhC4p7g@mail.gmail.com>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
 <1467204690-10790-3-git-send-email-ard.biesheuvel@linaro.org>
 <64a731b2-1ddb-78f5-fd02-204f19f0a432@arm.com> <CAKv+Gu_62V1Ww5UEJd3KP+TRj_kw3PW+wZaxQDnn-0ookLBBDg@mail.gmail.com>
 <fa285509-2135-43a9-439b-256d4667be05@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fa285509-2135-43a9-439b-256d4667be05-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suzuki K Poulose <Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org>
Cc: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 July 2016 at 18:36, Suzuki K Poulose <Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org> wrote:
> On 22/07/16 17:27, Ard Biesheuvel wrote:
>>
>> On 22 July 2016 at 16:30, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org> wrote:
>>>
>>> Hi Ard,
>>>
>>> On 29/06/16 13:51, Ard Biesheuvel wrote:
>>>>
>>>>
>>>> To avoid triggering diagnostics in the MMU code that are finicky about
>>>> splitting block mappings into more granular mappings, ensure that
>>>> regions
>>>> that are likely to appear in the Memory Attributes table as well as the
>>>> UEFI memory map are always mapped down to pages. This way, we can use
>>>> apply_to_page_range() instead of create_pgd_mapping() for the second
>>>> pass,
>>>> which cannot split or merge block entries, and operates strictly on
>>>> PTEs.
>>>>
>>>> Note that this aligns the arm64 Memory Attributes table handling code
>>>> with
>>>> the ARM code, which already uses apply_to_page_range() to set the strict
>>>> permissions.
>>>>
>>>
>>> This patch is merged in arm64/for-next/core now and when I try that
>>> branch with defconfig + CONFIG_PROVE_LOCKING, I get the following splat
>>> on boot and it fails to boot further on Juno.
>>>
>>> I could bisect that to this patch(Commit bd264d046aad ("arm64: efi:
>>> always map runtime services code and data regions down to pages") in
>>> that branch)
>>>
>>
>> Hi Sudeep,
>>
>> I can reproduce this on QEMU as well. It appears that
>> apply_to_page_range() expects pages containing translation tables to
>> have their per-page spinlock initialized if they are not part of
>> init_mm.
>>
>> This
>>
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -272,6 +272,7 @@ static phys_addr_t late_pgtable_alloc(void)
>>  {
>>         void *ptr = (void *)__get_free_page(PGALLOC_GFP);
>>         BUG_ON(!ptr);
>> +       BUG_ON(!pgtable_page_ctor(virt_to_page(ptr)));
>>
>>         /* Ensure the zeroed page is visible to the page table walker */
>>         dsb(ishst);
>>
>> makes the problem go away for me (just as a temporary hack) but I will
>> try to come up with something more appropriate, and check if ARM has
>> the same issue (since it uses apply_to_page_range() as well)
>>
>
> Ard,
>
> I took a quick look at it. Looks like we don't initialise the page-table
> pages allocated via late_pgtable_alloc. Since we allocate it for an mm !=
> init_mm,
> the lock validator comes into picture and finds a lock which is not
> initialised.
> The following patch fixes the issue. But is not a perfect one. May need to
> polish it
> a little bit.
>
> ----8>----
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index a96a241..d312667 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -270,12 +270,12 @@ static void __create_pgd_mapping(pgd_t *pgdir,
> phys_addr_t phys,
>   static phys_addr_t late_pgtable_alloc(void)
>  {
> -       void *ptr = (void *)__get_free_page(PGALLOC_GFP);
> -       BUG_ON(!ptr);
> +       struct page *page = pte_alloc_one(NULL, 0);
> +       BUG_ON(!page);
>         /* Ensure the zeroed page is visible to the page table walker */
>         dsb(ishst);
> -       return __pa(ptr);
> +       return __pa(page_address(page));
>  }
>

Actually, I just sent a response to the same effect. Alternatively, we
could educate apply_to_page_range() to treat the EFI page tables
specially (or simply all statically allocated mm_struct instances),
e.g.,

diff --git a/mm/memory.c b/mm/memory.c
index 15322b73636b..dc6145129170 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1852,8 +1852,11 @@ static int apply_to_pte_range(struct mm_struct
*mm, pmd_t *pmd,
        int err;
        pgtable_t token;
        spinlock_t *uninitialized_var(ptl);
+       bool is_kernel_mm;

-       pte = (mm == &init_mm) ?
+       is_kernel_mm = (mm == &init_mm || core_kernel_data((unsigned long)mm));
+
+       pte = is_kernel_mm ?
                pte_alloc_kernel(pmd, addr) :
                pte_alloc_map_lock(mm, pmd, addr, &ptl);
        if (!pte)
@@ -1873,7 +1876,7 @@ static int apply_to_pte_range(struct mm_struct
*mm, pmd_t *pmd,

        arch_leave_lazy_mmu_mode();

-       if (mm != &init_mm)
+       if (!is_kernel_mm)
                pte_unmap_unlock(pte-1, ptl);
        return err;
 }

but it seems more appropriate to initialize the struct pages
correctly, to preemptively deal with other code that may make similar
assumptions.

I also noticed that create_mapping_late() and create_mapping_noalloc()
are essentially the same, since the only two invocations of the former
should not split block entries, and simply remaps regions that have
already been mapped with stricter permissions. This means
late_pgtable_alloc is only used by create_pgd_mapping, which is only
used by the EFI code. So that allows for some shortcuts to be taken, I
would think. The only downside is that I will need to fix it in two
places (arm64 and ARM)

Anyway, thanks for the suggestion.

-- 
Ard.
