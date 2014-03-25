From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range() on native EFI platform only
Date: Tue, 25 Mar 2014 21:57:54 +0100
Message-ID: <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com, fenghua.yu@intel.com, hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com, stefano.stabellini@eu.citrix.com, tglx@linutronix.de, tony.luck@intel.com, Daniel Kiper <daniel.kiper@oracle.com>
List-Id: linux-efi@vger.kernel.org

Call efi_memblock_x86_reserve_range() on native EFI platform only.
This is not needed and even it should not be called on platforms
which wraps EFI infrastructure like Xen.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ce72964..992b67a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -933,7 +933,7 @@ void __init setup_arch(char **cmdline_p)
 		set_bit(EFI_64BIT, &x86_efi_facility);
 	}
 
-	if (efi_enabled(EFI_BOOT))
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature, "EL", 2))
 		efi_memblock_x86_reserve_range();
 #endif
 
-- 
1.7.10.4
