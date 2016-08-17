From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Wed, 17 Aug 2016 15:01:51 +0800
Message-ID: <20160817070151.GC5498@dhcp-128-65.nay.redhat.com>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
 <20160815150709.GA6085@nazgul.tnic>
 <20160815184731.GS214806@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160815184731.GS214806-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> > Why do you guys need the physical mapping all of a sudden?
> 
> It's not that we need it all of the sudden, necessarily, it's just that
> we've had to make other changes to make things work with the new,
> (almost) completely isolated, EFI page tables.  We ended up choosing the
> lesser of two evils, and have decided to temporarily rely on the
> physical address of our runtime code, instead of continuing to rely on
> EFI_OLD_MEMMAP.

In efi_map_region, there is already mapped md->phys_addr for broken
firmware. SGI still need EFI_OLD_MEMMAP? I means in 1st kernel instead
of kexec kernel.

void __init efi_map_region(efi_memory_desc_t *md)
{
        unsigned long size = md->num_pages << PAGE_SHIFT;
        u64 pa = md->phys_addr;

        if (efi_enabled(EFI_OLD_MEMMAP))
                return old_map_region(md);

        /*
         * Make sure the 1:1 mappings are present as a catch-all for
         * b0rked
         * firmware which doesn't update all internal pointers after
         * switching
         * to virtual mode and would otherwise crap on us.
         */
        __map_region(md, md->phys_addr);

[snip]

Thanks
Dave
