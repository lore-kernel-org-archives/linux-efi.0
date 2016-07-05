From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: MemoryOverwriteRequestControl
Date: Mon, 04 Jul 2016 21:24:36 -0700
Message-ID: <1467692676.2288.63.camel@HansenPartnership.com>
References: <CACxGe6s7rgTBUf7jtN6J3i3w-HvAm2rFnjjwCtWRS6oHx3ZB5A@mail.gmail.com>
	 <1467667917.2288.23.camel@HansenPartnership.com>
	 <20160704222609.GB5160@srcf.ucam.org>
	 <1467680635.2288.36.camel@HansenPartnership.com>
	 <20160705010622.GA7974@srcf.ucam.org>
	 <1467686108.2288.43.camel@HansenPartnership.com>
	 <20160705024022.GA9292@srcf.ucam.org>
	 <1467687531.2288.51.camel@HansenPartnership.com>
	 <20160705030314.GA9597@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160705030314.GA9597-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-07-05 at 04:03 +0100, Matthew Garrett wrote:
> On Mon, Jul 04, 2016 at 07:58:51PM -0700, James Bottomley wrote:
> > On Tue, 2016-07-05 at 03:40 +0100, Matthew Garrett wrote:
> > > dm-crypt secrets are typically unrelated to the TPM, so I really 
> > > don't think the TSS is the right layer to be solving this.
> > 
> > Not in theory: the MOR protocol is supposed to protect arbitrary
> > unprotected secrets in memory.  I accept that in practice, it was
> > designed to protect a single secret: the bitlocker encryption key.
> 
> I think we may be miscommunicating slightly. If MOR is intended to 
> protect arbitrary secrets then it needs to protect secrets that are 
> unrelated to the TPM - that means that TSS integration isn't
> sufficient. 

I agree: necessary but not sufficient.

> Unless we can guarantee that every piece of userspace is behaving 
> correctly, that probably means setting MOR in kernel init and letting
> userspace turn it off if it's been audited to handle things 
> appropriately (and having the kernel ignore that request if it has 
> its own secrets it needs to protect)

Well, no, I was thinking, as I said before, of a kernel secrets
counter.  MOR Control doesn't need to be set in init; merely when the
first secret is exposed.  It can be reset when the last one is
shredded.  We need a user space per process interface to this so that
processes can also declare secret exposure and shredding.  For dmcrypt,
first exposure is the dm device setup and shredding the teardown, so
it's fairly long lived.

However, there's still the problem of secrets and suspend/resume.  The
best I can come up with there is to have memory regions declared as
protected (in the kernel and per process) and encrypt them all on
suspend.  The problem, on resume, is getting enough up that we can ask
for the password, but not so much that it requires an encrypted
resource.  This is the problem windows couldn't solve, but I think
we're a bit better placed.

James
