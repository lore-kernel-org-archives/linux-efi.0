From: Dave Young <dyoung@redhat.com>
Subject: [PATCH v6 05/14] efi: reserve boot service fix
Date: Mon, 16 Dec 2013 17:30:26 +0800
Message-ID: <1387186235-15972-6-git-send-email-dyoung@redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
List-Id: linux-efi@vger.kernel.org

Current code check boot service region with kernel text region by:
start+size >= __pa_symbol(_text)
The end of the above region should be start + size - 1 instead.

I see this problem in ovmf + Fedora 19 grub boot:
text start: 1000000 md start: 800000 md size: 800000

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ef471d5..8a88c68 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -438,7 +438,7 @@ void __init efi_reserve_boot_services(void)
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
+		if ((start + size > __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
-- 
1.8.3.1
