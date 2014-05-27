From: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Tue, 27 May 2014 14:36:41 +0100
Message-ID: <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
	<20140527030058.GB2372@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140527030058.GB2372-4/PLUo9XfK+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 27 May 2014 04:00, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/26/14 at 04:39pm, Dave Young wrote:
>>
>> For efi=old_map and any old_map quirks like SGI UV in current
>> tree kexec/kdump will fail because it depends on the new 1:1 mapping.
>>
>> Thus export the mapping method to sysfs so kexec tools can switch
>> to original way to boot.
>>
>> Since we have efi.flags for all efi facilities so let's just export the
>> efi.flags itself, it maybe useful for other arches and use cases.
>
> Rethink about this issue, export flags will expose the efi facility
> macros to userspace, Matt, what's your opinion? It might be better to export
> a file 'old_map' only which is '0|1'

Exporting efi.flags is a non-starter. Those flags are part of an
internal interface and I'm not prepared to turn them into a userspace
ABI that we can never, ever change without a massive amount of pain.

I've only vaguely been following along with the other thread, so please
summarise everything again in your patch. Particularly, I need answers
to the following questions,

 - Are you trying to fix a kexec/kdump regression?
 - Does SGI UV work with kexec + UEFI at all?

The 1:1 mapping was required to make kexec + EFI work in the first
instance. If a machine implements the EFI 1:1 mapping, kexec should
work. If it doesn't implement the 1:1 mapping, then it's probably not
going to work, right?

The crux of the question: are you trying to fix a regression?

If not, then we just need to get SGI UV working with the EFI 1:1
mapping. No?
