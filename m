From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 01 Nov 2012 09:59:14 +0000
Message-ID: <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	   <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
	   <36538307.gzWq1oO7Kg@linux-lqwf.site>
	  <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	  <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
Sender: linux-security-module-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2012-11-01 at 10:45 +0100, Jiri Kosina wrote:
> On Thu, 1 Nov 2012, James Bottomley wrote:
> 
> > I'm actually just struggling to understand the use case for these more
> > esoteric protections.
> 
> I believe the real point is drawing a clear line between trusted and 
> untrusted (with root being userspace, hence implicitly untrusted), and 
> disallowing "legitimate crossing" of this line.

But that doesn't really help me: untrusted root is an oxymoron.  I get
capability separated systems, where you invest trust in layers and you
make each layer small and verifiable, so you have a granular trust
policy you build up.  I really don't understand the use case for trying
to remove a small portion of trust from the huge trust domain of root
and then doing a massive amount of fixup around the edges because
there's leaks all over the place from the trust that root still has.  It
all seems to be a bit backwards.  If you just begin with the capability
separated granular system, I don't see why it doesn't all just work with
what we have today.

James


