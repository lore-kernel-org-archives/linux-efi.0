From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Fri, 16 Sep 2016 10:31:49 +0100
Message-ID: <20160916093149.GC16797@codeblueprint.co.uk>
References: <1474005912.3930.10.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474005912.3930.10.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Sep, at 08:05:12AM, Mike Galbraith wrote:
> Hi Matt,
> 
> My workstation started instant rebooting with tip.  I bisected it to..
> 
>    efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
> 
> ..but seems it's really $subject, as box works fine with the below.
> 
> ---
>  drivers/firmware/efi/efi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -415,6 +415,7 @@ void __init efi_mem_reserve(phys_addr_t
>  {
>  	if (!memblock_is_region_reserved(addr, size))
>  		memblock_reserve(addr, size);
> +	else
>  
>  	/*
>  	 * Some architectures (x86) reserve all boot services ranges
> 
> 
> No idea what's going boom down in efi_arch_mem_reserve().

Urgh, that's bad. Which machine is this? Can you paste the dmesg after
booting with the efi=debug kernel parameter, either with your above
patch or with the commit reverted?
