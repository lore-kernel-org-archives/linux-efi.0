From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add missing 1:1 mappings to support buggy
 firmware
Date: Tue, 28 Feb 2017 11:36:30 +0000
Message-ID: <20170228113630.GB28416@codeblueprint.co.uk>
References: <1486607948-1509-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <20170214205139.GB28416@codeblueprint.co.uk>
 <1487130120.2150.23.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487130120.2150.23.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 14 Feb, at 07:42:00PM, Sai Praneeth Prakhya wrote:
> 
> It makes sense that "efi_sync_low_kernel_mappings()" would be the best
> place but I added them here for these reasons
> 
> 1. These mappings refer to "direct mapping of all physical memory" and
> thus in "efi_map_regions()" we update *these* mappings to create 1:1
> mappings (to allow physical mode accesses by buggy firmware), so if we
> copy these mappings in "efi_sync_low_kernel_mappings()" which is called
> later than efi_map_regions(), we will overwrite previous 1:1 mappings
> created by efi_map_regions() and hence kernel panics.
> 
> 2. The other reason for adding these mappings in
> "efi_alloc_page_tables()" is because that's the way mappings looked in
> swapper_pgd before we shifted EFI stuff to efi_pgd.
> 
> I have tested this by moving this code to
> "efi_sync_low_kernel_mappings()" and I see that kernel panics in
> set_virtual_address_map().
> 
> Please do correct me if you think otherwise.
> 
> Thanks for the review, Matt

OK, I now realise that I misunderstood this patch when I reviewed it
the first time. Sorry about that.

I see that the problem you're addressing is that some firmware will
access the physical address of EFI_CONVENTIONAL_MEMORY regions while
executing runtime services. And unless we're running in EFI mixed
mode, we don't map EFI_CONVENTIONAL_MEMORY regions into the EFI page
tables.

We already have code to handle the 1:1 mapping of
EFI_CONVENTIONAL_MEMORY because we need to do this for the EFI mixed
mode scenario. The difference for non-mixed mode is that we only want
to create the 1:1 mapping for EFI_CONVENTIONAL_MEMORY, we don't want
the virtual mapping too.

Lemme go and reply to your v2.
