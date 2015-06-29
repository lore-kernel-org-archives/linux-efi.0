From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid
 BGRT
Date: Mon, 29 Jun 2015 07:00:22 -0700
Message-ID: <20150629140022.GA22374@x>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629131305.GB13113-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 29, 2015 at 03:13:05PM +0200, Borislav Petkov wrote:
> On Mon, Jun 29, 2015 at 01:06:42PM +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > It's totally legitimate, per the ACPI spec, for the firmware to set the
> > BGRT 'status' field to zero to indicate that the BGRT image isn't being
> > displayed, and we shouldn't be printing an error message in that case
> > because it's just noise for users. So swap pr_err() for pr_debug().
> > 
> > However, Josh points that out it still makes sense to test the validity
> > of the upper 7 bits of the 'status' field, since they're marked as
> > "reserved" in the spec and must be zero. If firmware violates this it
> > really *is* an error.
> 
> Sounds to me this should be
> 
> 	pr_warn(FW_WARN "... );
> 
> then, no?
> 
> So that it hopefully gets caught at early testing when fw can still be
> fixed...?
> 
> Better yet FW_BUG even...

Definitely not FW_BUG.  The field is reserved *now*; it would be
legitimate for a new version of the BGRT spec to define one of those
bits for something else.

- Josh Triplett
