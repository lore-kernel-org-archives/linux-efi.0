From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Fri, 16 Sep 2016 15:45:20 +0100
Message-ID: <20160916144519.GA3179@leverpostej>
References: <1474005912.3930.10.camel@gmail.com>
 <20160916093149.GC16797@codeblueprint.co.uk>
 <1474020059.3881.3.camel@gmail.com>
 <20160916143007.GF16797@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160916143007.GF16797-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 16, 2016 at 03:30:07PM +0100, Matt Fleming wrote:
> On Fri, 16 Sep, at 12:00:59PM, Mike Galbraith wrote:
> > 
> > Ok, here's the whole thing just in case.  Hope it's not too big.
>  
> [...]
> 
> > [    0.000000] esrt: Reserving ESRT space from 0x00000000def87998 to 0x00000000def879d0.
> 
> OK, that's 56 bytes and yet I realise that at no point in the
> efi_mem_reserve() call path do we round up to the nearest page size
> even though the EFI memory map only deals with EFI_PAGE_SIZE regions.

I note that the base is also not aligned to EFI_PAGE_SIZE. Shouldn't we
round that down, too?

[...]

> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index f14b7a9da24b..e881b4b2ffd6 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -201,8 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>  		return;
>  	}
>  
> +	size = round_up(size, EFI_PAGE_SIZE);

i.e. have:

	size += addr % EFI_PAGE_SIZE;
	size = round_up(size, EFI_PAGE_SIZE);
	addr = round_down(base, EFI_PAGE_SIZE);

Thanks,
Mark.
