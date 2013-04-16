From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
Date: Wed, 17 Apr 2013 01:16:35 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz>
References: <1366153253-28572-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366153253-28572-1-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 17 Apr 2013, Richard Weinberger wrote:

> Using this parameter one can disable the storage_size/2 check if
> he is really sure that the UEFI does sane gc and fulfills the spec.
> 
> This parameter is useful if a devices uses more than 50% of the
> storage by default.
> The Intel DQSW67 desktop board is such a sucker for exmaple.
> 
> Signed-off-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt |  6 ++++++
>  arch/x86/platform/efi/efi.c         | 15 ++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4609e81..d1cc3a9 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -788,6 +788,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	edd=		[EDD]
>  			Format: {"off" | "on" | "skip[mbr]"}
>  
> +	efi_no_storage_paranoia [EFI; X86]
> +			Using this parameter you can use more than 50% of
> +			your efi variable storage. Use this parameter only if
> +			you are really sure that your UEFI does sane gc and
> +			fulfills the spec otherwise your board may brick.
> +
>  	eisa_irq_edge=	[PARISC,HW]
>  			See header of drivers/parisc/eisa.c.
>  
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 4959e3f..07524e1 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -113,6 +113,16 @@ static int __init setup_add_efi_memmap(char *arg)
>  }
>  early_param("add_efi_memmap", setup_add_efi_memmap);
>  
> +static bool efi_no_storage_paranoia;
> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);

Is there any particular reason to export this symbol?

-- 
Jiri Kosina
SUSE Labs
