From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] x86/efi: PFN_ALIGN() _text and _end when calculating
 number of pages
Date: Tue, 24 Nov 2015 09:23:23 +0100
Message-ID: <20151124082323.GA23451@gmail.com>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
 <1448285594-17617-2-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448285594-17617-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> While _text is currently aligned to PAGE_SIZE in the vmlinux linker
> script because it's based on CONFIG_PHYSICAL_ALIGN, it's always better
> to be explicit about these things to be sure no alignment bugs are
> lurking. There's no analogous enforcement for _end.
> 
> Dave provided an example of why the 'npages' calculation is wrong,
> 
>  "Just for fun, imagine that _end=0xfff and _text=0x1001.  npages
>   would be 0."
> 
> Use PFN_ALIGN() to be sure the calculation is correctly aligned to
> PAGE_SIZE.
> 
> Reported-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reported-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a0ac0f9c307f..3a90eb72d153 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -183,7 +183,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	efi_scratch.phys_stack = virt_to_phys(page_address(page));
>  	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
>  
> -	npages = (_end - _text) >> PAGE_SHIFT;
> +	npages = (PFN_ALIGN(_end) - PFN_ALIGN(_text)) >> PAGE_SHIFT;
>  	text = __pa(_text);

Didn't we want to do the _end alignment linker script fix instead?

Alignment assumptions are easy to make when symbols are well aligned typically (as 
in this case), so we should guarantee the alignment property instead of 
complicating the code.

Thanks,

	Ingo
