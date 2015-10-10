From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: linux-next: Tree for Sep 18 (build failures, up to 10/02)
Date: Sat, 10 Oct 2015 17:26:23 +0100
Message-ID: <20151010162623.GA2723@codeblueprint.co.uk>
References: <20150918140810.6345bce9@canb.auug.org.au>
 <20150918142204.GA17018@roeck-us.net>
 <20151002161637.GA17786@roeck-us.net>
 <20151003222607.GA2682@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151003222607.GA2682@codeblueprint.co.uk>
Sender: linux-next-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Zhang <zjzhang@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, Tony Luck <tony.luck@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Sat, 03 Oct, at 11:26:07PM, Matt Fleming wrote:
> 
> Urgh, sorry about this slipping through the cracks Guenter!
> 
> What about fixing it up with this patch?
> 
> ---
> 
> From 85ae872eafef767cf37a0a305266522a62b43fc2 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Sat, 3 Oct 2015 20:44:52 +0100
> Subject: [PATCH] efi: Use the generic efi.memmap instead of 'memmap'
> 
> Guenter reports that commit 7bf793115dd9 ("efi, x86: Rearrange
> efi_mem_attributes()") breaks ia64 compilation with the following
> error,
> 
>  drivers/built-in.o: In function `efi_mem_attributes':
>   (.text+0xde962): undefined reference to `memmap'
>  drivers/built-in.o: In function `efi_mem_attributes':
>   (.text+0xde971): undefined reference to `memmap'
> 
> Instead of using the (rather poorly named) global variable 'memmap'
> which doesn't exist on ia64, use efi.memmap which points to the
> 'memmap' object on x86 and arm64 and which is NULL for ia64.
> 
> The fact that efi.memmap is NULL for ia64 is OK because ia64 provides
> its own implementation of efi_mem_attributes().
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Zhang <zjzhang@codeaurora.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  drivers/firmware/efi/efi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index dd153be03f56..335f4c1a1504 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -647,13 +647,15 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>   */
>  u64 __weak efi_mem_attributes(unsigned long phys_addr)
>  {
> +	struct efi_memory_map *map;
>  	efi_memory_desc_t *md;
>  	void *p;
>  
>  	if (!efi_enabled(EFI_MEMMAP))
>  		return 0;
>  
> -	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +	map = efi.memmap;
> +	for (p = map->map; p < map->map_end; p += map->desc_size) {
>  		md = p;
>  		if ((md->phys_addr <= phys_addr) &&
>  		    (phys_addr < (md->phys_addr +

tip folks, could you pick this up to fix the ia64 breakage in
linux-next?

-- 
Matt Fleming, Intel Open Source Technology Center
