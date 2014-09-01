From: Calvin Walton <calvin.walton-08yNtVAFnCuw5LPnMra/2Q@public.gmane.org>
Subject: Re: [bisected, regression] 3.17-rc2 kernel doesn't load initramfs
 with EFI stub boot
Date: Mon, 01 Sep 2014 14:59:28 -0400
Message-ID: <1409597968.1055.1.camel@kepstin.ca>
References: <1409155357.1084.1.camel@kepstin.ca>
	 <20140901184208.GA3001@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140901184208.GA3001-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-09-01 at 19:42 +0100, Matt Fleming wrote:
> On Wed, 27 Aug, at 12:02:37PM, Calvin Walton wrote:
> >  Hi all,
> > 
> >  When I tried booting the 3.17-rc2 kernel on my Lenovo ThinkPad 
> > T440p
> >  (16gb ram) via Gummiboot/EFI stub, it failed with an error saying 
> > that
> >  it could not mount root. A little investigation revealed that the
> >  initramfs did not load, so mounting by filesystem UUID failed.
> >  I've bisected the change, and it has led me to:
> > 
> >  4bf7111f50167133a71c23530ca852a41355e739 is the first bad commit
> >  commit 4bf7111f50167133a71c23530ca852a41355e739
> >  Author: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >  Date:   Sat Jun 14 12:23:41 2014 -0700
> > 
> >      x86/efi: Support initrd loaded above 4G
> 
> Thanks for reporting this. Could you try the below commit and see
> whether it fixes things for you?
> 
>   http://article.gmane.org/gmane.linux.kernel.efi/4524

With Yinghai Lu's patch from the linked message, my ThinkPad is now 
booting correctly. (Admittedly using a rather "small" 7MB intramfs - I 
don't have any >2GB ones handy).

Feel free to take a
Tested-by: Calvin Walton <calvin.walton-08yNtVAFnCuw5LPnMra/2Q@public.gmane.org>

Thanks!


-- 
Calvin Walton <calvin.walton-08yNtVAFnCuw5LPnMra/2Q@public.gmane.org>
