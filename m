From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 3 Jun 2013 17:42:37 +0100
Message-ID: <20130603164237.GA23146@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike>
 <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312@srcf.ucam.org>
 <1370276286.2910.29.camel@dabdike>
 <20130603162435.GA22563@srcf.ucam.org>
 <1370277307.2910.39.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370277307.2910.39.camel@dabdike>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 03, 2013 at 09:35:07AM -0700, James Bottomley wrote:
> On Mon, 2013-06-03 at 17:24 +0100, Matthew Garrett wrote:
> > That seems optimistic. Windows never calls QueryVariableInfo() during 
> > boot services, so what makes you think doing so has ever been tested?
> 
> It's used by the UEFI shell package ... every system which boots to the
> shell automatically tests this.  I know no locked down UEFI system ships
> with a shell but almost every system in test has a Shell in some form,
> so I think its fairly safe to call it from boot services.

Why do you persist in this belief that all system vendors are going to 
have run a shell, let alone any kind of test suite? That runs counter to 
everything we've learned about x86 firmware. People verify that it runs 
Windows and then ship it.

> However, what about a compromise: why don't we implement 1:1 mapping and
> then call SetVirtualAddressMap with the 1:1 map ... in theory the
> pointer chases should then be nops (it will be replacing the physical
> address with the same virtual address), so everything should just work
> and anything the UEFI vendor missed will still work because the physical
> address will work also in this scenario.

The problem there is that you're saying "In theory". We know that 
Windows doesn't behave this way, so we have no legitimate expectation 
that it'll work. We know that it doesn't on some Apple hardware.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
