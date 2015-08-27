From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2 09/16] PM / hibernate: Reserve hibernation key and
 erase footprints
Date: Thu, 27 Aug 2015 18:21:44 +0800
Message-ID: <20150827102144.GE27415@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-10-git-send-email-jlee@suse.com>
 <20150821132753.GC3310@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150821132753.GC3310@codeblueprint.co.uk>
Sender: linux-pm-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 21, 2015 at 02:27:53PM +0100, Matt Fleming wrote:
> On Tue, 11 Aug, at 02:16:29PM, Lee, Chun-Yi wrote:
> > Add handler to parse the setup data that carrying hibernation key, it
> > reserves hibernation key by memblock then copies key to a allocated page
> > in later initcall stage.
> > 
> > And for erasing footprints, the codes in this patch remove setup
> > data that carried hibernation key, and clean the memory space that
> > reserved by memblock.
> > 
> > Reviewed-by: Jiri Kosina <jkosina@suse.com>
> > Tested-by: Jiri Kosina <jkosina@suse.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  arch/x86/include/asm/suspend.h  |  4 +++
> >  arch/x86/kernel/setup.c         | 21 ++++++++++-
> >  arch/x86/power/Makefile         |  1 +
> >  arch/x86/power/hibernate_keys.c | 78 +++++++++++++++++++++++++++++++++++++++++
> >  kernel/power/power.h            |  5 +++
> >  5 files changed, 108 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/x86/power/hibernate_keys.c
> 
> [...]
> 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 80f874b..b345359 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -112,6 +112,8 @@
> >  #include <asm/alternative.h>
> >  #include <asm/prom.h>
> >  
> > +#include <asm/suspend.h>
> > +
> >  /*
> >   * max_low_pfn_mapped: highest direct mapped pfn under 4GB
> >   * max_pfn_mapped:     highest direct mapped pfn over 4GB
> > @@ -425,10 +427,22 @@ static void __init reserve_initrd(void)
> >  }
> >  #endif /* CONFIG_BLK_DEV_INITRD */
> >  
> > +static void __init remove_setup_data(u64 pa_prev, u64 pa_next)
> > +{
> > +	struct setup_data *data;
> > +
> > +	if (pa_prev) {
> > +		data = early_memremap(pa_prev, sizeof(*data));
> > +		data->next = pa_next;
> > +		early_iounmap(data, sizeof(*data));
> 
> This should be early_memunmap for consistency().
>

I will use early_memunmap, thanks!
 
> > diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
> > new file mode 100644
> > index 0000000..357dc0e
> > --- /dev/null
> > +++ b/arch/x86/power/hibernate_keys.c
> > @@ -0,0 +1,78 @@
> > +/* Hibernation keys handler
> > + *
> > + * Copyright (C) 2015 Lee, Chun-Yi <jlee@suse.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public Licence
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the Licence, or (at your option) any later version.
> > + */
> > +
> > +#include <linux/bootmem.h>
> > +#include <linux/memblock.h>
> > +#include <linux/suspend.h>
> > +#include <asm/suspend.h>
> > +
> > +/* physical address of hibernation keys from boot params */
> > +static u64 keys_phys_addr;
> > +
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
> > +	memset(hibernation_setup_data, 0, sizeof(struct setup_data));
> 
> Why is this necessary? You're only clearing the struct setup_data
> fields and you unlinked this setup_data entry in remove_setup_data()
> anyway.
>

I want clean the setup_data fields that point to key data
before remove it from setup_data list.
 
> > +	early_memunmap(hibernation_setup_data, data_len);
> > +}
> > +
> > +int get_hibernation_key(u8 **hkey)
> > +{
> > +	if (!hibernation_keys)
> > +		return -ENODEV;
> > +
> > +	if (!hibernation_keys->hkey_status)
> > +		*hkey = hibernation_keys->hibernation_key;
> > +
> > +	return hibernation_keys->hkey_status;
> > +}
> 
> For global functions like this it's usually much preferred to prefix
> the name with the subsystem, i.e. hibernation_get_key().
>

I see, I will change the function name.
 
> > +static int __init init_hibernation_keys(void)
> > +{
> > +	struct hibernation_keys *keys;
> > +	int ret = 0;
> > +
> > +	if (!keys_phys_addr)
> > +		return -ENODEV;
> > +
> > +	keys = early_memremap(keys_phys_addr, sizeof(struct hibernation_keys));
> > +
> > +	/* Copy hibernation keys to a allocated page */
> > +	hibernation_keys = (struct hibernation_keys *)get_zeroed_page(GFP_KERNEL);
> > +	if (hibernation_keys) {
> > +		*hibernation_keys = *keys;
> > +	} else {
> > +		pr_err("PM: Allocate hibernation keys page failed\n");
> > +		ret = -ENOMEM;
> > +	}
> 
> It seems overkill to allocate an entire page for 28 bytes of data.
> 

Here to allocate an entire page because the basic unit is 'page' when
hibernation code checking saveable page that should included/excluded in
snapshot image.
Allocating an page to hibernation key can clearer to check the page should
excluded in snapshot image.

> -- 
> Matt Fleming, Intel Open Source Technology Center


Thanks a lot!
Joey Lee
