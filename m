From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 03 Jun 2013 09:35:07 -0700
Message-ID: <1370277307.2910.39.camel@dabdike>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
	 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
	 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
	 <1370270282.2910.9.camel@dabdike> <20130603152122.GA21312@srcf.ucam.org>
	 <1370276286.2910.29.camel@dabdike> <20130603162435.GA22563@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130603162435.GA22563-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-06-03 at 17:24 +0100, Matthew Garrett wrote:
> On Mon, Jun 03, 2013 at 09:18:06AM -0700, James Bottomley wrote:
> 
> > I don't entirely buy that.  All EFI programs run with the physical
> > address map, therefore every API an EFI program uses is also tested, at
> > boot time only, obviously.
> 
> That seems optimistic. Windows never calls QueryVariableInfo() during 
> boot services, so what makes you think doing so has ever been tested?

It's used by the UEFI shell package ... every system which boots to the
shell automatically tests this.  I know no locked down UEFI system ships
with a shell but almost every system in test has a Shell in some form,
so I think its fairly safe to call it from boot services.

> > However, the ExitBootServices() code seems to be much simpler, so I 
> > don't think it will cause too many bugs.  The UEFI test suites also 
> > seem to try UEFI calls before and after ExitBootServices(), so I think 
> > relying on a 1:1 mapping looks safer to me.
> 
> I have no expectation that the majority of system vendors run the test 
> suite, but I have every expectation that every system vendor runs 
> Windows. We should behave as close to the tested mechanism as possible, 
> ie do what Windows does - and that includes calling 
> SetVirtualAddressMap().

OK, so we basically agree to disagree.  When I looked at the actual
SetVirtualAddressMap() implementation, my heart skipped several beats:
it's a massive set of pointer chasing heuristics which is bound to be
incorrect in some instance, just because its so complex and easy to get
wrong.  Every time it's incorrect, we'll get a physical pointer used in
a virtual space and an oops within the UEFI code.  Conversely, I think
the engineering risk that a particular UEFI call is expecting to have
had SetVirtualAddressMap called is much lower.

However, what about a compromise: why don't we implement 1:1 mapping and
then call SetVirtualAddressMap with the 1:1 map ... in theory the
pointer chases should then be nops (it will be replacing the physical
address with the same virtual address), so everything should just work
and anything the UEFI vendor missed will still work because the physical
address will work also in this scenario.

James
