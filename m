From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86: efi: Replace GFP_ATOMIC with GFP_KERNEL in
 efi_query_variable_store
Date: Tue, 13 Feb 2018 19:07:08 +0100
Message-ID: <20180213180707.einsznaoghtctkqn@gmail.com>
References: <1516847386-5291-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516847386-5291-1-git-send-email-baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Jia-Ju Bai <baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The function kzalloc here is not called in atomic context.
> If nonblocking in efi_query_variable_store is true, 
> namely it is in atomic context, efi_query_variable_store will return before
> this kzalloc is called.
> Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 8a99a2e..b6dcb52 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -177,7 +177,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
>  		 * that by attempting to use more space than is available.
>  		 */
>  		unsigned long dummy_size = remaining_size + 1024;
> -		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
> +		void *dummy = kzalloc(dummy_size, GFP_KERNEL);

Looks good to me!

Reviewed-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,

	Ingo
