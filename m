From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [tip:x86/mm] x86/boot/32: Defer resyncing initial_page_table
 until per-cpu is set up
Date: Mon, 8 May 2017 08:31:55 +0200
Message-ID: <0c4d6d04-7038-fb82-87b3-343784550d0a@siemens.com>
References: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
 <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee-Ckxz5ZWcFp/9qxiX1TGQuw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgross-IBi9RG/b67k@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2017-03-23 10:14, tip-bot for Andy Lutomirski wrote:
> The x86 smpboot trampoline expects initial_page_table to have the
> GDT mapped.  If the GDT ends up in a virtually mapped per-cpu page,
> then it won't be in the page tables at all until perc-pu areas are
> set up.  The result will be a triple fault the first time that the
> CPU attempts to access the GDT after LGDT loads the perc-pu GDT.
> 
> This appears to be an old bug, but somehow the GDT fixmap rework
> is triggering it.  This seems to have something to do with the
> memory layout.
> 
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Link: http://lkml.kernel.org/r/a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/kernel/setup.c        | 15 ---------------
>  arch/x86/kernel/setup_percpu.c | 21 +++++++++++++++++++++
>  2 files changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 4bf0c89..56b1177 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1226,21 +1226,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  	kasan_init();
>  
> -#ifdef CONFIG_X86_32
> -	/* sync back kernel address range */
> -	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
> -			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
> -			KERNEL_PGD_PTRS);
> -
> -	/*
> -	 * sync back low identity map too.  It is used for example
> -	 * in the 32-bit EFI stub.
> -	 */
> -	clone_pgd_range(initial_page_table,
> -			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
> -			min(KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
> -#endif
> -
>  	tboot_probe();
>  
>  	map_vsyscall();
> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index 11338b0..bb1e8cc 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -288,4 +288,25 @@ void __init setup_per_cpu_areas(void)
>  
>  	/* Setup cpu initialized, callin, callout masks */
>  	setup_cpu_local_masks();
> +
> +#ifdef CONFIG_X86_32
> +	/*
> +	 * Sync back kernel address range.  We want to make sure that
> +	 * all kernel mappings, including percpu mappings, are available
> +	 * in the smpboot asm.  We can't reliably pick up percpu
> +	 * mappings using vmalloc_fault(), because exception dispatch
> +	 * needs percpu data.
> +	 */
> +	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
> +			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
> +			KERNEL_PGD_PTRS);
> +
> +	/*
> +	 * sync back low identity map too.  It is used for example
> +	 * in the 32-bit EFI stub.
> +	 */
> +	clone_pgd_range(initial_page_table,
> +			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
> +			min(KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
> +#endif
>  }
> 

This breaks the boot on our Intel Quark platform (IOT2000, similar to
Galileo Gen2). Reverting it over master makes it work again. Any idea
what goes wrong? Let me know how I can help debugging this.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
