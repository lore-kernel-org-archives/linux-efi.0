From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 09/16] PM / hibernate: Reserve hibernation key and
 erase footprints
Date: Sun, 13 Sep 2015 10:58:09 +0800
Message-ID: <20150913025809.GB6752@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-10-git-send-email-jlee@suse.com>
 <20150821132753.GC3310@codeblueprint.co.uk>
 <20150827102144.GE27415@linux-rxt1.site>
 <20150909122408.GE4973@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150909122408.GE4973-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 09, 2015 at 01:24:08PM +0100, Matt Fleming wrote:
> On Thu, 27 Aug, at 06:21:44PM, joeyli wrote:
> > On Fri, Aug 21, 2015 at 02:27:53PM +0100, Matt Fleming wrote:
> > > On Tue, 11 Aug, at 02:16:29PM, Lee, Chun-Yi wrote:
> > > > +static int __init init_hibernation_keys(void)
> > > > +{
> > > > +	struct hibernation_keys *keys;
> > > > +	int ret = 0;
> > > > +
> > > > +	if (!keys_phys_addr)
> > > > +		return -ENODEV;
> > > > +
> > > > +	keys = early_memremap(keys_phys_addr, sizeof(struct hibernation_keys));
> > > > +
> > > > +	/* Copy hibernation keys to a allocated page */
> > > > +	hibernation_keys = (struct hibernation_keys *)get_zeroed_page(GFP_KERNEL);
> > > > +	if (hibernation_keys) {
> > > > +		*hibernation_keys = *keys;
> > > > +	} else {
> > > > +		pr_err("PM: Allocate hibernation keys page failed\n");
> > > > +		ret = -ENOMEM;
> > > > +	}
> > > 
> > > It seems overkill to allocate an entire page for 28 bytes of data.
> > > 
> > 
> > Here to allocate an entire page because the basic unit is 'page' when
> > hibernation code checking saveable page that should included/excluded in
> > snapshot image.
> > Allocating an page to hibernation key can clearer to check the page should
> > excluded in snapshot image.
> 
> Do other pieces of code do something similar, i.e. allocate an entire
> page because the hibernation code deals with pages? If so, it might be
> possible to lump all these pieces of data together into a single
> 'auxiliary' page.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

Thanks for your suggestions, I will lump all these data to into a single page
with the key. I want keep all the contents in the page only for hibernation's
usage but not to share with other subsystem in kernel, that's more safe to avoid
the key be accessed by with other code.


Thanks a lot!
Joey Lee
