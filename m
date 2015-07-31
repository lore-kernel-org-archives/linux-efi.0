From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 01/16] PM / hibernate: define HMAC algorithm and
 digest size of swsusp
Date: Fri, 31 Jul 2015 18:08:12 +0800
Message-ID: <20150731100812.GD13113@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-2-git-send-email-jlee@suse.com>
 <20150728120156.GB9518@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150728120156.GB9518@amd>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 28, 2015 at 02:01:56PM +0200, Pavel Machek wrote:
> On Thu 2015-07-16 22:25:15, Lee, Chun-Yi wrote:
> > Using HMAC-SHA1 to be the HMAC algorithm of signing hibernate
> > snapshot image. The digest size of HMAC-SHA1 is 160 bits (20 bytes),
> > this size will be also applied to the length of HMAC key.
> > 
> > In addition, add HIBERNATE_VERIFICATION kernel config.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  include/linux/suspend.h |  5 +++++
> >  kernel/power/Kconfig    | 13 +++++++++++++
> >  kernel/power/power.h    |  1 +
> >  3 files changed, 19 insertions(+)
> > 
> > diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> > index 5efe743..6cd2a48 100644
> > --- a/include/linux/suspend.h
> > +++ b/include/linux/suspend.h
> > @@ -327,6 +327,11 @@ struct platform_hibernation_ops {
> >  };
> >  
> >  #ifdef CONFIG_HIBERNATION
> > +
> > +/* HMAC Algorithm of Hibernate Signature */
> > +#define SWSUSP_HMAC		"hmac(sha1)"
> > +#define SWSUSP_DIGEST_SIZE	20
> 
> I'd replace SWSUSP with HIBERNATION here, and pretty much everywhere.
>

SWSUSP is shorter than HIBERNATION, and there have some codes in hibernate
are also using swsusp. I still want to use it.


Thanks a lot!
Joey Lee 
