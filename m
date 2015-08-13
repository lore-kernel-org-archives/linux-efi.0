From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 09/16] PM / hibernate: Reserve hibernation key and
 erase footprints
Date: Thu, 13 Aug 2015 11:25:00 +0800
Message-ID: <20150813032500.GG5518@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-10-git-send-email-jlee@suse.com>
 <1439434143.15722.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439434143.15722.12.camel@localhost>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Chen, Yu C" <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vojtech-AlSwsSmVLrQ@public.gmane.org" <vojtech-AlSwsSmVLrQ@public.gmane.org>, "linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "jkosina-AlSwsSmVLrQ@public.gmane.org" <jkosina-AlSwsSmVLrQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Brown, Len" <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Yu, 

Thanks for your reviewing.

On Thu, Aug 13, 2015 at 02:45:32AM +0000, Chen, Yu C wrote:
> Hi Chun-yi,
> On Tue, 2015-08-11 at 14:16 +0800, Lee, Chun-Yi wrote:
> 
> > +/* A page used to keep hibernation keys */
> > +static struct hibernation_keys *hibernation_keys;
> > +
> > +void __init parse_hibernation_keys(u64 phys_addr, u32 data_len)
> > +{
> > +	struct setup_data *hibernation_setup_data;
> > +
> > +	/* Reserve keys memory, will copy and erase in init_hibernation_keys() */
> > +	keys_phys_addr = phys_addr + sizeof(struct setup_data);
> > +	memblock_reserve(keys_phys_addr, sizeof(struct hibernation_keys));
> > +
> > +	/* clear hibernation_data */
> > +	hibernation_setup_data = early_memremap(phys_addr, data_len);
> > +	if (!hibernation_setup_data)
> > +		return;
> > +
> should we invoke memblock_free if early_memremap failed?
> 
> Best Regards,
> Yu
> 
> 

Should not free memblock reservation of key data.

Using memblock_reserve is for reserve hibernation key until
init_hibernation_keys() copy key data to arbitrary allocated page.
Using early_memremap is for cleaning the setup_data header that's
used to carry key. That above 2 actions are different purposes.

So, even the action of cleaning setup_data failed, it doesn't
affect to the action for reserve hibernation key by memblock until
copy it.


Thanks a lot!
Joey Lee
