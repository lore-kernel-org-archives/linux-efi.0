From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Date: Wed, 9 Jul 2014 19:26:51 +0100
Message-ID: <20140709182651.GB15932@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140618142819.GN24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Jun, at 03:28:19PM, Matt Fleming wrote:
> On Sat, 14 Jun, at 12:23:41PM, Yinghai Lu wrote:
> > For boot efi kernel directly without bootloader.
> > If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
> > not limit initrd under hdr->initrd_add_max.
> > 
> > Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > 
> > ---
> >  arch/x86/boot/compressed/eboot.c |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> Applied, thanks!

Well, fooey. This patch breaks one of my ASUS machines. It appears some
firmware implementations exhibit issues reading directly into a buffer
above the 4GB mark.

I haven't diagnosed exactly what goes wrong with the buffer (i.e. in
what way it becomes corrupt), but I should really do that before
thinking of how to fix this.

I'll keep you posted, I just wanted to give you a heads up that things
are screwy in this area.

-- 
Matt Fleming, Intel Open Source Technology Center
