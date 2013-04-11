From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] x86,efi: Implement no_storage_paranoia parameter
Date: Thu, 11 Apr 2013 16:19:04 +0100
Message-ID: <5166D468.4030109@intel.com>
References: <1365584375-9372-1-git-send-email-richard@nod.at> <1365584375-9372-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365584375-9372-2-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/04/13 09:59, Richard Weinberger wrote:
> Using this parameter one can disable the storage_size/2 check if
> he is really sure that the UEFI does sane gc and fulfills the spec.
> 
> This parameter is useful if a devices uses more than 50% of the
> storage by default.
> The Intel DQSW67 desktop board is such an sucker for exmaple.
> 
> Signed-off-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 3f96a48..1b0efb6 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -41,6 +41,7 @@
>  #include <linux/io.h>
>  #include <linux/reboot.h>
>  #include <linux/bcd.h>
> +#include <linux/module.h>
>  
>  #include <asm/setup.h>
>  #include <asm/efi.h>
> @@ -71,6 +72,13 @@ static efi_system_table_t efi_systab __initdata;
>  
>  unsigned long x86_efi_facility;
>  
> +static bool efivars_no_storage_paranoia;
> +module_param_named(no_storage_paranoia, efivars_no_storage_paranoia, bool, 0644);

Could you rename this to 'efi_no_storage_paranoia' so that it isn't
confused with drivers/firmware/efivars.c? Also, it would be a good idea
to document this new kernel parameter in Documentation/kernel-parameters.

> +MODULE_PARM_DESC(no_storage_paranoia, "Use this parameter only if you are very"
> +		 " sure that your EFI implemenation does sane garbage"
> +		 " collection and fulfills the UEFI spec."
> +		 " Otherwise your board may brick."
> +		 " See: http://mjg59.dreamwidth.org/#entry-22855");

I think we should avoid including urls in the kernel source. The rest of
the description is fine.
