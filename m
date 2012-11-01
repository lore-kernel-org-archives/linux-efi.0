From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 16:40:45 +0000
Message-ID: <20121101164045.6a9ed161@pyramind.ukuu.org.uk>
References: <36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<20121101144912.GA10269@srcf.ucam.org>
	<20121101150654.19efe0b5@pyramind.ukuu.org.uk>
	<20121101162901.GE13132@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121101162901.GE13132@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 1 Nov 2012 16:29:01 +0000
Matthew Garrett <mjg@redhat.com> wrote:

> On Thu, Nov 01, 2012 at 03:06:54PM +0000, Alan Cox wrote:
> > > The entire point of this feature is that it's no longer possible to turn 
> > > a privileged user exploit into a full system exploit. Gaining admin 
> > > access on Windows 8 doesn't permit you to install a persistent backdoor, 
> > 
> > Really, that would be a first. Do you have a detailed knowledge of
> > windows 8 actual security ?
> 
> http://msdn.microsoft.com/en-us/library/windows/desktop/hh848061%28v=vs.85%29.aspx

No I said knowledge of not web pages. The Red Hat pages say Linux is very
secure, the Apple ones say MacOS is.

The point being you don't want to evaluate apparent security by press
release of one system versus deep internal knowledge of the other.

Alan
