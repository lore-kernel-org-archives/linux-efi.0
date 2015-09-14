From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH] efi/libstub/fdt: Standardize the names
 of EFI stub parameters
Date: Mon, 14 Sep 2015 04:39:49 -0600
Message-ID: <55F6C01502000078000A2823@prv-mh.provo.novell.com>
References: <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
 <20150910144938.GI29293@leverpostej>
 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
 <20150910162302.GN29293@leverpostej>
 <20150911124643.GB4530@olila.local.net-space.pl>
 <alpine.DEB.2.02.1509111410180.2672@kaball.uk.xensource.com>
 <CAKv+Gu9rN7_mxk0huX+34HSCC_aTWVTkUZKQMB1+9U56fRnwsA@mail.gmail.com>
 <20150911154534.GD4530@olila.local.net-space.pl>
 <55F6886D.1090900@huawei.com>
 <CAKv+Gu-xAAd=xTOh+qZvPDthgbRPLy=YwT4xfi4dS53EgJRh1Q@mail.gmail.com>
 <55F693F5.8030203@huawei.com>
 <CAKv+Gu-2kyd3Gf3ceSa1jdgCjqJ8zBCesa4xehLiZ+VzergS3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-2kyd3Gf3ceSa1jdgCjqJ8zBCesa4xehLiZ+VzergS3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>>> On 14.09.15 at 11:36, <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 14 September 2015 at 11:31, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> My understanding is that if there are no EFI_MEMORY_RUNTIME regions, it
>> means we can't use runtime services and should not set the bit
>> EFI_RUNTIME_SERVICES of efi.flags. But if efi_virtmap_init() return
>> true, the bit will be set.
>>
> 
> As I said, if you don't want the EFI_RUNTIME_SERVICES bit to be set
> for other reasons, don't rig efi_virtmap_init() to return false when
> it shouldn't.
> 
>>> The absence of such regions is allowed by the spec, so
>>> efi_virtmap_init() is correct imo to return success.
>>>
>> Sorry, not well know about the spec. Could you point out where the spec
>> says this?
>>
> 
> Well, I think it doesn't work that way. You are claiming that a memory
> map without at least one EFI_MEMORY_RUNTIME constitutes an error
> condition, so the burden is on you to provide a reference to the spec
> that says you must have at least one such region.

Sure, from a spec pov you're right. But where would runtime
services code/data live when there's not a single region marked
as needing a runtime mapping. IOW while the spec doesn't say
so, assuming no runtime services when there's not at least one
executable region with the runtime flag set could serve as a stop
gap measure against flawed firmware.

Jan
