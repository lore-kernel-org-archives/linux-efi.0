From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 21:35:24 +0000
Message-ID: <20121101213524.03fa2d53@pyramind.ukuu.org.uk>
References: <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	<1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<1351804440.2391.99.camel@dabdike.int.hansenpartnership.com>
	<20121101211859.GA20014@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121101211859.GA20014@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 1 Nov 2012 21:18:59 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Nov 01, 2012 at 09:14:00PM +0000, James Bottomley wrote:
> 
> > I agree that's a possibility.  However, I think the court of public
> > opinion would pillory the first Commercial Linux Distribution that went
> > to Microsoft for the express purpose of revoking their competition's
> > right to boot.  It would be commercial suicide.
> 
> Oracle are something of a vexatious litigant as far as the court of 
> public opinion is concerned, but even without that it could be a 
> customer who complains. If you're personally comfortable with a specific 
> level of security here, that's fine - but it's completely reasonable for 
> others to feel that there are valid technical and commercial concerns to 
> do this properly.

The main people who really really care about this the MS key stuff
is mostly irrelevant for as they won't use the Microsoft keys
anyway. Microsoft will have to provide signing to all sorts of other law
enforcement bodies as a responsible provider. If the FBI have a key no
other government security installation will have that key in their
systems. If the Chinese state has it I doubt the US government will be
too keen either.

All those official government trojans end up creating a big problem in the
trust department.

Alan
