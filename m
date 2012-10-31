From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:49:19 +0000
Message-ID: <20121031174919.51f1518d@pyramind.ukuu.org.uk>
References: <20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
	<20121031170334.59833fb1@pyramind.ukuu.org.uk>
	<20121031171048.GA17163@srcf.ucam.org>
	<20121031172121.14cc1215@pyramind.ukuu.org.uk>
	<20121031171743.GA17652@srcf.ucam.org>
	<20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
	<20121031173750.GB18615@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121031173750.GB18615-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012 17:37:50 +0000
Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:

> On Wed, Oct 31, 2012 at 05:39:19PM +0000, Alan Cox wrote:
> > On Wed, 31 Oct 2012 17:17:43 +0000
> > Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:
> > > By booting a signed kernel, not turning on swap and writing directly to 
> > > the swap partition.
> > 
> > Ok so the actual problem is that you are signing kernels that allow the
> > user to skip the S4 resume check ?
> 
> What S4 resume check?

One you would add .. but no I'm wrong there - its a problem at the
suspend point so you do need a signature for it. Oh well yet another
reason it's nto useful.

Alan
