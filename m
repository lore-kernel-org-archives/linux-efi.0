From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Linux 4.5-rc1
Date: Mon, 25 Jan 2016 15:29:36 -0500
Message-ID: <20160125202936.GB29683@redhat.com>
References: <1453750756-31463-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453750756-31463-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 25, 2016 at 02:39:16PM -0500, Peter Jones wrote:
> From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

I have no idea how I convinced "git send-email" to send this instead of
the intended patch.  Sorry about that, and I'll take care (and
--dry-run) to ensure it doesn't happen again.

> 
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index abfb3e8..c65fe37 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 4
> -PATCHLEVEL = 4
> +PATCHLEVEL = 5
>  SUBLEVEL = 0
> -EXTRAVERSION =
> +EXTRAVERSION = -rc1
>  NAME = Blurry Fish Butt
>  
>  # *DOCUMENTATION*
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
        Peter
