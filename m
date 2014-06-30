From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v7 06/10] arch/x86: Remove redundant
	set_bit(EFI_MEMMAP) call
Date: Mon, 30 Jun 2014 19:53:00 +0200
Message-ID: <1404150784-27921-7-git-send-email-daniel.kiper@oracle.com>
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

Remove redundant set_bit(EFI_MEMMAP, &efi.flags) call.
It is executed earlier in efi_memmap_init().

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/platform/efi/efi.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ae3d398..da15df9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -784,8 +784,6 @@ void __init efi_init(void)
 	if (efi_memmap_init())
 		return;
 
-	set_bit(EFI_MEMMAP, &efi.flags);
-
 	print_efi_memmap();
 }
 
-- 
1.7.10.4
