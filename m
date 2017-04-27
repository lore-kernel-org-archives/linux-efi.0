From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 09/32] x86/mm: Provide general kernel support for
 memory encryption
Date: Thu, 27 Apr 2017 18:12:27 +0200
Message-ID: <20170427161227.c57dkvghz63pvmu2@pd.tnic>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211754.10190.25082.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170418211754.10190.25082.stgit@tlendack-t1.amdoffice.net>
Sender: linux-arch-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 04:17:54PM -0500, Tom Lendacky wrote:
> Changes to the existing page table macros will allow the SME support to
> be enabled in a simple fashion with minimal changes to files that use these
> macros.  Since the memory encryption mask will now be part of the regular
> pagetable macros, we introduce two new macros (_PAGE_TABLE_NOENC and
> _KERNPG_TABLE_NOENC) to allow for early pagetable creation/initialization
> without the encryption mask before SME becomes active.  Two new pgprot()
> macros are defined to allow setting or clearing the page encryption mask.

...

> @@ -55,7 +57,7 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>  	__phys_addr_symbol(__phys_reloc_hide((unsigned long)(x)))
>  
>  #ifndef __va
> -#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
> +#define __va(x)			((void *)(__sme_clr(x) + PAGE_OFFSET))
>  #endif
>  
>  #define __boot_va(x)		__va(x)
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> index 7bd0099..fead0a5 100644
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -15,7 +15,7 @@
>  #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
>  #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
>  
> -#define __PHYSICAL_MASK		((phys_addr_t)((1ULL << __PHYSICAL_MASK_SHIFT) - 1))
> +#define __PHYSICAL_MASK		((phys_addr_t)(__sme_clr((1ULL << __PHYSICAL_MASK_SHIFT) - 1)))

That looks strange: poking SME mask hole into a mask...?

>  #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
>  
>  /* Cast *PAGE_MASK to a signed type so that it is sign-extended if

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
