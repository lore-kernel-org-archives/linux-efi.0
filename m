From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Tue, 28 May 2013 10:35:05 +0200
Message-ID: <20130528083505.GA30042@gmail.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130524074331.GL14575-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> What appears to be happening is that your the EFI runtime services code 
> is calling into the EFI boot services code, which is definitely a bug in 
> your firmware because we're at runtime, but we've seen other machines 
> that do similar things so we usually handle it just fine. However, what 
> makes your case different, and the reason you see the above splat, is 
> that it's using the physical address of the EFI boot services region, 
> not the virtual one we setup with SetVirtualAddressMap(). Which is a 
> second firmware bug. Again, we have seen other machines that access 
> physical addresses after SetVirtualAddressMap(), but until now we 
> haven't had any non-optional code that triggered them.
> 
> The only reason I can see that the offending commit would introduce this 
> problem is because it calls QueryVariableInfo() at boot time. I notice 
> that your machine is an SGI UV one, is there any chance you could get a 
> firmware fix for this? If possible, it would be also good to confirm 
> that it's this chunk of code in setup_efi_vars(),
> 
> 	status = efi_call_phys4(sys_table->runtime->query_variable_info,
> 				EFI_VARIABLE_NON_VOLATILE |
> 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> 				&remaining_size, &var_size);
> 
> that later makes GetNextVariable() jump to the physical address of the 
> EFI Boot Services region. Because if not, we need to do some more 
> digging.
> 
> Borislav, how are your 1:1 mapping patches coming along? In theory, once 
> those are merged we can gracefully workaround these kinds of issues.

Handling these gracefully without crashing boxes or expecting firmware to 
be sane (which is wishful thinking) would be _SO_ preferred ...

I suspect 1:1 mapped is what Windows does - and we simply need to provide 
a Windows-EFI compatible environment (which is reality), not just an 
EFI-spec environment (which is a fiction).

Thanks,

	Ingo
