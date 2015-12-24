From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v2 1/4] x86/efi: show actual ending addresses in efi_print_memmap
Date: Wed, 23 Dec 2015 19:07:23 -0600
Message-ID: <1450919243-5314-1-git-send-email-elliott@hpe.com>
References: <20151223124711.GB2471@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151223124711.GB2471-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Adjust efi_print_memmap to print the real end address of each
range, not 1 byte beyond. This matches other prints like those for
SRAT and nosave memory.

While investigating grub persistent memory corruption issues, it
was helpful to make this table match the ending address convention
used by:
* the kernel's e820 table prints
	BIOS-e820: [mem 0x0000001680000000-0x0000001c7fffffff] reserved
* the kernel's nosave memory prints
	PM: Registered nosave memory: [mem 0x880000000-0xc7fffffff]
* the kernel's ACPI System Resource Affinity Table prints
	SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
* grub's lsmmap and lsefimmap commands
	reserved  0000001680000000-0000001c7fffffff 00600000     24GiB UC WC WT WB NV
* the UEFI shell's memmap command
	Reserved   000000007FC00000-000000007FFFFFFF 0000000000000400 0000000000000001

For example, if you grep all the various logs for c7fffffff, you
won't find the kernel's line if it uses c80000000.

Also, change the closing ) to ] to match the opening [.

old:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c80000000) (16384MB)

new:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16384MB)

Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
---
Changes in v2:
 - Expanded rationale in the commit message
---
 arch/x86/platform/efi/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad28540..635a955 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -235,10 +235,10 @@ void __init efi_print_memmap(void)
 		char buf[64];
 
 		md = p;
-		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
 			i, efi_md_typeattr_format(buf, sizeof(buf), md),
 			md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
 #endif  /*  EFI_DEBUG  */
-- 
2.4.3
