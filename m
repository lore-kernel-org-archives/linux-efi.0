From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Wed, 10 Aug 2016 14:52:01 +0200
Message-ID: <20160810125201.GA9028@gmail.com>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160809052546.31462-1-icenowy-ymACFijhrKM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Icenowy Zheng <icenowy-ymACFijhrKM@public.gmane.org> wrote:

> Some broken firmwares have a wrongly filled version field in BGRT table.
> (See http://wiki.osdev.org/Broken_UEFI_implementations )
> 
> As we know, these firmwares can also provide correct BGRT image, although
> the table is wrong.
> 
> After removing the check of the version field, the kernel can now extract
> the image correctly, and the information is also correct.
> 
> Tested on a Thinkpad E531 (68854UC).

What's the practical effects of the bug - what problems does a missing 
/sys/firmware/acpi/bgrt/ cause?

I.e. how does the user notice?

Thanks,

	Ingo
