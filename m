From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for
 invalid BGRT
Date: Mon, 29 Jun 2015 07:53:26 -0700
Message-ID: <20150629145326.GA848@cloud>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
 <20150629140022.GA22374@x>
 <20150629141724.GG12383@pd.tnic>
 <20150629144940.GF28334@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629144940.GF28334-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 29, 2015 at 03:49:40PM +0100, Matt Fleming wrote:
> On Mon, 29 Jun, at 04:17:24PM, Borislav Petkov wrote:
> > On Mon, Jun 29, 2015 at 07:00:22AM -0700, Josh Triplett wrote:
> > > Definitely not FW_BUG.  The field is reserved *now*; it would be
> > > legitimate for a new version of the BGRT spec to define one of those
> > > bits for something else.
> > 
> > Which would mean that booting old kernels on new FW which defines those
> > reserved bits would cause that warning to fire erroneously.
> > 
> > So then we probably don't need it at all or we need to check implemented
> > BGRT version of the FW running to know which bits are defined by the
> > spec and which are reserved...
>  
> It still makes sense to have the error message because the kernel
> literally does not know what the firmware is trying to achieve by
> setting those bits.
> 
> But I agree with Josh that for the specific case of "reserved bits",
> FW_BUG is wrong, because if in some future version of the spec those
> bits get used, seeing,
> 
>   "[Firmware Bug]: Ignoring BGRT: reserved bits are non-zero 0x3"
> 
> is going to confuse the hell outta any firmware engineers, since it's
> not the firmware that's buggy, it's just that the kernel lacks support.

Right.  Same reason we shouldn't use FW_BUG for bgrt_tab->version != 1
or bgrt_tab->image_type != 0 .

> This discussion should definitely be summarised in printk.h.
> 
> However, other error messages in efi-bgrt.c probably do want to be
> sprinkled with FW_* if they represent things that should never happen
> ever.

I think the length check and null pointer check would fall in that
category.

- Josh Triplett
