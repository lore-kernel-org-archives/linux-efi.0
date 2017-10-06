From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/capsule-loader: pr_err() strings should end with
 newlines
Date: Fri, 6 Oct 2017 11:47:10 +0100
Message-ID: <20171006104710.GB3314@codeblueprint.co.uk>
References: <34e9e4c3647f1d1abd051e1d493d8a19c6259a64.1506336366.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <34e9e4c3647f1d1abd051e1d493d8a19c6259a64.1506336366.git.arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Sep, at 04:17:23PM, Arvind Yadav wrote:
> pr_err() messages should terminated with a new-line to avoid
> other messages being concatenated onto the end.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule-loader.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
> index ec8ac5c..51d2874 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -49,7 +49,7 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
>  	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) / PAGE_SIZE;
>  
>  	if (pages_needed == 0) {
> -		pr_err("invalid capsule size");
> +		pr_err("invalid capsule size\n");
>  		return -EINVAL;
>  	}
>  

Thanks, applied.
