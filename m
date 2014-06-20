From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v6 2/9] arch/x86: Do not access EFI memory map if it is not available
Date: Fri, 20 Jun 2014 23:29:21 +0200
Message-ID: <1403299768-9955-3-git-send-email-daniel.kiper@oracle.com>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

Do not access EFI memory map if it is not available. At least
Xen dom0 EFI implementation does not have an access to it.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
v6 - suggestions/fixes:
   - create this separate patch from main EFI_PARAVIRT patch
     (suggested by Matt Fleming).
---
 arch/x86/platform/efi/efi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0ee1f46..d2d3c41 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1220,6 +1220,9 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
-- 
1.7.10.4
