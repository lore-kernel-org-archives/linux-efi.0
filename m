From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 1/4] x86/efi: show actual ending addresses in efi_print_memmap
Date: Thu, 17 Dec 2015 19:28:31 -0600
Message-ID: <1450402114-3606-2-git-send-email-elliott@hpe.com>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450402114-3606-1-git-send-email-elliott@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>
List-Id: linux-efi@vger.kernel.org

Adjust efi_print_memmap to print the real end address of each
range, not 1 byte beyond. This matches other prints like those for
SRAT and nosave memory.

Change the closing ) to ] to match the opening [.

old:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c80000000) (16384MB)

new:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16384MB)

Example other address range prints:
    SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
    PM: Registered nosave memory: [mem 0x880000000-0xc7fffffff]

Signed-off-by: Robert Elliott <elliott@hpe.com>
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
