From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v7 09/12] efi: passing kexec necessary efi data via
 setup_data
Date: Mon, 23 Dec 2013 08:07:41 +0000
Message-ID: <20131223080741.GB28919@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <1387533742-18018-10-git-send-email-dyoung@redhat.com>
 <20131221160416.GD29501@console-pimps.org>
 <20131223020958.GB3760@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131223020958.GB3760-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 23 Dec, at 10:09:58AM, Dave Young wrote:
> On 12/21/13 at 04:06pm, Matt Fleming wrote:
> > On Fri, 20 Dec, at 06:02:19PM, Dave Young wrote:
> > > @@ -133,6 +133,19 @@ extern void efi_sync_low_kernel_mappings(void);
> > >  extern void efi_setup_page_tables(void);
> > >  extern void __init old_map_region(efi_memory_desc_t *md);
> > >  
> > > +struct efi_setup_data {
> > > +	u64 fw_vendor;
> > > +	u64 runtime;
> > > +	u64 tables;
> > > +	u64 smbios;
> > > +	u64 reserved[8];
> > > +	efi_memory_desc_t map[0];
> > > +};
> > 
> > [...]
> > 
> > > +static void get_nr_runtime_map(void)
> > > +{
> > > +	if (!efi_setup)
> > > +		return;
> > > +
> > > +	nr_efi_runtime_map = (efi_data_len - sizeof(struct efi_setup_data)) /
> > > +			     sizeof(efi_memory_desc_t);
> > > +}
> > 
> > Do we actually need the 'map' entry in efi_setup_data now that you're
> > passing it via efi_info (which is much better approach!)? Also, we don't
> > need the global nr_efi_runtime_map or efi_runtime_map variables now,
> > right?
> 
> The map is still necessary because we need store the map somewhere and pass
> the physicall address to kexec kernel. Passing them in setup_data is the
> only better way currently...
> 
> In efi_info there's only an entry for the map physical address, the original
> map area is not valid any more.

Where do you dereference efi_setup_data.map* in the kexec kernel?

-- 
Matt Fleming, Intel Open Source Technology Center
