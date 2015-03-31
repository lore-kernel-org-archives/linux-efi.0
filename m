From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v4.1
Date: Tue, 31 Mar 2015 10:57:18 +0200
Message-ID: <20150331085718.GB10962@gmail.com>
References: <20150327191651.GB5801@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150327191651.GB5801-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Yinghai Lu (1):
>       x86, boot: Allow 64bit EFI kernel to be loaded above 4G

Despite multiple warnings the changelog from Yinghai is still 
unreadable and chock full of typos, and in any case it should have 
been acked by Boris, hpa, tglx or me before applying it to a Git tree.

This was my last warning to Yinghai:

  http://lkml.iu.edu/hypermail/linux/kernel/1503.1/05342.html

I'm not pulling such messy patches from Yinghai anymore, please remove 
this patch from the EFI tree and submit a fixed version separately.

The other changes are looking good to me.

Thanks,

	Ingo
