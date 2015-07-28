From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [RFC PATCH 09/16] PM / hibernate: Reserve swsusp key and earse
 footprints
Date: Tue, 28 Jul 2015 14:35:23 +0200
Message-ID: <20150728123523.GD12681@amd>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-10-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437056730-15247-10-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Typo in patch subject.

> And for earsing footbprints, the codes in this patch remove setup

And two typos here.

> data that carried swsusp key, and clean the memory space that

And don't call it swsusp. Please fix globally.
								
> +++ b/arch/x86/power/hibernate_keys.c
> @@ -0,0 +1,79 @@
> +/* Swsusp keys handler
> + *
> + * Copyright (C) 2015 SUSE Linux Products GmbH. All rights

Are you sure?

> +static int __init init_hibernate_keys(void)
> +{
> +	struct swsusp_keys *keys;
> +	int ret = 0;
> +
> +	if (!keys_phys_addr)
> +		return -ENODEV;
> +
> +	keys = early_memremap(keys_phys_addr, sizeof(struct swsusp_keys));
> +
> +	/* Copy swsusp keys to a allocated page */
> +	swsusp_keys = (struct swsusp_keys *)get_zeroed_page(GFP_KERNEL);
> +	if (swsusp_keys) {
> +		*swsusp_keys = *keys;
> +	} else {
> +		pr_err("PM: Allocate swsusp keys page failed\n");
> +		ret = -ENOMEM;
> +	}
> +
> +	/* Earse keys data no matter copy success or failed */
> +	memset(keys, 0, sizeof(struct swsusp_keys));
> +	early_memunmap(keys, sizeof(struct swsusp_keys));
> +	memblock_free(keys_phys_addr, sizeof(struct swsusp_keys));
> +	keys_phys_addr = 0;
> +
> +	return ret;
> +}
> +
> +late_initcall(init_hibernate_keys);

init_hibernation_keys.


								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
