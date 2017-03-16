From: Omar Sandoval <osandov@osandov.com>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Thu, 16 Mar 2017 10:50:48 -0700
Message-ID: <20170316175048.GA25230@vader.DHCP.thefacebook.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
 <20170316124132.GF6261@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170316124132.GF6261@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dave Young <dyoung@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, kernel-team@fb.com, kexec@lists.infradead.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 16, 2017 at 12:41:32PM +0000, Matt Fleming wrote:
> On Mon, 13 Mar, at 03:37:48PM, Dave Young wrote:
> > 
> > Omar, could you try below patch? Looking at the efi_mem_desc_lookup, it is not
> > correct to be used in efi_arch_mem_reserve, if it passed your test, I
> > can rewrite patch log with more background and send it out:
> > 
> >         for_each_efi_memory_desc(md) {
> > 		[snip]
> >                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> >                     md->type != EFI_BOOT_SERVICES_DATA &&
> >                     md->type != EFI_RUNTIME_SERVICES_DATA) {
> >                         continue;
> >                 }
> > 
> > In above code, it meant to get a md of EFI_MEMORY_RUNTIME of either boot
> > data or runtime data, this is wrong for efi_mem_reserve, because we are
> > reserving boot data which has no EFI_MEMORY_RUNTIME attribute at the
> > running time. Just is happened to work and we did not capture the error.
> 
> Wouldn't something like this be simpler?
> 
> ---
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 30031d5293c4..cdfe8c628959 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -201,6 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>  		return;
>  	}
>  
> +	/* No need to reserve regions that will never be freed. */
> +	if (md.attribute & EFI_MEMORY_RUNTIME)
> +		return;
> +
>  	size += addr % EFI_PAGE_SIZE;
>  	size = round_up(size, EFI_PAGE_SIZE);
>  	addr = round_down(addr, EFI_PAGE_SIZE);

This works for me.

Reported-and-tested-by: Omar Sandoval <osandov@fb.com>
