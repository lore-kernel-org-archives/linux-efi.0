From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] arm64: improved memory map handling for /dev/mem,
 ACPI etc
Date: Tue, 6 Jan 2015 16:16:35 +0800
Message-ID: <20150106081635.GE2113@darkstar.redhat.com>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141226093528.GA26133@darkstar.redhat.com>
 <CAKv+Gu_1VCJK7y5U9H-mhjjN6AFW8+SGvbKUZfuzx6qGEpVg0A@mail.gmail.com>
 <20141230092514.GF2457@darkstar.redhat.com>
 <CAKv+Gu_Ou6Fv7-AUcpbUJAijwEJ8=PCB1mQU3mCfctLFAMhu_w@mail.gmail.com>
 <20150104081905.GA6231@darkstar.redhat.com>
 <CAKv+Gu-P7AeMNveZMe814FgrEr_z26vaYKWa=borKoPSc76Y6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-P7AeMNveZMe814FgrEr_z26vaYKWa=borKoPSc76Y6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/05/15 at 09:18am, Ard Biesheuvel wrote:
> On 4 January 2015 at 08:19, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 12/30/14 at 01:21pm, Ard Biesheuvel wrote:
> >> On 30 December 2014 at 09:25, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > On 12/29/14 at 09:22am, Ard Biesheuvel wrote:
> >> >> On 26 December 2014 at 09:35, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> >> > On 12/22/14 at 07:08pm, Ard Biesheuvel wrote:
> >> >> >> This series was split off from the UEFI virtmap for kexec series that I posted
> >> >> >> earlier today. The main purpose is to deal with the need to classify memory
> >> >> >> ranges as RAM or non-RAM in a consistent and comprehensive manner. This series
> >> >> >> applies on top of the other series.
> >> >> >>
> >> >> >> Patch #1 avoids an early panic if the UEFI memory map is available but UEFI
> >> >> >> support itself fails to initialize. In this case, there is no need to panic
> >> >> >> early, and we have a better chance of being able to inform the user if we deal
> >> >> >> with this error condition at a later time.
> >> >> >>
> >> >> >> Patch #2 adds iomem resource registration of UEFI memory regions. This is
> >> >> >> necessary because otherwise, drivers could potentially claim regions that
> >> >> >> are in active use by the firmware. This applies to both MMIO (NOR flash, RTC)
> >> >> >> and RAM ranges (runtime services code and data).
> >> >> >>
> >> >> >> Patch #3-6 adds support to UEFI and non-UEFI code paths to record all memory
> >> >> >> known to the system in the 'physmem' memblock table (if enabled). This fulfils
> >> >> >> a need in the /dev/mem and (upcoming) ACPI layers to be able to classify ranges
> >> >> >> as being backed by normal RAM even if they are not covered by the 'memory'
> >> >> >> memblock table, and are hence not covered by the linear direct mapping.
> >> >> >> The physmem code is pre-existing code that only needs minor tweaking to be made
> >> >> >> suitable for this purpose.
> >> >> >>
> >> >> >> Patch #7 enables the 'physmem' memblock table for arm64, and wires it into the
> >> >> >> handling of /dev/mem mappings, both to decide whether it should be mapped as
> >> >> >> MT_NORMAL, and whether read-write access can be allowed. (Non-RAM regions can
> >> >> >> be mapped read-write as long as they are not claimed by a driver in the iomem
> >> >> >> resource table. RAM regions can only be mapped read-only, and only if they are
> >> >> >> not covered by the 'memory' memblock table, and hence not covered by the linear
> >> >> >> mapping)
> >> >> >>
> >> >> >> Finally, patch #8 changes the way the virtual memory map is handled by the
> >> >> >> early UEFI code. Specifically, it memblock_remove()s rather than _reserves()
> >> >> >> UEFI reserved RAM regions, so that they are removed entirely from the linear
> >> >> >> mapping.
> >> >> >>
> >> >> >> Ard Biesheuvel (8):
> >> >> >>   arm64/efi: use UEFI memory map unconditionally if available
> >> >> >>   arm64/efi: register UEFI reserved regions as iomem resources
> >> >> >>   memblock: add physmem to memblock_dump_all() output
> >> >> >>   memblock: introduce memblock_add_phys() and memblock_is_physmem()
> >> >> >>   of: fdt: register physmem in early_init_dt_scan_memory()
> >> >> >>   arm64/efi: register physmem in reserve_regions()
> >> >> >>   arm64: use 'physmem' memblock to improve CONFIG_STRICT_DEVMEM handling
> >> >> >>   arm64/efi: memblock_remove rather than _reserve UEFI reserved RAM
> >> >> >
> >> >> > Ard, It is much cleaner for this splitting.
> >> >> >
> >> >>
> >> >> Thanks for having a look.
> >> >>
> >> >> > I wonder if some of them can become general code such as register reserved
> >> >> > regions as iomem resources?
> >> >> >
> >> >>
> >> >> AFAICT, the x86 code adds reservations for such regions to the E820
> >> >> memory map, which in turn is used to memblock_reserve() the actual
> >> >> memory. Also, sharing of the RTC is handled with a dedicated mutex in
> >> >> the runtime services wrapper code (and x86 does not even use the time
> >> >> related runtime services as they are broken on many firmware
> >> >> implementations) so blindly applying the same logic to x86 or ia64
> >> >> would likely break stuff.
> >> >
> >> > Ok, I think bootloader will pass the E820 ranges though it can not tell
> >> > which region is for what.
> >> >
> >> >>
> >> >> Do you (or Mark) have any feedback on the utility of this series in
> >> >> the ACPI context? I failed to mention in the cover letter that
> >> >> memblock_is_physmem() now serves the purpose of page_is_ram(), i.e.,
> >> >> whether a physical region is backed by a slice of RAM that was left
> >> >> out of the kernel's linear mapping.
> >> >
> >> > I will do some test later along with the stable mapping stuff.
> >
> > The whole patchset works well without the last patch.
> >
> > I found that patch 8/8 caused system boot hangs very early.
> > Just after stub print something about virtmap..
> >
> 
> Which platform is this?
> Do you have earlycon enabled?

It is apm mustang, earlycon was enabled.

> 
> > Any idea about it? I tested your patches upon 3.18.
> >
> 
> I suppose you tested both the virtmap series and this one, but did you
> also take the 3.19 changes we did for UEFI? Not sure it would make a
> difference, though.

Yes, both virtmap series and this one, I did not take UEFI 3.19 changes,
Which patchset do you have in mind? If no clue I will try rebase to test 3.19

> 
> >> > BTW, with previous stable mapping patches on modified 3.18 tree kexec kernel
> >> > panics because of damaged efi mempry map arrays. It contains some
> >> > random value instead of right addresses so that virt_to_phys return
> >> > same value for vendor field. Will do more debugging maybe I missed something.
> >> > Any clue for debugging above issue will be appreciated.
> >> >
> >>
> >> No clues, unfortunately. The memory map is not used after early boot,
> >> so it may be getting clobbered at any point between the first boot and
> >> the second boot.
> >
> > It was caused by uefi sys table/mmap start addresses changes.
> > I generate dtb from acpi=off boot /proc/device-tree, and use the dtb for kexec
> > boot, but seems mmap addresses changes sometimes.
> >
> > Do you know have plan or status in Linaro for exporting dtb for acpi booting?
> >
> 
> We have this patch upstream now
> 
> 08d53aa58cb1 of/fdt: export fdt blob as /sys/firmware/fdt
> 
> which exports whatever FDT the kernel received from the bootloader or
> the EFI stub, regardless of whether the kernel uses DT or not.

Great, will try.

Thanks
Dave
