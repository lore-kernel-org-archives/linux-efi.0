From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access
 ESRT table in memory
Date: Tue, 1 Mar 2016 23:30:40 +0000
Message-ID: <20160301233040.GA31476@codeblueprint.co.uk>
References: <1455535953-5056-2-git-send-email-ard.biesheuvel@linaro.org>
 <20160218104407.GC2651@codeblueprint.co.uk>
 <CAKv+Gu_AW7PKJJOd2mbEu3LKJe+gNaPHnH=sgO=YXM_KWFyKxw@mail.gmail.com>
 <20160218132824.GE2651@codeblueprint.co.uk>
 <CAKv+Gu-s1pzYBzuDG-Z7s3gyo8dPOfeidZQ+rim-uAWZCBcKQQ@mail.gmail.com>
 <20160218134324.GG2651@codeblueprint.co.uk>
 <CAKv+Gu875r9RkDC723kNsG4XC0eSE9RPPmSFZrD0sx0QxS+V4g@mail.gmail.com>
 <20160218141544.GH2651@codeblueprint.co.uk>
 <20160218191624.GA1515@redhat.com>
 <20160226144114.GA7475@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160226144114.GA7475-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Feb, at 02:41:14PM, Matt Fleming wrote:
> On Thu, 18 Feb, at 02:16:24PM, Peter Jones wrote:
> > 
> > So the question I have is: would you rather chop up regions and reserve
> > the space, or allocate a new copy and update the configuration table
> > (after ExitBootServices()) to point to it?  The latter makes it pretty
> > easy to do from an API that all these drivers can use, and it makes the
> > kexec case completely transparent.
> > 
> > Up to you.
> 
> I think it makes the most sense to chop up the regions we care about
> (i.e. the ones we have drivers for) because not only does that save us
> the effort of copying out the data on every kexec reboot, it also
> prevents us from leaking each copy since we don't free them at the
> moment.
> 
> Then we just need to maintain a separate list of regions to free in
> efi_free_boot_services() or have some other way to distinguish between
> them.
> 
> Oh, and save_runtime_map() would need updating to save Boot Services
> regions too.

I have a very rough draft of patches that implement this strategy on
the 'experiemntal/efi-memmap' branch in the EFI tree if anyone is
curious and wants to take a look. The series will be sent out soon.

I wouldn't necessarily try running them or anything as there's a few
things that I know are broken; ia64 build, EFI mixed mode boot,
probably arm64 regressions.

The upshot of the patch series is that there's a whole lot of code we
can share for manipulating memory maps between all EFI architectures
and by fixing this "reserve boot services regions" in a generic way it
should mean kexec under EFI on arm64 should be fairly trivial to
implement, along with ESRT, etc.
