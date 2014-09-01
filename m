From: Laszlo Ersek <lersek@redhat.com>
Subject: [PATCH 3/5] x86: efi: format EFI memory type & attrs with efi_md_typeattr_format()
Date: Mon,  1 Sep 2014 02:53:38 +0200
Message-ID: <1409532820-5027-4-git-send-email-lersek@redhat.com>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409532820-5027-1-git-send-email-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com, lersek@redhat.com
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 arch/x86/platform/efi/efi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94..ae2573a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -210,9 +210,12 @@ static void __init print_efi_memmap(void)
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
+		char buf[64];
+
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
-			i, md->type, md->attribute, md->phys_addr,
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx) (%lluMB)\n",
+			i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
-- 
1.8.3.1
