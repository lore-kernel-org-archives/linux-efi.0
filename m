From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for
 invalid BGRT
Date: Mon, 29 Jun 2015 07:45:42 -0700
Message-ID: <20150629144542.GA794@cloud>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
 <20150629140022.GA22374@x>
 <20150629141724.GG12383@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629141724.GG12383-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 29, 2015 at 04:17:24PM +0200, Borislav Petkov wrote:
> On Mon, Jun 29, 2015 at 07:00:22AM -0700, Josh Triplett wrote:
> > Definitely not FW_BUG.  The field is reserved *now*; it would be
> > legitimate for a new version of the BGRT spec to define one of those
> > bits for something else.
> 
> Which would mean that booting old kernels on new FW which defines those
> reserved bits would cause that warning to fire erroneously.

Not erroneously; those bits could potentially indicate some status
condition we don't know about, so we need to assume we can't handle the
table if a bit we don't understand is set.

(Specs like this should really do what ext4 does, and define whether a
given set of currently undefined bits are optional or mandatory; as in,
if you don't understand them, can you proceed or should you stop?)

> So then we probably don't need it at all or we need to check implemented
> BGRT version of the FW running to know which bits are defined by the
> spec and which are reserved...
> 
> Also, does the spec really say that reserved bits must be zero? Or it
> doesn't specify their value?

The spec says those bits of the status field are reserved and must be
zero.

- Josh Triplett
