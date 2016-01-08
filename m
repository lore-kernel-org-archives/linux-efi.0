From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: fix out-of-bounds null overwrite vulnerability
Date: Fri, 8 Jan 2016 10:13:23 +0000
Message-ID: <20160108101323.GA2532@codeblueprint.co.uk>
References: <1452193530-76672-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452193530-76672-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 07 Jan, at 02:05:30PM, Insu Yun wrote:
> snprintf's return value is not bound by size value.
> (https://www.kernel.org/doc/htmldocs/kernel-api/API-snprintf.html)
> if printed value is larger than buffer size, it can overwrite 
> null byte in out-of-bounds buffer.
 
But this function doesn't use snprintf(), it uses scnprintf() which
returns the number of characters written into buf and, because
scnprintf() largely follows vnsprintf(), it will never write more than
'size' bytes into the buffer.

> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/cper.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index d425374..77aa75f 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -267,7 +267,6 @@ static int cper_dimm_err_location(struct cper_mem_err_compact *mem, char *msg)
>  			     "DIMM location: not present. DMI handle: 0x%.4x ",
>  			     mem->mem_dev_handle);
>  
> -	msg[n] = '\0';
>  	return n;
>  }
>  

Calling this a vulnerability is a little extreme. These fields come
from firmware and if you can't trust the firmware you've got bigger
issues.

I'm not even sure this is a bug. Tony?
