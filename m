From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 09/16] PM / hibernate: Reserve hibernation key and
 erase footprints
Date: Wed, 9 Sep 2015 13:24:08 +0100
Message-ID: <20150909122408.GE4973@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-10-git-send-email-jlee@suse.com>
 <20150821132753.GC3310@codeblueprint.co.uk>
 <20150827102144.GE27415@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150827102144.GE27415@linux-rxt1.site>
Sender: linux-pm-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 27 Aug, at 06:21:44PM, joeyli wrote:
> On Fri, Aug 21, 2015 at 02:27:53PM +0100, Matt Fleming wrote:
> > On Tue, 11 Aug, at 02:16:29PM, Lee, Chun-Yi wrote:
> > > +static int __init init_hibernation_keys(void)
> > > +{
> > > +	struct hibernation_keys *keys;
> > > +	int ret = 0;
> > > +
> > > +	if (!keys_phys_addr)
> > > +		return -ENODEV;
> > > +
> > > +	keys = early_memremap(keys_phys_addr, sizeof(struct hibernation_keys));
> > > +
> > > +	/* Copy hibernation keys to a allocated page */
> > > +	hibernation_keys = (struct hibernation_keys *)get_zeroed_page(GFP_KERNEL);
> > > +	if (hibernation_keys) {
> > > +		*hibernation_keys = *keys;
> > > +	} else {
> > > +		pr_err("PM: Allocate hibernation keys page failed\n");
> > > +		ret = -ENOMEM;
> > > +	}
> > 
> > It seems overkill to allocate an entire page for 28 bytes of data.
> > 
> 
> Here to allocate an entire page because the basic unit is 'page' when
> hibernation code checking saveable page that should included/excluded in
> snapshot image.
> Allocating an page to hibernation key can clearer to check the page should
> excluded in snapshot image.

Do other pieces of code do something similar, i.e. allocate an entire
page because the hibernation code deals with pages? If so, it might be
possible to lump all these pieces of data together into a single
'auxiliary' page.

-- 
Matt Fleming, Intel Open Source Technology Center
