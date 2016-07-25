From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ESRT failures ... was Re: [PATCH 04/11] efi: Add efi_memmap_init_late()
 for permanent EFI memmap
Date: Mon, 25 Jul 2016 11:11:31 -0400
Message-ID: <57962C23.5090705@redhat.com>
References: <57867F32.8040001@redhat.com> <20160721121136.GF26504@codeblueprint.co.uk> <5790DFD0.4020806@redhat.com> <20160722131101.GJ26504@codeblueprint.co.uk> <57922028.7070103@redhat.com> <20160725144431.GA31759@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725144431.GA31759-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 07/25/2016 10:44 AM, Matt Fleming wrote:
> On Fri, 22 Jul, at 09:31:20AM, Prarit Bhargava wrote:
>>
>> Hmm ... maybe just a Dell specific quirk?
> 
> Quirks are best avoided at all costs, platform-specific quirks doubly
> so because there are just so many in the EFI arena that maintaining
> them all would be a nightmare.
> 
> Where possible we adopt a "most buggy implementation" approach to
> compatibility, as a least common denominator.
> 
> Could you try this patch out? It's not a final version, but I'd just
> like to see if anything else explodes when we start returning reserved
> regions.
> 
> ---
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 05509f3aaee8..9857796c4cd4 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -299,7 +299,8 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
>  
>  		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>  		    md->type != EFI_BOOT_SERVICES_DATA &&
> -		    md->type != EFI_RUNTIME_SERVICES_DATA) {
> +		    md->type != EFI_RUNTIME_SERVICES_DATA &&
> +		    md->type != EFI_RESERVED_TYPE) {

I had tried this fix earlier FWIW and it causes the boot to hang.

P.

>  			early_memunmap(md, sizeof (*md));
>  			continue;
>  		}
> 
