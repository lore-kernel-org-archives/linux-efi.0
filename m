From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 5 Aug 2013 16:40:10 +0200
Message-ID: <20130805144010.GE31845@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51FFB660.4060400-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
> I wouldn't call the design of SetVirtualAddressMap() braindead.

Ok, I've always wondered and you could probably shed some light on the
matter: why is SetVirtualAddressMap() a call-once only? Why can't I
simply call it again and update the mappings?

> I'd rather call kexec unique and somewhat unexpected :)

In all fairness, it was there before UEFI, AFAICT.

> > I wouldn't wonder if we f*cked it up again like the last time. I'll give
> > it a long hard look.
> 
> Ah sorry, by "and you guys suspect" I didn't mean to imply anything
> between the lines, I was simply trying to ascertain your working idea :)

As long as we get to the bottom of this, we're all fine. And I'd
pretty much expect everyone who is dealing with EFI to have grown a
sufficiently thick skin before starting to do so, so don't worry.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
