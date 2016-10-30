From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [tip:x86/asm] x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)
Date: Sun, 30 Oct 2016 09:21:29 -0700
Message-ID: <CALCETrUPruYjK_mEKtUuTczuvWH_mb64oGpwpXdMn1uoi0oLew@mail.gmail.com>
References: <c88f3e2920b18e6cc621d772a04a62c06869037e.1470907718.git.luto@kernel.org>
 <tip-e37e43a497d5a8b7c0cc1736d56986f432c394c9@git.kernel.org>
 <20161021123243.GC27807@codeblueprint.co.uk> <CALCETrUqhRg_G1fia=oFKrsxpF_YobEJLs1KpA3UF2Pnt6-u+w@mail.gmail.com>
 <20161024130931.GC20387@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161024130931.GC20387@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Brian Gerst <brgerst@gmail.com>, "linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 24, 2016 at 6:09 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>
> From d2c17f46686076677da3bf04caa2f69d654f8d8a Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt@codeblueprint.co.uk>
> Date: Thu, 20 Oct 2016 22:17:21 +0100
> Subject: [PATCH] x86/efi: Prevent mixed mode boot corruption with
>  CONFIG_VMAP_STACK
>
> Booting an EFI mixed mode kernel has been crashing since commit:
>

Looks reasonable.  It's certainly a considerable improvement over the
status quo.  Minor comments below, mainly of the form "do you need all
these changes":

>  int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  {
>         unsigned long pfn, text;
>         struct page *page;
>         unsigned npages;
> +       void *addr;
>         pgd_t *pgd;
>
>         if (efi_enabled(EFI_OLD_MEMMAP))
> @@ -251,7 +277,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>         if (!page)
>                 panic("Unable to allocate EFI runtime stack < 4GB\n");
>
> -       efi_scratch.phys_stack = virt_to_phys(page_address(page));
> +       addr = page_address(page);
> +       efi_scratch.phys_stack = virt_to_phys_or_null_size(addr, PAGE_SIZE);

This can't be on the stack -- you just allocated it with alloc_page().

>         efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
>
>         npages = (_etext - _text) >> PAGE_SHIFT;
> @@ -494,8 +521,8 @@ static efi_status_t efi_thunk_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>
>         spin_lock(&rtc_lock);
>
> -       phys_tm = virt_to_phys(tm);
> -       phys_tc = virt_to_phys(tc);
> +       phys_tm = virt_to_phys_or_null(tm);
> +       phys_tc = virt_to_phys_or_null(tc);

Seems okay.

> @@ -511,7 +538,7 @@ static efi_status_t efi_thunk_set_time(efi_time_t *tm)
>
>         spin_lock(&rtc_lock);
>
> -       phys_tm = virt_to_phys(tm);
> +       phys_tm = virt_to_phys_or_null(tm);

Seems okay.

> @@ -529,9 +556,9 @@ efi_thunk_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
>
>         spin_lock(&rtc_lock);
>
> -       phys_enabled = virt_to_phys(enabled);
> -       phys_pending = virt_to_phys(pending);
> -       phys_tm = virt_to_phys(tm);
> +       phys_enabled = virt_to_phys_or_null(enabled);
> +       phys_pending = virt_to_phys_or_null(pending);
> +       phys_tm = virt_to_phys_or_null(tm);

All seem okay.

>
>         status = efi_thunk(get_wakeup_time, phys_enabled,
>                              phys_pending, phys_tm);
> @@ -549,7 +576,7 @@ efi_thunk_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
>
>         spin_lock(&rtc_lock);
>
> -       phys_tm = virt_to_phys(tm);
> +       phys_tm = virt_to_phys_or_null(tm);

Seems reasonable.

> +static unsigned long efi_name_size(efi_char16_t *name)
> +{
> +       return ucs2_strsize(name, EFI_VAR_NAME_LEN) + 1;
> +}

If this is really dynamic, I'm surprised that anything ends up
aligned.  Can't this be a number like 6?  It might pay to extend that
warning to also check that, if the variable is on the stack, its size
is a power of two.  But maybe none of the users of this are on the
stack, in which case it might pay to try to prevent a new user on the
stack from showing up.
