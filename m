From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] x86/efi: Add missing 1:1 mappings to support buggy
 firmware
Date: Mon, 20 Mar 2017 11:52:23 -0700
Message-ID: <1490035943.24510.65.camel@intel.com>
References: <1487131421-23703-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <20170228115104.GC28416@codeblueprint.co.uk>
         <1488332358.4028.15.camel@intel.com> <1488338734.4028.32.camel@intel.com>
         <20170316114722.GD6261@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316114722.GD6261-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-03-16 at 11:47 +0000, Matt Fleming wrote:
> On Tue, 28 Feb, at 07:25:34PM, Sai Praneeth Prakhya wrote:
> > 
> > > > 
> > > > I don't think we should be adding yet another place in the EFI code
> > > > where we're modifying the page tables. 
> > > > 
> > > > We already have the ability to map EFI_CONVENTIONAL_MEMORY regions
> > > > inside of efi_map_regions() via the should_map_region() function.
> > > > 
> > > > Currently, unless you're booting in mixed mode that function will
> > > > return 'false' if the region type is EFI_CONVENTIONAL_MEMORY, so to
> > > > get your machine booting you need to do two things,
> > > > 
> > > >   1) Modify should_map_region() to allow EFI_CONVENTIONAL_MEMORY to be
> > > >      mapped
> > > > 
> > > >   2) Modify the 64-bit version of efi_map_region() to *only* create
> > > >      1:1 mapping for EFI_CONVENTIONAL_MEMORY regions.
> > > 
> > > Thanks for the suggestions! Will try these and will let you know if that
> > > fixes the issue.
> > > 
> > 
> > I have noticed this issue on two machines HP laptop and a Desktop
> > (Gigabyte). Adding mappings for EFI_CONVENTIONAL_MEMORY and
> > *EFI_LOADER_DATA* solves the issue. Presently, I only have access to one
> > machine (Desktop) and as soon as I test this on laptop (hopefully it
> > does not access any other EFI regions illegally), I will send version 3
> > of the patch.
> > 
> > Since this patch will be mapping EFI_CONVENTIONAL_MEMORY and
> > EFI_LOADER_DATA in 1:1 mode on 64-bit machines, I think we could also do
> > the same with EFI_BOOT_SERVICES_DATA and EFI_BOOT_SERVICES_CODE. In
> > other words we could remove the existing mappings for
> > EFI_BOOT_SERVICES_CODE and EFI_BOOT_SERVICES_DATA from VA mapping.
> 
> Do you know what data is being access in the EFI_LOADER_DATA region?
> Accessing that via the 1:1 mapping is really strange because the
> firmware will have had to convert any addresses the kernel gave it
> from virtual to physical (the kernel stores things in EFI_LOADER_DATA
> regions during boot).

By looking up the EFI_MEMORY_MAP for the faulted phys_addr, I have
confirmed that firmware tried to access EFI_CONVENTIONAL_MEMORY. I don't
know what data is being accessed, but I can do a hexdump of that region
(If you are interested in the data). (According to my speculation) The
buggy firmware here is not converting virtual addresses given by kernel
to physical addresses and then triggering these illegal accesses, but
the firmware might be referencing some data that is in
EFI_CONVENTIONAL_MEMORY or EFI_LOADER_DATA. This might happen because
firmware didn't copy all the data that it needs for runtime into
EFI_RUNTIME_DATA regions before giving control to kernel or hasn't
updated all it's pointers during ConvertPointer() or maybe something
else.

Based on this speculation I have written patches to kernel which are in
Linux UEFI Validation (LUV) and they detected illegal accesses from
efi_runtime_services(). When firmware does these illegal accesses,
kernel will lookup EFI_MEMORY_MAP and will fix up page faults
dynamically. Please have a look at these patches for more information.
https://lists.01.org/pipermail/luv/2017-March/001636.html

Recently, we helped a firmware developer debug implementation of
QueryCapsuleCapabilities() (a efi_runtime_service()). He said that, his
implementation did access EFI_BOOT_SERVICES_CODE/DATA regions when it
was called (which is illegal). So, we can assume that there might be
some firmware implementations which access efi regions *other than
EFI_RUNTIME and kernel passed arguments* even after booting (i.e. from
some efi_runtime_service()) and most importantly these accesses will
*always* occur only in 1:1 mode (as buggy firmware has knowledge of only
physical addresses and not virtual mode). 

Please let me know if you think my speculation is not right.

> 
> > I think; this should not break any machines because firmware could
> > access illegal addresses only in 1:1 mode and not in VA mode because
> > that's the only address space firmware has knowledge about. Firmware
> > doesn't know about virtual addresses until we pass them through
> > SetVirtualAddressMap().
> >
> > So Matt, could you please confirm if you had come across any machines
> > that did illegal access to EFI regions using virtual addresses?
> 
> I don't think I do have access to such machines, but what would
> removing the virtual mappings buy us? The risk of breaking machines
> with buggy firmware outweighs any benefit that I can think of.

I think we might not break any machines because we will have 1:1
mappings to support buggy firmware and remove VA mappings because they
aren't used at all (according to the reasons I mentioned above).

> 
> Am I missing something?

The reasons that we might consider to remove these mappings are:

1. They are unnecessary mappings according to UEFI spec and the logic in
kernel. In kernel we wanted to reserve EFI_BOOT_SERVICES_CODE/DATA
regions *only* until SetVirtualAddressMap() but presently as we have
mappings for these regions we are preserving these regions forever. I
mean we have two mappings pointing to the same physical addresses, one
being 1:1 mapping and the other being VA mapping. So, I think we can
remove VA mapping and have 1:1 mappings to support buggy firmware.

2. As we have mappings we now allow firmware/kernel to access these
regions (that shouldn't be accessed). This can can be considered as a
security issue (maybe highly unlikely but nevertheless).

3. If we remove these mappings we will know about machines that does
access EFI_BOOT_SERVICES_CODE/DATA regions even after booting in VA
mode. The main reason this patch and the discussion started because of
commit 67a9108ed431 ("x86/efi: Build our own page table structures"). In
this commit we moved to efi_pgd and hence we didn't have 1:1 mappings
for EFI_CONVENTIONAL_MEMORY and EFI_LOADER_DATA/CODE and hence I came
across the bug. Hadn't we moved to efi_pgd at all from swapper_pgd I
would have never noticed that efi_runtime_services() will do illegal
accesses and a firmware bug would go unnoticed.

So to conclude, as you said we *might* break some machines (highly
unlikely) but at least we will get to know that one more different bug
in firmware.

Sorry! for making it too long. But working on these bug gave me new
insights into efi code and hence have put some here. 

Regards,
Sai
