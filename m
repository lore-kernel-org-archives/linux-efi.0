From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
Date: Tue, 13 Aug 2013 11:43:30 -0700
Message-ID: <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>
References: <52050985.9070107@zytor.com>
	 <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>
	 <52050D03.4030805@zytor.com> <520A7B48.3020304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <520A7B48.3020304-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-08-13 at 11:30 -0700, H. Peter Anvin wrote:
> On 08/09/2013 08:38 AM, H. Peter Anvin wrote:
> > On 08/09/2013 08:32 AM, James Bottomley wrote:
> >> On Fri, 2013-08-09 at 08:23 -0700, H. Peter Anvin wrote:
> >>> I would like to change the defaults for CONFIG_EFI and CONFIG_EFI_STUB
> >>> to y.  There is little reason to omit this since EFI now is a
> >>> significant percentage of all systems.
> >>
> >> You didn't actually attach the patch, but I presume this is for 64 bit
> >> compiles on x86 only?  We still have significant problems getting 64 bit
> >> EFI to interact with 32 bit kernels, so I don't believe we should enable
> >> CONFIG_EFI globally for all of x86.
> >>
> > 
> > Well, it doesn't *solve* the problem with cross-mode, but it should work
> > as-is for EFI32->32-bit kernel and EFI64->64-bit kernel.  For the
> > cross-mode kernels they will simply not do anything.
> > 
> > Either way, nothing bad should come from it.  The worst thing that will
> > happen is that the kernel says "I don't have any EFI that I recognize."
> > 
> > Cross-mode support will always require a secondary bootloader (since as
> > far as I know there is no concept of "fat binaries" for EFI), but Matt
> > Fleming is working on genuine cross-mode support for both the boot stub
> > and (eventually) run time support.
> > 
> 
> James, does this address your concerns?

You mean for globally enabling CONFIG_EFI on x86?  not really for 32
bit, you say above it's pretty much unusable; I'd prefer just to enable
it for 64 bit.  As you said in your original post "since EFI now is a
significant percentage of all systems" but you actually mean EFI64 ...
EFI32 is a pretty insignificant percentage of all systems.

Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
I tried on my Secure Boot SDV it wouldn't work; the problem is getting
someting in the transfer of control path to boot the processor back to
32 bit mode.

James
