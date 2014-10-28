From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] arm64/efi: move SetVirtualAddressMap() to UEFI stub
Date: Tue, 28 Oct 2014 16:16:38 +0800
Message-ID: <20141028081638.GI3329@darkstar.nay.redhat.com>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
 <1414154384-15385-5-git-send-email-ard.biesheuvel@linaro.org>
 <20141028074732.GG3329@darkstar.nay.redhat.com>
 <CAKv+Gu8U2umRSBDddW3oktfLZkv8v+6bEKycO46+ouciQ__uXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8U2umRSBDddW3oktfLZkv8v+6bEKycO46+ouciQ__uXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi, Ard

[snip]
> >> +static phys_addr_t __init efi_to_phys(unsigned long addr)
> >> +{
> >> +     efi_memory_desc_t *md;
> >> +
> >> +     for_each_efi_memory_desc(&memmap, md) {
> >> +             if (!(md->attribute & EFI_MEMORY_RUNTIME))
> >> +                     continue;
> >> +             if (md->virt_addr == 0)
> >> +                     /* no virtual mapping has been installed by the stub */
> >> +                     break;
> >> +             if (md->virt_addr < addr &&
> >> +                 (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
> >> +                     return md->phys_addr + addr - md->virt_addr;
> >> +     }
> >> +
> >> +     WARN_ONCE(1, "UEFI virtual mapping incomplete or missing -- no entry found for 0x%lx\n",
> >> +               addr);
> >
> > die here instead of warn looks better, addr could be anything which does not match the virt maps.
> >
> 
> The general idea was (and below as well) that SetVirtualAddressMap()
> is called from the stub, at a point where we can't easily panic/error
> out in a meaningful way, as we have just called ExitBootServices() so
> there is no console etc. So instead, I zero out all the virt_addr
> fields, which indicates that no virtual mapping is installed. That
> does not necessarily mean (on arm64 at least) that we will not be able
> to bring up ACPI etc and moan in a way that could catch someone's
> attention rather than only on the console.

Ok, thanks for explanation.

> 
> I chose a WARN_ONCE() because it gives a nice fat stack dump in the
> kernel log, but as the RT services regions and fw_vendor and
> config_table are still id mapped, I don't see a compelling reason to
> panic right here.

I worried that the addr was not the orignal physical address, maybe it's
corrupt in the middle of svam because of firmware bugs etc..

If we can ensuer it's same address as before svam callback, it will be
fine for using WARN.

[snip]
> >>       /* Now we are ready to exit_boot_services.*/
> >>       status = sys_table->boottime->exit_boot_services(handle, mmap_key);
> >>
> >> +     if (status == EFI_SUCCESS) {
> >> +             efi_set_virtual_address_map_t *svam;
> >> +
> >> +             /* Install the new virtual address map */
> >> +             svam = sys_table->runtime->set_virtual_address_map;
> >> +             status = svam(runtime_entry_count * desc_size, desc_size,
> >> +                           desc_ver, memory_map);
> >>
> >> -     if (status == EFI_SUCCESS)
> >> -             return status;
> >> +             /*
> >> +              * We are beyond the point of no return here, so if the call to
> >> +              * SetVirtualAddressMap() failed, we need to signal that to the
> >> +              * incoming kernel but proceed normally otherwise.
> >> +              */
> >> +             if (status != EFI_SUCCESS) {
> >> +                     int i;
> >> +
> >> +                     /*
> >> +                      * Set the virtual address field of all
> >> +                      * EFI_MEMORY_RUNTIME entries to 0. This will signal
> >> +                      * the incoming kernel that no virtual translation has
> >> +                      * been installed.
> >> +                      */
> >> +                     for (i = 0; i < map_size; i += desc_size) {
> >> +                             efi_memory_desc_t *p;
> >> +
> >> +                             p = (efi_memory_desc_t *)((u8 *)memory_map + i);
> >> +                             if (!(p->attribute & EFI_MEMORY_RUNTIME))
> >> +                                     break;
> >
> > should it be continue instead of break?
> >
> 
> The memory map is sorted, so we can break as soon as we encounter the
> first one without the attribute set.

ok, it's fine, I did not know that.

> 
> >> +                             p->virt_addr = 0;
> >
> > In X86 kernel panics in case set_virtual_address_map, Matt mentioned that it's
> > not reasonable to continue. But for arm64 I'm not sure it's same case.
> >
> 
> As I said, perhaps it is not reasonable, or perhaps it is, but
> panicking here is maybe not the most productive thing to do.
> I could add a printk() before calling exitbootservices() perhaps,
> saying 'if you can read this line, and nothing more, we may have
> crashed in/after SetVirtualAddressMap()'
> 

I tend to agree with you. adding a printk will be better.

Thanks
Dave 
