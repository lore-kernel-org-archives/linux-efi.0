From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Tue, 15 Aug 2017 14:46:33 -0700
Message-ID: <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com> <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Peter Zijlstra <peterz@infradead.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Andrew Lutomirski <luto@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, ricardo.neri@intel.com, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 15, 2017 at 12:18 PM, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> +/*
> + * Makes the calling kernel thread switch to/from efi_mm context
> + * Can be used from SetVirtualAddressMap() or during efi runtime calls
> + * (Note: This routine is heavily inspired from use_mm)
> + */
> +void efi_switch_mm(struct mm_struct *mm)
> +{
> +       struct task_struct *tsk = current;
> +
> +       task_lock(tsk);
> +       efi_scratch.prev_mm = tsk->active_mm;
> +       if (efi_scratch.prev_mm != mm) {
> +               mmgrab(mm);
> +               tsk->active_mm = mm;
> +       }
> +       switch_mm(efi_scratch.prev_mm, mm, NULL);
> +       task_unlock(tsk);
> +
> +       if (efi_scratch.prev_mm != mm)
> +               mmdrop(efi_scratch.prev_mm);

I'm confused.  You're mmdropping an mm that you are still keeping a
pointer to.  This is also a bit confusing in the case where you do
efi_switch_mm(efi_scratch.prev_mm).

This whole manipulation seems fairly dangerous to me for another
reason -- you're taking a user thread (I think) and swapping out its
mm to something that the user in question should *not* have access to.
What if a perf interrupt happens while you're in the alternate mm?
What if you segfault and dump core?  Should we maybe just have a flag
that says "this cpu is using a funny mm", assert that the flag is
clear when scheduling, and teach perf, coredumps, etc not to touch
user memory when the flag is set?

Admittedly, the latter problem may well have existed even before these patches.

> +}
> +



>  #ifdef CONFIG_EFI_MIXED
>  extern efi_status_t efi64_thunk(u32, ...);
>
> @@ -649,16 +665,13 @@ efi_status_t efi_thunk_set_virtual_address_map(
>         efi_sync_low_kernel_mappings();
>         local_irq_save(flags);
>
> -       efi_scratch.prev_cr3 = read_cr3();
> -       write_cr3((unsigned long)efi_scratch.efi_pgt);
> -       __flush_tlb_all();
> +       efi_switch_mm(&efi_mm);
>
>         func = (u32)(unsigned long)phys_set_virtual_address_map;
>         status = efi64_thunk(func, memory_map_size, descriptor_size,
>                              descriptor_version, virtual_map);
>
> -       write_cr3(efi_scratch.prev_cr3);
> -       __flush_tlb_all();
> +       efi_switch_mm(efi_scratch.prev_mm);
>         local_irq_restore(flags);
>
>         return status;
