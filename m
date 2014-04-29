From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Date: Tue, 29 Apr 2014 12:21:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404291217380.6261@ionos.tec.linutronix.de>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com> <20140425115345.GC26088@console-pimps.org> <20140426072821.GA2286@darkstar.redhat.com> <20140429094539.GD26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140429094539.GD26088-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 29 Apr 2014, Matt Fleming wrote:
> I would just replace the existing calls to early_ioremap() with
> efi_ioremap() and implement it like so (all in
> arch/x86/platform/efi/early_printk.c),
> 
> static void *efi_ioremap(resource_size_t phys_addr, unsigned long size)
> {
> 	if (system_state == SYSTEM_BOOTING)
> 		return early_ioremap(phys_addr, size);
> 
> 	return ioremap(phys_addr, size);
> }
> 
> At least I think SYSTEM_BOOTING is the correct way to figure out when to
> use early_ioremap(), I'm open to other suggestions though.

ioremap() is available after paging_init() has been called.

Just x86 has this extra bits so you can use early_ioremap/unmap
_AFTER_ paging_init(). No idea why, but probably to cope with some
brilliant init calls which run pre and post paging_init().

Thanks,

	tglx
