From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 31 May 2013 12:12:50 +0200
Message-ID: <20130531101250.GD30394@gmail.com>
References: <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305310023020.30576-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org> wrote:

> On Thu, 30 May 2013, Russ Anderson wrote:
> 
> > > > > > Yes, but this call is clearly happening way before ExitBootServices() -- 
> > > > > > see the surrounding code, see for example this in efi_main():
> > > > > > 
> > > > > > [ ... snip ... ]
> > > > > > 	setup_efi_vars(boot_params);
> > > > > > 
> > > > > > 	setup_efi_pci(boot_params);
> > > > > > 
> > > > > > 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > > > > > 				EFI_LOADER_DATA, sizeof(*gdt),
> > > > > > 				(void **)&gdt);
> > > > > > 	if (status != EFI_SUCCESS) {
> > > > > > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > > > > > 		goto fail;
> > > > > > 	}
> > > > > > [ ... snip ... ]
> > > > > 
> > > > > Yes.  Note the failing call is sys_table->runtime while all the
> > > > > other calls are sys_table->boottime and seem to work.  Not sure
> > > > > why the sys_table->runtime call has a problem but it may be
> > > > > a clue.  Could something in the runtime path not be set up???
> > > > 
> > > > That was my original idea early today as well. My understanding of the 
> > > > UEFI spec is admittedly limited, but afaics calling runtime method from 
> > > > boot environment should be a valid thing to do ... ?
> > > 
> > > QueryVariableInfo() is a runtime services, all runtime services should
> > > available bother on boot time and runtime:
> > > 
> > > UEFI spec 2.3.1 P.109:
> > >   Runtime Services
> > >   Functions that are available before and after any call to  
> > >   ExitBootServices(). These functions are described in Section 7.
> > 
> > That's a great idea.  This patch moves the QueryVariableInfo()
> > call from bootime to runtime, in efi_late_init().  The attached
> > patch is consistent with the UEFI spec and avoids the problem.
> 
> Unfortunately that means that you can as well throw the patch away 
> completely.
> 
> The sole point is to run the QueryVariableInfo() from the boot 
> environment, in order to obtain more accurate information. And it's a 
> valid thing to do, according to UEFI specification.

Argh!

The 'UEFI specification', if contradicted by reality, has _NO VALUE_ 
whatsoever. Full stop.

Any specification is only valuable as long as it's followed by everyone: 
but once that is not the case, it does not matter much what the written 
wishes on the paper express.

What matters is that a system that booted fine with v3.8 does not boot 
anymore due to a change we did to the EFI code. And the only valid 
response to that is to make it work. Full stop!

And this is not only about SGI/UV systems: in this thread there were 
multiple systems mentioned that _DO NOT BOOT_ due to this change.

So this change needs to be reverted or fixed.

Thanks,

	Ingo
