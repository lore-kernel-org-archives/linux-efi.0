From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v4 4/5] arch/x86: Replace plain strings with constants
Date: Fri, 16 May 2014 22:41:43 +0200
Message-ID: <1400272904-31121-5-git-send-email-daniel.kiper@oracle.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f41f648..7a67f5d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -924,11 +924,11 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
+				EFI32_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_DIRECT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4)) {
+				EFI64_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_DIRECT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
-- 
1.7.10.4
