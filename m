From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Tue, 5 Jul 2016 02:06:23 +0100
Message-ID: <20160705010622.GA7974@srcf.ucam.org>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
 <1467667917.2288.23.camel@HansenPartnership.com>
 <20160704222609.GB5160@srcf.ucam.org>
 <1467680635.2288.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467680635.2288.36.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 04, 2016 at 06:03:55PM -0700, James Bottomley wrote:

> It's perhaps arguable that for parity we should set it when an
> encrypted filesystem is mounted and unset it when they're all unmounted
> (that implementation could be an entirely in-os thing for us ...
> probably implemented as some type of "secrets held" reference count). 
>  However, the point I was making is that anything that wants access to
> a sealed or bound secret would likely also like to control this, so it
> should be a property of the TSS (or at least the TSS should be a
> participant in the implementation).

We want to set it the moment anything secret lands in RAM. Tying it to 
TSS doesn't get us that.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
