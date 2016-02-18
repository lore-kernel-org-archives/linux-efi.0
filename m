From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access
 ESRT table in memory
Date: Thu, 18 Feb 2016 14:16:24 -0500
Message-ID: <20160218191624.GA1515@redhat.com>
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
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218141544.GH2651-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 18, 2016 at 02:15:44PM +0000, Matt Fleming wrote:
> On Thu, 18 Feb, at 02:44:02PM, Ard Biesheuvel wrote:
> > On 18 February 2016 at 14:43, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > > On Thu, 18 Feb, at 02:29:32PM, Ard Biesheuvel wrote:
> > >> On 18 February 2016 at 14:28, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > >> > On Thu, 18 Feb, at 01:16:05PM, Ard Biesheuvel wrote:
> > >> >> On 18 February 2016 at 11:44, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > >> >> > On Mon, 15 Feb, at 12:32:32PM, Ard Biesheuvel wrote:
> > >> >> >> On ARM and arm64, ioremap() and memremap() are not interchangeable like
> > >> >> >> on x86, and the use of ioremap() on ordinary RAM is typically flagged
> > >> >> >> as an error if the memory region being mapped is also covered by the
> > >> >> >> linear mapping, since that would lead to aliases with conflicting
> > >> >> >> cacheability attributes.
> > >> >> >>
> > >> >> >> Since what we are dealing with is not an I/O region with side effects,
> > >> >> >> using ioremap() here is arguably incorrect anyway, so let's replace
> > >> >> >> it with memremap instead. Also add a missing unmap on the success path,
> > >> >> >> and drop a memblock_remove() call which does not belong here, this far
> > >> >> >> into the boot sequence.
> > >> >> >>
> > >> >> >> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >> >> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > >> >> >> ---
> > >> >> >>  drivers/firmware/efi/esrt.c | 16 ++++++++--------
> > >> >> >>  1 file changed, 8 insertions(+), 8 deletions(-)
> > >> >> >>
> > >> >> >
> > >> >> > [...]
> > >> >> >
> > >> >> >> @@ -432,8 +434,6 @@ static int __init esrt_sysfs_init(void)
> > >> >> >>       if (error)
> > >> >> >>               goto err_cleanup_list;
> > >> >> >>
> > >> >> >> -     memblock_remove(esrt_data, esrt_data_size);
> > >> >> >> -
> > >> >> >>       pr_debug("esrt-sysfs: loaded.\n");
> > >> >> >>
> > >> >> >>       return 0;
> > >> >> >
> > >> >> > Shouldn't we be replacing memblock_remove() with free_bootmem_late()?
> > >> >> > The original ESRT region is still reserved at this point, so we should
> > >> >> > do our best to release it to the page allocator.
> > >> >>
> > >> >> I'd rather we keep it reserved. That way, the config table entry still
> > >> >> points to something valid, which could be useful for kexec(), I think?
> > >> >> At least, that is how I intended to handle config tables on ARM ...
> > >> >
> > >> > If we're going to reserve it why do we need to copy the data out at
> > >> > all in esrt_sysfs_init()?
> > >>
> > >> Excellent question. I don't think there is any point to doing that.
> > >
> > > ... Unless the data is contained in an EFI Boot Services region ;-)
> > >
> > > Peter?
> > 
> > Yes, it usually is. Is that a problem?
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

I think we've got to copy them out anyway and give a new copy to any
kexec'd kernel.  In 5.6 in the spec, it says of the table data:

  The VendorGuid associated with a given VendorTable pointer defines
  whether or not a particular address reported in the table gets fixed
  up when a call to SetVirtualAddressMap() is made. It is the
  responsibility of the specification defining the VendorTable to
  specify whether to convert the addresses reported in the table.

Of course the ESRT definition doesn't say anything about that, since
it actually says it's in BootServicesData, and so remapping its address
doesn't really make a lot of sense.  Unfortunately the others are
actually *less* well defined.  Here's a list of the tables defined in
the 2.6 spec, and what they say about either their allocation region
or their remap policy:

ACPI20		nada			Physical Address (PA)
ACPI		nada			PA
SAL		nada			PA
SMBIOS		nada			PA
SMBIOS3		nada			PA
MPS		nada			PA
properties	nada			PA
memory attrs	nada			nada
debugimage info	nada			nada
IEIT		nada			nada
ESRT		BootServicesData	nada

So... for the ones specified by physical addresses, we know we can
access them early on, and it probably doesn't matter what allocation
pool they're in, because we're reserving them anyway.  Memory attributes
I would /guess/ have to also be specified by PAs; it's in the very next
subsection of the spec from all the other ones, and I think it just got
omitted from the list.  That leaves the last three.  As an aside, since
these definitions are so very poor, I'm going to put it on my TODO for
USST to clarify and fix these up, as well as to look at systemic fixes
for this problem in the future.

Anyway, the last three.  I think it's safe to assume that they are
mapped to virtual addresses we can read from *before*
SetVirtualAddressMap() and ExitBootServices() are called, especially
since we generally have an identity map before then anyway, but we
really don't know anything at all after that.  We also don't know the
sizes without parsing the tables themselves, which continues to be a
pain in the ass.

> I've always stayed clear of 2) in case there exists cross-region
> references in the data that isn't obvious. I'd like to think that
> would never happen, but, you know, dragons lurk here, etc.
> 
> Though actually, now I think about it, cross-region references can't
> possibly exist because they'd cause issues with the current code.

I would think any single table has to be entirely within the same
region, yes.

> So maybe the best solution is actually 2), where we preserve the Boot
> Services regions if any of the drivers (ESRT, BGRT) request them but
> free all the others? 

Note that BGRT is an ACPI table rather than an EFI Configuration Table,
and as such we actually have bounds for it.  The others are... special.

- Debug Image Info actually has a size.  That's nice of it.  It's also
  the table we've never talked about using.
- ESRT you have to compute the size as your parse it, and it has
  variable length members, so the driver for it needs to figure it out.
- IEIT has a number of entries at the top level, and then each entry has
  a size.  Probably still best to have the driver that's parsing it
  figure the size out.
- the Memory Attributes Table has a number of entries and a size of each
  entry, so you can just multiply.

> What are the lifetime rules for Boot Services regions on arm*?

I'll leave this for Ard and friends.

So the question I have is: would you rather chop up regions and reserve
the space, or allocate a new copy and update the configuration table
(after ExitBootServices()) to point to it?  The latter makes it pretty
easy to do from an API that all these drivers can use, and it makes the
kexec case completely transparent.

Up to you.

-- 
  Peter
