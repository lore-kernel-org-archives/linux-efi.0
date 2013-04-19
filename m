From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Fri, 19 Apr 2013 08:50:14 +0100
Message-ID: <5170F736.2060803@console-pimps.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51700876.1000305@intel.com> <51701D2E.6060903@console-pimps.org> <51708D3D.9010707@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51708D3D.9010707-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/19/2013 01:18 AM, Darren Hart wrote:
> On 04/18/2013 09:19 AM, Matt Fleming wrote:
>>
>> Could you give it a spin on your MinnowBoard?
> 
> I've removed the patch I reference above and applied your patch to my
> 3.8.4 MinnowBoard dev tree. It panics with:

D'oh. OK, at this point I'm inclined to apply Josh Boyer's patch on top
of my urgent branch which will address the WARNING people are hitting on
i386. I updated the commit message a little.

Josh (Boyer), are you guys still carrying this patch and have you seen
any fallout? I notice your SoB isn't on the patch that Darren posted, am
I OK to add it?

---

>From 40f053eb6ccb3f0c462ef7a23c44c3264d87a0d4 Mon Sep 17 00:00:00 2001
From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Thu, 18 Apr 2013 07:51:34 -0700
Subject: [PATCH] x86, efi: Don't map Boot Services on i386

Add patch to fix 32bit EFI service mapping (rhbz 726701)

Multiple people are reporting hitting the following WARNING on i386,

  WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
  Modules linked in:
  Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
  Call Trace:
   [<c102b6af>] warn_slowpath_common+0x5f/0x80
   [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
   [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
   [<c102b6ed>] warn_slowpath_null+0x1d/0x20
   [<c1023fb3>] __ioremap_caller+0x3d3/0x440
   [<c106007b>] ? get_usage_chars+0xfb/0x110
   [<c102d937>] ? vprintk_emit+0x147/0x480
   [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
   [<c102406a>] ioremap_cache+0x1a/0x20
   [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
   [<c1418593>] efi_enter_virtual_mode+0x1e4/0x3de
   [<c1407984>] start_kernel+0x286/0x2f4
   [<c1407535>] ? repair_env_string+0x51/0x51
   [<c1407362>] i386_start_kernel+0x12c/0x12f

Due to the workaround described in commit 916f676f8 ("x86, efi: Retain
boot service code until after switching to virtual mode") EFI Boot
Service regions are mapped for a period during boot. Unfortunately, with
the limited size of the i386 direct kernel map it's possible that some
of the Boot Service regions will not be directly accessible, which
causes them to be ioremap()'d, triggering the above warning as the
regions are marked as E820_RAM in the e820 memmap.

There are currently only two situations where we need to map EFI Boot
Service regions,

  1. To workaround the firmware bug described in 916f676f8
  2. To access the ACPI BGRT image

but since we haven't seen an i386 implementation that requires either,
this simple fix should suffice for now.

[ Added to changelog - Matt ]

Reported-by: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Acked-by: Tom Zanussi <tom.zanussi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4a86a6..b9876aa 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -997,10 +997,13 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+#ifdef CONFIG_X86_64
+			if (md->type != EFI_BOOT_SERVICES_CODE &&
+			    md->type != EFI_BOOT_SERVICES_DATA)
+#endif
+				continue;
+		}
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
-- 
1.8.1.4

-- 
Matt Fleming, Intel Open Source Technology Center
