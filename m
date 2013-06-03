From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 3 Jun 2013 19:11:10 +0100
Message-ID: <20130603181110.GA25060@srcf.ucam.org>
References: <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike>
 <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312@srcf.ucam.org>
 <1370276286.2910.29.camel@dabdike>
 <20130603162435.GA22563@srcf.ucam.org>
 <1370277307.2910.39.camel@dabdike>
 <20130603164237.GA23146@srcf.ucam.org>
 <1370282703.9888.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370282703.9888.5.camel@dabdike>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 03, 2013 at 11:05:03AM -0700, James Bottomley wrote:
> On Mon, 2013-06-03 at 17:42 +0100, Matthew Garrett wrote:
> > Why do you persist in this belief that all system vendors are going to 
> > have run a shell, let alone any kind of test suite? That runs counter to 
> > everything we've learned about x86 firmware. People verify that it runs 
> > Windows and then ship it.
> 
> I don't, but I find it hard to believe no vendor ever runs an EFI shell
> on their systems.  The feedback I got from a couple of OEMs is that they
> use the shell mostly for internal testing.

There are vendors that do, and I expect that there are vendors who 
don't. There are vendors who will make changes to firmware and run the 
EFI test suite, and there are vendors who will make changes to firmware 
and run Windows.

> > The problem there is that you're saying "In theory". We know that 
> > Windows doesn't behave this way, so we have no legitimate expectation 
> > that it'll work. We know that it doesn't on some Apple hardware.
> 
> Fine, you say we need to call SetVirtualAddressMap because windows does,
> I agree, I'm just saying we get additional safety from calling it with
> the 1:1 map ... I don't see what the problem is.

No. I'm saying that calling it with the 1:1 map is something very 
different to the behaviour of Windows, and I'm saying that doing so is 
known to cause variable writes on some Apple hardware to stop working. 
If we're aiming for maximum compatibility, we need to call 
SetVirtualAddressMap() with addresses above the canonicalisation hole.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
