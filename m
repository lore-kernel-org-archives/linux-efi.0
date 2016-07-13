From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: ESRT failures ... was Re: [PATCH 04/11] efi: Add efi_memmap_init_late()
 for permanent EFI memmap
Date: Wed, 13 Jul 2016 13:49:38 -0400
Message-ID: <57867F32.8040001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[I am not subscribed to linux-efi.  Sorry for the bad threading.  Please include
me on the cc on any replies.]

Matt, I grabbed your patches which are similar to a change that I wanted to make
to the kernel.  There is one issue though that I want to bring up.

With or without your changeset, I see the following issue on Dell system with a
valid ESRT table.


[    0.000000] efi:  SMBIOS=0x8ce95000  ACPI=0x8d2fe000  ACPI 2.0=0x8d2fe014
ESRT=0x8d0f5000  MPS=0x8d0dd000
[    0.000000] efi: requested map not found.
[    0.000000] esrt: ESRT header is not in the memory map.
[    0.000000] SMBIOS 2.8 present.

This occurs AFAICT (with or without your changes) because of this check in
efi_mem_desc_lookup():

                if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
                    md->type != EFI_BOOT_SERVICES_DATA &&
                    md->type != EFI_RUNTIME_SERVICES_DATA) {
                        continue;
                }

which then results in skipping the appropriate region.  IIUC (and that's part of
my question ;)) the above check means that the region has already been
permanently mapped.  That is,

rc = efi_mem_desc_lookup(efi.esrt, &md);
        if (rc < 0) {
                pr_err("ESRT header is not in the memory map.\n");
                return;
        }
...
        va = early_memremap(efi.esrt, size);
        if (!va) {

and rc is -ENOENT because a matching region couldn't be found.  As can be seen
the existing ESRT code will attempt to remap the region if not mapped.

I think that perhaps the function should be changed to do

        for_each_efi_memory_desc(md) {
                u64 size;
                u64 end;

                size = md->num_pages << EFI_PAGE_SHIFT;
                end = md->phys_addr + size;
                if (phys_addr >= md->phys_addr && phys_addr < end) {
                        memcpy(out_md, md, sizeof(*out_md));

                        if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
                            md->type != EFI_BOOT_SERVICES_DATA &&
                            md->type != EFI_RUNTIME_SERVICES_DATA) {
                                return UNMAPPED;
                        }

                        return MAPPED;
                }
        }

so that individual callers (like the ESRT code) can then make a decision on
whether or not the area needs to be mapped.

Thoughts/concerns?

P.
