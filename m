From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 24 May 2013 08:43:31 +0100
Message-ID: <20130524074331.GL14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130523203234.GD20913-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 23 May, at 03:32:34PM, Russ Anderson wrote:
>    efi: mem127: type=4, attr=0xf, range=[0x000000006bb22000-0x000000007ca9c000) (271MB)

EFI_BOOT_SERVICES_CODE

>    efi: mem133: type=5, attr=0x800000000000000f, range=[0x000000007daff000-0x000000007dbff000) (1MB)

EFI_RUNTIME_SERVICES_CODE

>    EFI Variables Facility v0.08 2004-May-17
>    BUG: unable to handle kernel paging request at 000000007ca95b10
>    IP: [<ffff88007dbf2140>] 0xffff88007dbf213f

This...

>    Call Trace:
>     [<ffffffff81139a34>] ?  __alloc_pages_nodemask+0x154/0x2f0
>     [<ffffffff81174f7d>] ?  alloc_page_interleave+0x9d/0xa0
>     [<ffffffff812fe192>] ?  put_dec+0x72/0x90
>     [<ffffffff812f6d53>] ?  ida_get_new_above+0xb3/0x220
>     [<ffffffff812f6174>] ?  sub_alloc+0x74/0x1d0
>     [<ffffffff812f6174>] ?  sub_alloc+0x74/0x1d0
>     [<ffffffff812f6d53>] ?  ida_get_new_above+0xb3/0x220
>     [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150

is junk on the stack.

>     [<ffffffff810499b3>] ?  efi_call3+0x43/0x80
>     [<ffffffff810492a7>] ?  virt_efi_get_next_variable+0x47/0x1c0
>     [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
>     [<ffffffff814c7b55>] ?  efivar_init+0xd5/0x390
>     [<ffffffff814c8ae0>] ?  efivar_update_sysfs_entries+0x90/0x90
>     [<ffffffff812f906b>] ?  kobject_uevent+0xb/0x10
>     [<ffffffff812f812b>] ?  kset_register+0x5b/0x70
>     [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
>     [<ffffffff814c8d47>] ?  efivars_sysfs_init+0x87/0xf0
>     [<ffffffff8100032a>] ?  do_one_initcall+0x15a/0x1b0
>     [<ffffffff81a17831>] ?  do_basic_setup+0xad/0xce
>     [<ffffffff81a17ae3>] ?  kernel_init_freeable+0x291/0x291
>     [<ffffffff81a3708a>] ?  sched_init_smp+0x15b/0x162
>     [<ffffffff81a17a5f>] ?  kernel_init_freeable+0x20d/0x291
>     [<ffffffff81601eb0>] ?  rest_init+0x80/0x80
>     [<ffffffff81601ebe>] ?  kernel_init+0xe/0x180
>     [<ffffffff8162179c>] ?  ret_from_fork+0x7c/0xb0
>     [<ffffffff81601eb0>] ?  rest_init+0x80/0x80

Here's the real call stack leading up to the crash.

What appears to be happening is that your the EFI runtime services code
is calling into the EFI boot services code, which is definitely a bug in
your firmware because we're at runtime, but we've seen other machines
that do similar things so we usually handle it just fine. However, what
makes your case different, and the reason you see the above splat, is
that it's using the physical address of the EFI boot services region,
not the virtual one we setup with SetVirtualAddressMap(). Which is a
second firmware bug. Again, we have seen other machines that access
physical addresses after SetVirtualAddressMap(), but until now we
haven't had any non-optional code that triggered them.

The only reason I can see that the offending commit would introduce this
problem is because it calls QueryVariableInfo() at boot time. I notice
that your machine is an SGI UV one, is there any chance you could get a
firmware fix for this? If possible, it would be also good to confirm
that it's this chunk of code in setup_efi_vars(),

	status = efi_call_phys4(sys_table->runtime->query_variable_info,
				EFI_VARIABLE_NON_VOLATILE |
				EFI_VARIABLE_BOOTSERVICE_ACCESS |
				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
				&remaining_size, &var_size);

that later makes GetNextVariable() jump to the physical address of the
EFI Boot Services region. Because if not, we need to do some more
digging.

Borislav, how are your 1:1 mapping patches coming along? In theory, once
those are merged we can gracefully workaround these kinds of issues.

-- 
Matt Fleming, Intel Open Source Technology Center
