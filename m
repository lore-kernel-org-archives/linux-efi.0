From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Thu, 30 May 2013 00:22:13 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130529210115.GC28027-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 29 May 2013, Russ Anderson wrote:

> > What appears to be happening is that your the EFI runtime services code
> > is calling into the EFI boot services code, which is definitely a bug in
> > your firmware because we're at runtime, but we've seen other machines
> > that do similar things so we usually handle it just fine. However, what
> > makes your case different, and the reason you see the above splat, is
> > that it's using the physical address of the EFI boot services region,
> > not the virtual one we setup with SetVirtualAddressMap(). Which is a
> > second firmware bug. Again, we have seen other machines that access
> > physical addresses after SetVirtualAddressMap(), but until now we
> > haven't had any non-optional code that triggered them.
> > 
> > The only reason I can see that the offending commit would introduce this
> > problem is because it calls QueryVariableInfo() at boot time. I notice
> > that your machine is an SGI UV one, is there any chance you could get a
> > firmware fix for this? If possible, it would be also good to confirm
> > that it's this chunk of code in setup_efi_vars(),
> > 
> > 	status = efi_call_phys4(sys_table->runtime->query_variable_info,
> > 				EFI_VARIABLE_NON_VOLATILE |
> > 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> > 				&remaining_size, &var_size);
> 
> This does trigger the problem.  Note that the definition of
> QueryVariableInfo() in the UEFI spec says:
> 
>   The returned MaximumVariableStorageSize, RemainingVariableStorageSize,
>   MaximumVariableSize information may change immediately after the call
>   based on other runtime activities including asynchronous error events.
>   Also, these values associated with different attributes are not
>   additive in nature.
> 
> Note the values may be accurate at the point in time when returned,
> but may not be after that.
> 
>   After the system has transitioned into runtime (after
>   ExitBootServices() is called), an implementation may not be able to
>   accurately return information about the Boot Services variable store.
>   In such cases, EFI_INVALID_PARAMETER should be returned.
> 
> It is not clear to me exactly when ExitBootServices() is called.
> Our bios is returning a failing indication on the call.

Yes, but this call is clearly happening way before ExitBootServices() -- 
see the surrounding code, see for example this in efi_main():

[ ... snip ... ]
	setup_efi_vars(boot_params);

	setup_efi_pci(boot_params);

	status = efi_call_phys3(sys_table->boottime->allocate_pool,
				EFI_LOADER_DATA, sizeof(*gdt),
				(void **)&gdt);
	if (status != EFI_SUCCESS) {
		efi_printk("Failed to alloc mem for gdt structure\n");
		goto fail;
	}
[ ... snip ... ]

We are calling QueryVariableInfo() in setup_efi_vars(), and later on 
AllocatePool is being called (through boot table). That'd inherently fail 
if we were calling it after ExitBootServices() has happened, but I believe 
that call is succeeding on your affected system as well.

-- 
Jiri Kosina
SUSE Labs
