From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V2] x86/efi: Add missing 1:1 mappings to support buggy
 firmware
Date: Thu, 16 Mar 2017 11:47:22 +0000
Message-ID: <20170316114722.GD6261@codeblueprint.co.uk>
References: <1487131421-23703-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <20170228115104.GC28416@codeblueprint.co.uk>
 <1488332358.4028.15.camel@intel.com>
 <1488338734.4028.32.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488338734.4028.32.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Feb, at 07:25:34PM, Sai Praneeth Prakhya wrote:
> 
> > > 
> > > I don't think we should be adding yet another place in the EFI code
> > > where we're modifying the page tables. 
> > > 
> > > We already have the ability to map EFI_CONVENTIONAL_MEMORY regions
> > > inside of efi_map_regions() via the should_map_region() function.
> > > 
> > > Currently, unless you're booting in mixed mode that function will
> > > return 'false' if the region type is EFI_CONVENTIONAL_MEMORY, so to
> > > get your machine booting you need to do two things,
> > > 
> > >   1) Modify should_map_region() to allow EFI_CONVENTIONAL_MEMORY to be
> > >      mapped
> > > 
> > >   2) Modify the 64-bit version of efi_map_region() to *only* create
> > >      1:1 mapping for EFI_CONVENTIONAL_MEMORY regions.
> > 
> > Thanks for the suggestions! Will try these and will let you know if that
> > fixes the issue.
> > 
> 
> I have noticed this issue on two machines HP laptop and a Desktop
> (Gigabyte). Adding mappings for EFI_CONVENTIONAL_MEMORY and
> *EFI_LOADER_DATA* solves the issue. Presently, I only have access to one
> machine (Desktop) and as soon as I test this on laptop (hopefully it
> does not access any other EFI regions illegally), I will send version 3
> of the patch.
> 
> Since this patch will be mapping EFI_CONVENTIONAL_MEMORY and
> EFI_LOADER_DATA in 1:1 mode on 64-bit machines, I think we could also do
> the same with EFI_BOOT_SERVICES_DATA and EFI_BOOT_SERVICES_CODE. In
> other words we could remove the existing mappings for
> EFI_BOOT_SERVICES_CODE and EFI_BOOT_SERVICES_DATA from VA mapping.

Do you know what data is being access in the EFI_LOADER_DATA region?
Accessing that via the 1:1 mapping is really strange because the
firmware will have had to convert any addresses the kernel gave it
from virtual to physical (the kernel stores things in EFI_LOADER_DATA
regions during boot).

> I think; this should not break any machines because firmware could
> access illegal addresses only in 1:1 mode and not in VA mode because
> that's the only address space firmware has knowledge about. Firmware
> doesn't know about virtual addresses until we pass them through
> SetVirtualAddressMap().
>
> So Matt, could you please confirm if you had come across any machines
> that did illegal access to EFI regions using virtual addresses?

I don't think I do have access to such machines, but what would
removing the virtual mappings buy us? The risk of breaking machines
with buggy firmware outweighs any benefit that I can think of. 

Am I missing something?
