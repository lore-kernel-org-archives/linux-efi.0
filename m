From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 01/16] Add the ability to lock down access to the running
 kernel image
Date: Wed, 16 Nov 2016 23:20:49 +0100
Message-ID: <20161116222049.hywdxse4hwsrfwjm@pd.tnic>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933284407.19316.17886320817060158597.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147933284407.19316.17886320817060158597.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 16, 2016 at 09:47:24PM +0000, David Howells wrote:
> Provide a single call to allow kernel code to determine whether the system
> should be locked down, thereby disallowing various accesses that might
> allow the running kernel image to be changed including the loading of
> modules that aren't validly signed with a key we recognise, fiddling with
> MSR registers and disallowing hibernation,
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

...

> +/**
> + * kernel_is_locked_down - Find out if the kernel is locked down
> + */
> +bool kernel_is_locked_down(void)
> +{
> +	return kernel_locked_down;
> +}
> +EXPORT_SYMBOL(kernel_locked_down);

Surely

EXPORT_SYMBOL(kernel_is_locked_down);

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
