From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: ESRT failures ... was Re: [PATCH 04/11] efi: Add
 efi_memmap_init_late() for permanent EFI memmap
Date: Thu, 21 Jul 2016 13:11:36 +0100
Message-ID: <20160721121136.GF26504@codeblueprint.co.uk>
References: <57867F32.8040001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57867F32.8040001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Jul, at 01:49:38PM, Prarit Bhargava wrote:
> [I am not subscribed to linux-efi.  Sorry for the bad threading.  Please include
> me on the cc on any replies.]
> 
> Matt, I grabbed your patches which are similar to a change that I wanted to make
> to the kernel.  There is one issue though that I want to bring up.
> 
> With or without your changeset, I see the following issue on Dell system with a
> valid ESRT table.
> 
> 
> [    0.000000] efi:  SMBIOS=0x8ce95000  ACPI=0x8d2fe000  ACPI 2.0=0x8d2fe014
> ESRT=0x8d0f5000  MPS=0x8d0dd000
> [    0.000000] efi: requested map not found.
> [    0.000000] esrt: ESRT header is not in the memory map.
> [    0.000000] SMBIOS 2.8 present.
> 
> This occurs AFAICT (with or without your changes) because of this check in
> efi_mem_desc_lookup():
> 
>                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>                     md->type != EFI_BOOT_SERVICES_DATA &&
>                     md->type != EFI_RUNTIME_SERVICES_DATA) {
>                         continue;
>                 }
> 
> which then results in skipping the appropriate region.  IIUC (and that's part of
> my question ;)) the above check means that the region has already been
> permanently mapped.  That is,
 
No, the above check is intended to skip any regions that are not
required at runtime and so won't be found in the EFI memmap.

The question is, what does the EFI memmap descriptor look like that
describes your ESRT table?

> rc = efi_mem_desc_lookup(efi.esrt, &md);
>         if (rc < 0) {
>                 pr_err("ESRT header is not in the memory map.\n");
>                 return;
>         }
> ...
>         va = early_memremap(efi.esrt, size);
>         if (!va) {
> 
> and rc is -ENOENT because a matching region couldn't be found.  As can be seen
> the existing ESRT code will attempt to remap the region if not mapped.
> 
> I think that perhaps the function should be changed to do
> 
>         for_each_efi_memory_desc(md) {
>                 u64 size;
>                 u64 end;
> 
>                 size = md->num_pages << EFI_PAGE_SHIFT;
>                 end = md->phys_addr + size;
>                 if (phys_addr >= md->phys_addr && phys_addr < end) {
>                         memcpy(out_md, md, sizeof(*out_md));
> 
>                         if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>                             md->type != EFI_BOOT_SERVICES_DATA &&
>                             md->type != EFI_RUNTIME_SERVICES_DATA) {
>                                 return UNMAPPED;
>                         }
> 
>                         return MAPPED;
>                 }
>         }
> 
> so that individual callers (like the ESRT code) can then make a decision on
> whether or not the area needs to be mapped.
> 
> Thoughts/concerns?

efi_mem_desc_lookup() should just return the correct EFI memory
descriptor now that we have efi_mem_reserve() coming in v4.9.

What does the EFI memmap (as printed with efi=debug) look like on your
machine?
