From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64: xen: Implement EFI reset_system callback
Date: Wed, 19 Apr 2017 21:29:06 +0200
Message-ID: <20170419192906.GO16658@olila.local.net-space.pl>
References: <20170405181417.15985-1-julien.grall@arm.com>
 <e5b548be-2ec3-9b4f-a456-929d5fb881ab@oracle.com>
 <b8c9c6cd-906a-2360-ca9f-d34a45258567@suse.com>
 <3f6f5853-cd08-8afc-f71a-b0c1545c7564@arm.com>
 <20170406142710.GE4372@olila.local.net-space.pl>
 <ed7f64f4-17db-e2a5-f362-b382666cbc36@suse.com>
 <20170406152040.GH4372@olila.local.net-space.pl>
 <e449f220-8db7-d58c-bdbf-47ccd6dd014b@arm.com>
 <20170406155453.GA3966@leverpostej>
 <20170418134650.GL24360@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170418134650.GL24360-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 02:46:50PM +0100, Matt Fleming wrote:
> On Thu, 06 Apr, at 04:55:11PM, Mark Rutland wrote:
> >
> > Please, let's keep the Xen knowledge constrained to the Xen EFI wrapper,
> > rather than spreading it further.
> >
> > IMO, given reset_system is a *mandatory* function, the Xen wrapper
> > should provide an implementation.
> >
> > I don't see why you can't implement a wrapper that calls the usual Xen
> > poweroff/reset functions.
>
> I realise I'm making a sweeping generalisation, but adding
> EFI_PARAVIRT is almost always the wrong thing to do.

Why?

> I'd much prefer to see Mark's idea implemented.

If you wish I do not object.

Daniel
