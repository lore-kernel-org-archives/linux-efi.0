From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v7 03/10] arch/x86: Do not access EFI memory map
	if it is not available
Date: Mon, 30 Jun 2014 19:52:57 +0200
Message-ID: <1404150784-27921-4-git-send-email-daniel.kiper@oracle.com>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: fenghua.yu@intel.com, jeremy@goop.org, matt.fleming@intel.com, ian.campbell@citrix.com, andrew.cooper3@citrix.com, stefano.stabellini@eu.citrix.com, tony.luck@intel.com, mjg59@srcf.ucam.org, mingo@redhat.com, david.vrabel@citrix.com, jbeulich@suse.com, hpa@zytor.com, boris.ostrovsky@oracle.com, tglx@linutronix.de, eshelton@pobox.com
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
