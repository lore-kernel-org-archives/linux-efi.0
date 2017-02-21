From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [RFC PATCH v4 13/28] efi: Update efi_mem_type() to return
 defined EFI mem types
Date: Tue, 21 Feb 2017 12:05:05 +0000
Message-ID: <20170221120505.GQ28416@codeblueprint.co.uk>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154457.19244.5369.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170216154457.19244.5369.stgit@tlendack-t1.amdoffice.net>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Alexander Potapenko <glider@google.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Bori
List-Id: linux-efi@vger.kernel.org

On Thu, 16 Feb, at 09:44:57AM, Tom Lendacky wrote:
> Update the efi_mem_type() to return EFI_RESERVED_TYPE instead of a
> hardcoded 0.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/platform/efi/efi.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index a15cf81..6407103 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -1037,7 +1037,7 @@ u32 efi_mem_type(unsigned long phys_addr)
>  	efi_memory_desc_t *md;
>  
>  	if (!efi_enabled(EFI_MEMMAP))
> -		return 0;
> +		return EFI_RESERVED_TYPE;
>  
>  	for_each_efi_memory_desc(md) {
>  		if ((md->phys_addr <= phys_addr) &&
> @@ -1045,7 +1045,7 @@ u32 efi_mem_type(unsigned long phys_addr)
>  				  (md->num_pages << EFI_PAGE_SHIFT))))
>  			return md->type;
>  	}
> -	return 0;
> +	return EFI_RESERVED_TYPE;
>  }

I see what you're getting at here, but arguably the return value in
these cases never should have been zero to begin with (your change
just makes that more obvious).

Returning EFI_RESERVED_TYPE implies an EFI memmap entry exists for
this address, which is misleading because it doesn't in the hunks
you've modified above.

Instead, could you look at returning a negative error value in the
usual way we do in the Linux kernel, and update the function prototype
to match? I don't think any callers actually require the return type
to be u32.
