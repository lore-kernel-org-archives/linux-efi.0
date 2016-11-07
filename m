From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Fix EFI memmap pointer size warning
Date: Mon, 7 Nov 2016 09:59:26 +0000
Message-ID: <20161107095926.GF8845@codeblueprint.co.uk>
References: <20161106130254.dxcguu4qh2nh2md7@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161106130254.dxcguu4qh2nh2md7@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi <linux-efi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 06 Nov, at 02:02:54PM, Borislav Petkov wrote:
> Hi Matt,
> 
> please doublecheck me on this but I think we're fine using an unsigned
> long.
> 
> Thanks.
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Sun, 6 Nov 2016 13:49:10 +0100
> Subject: [PATCH] x86/efi: Fix EFI memmap pointer size warning
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Fix this when building on 32-bit:
> 
>   arch/x86/platform/efi/efi.c: In function ‘__efi_enter_virtual_mode’:
>   arch/x86/platform/efi/efi.c:911:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>        (efi_memory_desc_t *)pa);
>        ^
>   arch/x86/platform/efi/efi.c:918:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>        (efi_memory_desc_t *)pa);
>        ^
> 
> The @pa local variable is declared as phys_addr_t and that is a u64 when
> CONFIG_PHYS_ADDR_T_64BIT=y. (The last is enabled on 32-bit on a PAE
> build.)
> 
> However, its value comes from __pa() which is basically doing pointer
> arithmetic and checking, and returns unsigned long as it is the native
> pointer width.
> 
> So let's use an unsigned long too. It should be fine to do so because
> the later users cast it to a pointer too.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/platform/efi/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index bf99aa7005eb..936a488d6cf6 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -861,7 +861,7 @@ static void __init __efi_enter_virtual_mode(void)
>  	int count = 0, pg_shift = 0;
>  	void *new_memmap = NULL;
>  	efi_status_t status;
> -	phys_addr_t pa;
> +	unsigned long pa;
>  
>  	efi.systab = NULL;
>  

Right, this does look correct given that __pa() uses 'unsigned long'.

I think the reason this is safe on PAE is that __get_free_pages() is
guaranteed to return a 32-bit address, and will not return HIGHMEM
pages. Which makes __pa() legal and 'unsigned long' the correct type.

Want me to take this through the EFI tree?
