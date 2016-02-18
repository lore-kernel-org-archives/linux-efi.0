From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access ESRT
 table in memory
Date: Thu, 18 Feb 2016 15:21:25 +0100
Message-ID: <CAKv+Gu8RP21vw1Ht7UtkHsen2GMUNx8DikH-hLaezV+uZvWO-g@mail.gmail.com>
References: <1455535953-5056-1-git-send-email-ard.biesheuvel@linaro.org>
	<1455535953-5056-2-git-send-email-ard.biesheuvel@linaro.org>
	<20160218104407.GC2651@codeblueprint.co.uk>
	<CAKv+Gu_AW7PKJJOd2mbEu3LKJe+gNaPHnH=sgO=YXM_KWFyKxw@mail.gmail.com>
	<20160218132824.GE2651@codeblueprint.co.uk>
	<CAKv+Gu-s1pzYBzuDG-Z7s3gyo8dPOfeidZQ+rim-uAWZCBcKQQ@mail.gmail.com>
	<20160218134324.GG2651@codeblueprint.co.uk>
	<CAKv+Gu875r9RkDC723kNsG4XC0eSE9RPPmSFZrD0sx0QxS+V4g@mail.gmail.com>
	<20160218141544.GH2651@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218141544.GH2651-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 February 2016 at 15:15, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 18 Feb, at 02:44:02PM, Ard Biesheuvel wrote:
>> On 18 February 2016 at 14:43, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> > On Thu, 18 Feb, at 02:29:32PM, Ard Biesheuvel wrote:
>> >> On 18 February 2016 at 14:28, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> >> > On Thu, 18 Feb, at 01:16:05PM, Ard Biesheuvel wrote:
>> >> >> On 18 February 2016 at 11:44, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> >> >> > On Mon, 15 Feb, at 12:32:32PM, Ard Biesheuvel wrote:
>> >> >> >> On ARM and arm64, ioremap() and memremap() are not interchangeable like
>> >> >> >> on x86, and the use of ioremap() on ordinary RAM is typically flagged
>> >> >> >> as an error if the memory region being mapped is also covered by the
>> >> >> >> linear mapping, since that would lead to aliases with conflicting
>> >> >> >> cacheability attributes.
>> >> >> >>
>> >> >> >> Since what we are dealing with is not an I/O region with side effects,
>> >> >> >> using ioremap() here is arguably incorrect anyway, so let's replace
>> >> >> >> it with memremap instead. Also add a missing unmap on the success path,
>> >> >> >> and drop a memblock_remove() call which does not belong here, this far
>> >> >> >> into the boot sequence.
>> >> >> >>
>> >> >> >> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >> >> >> ---
>> >> >> >>  drivers/firmware/efi/esrt.c | 16 ++++++++--------
>> >> >> >>  1 file changed, 8 insertions(+), 8 deletions(-)
>> >> >> >>
>> >> >> >
>> >> >> > [...]
>> >> >> >
>> >> >> >> @@ -432,8 +434,6 @@ static int __init esrt_sysfs_init(void)
>> >> >> >>       if (error)
>> >> >> >>               goto err_cleanup_list;
>> >> >> >>
>> >> >> >> -     memblock_remove(esrt_data, esrt_data_size);
>> >> >> >> -
>> >> >> >>       pr_debug("esrt-sysfs: loaded.\n");
>> >> >> >>
>> >> >> >>       return 0;
>> >> >> >
>> >> >> > Shouldn't we be replacing memblock_remove() with free_bootmem_late()?
>> >> >> > The original ESRT region is still reserved at this point, so we should
>> >> >> > do our best to release it to the page allocator.
>> >> >>
>> >> >> I'd rather we keep it reserved. That way, the config table entry still
>> >> >> points to something valid, which could be useful for kexec(), I think?
>> >> >> At least, that is how I intended to handle config tables on ARM ...
>> >> >
>> >> > If we're going to reserve it why do we need to copy the data out at
>> >> > all in esrt_sysfs_init()?
>> >>
>> >> Excellent question. I don't think there is any point to doing that.
>> >
>> > ... Unless the data is contained in an EFI Boot Services region ;-)
>> >
>> > Peter?
>>
>> Yes, it usually is. Is that a problem?
>
> Yes, we free the Boot Services regions before hitting userspace on
> x86, see efi_free_boot_services(). We do this map/copy/unmap trick in
> the ACPI BGRT driver for that reason.
>
> The Boot Services regions can be many gigabytes in size, which makes
> leaving them alone impractical.
>
> For kexec on x86 we simply discard the BGRT table, which isn't the end
> of the world because who really needs access to the BGRT image on
> kexec reboot? However, I can see the value of preserving the ESRT.
>
> I guess we've got two options, 1) copy out the chunks of Boot Services
> regions we're interested in and rewrite the EFI tables to point at
> these new allocations and free/discard all of the original Boot
> Services regions or 2) only selectively free the Boot Services
> regions.
>
> I've always stayed clear of 2) in case there exists cross-region
> references in the data that isn't obvious. I'd like to think that
> would never happen, but, you know, dragons lurk here, etc.
>
> Though actually, now I think about it, cross-region references can't
> possibly exist because they'd cause issues with the current code.
>
> So maybe the best solution is actually 2), where we preserve the Boot
> Services regions if any of the drivers (ESRT, BGRT) request them but
> free all the others?
>
> What are the lifetime rules for Boot Services regions on arm*?

We treat all Boot Services regions like Loader Code/Data or free
regions: it is all recorded in memblock as usable memory, and only the
regions that are explicitly reserved are protected from further
general use.

I am currently looking into the memory attribute table, and the use
case is very similar. It would be very useful from our pov to simply
memblock_reserve() the region right after having called
efi_config_parse_tables(), and actually consume its data when we get
around to it later. The ESRT handling is already split down the middle
in the same way.
