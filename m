From: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Subject: Re: [PATCH 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Wed, 21 Dec 2016 20:45:13 +0200
Message-ID: <c7bf34ba-56f0-8346-36d1-7069f2115dcf@nextfour.com>
References: <20161221182846.2968-1-nicstange@gmail.com>
 <20161221182846.2968-2-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161221182846.2968-2-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org



On 21.12.2016 20:28, Nicolai Stange wrote:
> Before invoking the arch specific handler, efi_mem_reserve() reserves
> the given memory region through memblock.
>
> efi_mem_reserve() can get called after mm_init() though -- through
> efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
> not be used anymore.
>
> Let efi_mem_reserve() check whether memblock is dead and not do the
> reservation if so. Emit a warning from the generic efi_arch mem_reserve()
> in this case: if the architecture doesn't provide any other means of
> registering the region as reserved, the operation would be a nop.
>
> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>
> ---
>  drivers/firmware/efi/efi.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 92914801e388..12b2e3a6d73f 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -403,7 +403,10 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
>  	return end;
>  }
>  
> -void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
> +void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size)
> +{
> +	WARN(slab_is_available(), "efi_mem_reserve() has no effect");
> +}
>  
>  /**
>   * efi_mem_reserve - Reserve an EFI memory region
> @@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>   */
>  void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>  {
> -	if (!memblock_is_region_reserved(addr, size))
> +	if (slab_is_available() && !memblock_is_region_reserved(addr, size))
>  		memblock_reserve(addr, size);
Maybe !slab_is_available() ?

>  
--Mika
