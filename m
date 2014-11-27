From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 03/13] arm64: improve CONFIG_STRICT_DEVMEM handling
Date: Thu, 27 Nov 2014 14:22:14 +0800
Message-ID: <20141127062214.GC2860@darkstar.nay.redhat.com>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
 <1416315432-8534-4-git-send-email-ard.biesheuvel@linaro.org>
 <20141126093042.GA6474@darkstar.nay.redhat.com>
 <CAKv+Gu8UyfdFhaKXNQMzuf7L3b9jDyUd4FzG1x-c7FfoxnZe=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8UyfdFhaKXNQMzuf7L3b9jDyUd4FzG1x-c7FfoxnZe=Q@mail.gmail.com>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/26/14 at 05:23pm, Ard Biesheuvel wrote:
> On 26 November 2014 at 10:30, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 11/18/14 at 01:57pm, Ard Biesheuvel wrote:
> >> Improve the handling of /dev/mem mappings under CONFIG_STRICT_DEVMEM by:
> >> - allowing read-only access to parts of System RAM that are not
> >>   considered memory by the kernel, this is mainly intended for exposing
> >>   UEFI Configuration tables to userland;
> >
> > Ard, can you elabrate a bit? Are this for the acpi case because no dtb in
> > procfs?
> >
> 
> No, that is a different issue.
> 
> > Anyway I also think using /dev/mem looks not a good way to expose
> > infomation to userspace.
> >
> 
> This is for compatibility with existing tools like dmidecode and lshw
> that already use /dev/mem.
> However, on x86, the tables they access are in iomem resource ranges
> that are accessible under CONFIG_STRICT_DEVMEM, whereas on arm64,
> those regions are inaccessible.
> 
> So while our position is that using /dev/mem for *anything* is an
> awful idea, this particular patch just tries to bring arm64 in line
> with what currently existing tools expect.

Ard, Ok, thanks for the clarification.
