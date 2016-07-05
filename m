From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Tue, 5 Jul 2016 04:03:14 +0100
Message-ID: <20160705030314.GA9597@srcf.ucam.org>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
 <1467667917.2288.23.camel@HansenPartnership.com>
 <20160704222609.GB5160@srcf.ucam.org>
 <1467680635.2288.36.camel@HansenPartnership.com>
 <20160705010622.GA7974@srcf.ucam.org>
 <1467686108.2288.43.camel@HansenPartnership.com>
 <20160705024022.GA9292@srcf.ucam.org>
 <1467687531.2288.51.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467687531.2288.51.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 04, 2016 at 07:58:51PM -0700, James Bottomley wrote:
> On Tue, 2016-07-05 at 03:40 +0100, Matthew Garrett wrote:
> > dm-crypt secrets are typically unrelated to the TPM, so I really 
> > don't think the TSS is the right layer to be solving this.
> 
> Not in theory: the MOR protocol is supposed to protect arbitrary
> unprotected secrets in memory.  I accept that in practice, it was
> designed to protect a single secret: the bitlocker encryption key.

I think we may be miscommunicating slightly. If MOR is intended to 
protect arbitrary secrets then it needs to protect secrets that are 
unrelated to the TPM - that means that TSS integration isn't sufficient. 
Unless we can guarantee that every piece of userspace is behaving 
correctly, that probably means setting MOR in kernel init and letting 
userspace turn it off if it's been audited to handle things 
appropriately (and having the kernel ignore that request if it has its 
own secrets it needs to protect)

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
