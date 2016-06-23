From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 11/11] x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data
Date: Thu, 23 Jun 2016 12:34:50 +0100
Message-ID: <1466681690-5850-12-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, Borislav Petkov <bp@alien8.de>, Mark Rutland <mark.rutland@arm.com>, Josh Boyer <jwboyer@fedoraproject.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@amacapital.net>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>
List-Id: linux-efi@vger.kernel.org

efi_mem_reserve() allows us to permanently mark EFI boot services
regions as reserved, which means we no longer need to copy the image
data out and into a separate buffer.

Leaving the data in the original boot services region has the added
benefit that BGRT images can now be passed across kexec reboot.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: M=C3=B4she van der Sterre <me@moshe.nl>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi-bgrt.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/e=
fi-bgrt.c
index 6a2f5691b1ab..6aad870e8962 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -82,21 +82,12 @@ void __init efi_bgrt_init(void)
 	}
 	bgrt_image_size =3D bmp_header.size;
=20
-	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
+	bgrt_image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEM=
REMAP_WB);
 	if (!bgrt_image) {
-		pr_notice("Ignoring BGRT: failed to allocate memory for image (wante=
d %zu bytes)\n",
-		       bgrt_image_size);
-		return;
-	}
-
-	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP=
_WB);
-	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image memory\n");
-		kfree(bgrt_image);
 		bgrt_image =3D NULL;
 		return;
 	}
=20
-	memcpy(bgrt_image, image, bgrt_image_size);
-	memunmap(image);
+	efi_mem_reserve(bgrt_tab->image_address, bgrt_image_size);
 }
--=20
2.7.3
