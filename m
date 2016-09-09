From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 11/29] x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data
Date: Fri,  9 Sep 2016 16:18:33 +0100
Message-ID: <20160909151851.27577-12-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Josh Triplett <josh@joshtriplett.org>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

efi_mem_reserve() allows us to permanently mark EFI boot services
regions as reserved, which means we no longer need to copy the image
data out and into a separate buffer.

Leaving the data in the original boot services region has the added
benefit that BGRT images can now be passed across kexec reboot.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Tested-by: Dave Young <dyoung@redhat.com> [kexec/kdump]
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> [arm]
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Môshe van der Sterre <me@moshe.nl>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi-bgrt.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index 6a2f5691b1ab..6aad870e8962 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -82,21 +82,12 @@ void __init efi_bgrt_init(void)
 	}
 	bgrt_image_size = bmp_header.size;
 
-	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
+	bgrt_image = memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP_WB);
 	if (!bgrt_image) {
-		pr_notice("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
-		       bgrt_image_size);
-		return;
-	}
-
-	image = memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP_WB);
-	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image memory\n");
-		kfree(bgrt_image);
 		bgrt_image = NULL;
 		return;
 	}
 
-	memcpy(bgrt_image, image, bgrt_image_size);
-	memunmap(image);
+	efi_mem_reserve(bgrt_tab->image_address, bgrt_image_size);
 }
-- 
2.9.3
