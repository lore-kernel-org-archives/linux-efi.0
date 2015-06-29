From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid
 BGRT
Date: Mon, 29 Jun 2015 16:17:24 +0200
Message-ID: <20150629141724.GG12383@pd.tnic>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
 <20150629140022.GA22374@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629140022.GA22374@x>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 29, 2015 at 07:00:22AM -0700, Josh Triplett wrote:
> Definitely not FW_BUG.  The field is reserved *now*; it would be
> legitimate for a new version of the BGRT spec to define one of those
> bits for something else.

Which would mean that booting old kernels on new FW which defines those
reserved bits would cause that warning to fire erroneously.

So then we probably don't need it at all or we need to check implemented
BGRT version of the FW running to know which bits are defined by the
spec and which are reserved...

Also, does the spec really say that reserved bits must be zero? Or it
doesn't specify their value?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
