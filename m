From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Date: Thu, 3 Oct 2013 15:27:21 +0100
Message-ID: <20131003142721.GB2781@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
 <20131003095224.GX21381@console-pimps.org>
 <1380807804.17503.9.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1380807804.17503.9.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 03 Oct, at 09:43:24AM, Mark Salter wrote:
> On Thu, 2013-10-03 at 10:52 +0100, Matt Fleming wrote:
> > > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > > +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> > > +                            void *fdt, int new_fdt_size, char *cmdline_ptr,
> > > +                            u64 initrd_addr, u64 initrd_size,
> > > +                            efi_memory_desc_t *memory_map,
> > > +                            unsigned long map_size, unsigned long desc_size,
> > > +                            u32 desc_ver)
> > 
> > Hmm... does this function really belong in efi-stub-helper.c? That file
> > should be for architecture independent functionality only.
> > 
> 
> It isn't really arm-specific although arm is the only user right now.
> We're using the FDT to pass EFI boot info that is passed in the boot
> params block on x86. So potentially other architectures could use the
> same code.

It's not EFI-specific either, apart from the fdt property names.

> How about making it someting like:
> 
> #ifdef ARCH_NEEDS_EFI_FDT
> static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> ...
> #endif
> 
> so the architecture can decide whether to include it or not.

Is one implementation of this function going to fit all architectures?
Can we be sure of that ahead of time?

I'd prefer this to be kept in arch/ for now, and possibly moved into
efi-stub-helper.c at a later date if indeed it turns out to be generally
useful.

-- 
Matt Fleming, Intel Open Source Technology Center
