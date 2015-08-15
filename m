From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH v2 08/16] x86/efi: Carrying hibernation key by setup
 data
Date: Sat, 15 Aug 2015 19:07:38 +0200
Message-ID: <20150815170737.GA25353@Nokia-N900>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-9-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-9-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue 2015-08-11 14:16:28, Lee, Chun-Yi wrote:
> For forwarding hibernation key from EFI stub to boot kernel, this patch
> allocates setup data for carrying hibernation key, size and the status
> of efi operating.
> 
> Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>

Jiri, are you sure you reviewed these? This is not really
english, afaict, and efi/EFI should be spelled consistently.

Could you try reviewing it again? Pointing out 10s of small
bugs is quite boring...

>  	unsigned long key_size;
>  	unsigned long attributes;
> +	struct setup_data *setup_data, *hibernation_setup_data;
>  	struct hibernation_keys *keys;
> +	unsigned long size = 0;
>  	efi_status_t status;
>  
>  	/* Allocate setup_data to carry keys */
> +	size = sizeof(struct setup_data) + sizeof(struct hibernation_keys);
>  	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> -				sizeof(struct hibernation_keys), &keys);
> +				size, &hibernation_setup_data);
>  	if (status != EFI_SUCCESS) {
>  		efi_printk(sys_table, "Failed to alloc mem for hibernation keys\n");
>  		return;
>  	}
>  
> -	memset(keys, 0, sizeof(struct hibernation_keys));
> +	memset(hibernation_setup_data, 0, size);
> +	keys = (struct hibernation_keys *) hibernation_setup_data->data;
>  

any chance to type stuff correctly so that casts are not
neccessary?

> +clean_fail:
> +	hibernation_setup_data->type = SETUP_HIBERNATION_KEYS;
> +	hibernation_setup_data->len = sizeof(struct hibernation_keys);
> +	hibernation_setup_data->next = 0;
> +	keys->hkey_status = efi_status_to_err(status);
> +
> +	setup_data = (struct setup_data *)params->hdr.setup_data;
> +	while (setup_data && setup_data->next)
> +		setup_data = (struct setup_data *)setup_data->next;

way too many casts here.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
