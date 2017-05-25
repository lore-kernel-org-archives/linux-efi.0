From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Thu, 25 May 2017 22:14:09 +0100
Message-ID: <20170525211409.GH3546@codeblueprint.co.uk>
References: <1495089570-21005-1-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495089570-21005-1-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Frank Ramsay <frank.ramsay-ZPxbGqLxI0U@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 18 May, at 02:39:30PM, Baoquan He wrote:
> For EFI with 'efi=old_map' kernel option specified, Kernel will panic
> when kaslr is enabled.
> 
> The back trace is:
> 
> BUG: unable to handle kernel paging request at 000000007febd57e
> IP: 0x7febd57e
> PGD 1025a067
> PUD 0
> 
> Oops: 0010 [#1] SMP
> [ ... ]
> Call Trace:
>  ? efi_call+0x58/0x90
>  ? printk+0x58/0x6f
>  efi_enter_virtual_mode+0x3c5/0x50d
>  start_kernel+0x40f/0x4b8
>  ? set_init_arg+0x55/0x55
>  ? early_idt_handler_array+0x120/0x120
>  x86_64_start_reservations+0x24/0x26
>  x86_64_start_kernel+0x14c/0x16f
>  start_cpu+0x14/0x14
> 
> The root cause is the ident mapping is not built correctly in old_map case.
> 
> For nokaslr kernel, PAGE_OFFSET is 0xffff880000000000 which is PGDIR_SIZE
> aligned. We can borrow the pud table from direct mapping safely. Given a
> physical address X, we have pud_index(X) == pud_index(__va(X)). However,
> for kaslr kernel, PAGE_OFFSET is PUD_SIZE aligned. For a given physical
> address X, pud_index(X) != pud_index(__va(X)). We can't only copy pgd entry
> from direct mapping to build ident mapping, instead need copy pud entry
> one by one from direct mapping.
> 
> Fix it.
> 
> Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
> Cc: Frank Ramsay <frank.ramsay-ZPxbGqLxI0U@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> v3->v4:
>     1. Forget running scripts/checkpatch.pl to check patch, there are several
>     code stype issue. Correct them in this version.
> 
> v2->v3:
>     1. Rewrite code to copy pud entry one by one so that code can be understood
>     better. Usually we only have less than 1TB or several TB memory, pud entry
>     copy one by one won't impact efficiency.
> 
>     2. Adding p4d page table handling.
> 
> v1->v2:
>     Change code and add description according to Thomas's suggestion as below:
> 
>     1. Add checking if pud table is allocated successfully. If not just break
>     the for loop.
> 
>     2. Add code comment to explain how the 1:1 mapping is built in efi_call_phys_prolog
> 
>     3. Other minor change
> 
>  arch/x86/platform/efi/efi_64.c | 70 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 62 insertions(+), 8 deletions(-)

Thanks, applied.
