From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] arm64: efi: always map runtime services code and data
 regions down to pages
Date: Fri, 22 Jul 2016 18:27:57 +0200
Message-ID: <CAKv+Gu_62V1Ww5UEJd3KP+TRj_kw3PW+wZaxQDnn-0ookLBBDg@mail.gmail.com>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
 <1467204690-10790-3-git-send-email-ard.biesheuvel@linaro.org> <64a731b2-1ddb-78f5-fd02-204f19f0a432@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <64a731b2-1ddb-78f5-fd02-204f19f0a432-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 July 2016 at 16:30, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On 29/06/16 13:51, Ard Biesheuvel wrote:
>>
>> To avoid triggering diagnostics in the MMU code that are finicky about
>> splitting block mappings into more granular mappings, ensure that regions
>> that are likely to appear in the Memory Attributes table as well as the
>> UEFI memory map are always mapped down to pages. This way, we can use
>> apply_to_page_range() instead of create_pgd_mapping() for the second pass,
>> which cannot split or merge block entries, and operates strictly on PTEs.
>>
>> Note that this aligns the arm64 Memory Attributes table handling code with
>> the ARM code, which already uses apply_to_page_range() to set the strict
>> permissions.
>>
>
> This patch is merged in arm64/for-next/core now and when I try that
> branch with defconfig + CONFIG_PROVE_LOCKING, I get the following splat
> on boot and it fails to boot further on Juno.
>
> I could bisect that to this patch(Commit bd264d046aad ("arm64: efi:
> always map runtime services code and data regions down to pages") in
> that branch)
>

Hi Sudeep,

I can reproduce this on QEMU as well. It appears that
apply_to_page_range() expects pages containing translation tables to
have their per-page spinlock initialized if they are not part of
init_mm.

This

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -272,6 +272,7 @@ static phys_addr_t late_pgtable_alloc(void)
 {
        void *ptr = (void *)__get_free_page(PGALLOC_GFP);
        BUG_ON(!ptr);
+       BUG_ON(!pgtable_page_ctor(virt_to_page(ptr)));

        /* Ensure the zeroed page is visible to the page table walker */
        dsb(ishst);

makes the problem go away for me (just as a temporary hack) but I will
try to come up with something more appropriate, and check if ARM has
the same issue (since it uses apply_to_page_range() as well)

-- 
Ard.

> -->8
>
> efi: memattr: Processing EFI Memory Attributes table:
> efi: memattr:  0x0000f9400000-0x0000f942ffff [Runtime Data       |RUN| |
> |XP|  |  |  |   |  |  |  |  ]
> Unable to handle kernel NULL pointer dereference at virtual address 00000018
> pgd = ffff000009aa4000
> [00000018] *pgd=00000009ffffe003, *pud=00000009ffffd003,
> *pmd=0000000000000000
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.7.0-rc7-next-20160722 #134
> Hardware name: ARM Juno development board (r2) (DT)
> task: ffff800976ca0000 task.stack: ffff800976c3c000
> PC is at __lock_acquire+0x13c/0x19e0
> LR is at lock_acquire+0x4c/0x68
> pc : [<ffff000008104544>] lr : [<ffff000008106114>] pstate: 200000c5
> ....
>  __lock_acquire+0x13c/0x19e0
>  lock_acquire+0x4c/0x68
>  _raw_spin_lock+0x40/0x58
>  apply_to_page_range+0x18c/0x388
>  efi_set_mapping_permissions+0x34/0x44
>  efi_memattr_apply_permissions+0x200/0x2a8
>  arm_enable_runtime_services+0x1b4/0x1fc
>  do_one_initcall+0x38/0x128
>  kernel_init_freeable+0x84/0x1f0
>  kernel_init+0x10/0x100
>  ret_from_fork+0x10/0x40
> Code: 5280003c 79004401 140000b5 b000b880 (f9400282)
> ---[ end trace 892120beb6681b4e ]---
>
