From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v24 5/9] arm64: kdump: add kdump support
Date: Wed, 24 Aug 2016 16:04:43 +0800
Message-ID: <20160824080443.GA12902@dhcp-128-65.nay.redhat.com>
References: <20160809015615.28527-1-takahiro.akashi@linaro.org>
 <20160809015615.28527-3-takahiro.akashi@linaro.org>
 <57AB586D.3080900@arm.com> <20160818071547.GC20080@linaro.org>
 <20160819012651.GE20080@linaro.org>
 <20160819112217.GB22221@localhost.localdomain>
 <20160822012919.GI20080@linaro.org> <57BB0272.1000008@arm.com>
 <20160823003815.GL20080@linaro.org>
 <20160823112343.GC13501@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160823112343.GC13501-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, bauerman-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Ccing uefi people.

On 08/23/16 at 04:53pm, Pratyush Anand wrote:
> On 23/08/2016:09:38:16 AM, AKASHI Takahiro wrote:
> > On Mon, Aug 22, 2016 at 02:47:30PM +0100, James Morse wrote:
> > > On 22/08/16 02:29, AKASHI Takahiro wrote:
> > > > On Fri, Aug 19, 2016 at 04:52:17PM +0530, Pratyush Anand wrote:
> > > >> It will help kexec-tools to prevent copying  of any unnecessary data. I
> > > >> think, then you also need to change phys_offset calculation in kexec-tools. That
> > > >> should be start of either of first "reserved" or "System RAM" block.
> > > > 
> > > > Good point, but I'm not sure this is always true.
> > > 
> > > > Is there any system whose ACPI memory is *not* part of DRAM
> > > 
> > > From the spec, it looks like this is allowed.
> > > 
> > > What do you mean by 'DRAM'? Any ACPI region will be in the UEFI memory map, so
> > > the question is what is its type and memory attributes?
> > 
> > Yes.
> > 
> > > The UEFI spec[0] says ACPI regions can have a type of EfiACPIReclaimMemory or
> > > EfiACPIMemoryNVS, the memory attributes aren't specified, so are chosen by the
> > > firmware.
> > > 
> > > It is possible these regions have to be mapped non-cacheable, page 40 has a
> > > couple of:
> > > > If no information about the table location exists in the UEFI memory map or
> > > ACPI memory
> > > > descriptors, the table is assumed to be non-cached.
> > > 
> > > reserve_regions() in drivers/firmware/efi/arm-init.c will add any entry in the
> > > memory map that has a 'WB' attribute to the memblock.memory list (via
> > > early_init_dt_add_memory_arch()), it will also mark as no-map regions that have
> > > this attribute and aren't in the is_reserve_region() list.

Looking the arm-init.c, I suspect it missed the some efi ranges as
reserved ranges like runtime code and runtime data etc. But I might be
wrong.

Below is the is_reserve_region, it will regard any regions which is not
in the EFI_* below as normal memory, it does not include the runtime
ranges and other types.

static __init int is_reserve_region(efi_memory_desc_t *md)
{
        switch (md->type) {
        case EFI_LOADER_CODE:
        case EFI_LOADER_DATA:
        case EFI_BOOT_SERVICES_CODE:
        case EFI_BOOT_SERVICES_DATA:
        case EFI_CONVENTIONAL_MEMORY:
        case EFI_PERSISTENT_MEMORY:
                return 0;
        default:
                break;
        }
        return is_normal_ram(md);
}

Let's see the x86 do_add_efi_mem_map, the default case set all other
types as reserved. Shouldn't this be same in all arches though there's
no e820 in arm(64)?

static void __init do_add_efi_memmap(void)
{

[snip]
                switch (md->type) {
                case EFI_LOADER_CODE:
                case EFI_LOADER_DATA:
                case EFI_BOOT_SERVICES_CODE:
                case EFI_BOOT_SERVICES_DATA:
                case EFI_CONVENTIONAL_MEMORY:
                        if (md->attribute & EFI_MEMORY_WB)
                                e820_type = E820_RAM;
                        else
                                e820_type = E820_RESERVED;
                        break;
[snip]
                default:
                        /*
                         * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
                         * EFI_RUNTIME_SERVICES_DATA
                         * EFI_MEMORY_MAPPED_IO
                         * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
                         */
                        e820_type = E820_RESERVED;
                        break;
                }
[snip]
}

> > > 
> > > If these ACPI regions have the 'WB' attribute, we add them as memory and mark
> > > them nomap. These show up as either a hole, or 'reserved' in /proc/iomem.
> > > If they don't have the 'WB' attribute, then then they are left out of memblock
> > > and aren't part of DRAM, I don't think these will show up in /proc/iomem at all.
> > 
> > Let's say,
> > 0x1000-0x1fff: reserved (SRAM for UEFI, WB)
> > 0x80000000-0xffffffff: System RAM (DRAM)
> 
> May be slightly more complicated:
> 0x80000000-0x80001fff: System RAM (DRAM) for UEFI, WB
> 0x80002000-0xffffffff: System RAM (DRAM)
> 
> Kernel will have phys_offset 0x80000000, however kexec-tools will calculate it
> as 0x80002000.
> 
> > 
> > If, as Pratyush suggested, "reserved" resources are added to phys_offset
> > calculation, the kernel linear mapping area starts at PAGE_OFFSET, but
> > there is no actual mapping around PAGE_OFFSET.
> > It won't hurt anything, but looks funny.
> > So we'd better not include "reserved" in phys_offset calculation anyway.
> >         -> Pratyush
> 
> My only concern is that, then we will have different values of phys_offset in
> kernel and kexec-tools, which might lead to further confusion.
> 
> ~Pratyush
