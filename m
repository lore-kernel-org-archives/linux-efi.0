From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Mon, 04 Jul 2016 19:35:08 -0700
Message-ID: <1467686108.2288.43.camel@HansenPartnership.com>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
	 <1467667917.2288.23.camel@HansenPartnership.com>
	 <20160704222609.GB5160@srcf.ucam.org>
	 <1467680635.2288.36.camel@HansenPartnership.com>
	 <20160705010622.GA7974@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160705010622.GA7974-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-07-05 at 02:06 +0100, Matthew Garrett wrote:
> On Mon, Jul 04, 2016 at 06:03:55PM -0700, James Bottomley wrote:
> 
> > It's perhaps arguable that for parity we should set it when an
> > encrypted filesystem is mounted and unset it when they're all 
> > unmounted (that implementation could be an entirely in-os thing for 
> > us ... probably implemented as some type of "secrets held" 
> > reference count).  However, the point I was making is that anything 
> > that wants access to a sealed or bound secret would likely also 
> > like to control this, so it should be a property of the TSS (or at 
> > least the TSS should be a participant in the implementation).
> 
> We want to set it the moment anything secret lands in RAM. Tying it 
> to TSS doesn't get us that.

Well, we do to an approximation: whenever Tspi_Data_Unbind/Unseal are
called secrets are dumped in RAM ... it's not the only time, but it's
one of the biggest.  What the TSS doesn't know is when the secret is
safely disposed of again.  It's one of the annoying lacuna in the
model: the TSS itself is great at managing stuff, but as soon as it
transmits secrets beyond itself, well, that's someone else's problem.

James
