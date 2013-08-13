From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
Date: Tue, 13 Aug 2013 12:02:05 -0700
Message-ID: <1376420525.3467.70.camel@dabdike.int.hansenpartnership.com>
References: <52050985.9070107@zytor.com>
	  <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>
	  <52050D03.4030805@zytor.com> <520A7B48.3020304@zytor.com>
	 <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
	 <520A8054.1030108@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <520A8054.1030108-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-08-13 at 11:52 -0700, H. Peter Anvin wrote:
> On 08/13/2013 11:43 AM, James Bottomley wrote:
> > Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
> > I tried on my Secure Boot SDV it wouldn't work; the problem is getting
> > someting in the transfer of control path to boot the processor back to
> > 32 bit mode.
> 
> We can boot with a bootloader in "skip stub" mode; no runtime services
> yet.

So the bootloader has to do the 64->32 transition?

>   We are working on making it possible to boot via a EFI stub in
> assisted mode (still needing a bootloader, but with the boot stub in the
> kernel.)
> 
> Runtime services will be the last piece, obviously, but even that looks
> reasonably doable.

So why not start with the working case (default to EFI on 64 bit) and
add in the mostly non-working case (default to EFI on 32 bit) when it
actually mostly works?

James
