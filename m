From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 03 Jun 2013 14:19:05 -0700
Message-ID: <1370294345.9888.12.camel@dabdike>
References: <20130603081148.GB13607@nazgul.tnic>
	 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
	 <1370270282.2910.9.camel@dabdike> <20130603152122.GA21312@srcf.ucam.org>
	 <1370276286.2910.29.camel@dabdike> <20130603162435.GA22563@srcf.ucam.org>
	 <1370277307.2910.39.camel@dabdike> <20130603164237.GA23146@srcf.ucam.org>
	 <1370282703.9888.5.camel@dabdike> <20130603181110.GA25060@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130603181110.GA25060-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-06-03 at 19:11 +0100, Matthew Garrett wrote:
> > > The problem there is that you're saying "In theory". We know that 
> > > Windows doesn't behave this way, so we have no legitimate expectation 
> > > that it'll work. We know that it doesn't on some Apple hardware.
> > 
> > Fine, you say we need to call SetVirtualAddressMap because windows does,
> > I agree, I'm just saying we get additional safety from calling it with
> > the 1:1 map ... I don't see what the problem is.
> 
> No. I'm saying that calling it with the 1:1 map is something very 
> different to the behaviour of Windows, and I'm saying that doing so is 
> known to cause variable writes on some Apple hardware to stop working. 
> If we're aiming for maximum compatibility, we need to call 
> SetVirtualAddressMap() with addresses above the canonicalisation hole.

OK, so tell me this problem: it's a new one one me.  I think you're
saying if we don't call SetVirtualAddressMap with a mapping above a
certain value, some Apple system breaks somehow? (how?).

James
