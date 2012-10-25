From: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v3] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
Date: Thu, 25 Oct 2012 10:05:47 -0700
Message-ID: <CAOesGMi-WeHe7XKVYh90GQ3Ko8BdQh2bFU6Gdi20UKySO+4dRQ@mail.gmail.com>
References: <1351059878-28795-1-git-send-email-olof@lixom.net>
	<1351098044-4586-1-git-send-email-olof@lixom.net>
	<1351171217.5303.13.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351171217.5303.13.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marko.kohtala-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 25, 2012 at 6:20 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Wed, 2012-10-24 at 10:00 -0700, Olof Johansson wrote:
>> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
>> efi_enabled once setup is done. Beyond setup, it is normally used to
>> determine if runtime services are available and we will have none.
>>
>> This will resolve issues stemming from efivars modprobe panicking on a
>> 32/64-bit setup, as well as some reboot issues on similar setups.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45991
>>
>> Reported-by: Marko Kohtala <marko.kohtala-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Reported-by: Maxim Kammerer <mk-HZxBN897WPs@public.gmane.org>
>> Signed-off-by: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
>> Acked-by: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # 3.4 - 3.6
>> Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>
> Running with this patch results in the following,
>
> [    3.486943] ------------[ cut here ]------------
> [    3.488455] WARNING: at /home/matt/src/kernels/linux-2.6/arch/x86/mm/ioremap.c:586 check_early_ioremap_leak+0x3b/0x50()
> [    3.490043] Hardware name: MacBook2,1
> [    3.491600] Debug warning: early ioremap leak of 1 areas detected.
> [    3.493156] Modules linked in:
> [    3.493973] usb 1-4: new high-speed USB device number 3 using ehci_hcd
> [    3.496340] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc1+ #26
> [    3.497949] Call Trace:
> [    3.499558]  [<ffffffff81d022ab>] ? check_early_ioremap_leak+0x3b/0x50
> [    3.501217]  [<ffffffff81032970>] warn_slowpath_common+0x85/0x9d
> [    3.502872]  [<ffffffff81d02270>] ? early_ioremap_debug_setup+0x12/0x12
> [    3.504516]  [<ffffffff81032a2b>] warn_slowpath_fmt+0x46/0x48
> [    3.506161]  [<ffffffff81cf89df>] ? mcheck_debugfs_init+0x3b/0x3b
> [    3.507790]  [<ffffffff81d022ab>] check_early_ioremap_leak+0x3b/0x50
> [    3.509418]  [<ffffffff8100023b>] do_one_initcall+0x7f/0x134
> [    3.511040]  [<ffffffff8163cc3c>] kernel_init+0x10c/0x275
> [    3.512638]  [<ffffffff81cef4c7>] ? loglevel+0x31/0x31
> [    3.514241]  [<ffffffff8163cb30>] ? rest_init+0x74/0x74
> [    3.515824]  [<ffffffff8165ca9c>] ret_from_fork+0x7c/0xb0
> [    3.517393]  [<ffffffff8163cb30>] ? rest_init+0x74/0x74
> [    3.518958] ---[ end trace afc7d1c216dac6e1 ]---
> [    3.520479] please boot with early_ioremap_debug and report the dmesg.
>
> because we're now leaking the mapping from efi_memmap_init().

Odd, I didn't see it here. Thanks for catching it.

> Maybe it should be handled like so?

Looks good, since the memory should still be reserved and not reused.

Acked-by: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
(or just amend the original patch)


-Olof
