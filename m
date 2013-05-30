From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 31 May 2013 00:25:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130530221737.GA11105-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 30 May 2013, Russ Anderson wrote:

> > > > > Yes, but this call is clearly happening way before ExitBootServices() -- 
> > > > > see the surrounding code, see for example this in efi_main():
> > > > > 
> > > > > [ ... snip ... ]
> > > > > 	setup_efi_vars(boot_params);
> > > > > 
> > > > > 	setup_efi_pci(boot_params);
> > > > > 
> > > > > 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > > > > 				EFI_LOADER_DATA, sizeof(*gdt),
> > > > > 				(void **)&gdt);
> > > > > 	if (status != EFI_SUCCESS) {
> > > > > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > > > > 		goto fail;
> > > > > 	}
> > > > > [ ... snip ... ]
> > > > 
> > > > Yes.  Note the failing call is sys_table->runtime while all the
> > > > other calls are sys_table->boottime and seem to work.  Not sure
> > > > why the sys_table->runtime call has a problem but it may be
> > > > a clue.  Could something in the runtime path not be set up???
> > > 
> > > That was my original idea early today as well. My understanding of the 
> > > UEFI spec is admittedly limited, but afaics calling runtime method from 
> > > boot environment should be a valid thing to do ... ?
> > 
> > QueryVariableInfo() is a runtime services, all runtime services should
> > available bother on boot time and runtime:
> > 
> > UEFI spec 2.3.1 P.109:
> >   Runtime Services
> >   Functions that are available before and after any call to  
> >   ExitBootServices(). These functions are described in Section 7.
> 
> That's a great idea.  This patch moves the QueryVariableInfo()
> call from bootime to runtime, in efi_late_init().  The attached
> patch is consistent with the UEFI spec and avoids the problem.

Unfortunately that means that you can as well throw the patch away 
completely.

The sole point is to run the QueryVariableInfo() from the boot 
environment, in order to obtain more accurate information.
And it's a valid thing to do, according to UEFI specification.

-- 
Jiri Kosina
SUSE Labs
