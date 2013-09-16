From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 16 Sep 2013 13:50:46 +0200
Message-ID: <5236F096.8040702@redhat.com>
References: <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic> <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com> <20130807151935.GJ17920@pd.tnic> <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com> <20130807201908.GG2515@console-pimps.org> <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com> <20130808101730.GJ2515@console-pimps.org> <20130913203812.GA312@anatevka.fc.hp.com> <20130916105920.GB2697@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130916105920.GB2697-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: jerry.hoemann-VXdhtT5mjnY@public.gmane.org, Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>, edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Brian Richardson <brian.richardson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Randy Wright <rwright-VXdhtT5mjnY@public.gmane.org>, Linn Crosetto <linn.crosetto-VXdhtT5mjnY@public.gmane.org>, terry.lee-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, randy.pawell-VXdhtT5mjnY@public.gmane.org, chrisp-VXdhtT5mjnY@public.gmane.org, linda.knippers-VXdhtT5mjnY@public.gmane.org, dong.wei-VXdhtT5mjnY@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Chao Zhang <chao.b.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yao Jiewen <jiewen.yao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/16/13 12:59, Matt Fleming wrote:
> On Fri, 13 Sep, at 02:38:12PM, jerry.hoemann-VXdhtT5mjnY@public.gmane.org wrote:
>> Matt,
>>
>> We have hit an issue on our new platform in development related to the
>> call of efi_reserve_boot_services() from setup_arch().
>>
>> The reservation can interfere with allocation of the crash kernel.
>  
> Jerry, thanks for bringing this up.
> 
>> In pre 3.9(?) kernels,  the crash kernel is required to be allocated from
>> physically contiguous memory below 896 MB.
>>
>> Our new platforms are large in both the amount of memory and the amount
>> of IO. This requires large crash kernels for kdump to work.  This is even
>> after the work done for makedumpfile v 1.5 to allow it to work with a
>> smaller foot print.
>>
>>
>> One of the problems is that drivers will allocate memory as boot code and/or
>> data in the region < 896 that effectively fragments this memory.
>> With the reservation, we can't reuse the memory when needed for the
>> crash kernels.   If we remove the reservation and allow the kernel
>> to reuse the memory,  we the reservation of the crash kernel succeeds.
>>
>> This is definitely a problem for distros that are pre 3.9.  Probably less
>> so for top of tree, but i haven't been focused there.
>>
>> So we are definitely interested in finding a mechanism to not
>> do this reservation on platforms that don't have the issues described
>> earlier in this thread.
> 
> OK, in an ideal world we'd move the crash kernel reservation after
> efi_free_boot_services(), because at that point the boot regions are
> available again. But it seems that we reserve the boot regions really
> early during startup and release them relatively late. The reason is
> that the Boot Graphics Resource Table (BGRT) data, if present, is
> located in the Boot Services Data regions but we can't extract the
> address of the region from the ACPI tables until we've setup the ACPI
> subsystem, which happens quite late.

Why is BGRT allocated as Boot Services Data?

In file
"MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.c":

InstallBootGraphicsResourceTable()
  BgrtAllocateBsDataMemoryBelow4G()
    gBS->AllocatePages(... EfiBootServicesData ...)

>From Table 25. Memory Type Usage before ExitBootServices():

  EfiBootServicesData  -- The data portions of a loaded Boot Services
                          Driver, and the default data allocation type
                          used by a Boot Services Driver to allocate
                          pool memory.

  EfiACPIReclaimMemory -- Memory that holds the ACPI tables.

>From Table 26. Memory Type Usage after ExitBootServices():

  EfiBootServicesData -- Memory available for general use.

  EfiACPIReclaimMemory -- This memory is to be preserved by the loader
                          and OS until ACPI is enabled. Once ACPI is
                          enabled, the memory in this range is available
                          for general use.

I thought that anything referenced by a pointer in any ACPI table was
EfiACPIReclaimMemory or stricter. Specifically, the RSDT or XSDT points
to BGRT, so BGRT is EfiACPIReclaimMemory.  BGRT points to the image data
(with its Image Address field), hence the image data should be
EfiACPIReclaimMemory too.

Otherwise, the pointer (BGRT.ImageAddress) can outlive the pointed-to
storage (the image data).

The image data sounds to me like textbook example for
EfiACPIReclaimMemory. This way the kernel could free Boot Services Data
early, perform the crash kernel reservation right after, and safely
access BGRT whenever the ACPI subsystem is brought up later.


The edk2 commit that flipped the memory type underneath the image data
from EfiReservedMemoryType to EfiBootServicesData is:

    https://github.com/tianocore/edk2/commit/4c58575e

I think this commit is wrong. It's fine for OSPM to release the image
data at some point, but not right after ExitBootServices(), because
referencing pointers in ACPI tables survive strictly longer.

... Actually, the commit does follow the ACPI spec 5.0:

5.2.22.4 Image Address

    The Image Address contains the location in memory where an
    in-memory copy of the boot image can be found. The image should be
    stored in EfiBootServicesData, allowing the system to reclaim
    the memory when the image is no longer needed.

The ACPI spec 5.0 should recommend EfiACPIReclaimMemory here IMO. (I
take the current wording ("should be stored") as a recommendation only.)

If that's in fact a recommendation (and not a hard requirement), then it
should be easy to change BgrtAllocateBsDataMemoryBelow4G() again.

Thanks,
Laszlo
