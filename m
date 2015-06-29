From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid
 BGRT
Date: Mon, 29 Jun 2015 17:44:58 +0200
Message-ID: <20150629154458.GH12383@pd.tnic>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
 <20150629140022.GA22374@x>
 <20150629141724.GG12383@pd.tnic>
 <20150629144940.GF28334@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629144940.GF28334-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 29, 2015 at 03:49:40PM +0100, Matt Fleming wrote:
> It still makes sense to have the error message because the kernel
> literally does not know what the firmware is trying to achieve by
> setting those bits.
> 
> But I agree with Josh that for the specific case of "reserved bits",
> FW_BUG is wrong, because if in some future version of the spec those
> bits get used, seeing,
> 
>   "[Firmware Bug]: Ignoring BGRT: reserved bits are non-zero 0x3"

I still don't see what that message brings if some kernel complains that
some bits are !0 then. Are they valid bits which the kernel doesn't know
about or are they erroneously set and reserved. This, IMHO, is confusing
because the error message is not correct in all cases.

Thus my suggestion to either check the spec version before looking at
the bits or find out in some other way which bits are defined and which
are reserved and warn only about the reserved ones which are 1b.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
