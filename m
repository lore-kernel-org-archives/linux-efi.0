From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v7 1/2] efi: export efi_capsule_supported() function
 symbol
Date: Wed, 7 Oct 2015 02:01:06 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A864DCF@PGSMSX102.gar.corp.intel.com>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com>
 <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com>
 <20151005131350.GA26329@nazgul.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A864613@PGSMSX102.gar.corp.intel.com>
 <5612EB38.2050209@nexus-software.ie>
 <F54AEECA5E2B9541821D670476DAE19C4A864B5D@PGSMSX102.gar.corp.intel.com>
 <5613E076.20508@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5613E076.20508-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Bryan O'Donoghue [mailto:pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org]
> Sent: Tuesday, October 06, 2015 10:54 PM
> >>
> >> Aside from that, I'm curious which types of capsules you've used here
> >> too - does it include the MFH header ? Keep in mind the initial
> >> firmware that shipped with Galileo will depend on that MFH being
> present.
> >>
> >>
> http://download.intel.com/support/processors/quark/sb/quark_secureboo
> >> t
> >> prm_330234_001.pdf
> >> - Section A1 - table 7 ?
> >>
> >> So if we boot a 4.x kernel with that initial firmware version 0.75 if
> >> memory serves - it's important that the capsule.c code handles the MFH.
> >>
> >
> > Already got agreement with Matt that Quark Security Header patch will
> > not be upstream to mainline as it is not a standard header. So Intel
> > will carry this patch ourselves.
> 
> Right... so what sort of capsule are you testing with ?

I am testing on Intel Galileo Gen 1 with bios version v0.7.5, v0.8.0, v1.0.1 & v1.0.2.

Thanks & Regards,
Wilson
