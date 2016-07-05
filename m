From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Mon, 04 Jul 2016 19:58:51 -0700
Message-ID: <1467687531.2288.51.camel@HansenPartnership.com>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
	 <1467667917.2288.23.camel@HansenPartnership.com>
	 <20160704222609.GB5160@srcf.ucam.org>
	 <1467680635.2288.36.camel@HansenPartnership.com>
	 <20160705010622.GA7974@srcf.ucam.org>
	 <1467686108.2288.43.camel@HansenPartnership.com>
	 <20160705024022.GA9292@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160705024022.GA9292-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-07-05 at 03:40 +0100, Matthew Garrett wrote:
> On Mon, Jul 04, 2016 at 07:35:08PM -0700, James Bottomley wrote:
> > On Tue, 2016-07-05 at 02:06 +0100, Matthew Garrett wrote:
> > > We want to set it the moment anything secret lands in RAM. Tying 
> > > it to TSS doesn't get us that.
> > 
> > Well, we do to an approximation: whenever Tspi_Data_Unbind/Unseal 
> > are called secrets are dumped in RAM ... it's not the only time, 
> > but it's one of the biggest.  What the TSS doesn't know is when the 
> > secret is safely disposed of again.  It's one of the annoying 
> > lacuna in the model: the TSS itself is great at managing stuff, but 
> > as soon as it transmits secrets beyond itself, well, that's someone 
> > else's problem.
> 
> dm-crypt secrets are typically unrelated to the TPM, so I really 
> don't think the TSS is the right layer to be solving this.

Not in theory: the MOR protocol is supposed to protect arbitrary
unprotected secrets in memory.  I accept that in practice, it was
designed to protect a single secret: the bitlocker encryption key.

If all we're after in Linux is matching the windows use case, then
protecting disc encryption keys (not just dm-crypt, we'd need ecryptfs
as well and possibly the new ext4 ecryptfs integration) will do. 
 However, being Linux, I was just wondering if we couldn't actually do
more what the spirit of MOR was designed for (i.e. protecting arbitrary
secrets in memory).

James
