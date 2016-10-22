From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [tip:x86/asm] x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)
Date: Fri, 21 Oct 2016 17:18:30 -0700
Message-ID: <CALCETrUqhRg_G1fia=oFKrsxpF_YobEJLs1KpA3UF2Pnt6-u+w@mail.gmail.com>
References: <c88f3e2920b18e6cc621d772a04a62c06869037e.1470907718.git.luto@kernel.org>
 <tip-e37e43a497d5a8b7c0cc1736d56986f432c394c9@git.kernel.org> <20161021123243.GC27807@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021123243.GC27807-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Oct 21, 2016 5:32 AM, "Matt Fleming" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>
> On Wed, 24 Aug, at 06:03:04AM, tip-bot for Andy Lutomirski wrote:
> > Commit-ID:  e37e43a497d5a8b7c0cc1736d56986f432c394c9
> > Gitweb:     http://git.kernel.org/tip/e37e43a497d5a8b7c0cc1736d56986f432c394c9
> > Author:     Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > AuthorDate: Thu, 11 Aug 2016 02:35:23 -0700
> > Committer:  Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > CommitDate: Wed, 24 Aug 2016 12:11:42 +0200
> >
> > x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)
> >
> > This allows x86_64 kernels to enable vmapped stacks by setting
> > HAVE_ARCH_VMAP_STACK=y - which enables the CONFIG_VMAP_STACK=y
> > high level Kconfig option.
> >
> > There are a couple of interesting bits:
>
> This commit broke booting EFI mixed mode kernels. Here's what I've got
> queued up to fix it.
>
> ---
> From acf11e55bfcef7a1dca7d1735f4a780e0cdb1c89 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Date: Thu, 20 Oct 2016 22:17:21 +0100
> Subject: [PATCH] x86/efi: Prevent mixed mode boot corruption with
>  CONFIG_VMAP_STACK
>
> Booting an EFI mixed mode kernel has been crashing since commit:
>
>   e37e43a497d5 ("x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)")
>
> The user-visible effect in my test setup was the kernel being unable
> to find the root file system ramdisk. This was likely caused by silent
> memory or page table corruption.
>
> Enabling CONFIG_DEBUG_VIRTUAL immediately flagged the thunking code as
> abusing virt_to_phys() because it was passing addresses that were not
> part of the kernel direct mapping.
>
> Use the slow version instead, which correctly handles all memory
> regions by performing a page table walk.
>
> Suggested-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 59 +++++++++++++++++++++++++-----------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 58b0f801f66f..e3569a00885b 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -211,6 +211,17 @@ void efi_sync_low_kernel_mappings(void)
>         memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
>  }
>
> +/*
> + * Wrapper for slow_virt_to_phys() that handles NULL addresses.
> + */
> +static inline phys_addr_t virt_to_phys_or_null(void *va)
> +{
> +       if (!va)
> +               return 0;
> +
> +       return slow_virt_to_phys(va);
> +}
> +

This is asking for trouble if any of the variable length parameters
are on the stack.  How about adding a "size_t size" parameter and
doing:

if (!va) {
  return 0;
} else if (virt_addr_valid(va)) {
  return virt_to_phys(va);
} else {
  /* A fully aligned variable on the stack is guaranteed not to cross
a page boundary. */
  WARN_ON(!IS_ALIGNED((uintptr_t)va, size) || size > PAGE_SIZE);
  return slow_virt_to_phys(va);
}
