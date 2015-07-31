From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 09/16] PM / hibernate: Reserve swsusp key and earse
 footprints
Date: Fri, 31 Jul 2015 23:43:03 +0800
Message-ID: <20150731154303.GF2067@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-10-git-send-email-jlee@suse.com>
 <20150728123523.GD12681@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150728123523.GD12681@amd>
Sender: linux-pm-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 28, 2015 at 02:35:23PM +0200, Pavel Machek wrote:
> Typo in patch subject.
> 
> > And for earsing footbprints, the codes in this patch remove setup
> 
> And two typos here.
>

Sorry for subject and above typos, I will fix it.
Thanks.
 
> > data that carried swsusp key, and clean the memory space that
> 
> And don't call it swsusp. Please fix globally.
> 

OK~
								
> > +++ b/arch/x86/power/hibernate_keys.c
> > @@ -0,0 +1,79 @@
> > +/* Swsusp keys handler
> > + *
> > + * Copyright (C) 2015 SUSE Linux Products GmbH. All rights
> 
> Are you sure?
> 

Thank for your finding here, I will change the Copyright to me with my
company mail address.

> > +static int __init init_hibernate_keys(void)
> > +{
> > +	struct swsusp_keys *keys;
> > +	int ret = 0;
> > +
> > +	if (!keys_phys_addr)
> > +		return -ENODEV;
> > +
> > +	keys = early_memremap(keys_phys_addr, sizeof(struct swsusp_keys));
> > +
> > +	/* Copy swsusp keys to a allocated page */
> > +	swsusp_keys = (struct swsusp_keys *)get_zeroed_page(GFP_KERNEL);
> > +	if (swsusp_keys) {
> > +		*swsusp_keys = *keys;
> > +	} else {
> > +		pr_err("PM: Allocate swsusp keys page failed\n");
> > +		ret = -ENOMEM;
> > +	}
> > +
> > +	/* Earse keys data no matter copy success or failed */
> > +	memset(keys, 0, sizeof(struct swsusp_keys));
> > +	early_memunmap(keys, sizeof(struct swsusp_keys));
> > +	memblock_free(keys_phys_addr, sizeof(struct swsusp_keys));
> > +	keys_phys_addr = 0;
> > +
> > +	return ret;
> > +}
> > +
> > +late_initcall(init_hibernate_keys);
> 
> init_hibernation_keys.
> 
> 
> 								Pavel

I will change the function name.


Thanks a lot!
Joey Lee
