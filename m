From: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Thu, 29 May 2014 12:53:19 +0100
Message-ID: <CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
	<20140527030058.GB2372@darkstar.nay.redhat.com>
	<CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
	<20140528020935.GB2820@darkstar.nay.redhat.com>
	<20140528145140.GN14863@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140528145140.GN14863-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 28 May 2014 15:51, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, May 28, 2014 at 10:09:35AM +0800, Dave Young wrote:
>
> [..]
>> > I've only vaguely been following along with the other thread, so please
>> > summarise everything again in your patch. Particularly, I need answers
>> > to the following questions,
>> >
>> >  - Are you trying to fix a kexec/kdump regression?
>>
>> Somehow it is a regression.
>
> Well, it is a *regression*. Previously kdump would work with
> SGI UV machines as it used "noefi". Now kexec by default thinks that
> efi is enabled and 1:1 mappings are in place and that does not work
> with SGI UV machines.

So, if someone boots an SGI UV machine with the "noefi" kernel command
line parameter, the kernel still creates
/sys/firmware/efi/runtime-map/ ? Why does kexec/kdump think a kernel
booted with "noefi" supports EFI?

Or are we talking about a different "noefi" parameter?
