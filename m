From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH] efivar: Disable get_next_variable when firmware is
 broken
Date: Wed, 20 Mar 2013 02:10:24 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6FF6A@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6FBF6@USINDEM103.corp.hds.com>
 <5148E38D.5010109@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5148E38D.5010109-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Andre Heider (a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Lingzhu Xiang (lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Matt Fleming
> Sent: Tuesday, March 19, 2013 6:16 PM
> To: Seiji Aguchi
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Andre Heider (a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org); Lingzhu Xiang (lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org); mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; dle-
> develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Satoru Moriya; Tomoki Sekiyama
> Subject: Re: [PATCH] efivar: Disable get_next_variable when firmware is broken
> 
> On 03/19/2013 09:17 PM, Seiji Aguchi wrote:
> > [Problem]
> > Some firmware implementations return the same variable name on
> > multiple calls to get_next_variable().
> > In this case, an efivar driver gets stuck in a infinite loop at
> > initializing time, register_efivars().
> > It is hard for users to fix the broken firmware.
> >
> > Here is an actual result of the case above.
> > http://article.gmane.org/gmane.linux.kernel.efi/835
> >
> > [Solution]
> > This patch terminates the loop immediately and disables
> > get_next_variable() at the initializing time when the same variable
> > name is found on multiple calls to get_next_variable().
> >
> > Also, to avoid stucking in the infinite loop, update_sysfs_entries
> > returns without calling get_next_variable if the case above happens.
> >
> > Reported-by: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
> > ---
> >  drivers/firmware/efivars.c     |   34 ++++++++++++++++++++++++++++++++--
> >  drivers/firmware/google/gsmi.c |    4 +++-
> >  include/linux/efi.h            |    3 ++-
> >  3 files changed, 37 insertions(+), 4 deletions(-)
> 
> I don't see how this solution is an improvement to the patch I posted here.
> 
> 	http://article.gmane.org/gmane.linux.kernel.efi/905

Ah, I just missed your patch above.
It is reasonable to me.

> 
> You unconditionally call efivar_update_sysfs_entries(), even when the algorithm isn't going to succeed. Your patch also spreads this
> firmware brain damage into the gsmi.c code, which really doesn't need to concern itself with these problems.
> 

I agree. Thank you for giving me the comment.

Seiji

> --
> Matt Fleming, Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html
