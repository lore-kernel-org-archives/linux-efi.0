From: Juergen Gross <jgross@suse.com>
Subject: [PATCH 4/4] x86, efi: use early_ioremap in arch/x86/platform/efi/efi-bgrt.c
Date: Tue, 24 Feb 2015 10:13:31 +0100
Message-ID: <1424769211-11378-5-git-send-email-jgross@suse.com>
References: <1424769211-11378-1-git-send-email-jgross@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424769211-11378-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, linux-efi@vger.kernel.org, matt.fleming@intel.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-efi@vger.kernel.org

Use early_ioremap() to map an I/O-area instead of early_memremap().

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/platform/efi/efi-bgrt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index d143d21..d7f997f 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -67,7 +67,7 @@ void __init efi_bgrt_init(void)
 
 	image = efi_lookup_mapped_addr(bgrt_tab->image_address);
 	if (!image) {
-		image = early_memremap(bgrt_tab->image_address,
+		image = early_ioremap(bgrt_tab->image_address,
 				       sizeof(bmp_header));
 		ioremapped = true;
 		if (!image) {
@@ -89,7 +89,7 @@ void __init efi_bgrt_init(void)
 	}
 
 	if (ioremapped) {
-		image = early_memremap(bgrt_tab->image_address,
+		image = early_ioremap(bgrt_tab->image_address,
 				       bmp_header.size);
 		if (!image) {
 			pr_err("Ignoring BGRT: failed to map image memory\n");
-- 
2.1.4
