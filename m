From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Sat, 30 Apr 2016 23:12:09 +0100
Message-ID: <20160430221209.GO2839@codeblueprint.co.uk>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160429154119.GI113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 29 Apr, at 10:41:19AM, Alex Thorlton wrote:
> 
> You can see here that we've made it past the MMR read in uv_system_init,
> but we die inside of our first EFI callback.  In this example, it looks
> like we're using the kernel page table at the time of the failure, and I
> believe that the failing address is somewhere in our EFI runtime code:
> 
> [    0.803396] efi: ATHORLTON EFI md dump:
> [    0.803396]         type: 5
> [    0.803396]         pad: 0
> [    0.803396]         phys_addr: 6a0a6000
> [    0.803396]         virt_addr: 0
> [    0.803396]         num_pages: 184
> [    0.803396]         attribute: 800000000000000f
> 
> So it looks like we're trying to read from EFI runtime space while using
> the kernel page table, which fails, presumably because the space is also
> not mapped into the kernel page table.  While I understand *why* it
> fails, and why the address isn't mapped, I don't fully know how we
> should handle fixing it.

How come you're not using the new EFI page tables while making EFI
runtime calls?

Who owns the MMR space and what is it used for? Do both the kernel and
the firmware need access to it? My SGI UV knowledge is zero, so I'm
happy to be educated! I can't think of any analogous memory regions on
x86 where the EFI services require the kernel to map them, other than
the EFI regions themselves.

Runtime EFI regions should be opaque, isolated and self-contained.
This is why there are two phases of execution for firmware; before and
after ExitBootServices(). Once the kernel takes control after
ExitBootServices() firmware can no longer provide timer services, for
example, and doesn't care where the kernel maps the LAPIC because it
never tries to access it.

The fact that the UV firmware does care where the MMR space is mapped
makes me suspect that there's a lack of isolation.
