From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi-pstore: implement efivars_pstore_exit()
Date: Wed, 11 Nov 2015 16:59:47 +0000
Message-ID: <20151111165947.GD4889@codeblueprint.co.uk>
References: <cover.1446869434.git.geliangtang@163.com>
 <337377a3fbcf855d6a5217e06fcd8c8a979f2853.1446869434.git.geliangtang@163.com>
 <c203e0cfee351d6f97c6a1a42c3e25b4be339f93.1446869434.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c203e0cfee351d6f97c6a1a42c3e25b4be339f93.1446869434.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 07 Nov, at 12:43:48PM, Geliang Tang wrote:
> The original efivars_pstore_exit() is empty. I
>  1) add a bufsize check statement.
>  2) call pstore_unregister as it is defined now.
>  3) free the memory and set bufsize to 0.
> 
> Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-pstore.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index eac76a7..62d57d8 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -393,6 +393,13 @@ static __init int efivars_pstore_init(void)
>  
>  static __exit void efivars_pstore_exit(void)
>  {
> +	if (!efi_pstore_info.bufsize)
> +		return;
> +
> +	pstore_unregister(&efi_pstore_info);
> +	kfree(efi_pstore_info.buf);
> +	efi_pstore_info.buf = NULL;
> +	efi_pstore_info.bufsize = 0;
>  }
>  
>  module_init(efivars_pstore_init);

Looks OK to me. Kees, are you picking this up?
