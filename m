From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] x86/efi: Add missing 1:1 mappings to support buggy
 firmware
Date: Tue, 28 Feb 2017 17:39:18 -0800
Message-ID: <1488332358.4028.15.camel@intel.com>
References: <1487131421-23703-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <20170228115104.GC28416@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228115104.GC28416-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-02-28 at 11:51 +0000, Matt Fleming wrote:
> On Tue, 14 Feb, at 08:03:41PM, Sai Praneeth Prakhya wrote:
> > From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > There are some machines with buggy firmware that access EFI regions in
> > 1:1 mode (or physical mode) rather than virtual mode even after kernel
> > being booted. On these machines, if we invoke an EFI runtime service
> > (that does these buggy accesses) then it causes a page fault and hence
> > results in kernel hang. The page fault happens because the requested
> > region doesn't have appropriate page attributes set or the mapping for
> > the region might be missing. This issue was introduced by commit
> > 67a9108ed431 ("x86/efi: Build our own page table structures"). Before
> > this commit, 1:1 mappings for EFI regions were in swapper_pgd and were
> > not needed to be synced, but this commit introduced efi_pgd which missed
> > these mappings.
>  
> The subject line needs to mention EFI_CONVENTIONAL_MEMORY, because we
> already have 1:1 mappings for some regions, just not for
> EFI_CONVENTIONAL_MEMORY (by default). Those are the missing mappings.

Sorry! for the confusing subject line.

> 
> > Below is the edited version of the page fault output that I noticed:
> > 
> > BUG: unable to handle kernel paging request at 0000000018847980
> > I have looked at EFI Memory map for the faulted address and found that
> > it belongs to memory region of type "Conventional Memory". So, this
> > firmware bug is not same as accessing EFI_BOOT_SERVICES_* regions after
> > boot, but firmware accessing *illegal regions* in *1:1 mode*.
>  
> Can you confirm that the firmware is accessing the corresponding
> physical address of a virtual address that was passed an argument to
> the EFI runtime service? In other words, is the firmware accessing
> memory (via the wrong mapping) that the kernel has passed, or is it
> accessing memory locations it shouldn't be?
> 

Sure! Will do that. Will change the patch according to your suggestion
(mapping EFI_CONVENTIONAL_MEMORY only in 1:1 mode) and see if that fixes
the issue. I am sure that it's the buggy firmware causing the issue but
let me just confirm.

> > Below shown are the efi_pgd dumps before and after the bad commit.
> > efi_dump_pagetable() is called before calling efi_merge_regions() in
> > __efi_enter_virtual_mode() and this kernel is booted on qemu to obtain
> > page table dumps.
> > While not having these mappings isn't a bug but we need these mappings
> > to support machines with buggy firmware.
>  
> If buggy machines do not boot because we do not have these mappings,
> then yes, it is a bug.
> 

Actually, the machine does boot. But after booting when I run some efi
tests (using LUV) and when the tests call some EFI_RUNTIME_SERVICE
(efi_query_capsule_caps(), efi_get_next_variable()), the system hangs.
It hangs because page fault occurs in kernel mode and it is not
resolved.

> > Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

> 
> I don't think we should be adding yet another place in the EFI code
> where we're modifying the page tables. 
> 
> We already have the ability to map EFI_CONVENTIONAL_MEMORY regions
> inside of efi_map_regions() via the should_map_region() function.
> 
> Currently, unless you're booting in mixed mode that function will
> return 'false' if the region type is EFI_CONVENTIONAL_MEMORY, so to
> get your machine booting you need to do two things,
> 
>   1) Modify should_map_region() to allow EFI_CONVENTIONAL_MEMORY to be
>      mapped
> 
>   2) Modify the 64-bit version of efi_map_region() to *only* create
>      1:1 mapping for EFI_CONVENTIONAL_MEMORY regions.

Thanks for the suggestions! Will try these and will let you know if that
fixes the issue.
