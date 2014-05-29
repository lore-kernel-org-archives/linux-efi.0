From: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Thu, 29 May 2014 14:10:41 +0100
Message-ID: <CAL01qpuNS0u89gaR9pCKUoCVRkADhPO4mZueEyK8nP84=OfDaA@mail.gmail.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
	<20140527030058.GB2372@darkstar.nay.redhat.com>
	<CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
	<20140528020935.GB2820@darkstar.nay.redhat.com>
	<20140528145140.GN14863@redhat.com>
	<CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
	<20140529125910.GE14570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140529125910.GE14570-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 May 2014 13:59, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Only second kernel boots with "noefi" and this parameter is appened by
> kexec-tools to second kernel command line. So first kernel will still
> boot *without noefi* and kexec-tools wil think that this system support
> booting second kernel with UEFI enabled.
>
> I don't know if we export /sys/firmware/efi/runtime-map/ in case of
> non 1:1 mapping or not. Dave and Boris will know better.

Looking at the code the answer is: yes. I think that's the bug right there.

By exporting entries in /sys/firmware/efi/runtime-map we're saying
"These mappings persist across kexec, you can trust that they won't
change", for SGI UV (which currently uses the quirk) or if you boot
with efi=old_map on the command line, that's simply not true.

So, it would seem to me that we're missing a "if
(efi_enabled(OLD_MAP))" in drivers/firmware/efi/runtime-map.c.
Borislav, Dave? What do you guys think?

This is all assuming that the root of the regression is that
kexec-tools sees entries in /sys/firmware/efi/runtime-map/ and says
"Yay! EFI boot!".
