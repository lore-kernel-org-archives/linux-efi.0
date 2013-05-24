From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 24 May 2013 13:09:11 +0200
Message-ID: <20130524110911.GA32220@nazgul.tnic>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130524074331.GL14575-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 24, 2013 at 08:43:31AM +0100, Matt Fleming wrote:
> What appears to be happening is that your the EFI runtime services
> code is calling into the EFI boot services code, which is definitely
> a bug in your firmware because we're at runtime, but we've seen
> other machines that do similar things so we usually handle it just
> fine. However, what makes your case different, and the reason you
> see the above splat, is that it's using the physical address of
> the EFI boot services region, not the virtual one we setup with
> SetVirtualAddressMap(). Which is a second firmware bug.

I'm speechless. Let's have someone else do the ranting this time:

http://www.happyassassin.net/2013/05/03/a-day-in-the-life-of-a-firmware-engineer/

> Again, we have seen other machines that access
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

What do you mean, map boot time functions 1:1 too?

In any case, I think I have an idea about the bug I was discussing with
hpa recently but I need to do more experimenting. I have the next week
off, though, so don't hold your breath just yet :).
