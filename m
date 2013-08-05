From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 5 Aug 2013 20:12:25 +0200
Message-ID: <20130805181225.GH31845@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>
Cc: edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 05, 2013 at 08:50:17AM -0700, Andrew Fish wrote:
> AFAICT EFI pre-dates kexec merge into mainline by a number of years as
> SetVirtualaddressMap() was part of EFI 1.0 (previous millennium)

Ok, fair enough.

> The EFI to UEFI conversion was placing EFI 1.10 into an industry
> standard, UEFI 2.0. UEFI is an industry standard so some one just
> needs to make a proposal to update the spec. The edk2 open source
> project is not part of the standards body so complaining on this
> mailing list is not going to get anything changed.

Right, I don't think that even changing the spec would help - it would
actually make things worse because then we'd have to differentiate
between UEFI versions: those which can do SetVirtualaddressMap() more
than once and the older ones.

So let's drop the discussion here - it is what it is, it is too late to
change anything. At least we talked about it. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
