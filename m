From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Mon, 04 Jul 2016 18:03:55 -0700
Message-ID: <1467680635.2288.36.camel@HansenPartnership.com>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
	 <1467667917.2288.23.camel@HansenPartnership.com>
	 <20160704222609.GB5160@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704222609.GB5160-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-07-04 at 23:26 +0100, Matthew Garrett wrote:
> On Mon, Jul 04, 2016 at 02:31:57PM -0700, James Bottomley wrote:
> 
> > Currently, the kernel does nothing with this, but you'd more expect
> > something in userspace to do something with it, probably a
> > component of
> > the TSS.
> 
> The OS loader is expected to set MOR to 1, so given the boot stub 
> there's need for kernel support. A "correct" implementation would 
> also involve the kernel clearing all its secrets before reboot and 
> then setting it back to 0, so I don't think we can just punt
> responsibility to userspace.

Yes, but the whole thing is a bit of a windows ism.  In windows,
bitlocker is invoked from the loader, which is when the secret they're
worried about is unbound.  Windows has to operate like this because of
the drive letter problem.

It's perhaps arguable that for parity we should set it when an
encrypted filesystem is mounted and unset it when they're all unmounted
(that implementation could be an entirely in-os thing for us ...
probably implemented as some type of "secrets held" reference count). 
 However, the point I was making is that anything that wants access to
a sealed or bound secret would likely also like to control this, so it
should be a property of the TSS (or at least the TSS should be a
participant in the implementation).

To be honest, this is all a bit smoke and mirrors security until we've
got a way to protect secrets across suspend/resume because that's the
biggest vulnerability window for theft and the MOR protocols do nothing
to protect this.

James
