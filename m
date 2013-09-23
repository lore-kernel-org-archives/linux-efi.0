From: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCHv2] x86: EFI stub support for large memory maps
Date: Sun, 22 Sep 2013 18:23:28 -0600
Message-ID: <20130923002328.GC24764@oranje.fc.hp.com>
References: <1377291771-21302-1-git-send-email-linn@hp.com>
 <1378487056-9857-1-git-send-email-linn@hp.com>
 <20130917201452.GI3409@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130917201452.GI3409-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 17, 2013 at 09:14:52PM +0100, Matt Fleming wrote:
> > +static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
> > +				  u32 *e820ext_size)
> > +{
> > +	efi_status_t status;
> > +	unsigned long size;
> > +
> > +	size = sizeof(struct setup_data) +
> > +		sizeof(struct e820entry) * nr_desc;
> > +
> > +	if (*e820ext && size <= *e820ext_size)
> > +		return EFI_SUCCESS; /* Already allocated */
> 
> Do we actually need this check? I thought the 'prev_nr_desc' below
> ensures we only allocate 'e820ext' if we need more memory.

I am okay with removing the check. There is another bug in exit_boot, when
jumping to get_map the call to get the memory map is passed the previous map
size instead of the size of the allocated buffer. I'll make the changes and
resend.

> 
> [...]
> 
> > @@ -1016,6 +1157,19 @@ get_map:
> >  	if (status != EFI_SUCCESS)
> >  		goto free_mem_map;
> >  
> > +	prev_nr_desc = nr_desc;
> > +	nr_desc = size / desc_size;
> > +	if (nr_desc > prev_nr_desc &&
> > +	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
> > +		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
> > +
> > +		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
> > +		if (status != EFI_SUCCESS)
> > +			goto free_mem_map;
> > +
> > +		goto get_map; /* Allocated memory, get map again */
> > +	}
> > +
