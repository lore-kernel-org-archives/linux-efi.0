From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] x86/efi: Only pass mapped RAM regions to free_bootmem_late()
Date: Thu,  5 Jun 2014 14:27:34 +0100
Message-ID: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

free_bootmem_late() expects to only be passed RAM regions that the
kernel can access, and that have a corresponding 'struct page'. It's
possible for regions in the EFI memory map to reside in address ranges
for which pfn_to_page() doesn't work, for instance when running on an
i386 system with CONFIG_HIGHMEM=n.

This is in fact the case for one of Alan's machines where some of the
EFI boot services pages live in highmem, and running a kernel without
CONFIG_HIGHMEM enabled results in the following oops,

 BUG: unable to handle kernel paging request at f7f1f080
 IP: [<c17fba96>] __free_pages_bootmem+0x5a/0xb8
 *pdpt = 0000000001887001 *pde = 0000000001984067 *pte = 000000000 0000000
 Oops: 0002 [#1] SMP

[...]

 Call Trace:
  [<c17feacc>] free_bootmem_late+0x2d/0x3d
  [<c17f1013>] efi_free_boot_services+0x48/0x5b
  [<c17ddc12>] start_kernel+0x3ad/0x3cf
  [<c17dd654>] ? set_init_arg+0x49/0x49
  [<c17dd380>] i386_start_kernel+0x12e/0x131

Reported-by: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

Alan, could you double check that this patch also fixes the oops on your
CONFIG_HIGHMEM=n machine?

 arch/x86/platform/efi/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd39e8bd..893d183ee98f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -451,6 +451,9 @@ void __init efi_free_boot_services(void)
 		if (!size)
 			continue;
 
+		if (!e820_all_mapped(start, start + size, E820_RAM))
+			continue;
+
 		free_bootmem_late(start, size);
 	}
 
-- 
1.9.0
