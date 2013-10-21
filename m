From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Mon, 21 Oct 2013 20:47:39 +0800
Message-ID: <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
References: <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
 <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131014155851.GJ4009-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/14/13 at 05:58pm, Borislav Petkov wrote:
> On Sun, Oct 13, 2013 at 11:25:21AM +0200, Borislav Petkov wrote:
> > In the meantime, I'll finish randconfigs testing of the patches and
> > upload the latest version to k-org, I'll let you know.
> 
> Ok, here it is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi
> 
> This version seems to work on most boxes except Matt's Asus half-life
> zombie.

What's the status of this series?

> 
> Let me know if there are issues,

I need below patch for mapping to fixed virt addr passed
from 1st kernel. Would you like to add it to your series
or I send out it later?

BTW, what tree should my patches based on? Matt's next tree?
Looks like your tree is not consistant with Matt's tree.

--

Add function efi_map_region_fixed for mapping to a specific
virt address. 

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- bp.orig/arch/x86/platform/efi/efi.c
+++ bp/arch/x86/platform/efi/efi.c
@@ -1086,6 +1086,19 @@ static void efi_merge_regions(void)
 	}
 }
 
+void __init efi_map_region_fixed(efi_memory_desc_t *md, u64 virt_addr)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long pf = 0;
+
+	if (!(md->attribute & EFI_MEMORY_WB))
+		pf |= _PAGE_PCD;
+
+	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, virt_addr, md->num_pages, pf))
+		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, virt_addr);
+}
+
 /*
  * Map efi memory ranges for runtime serivce
  * Return the new memmap with updated virtual addrresses.
