From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 3/3] x86/efi-bgrt: Switch all pr_err() to pr_notice() for invalid BGRT
Date: Tue,  3 May 2016 20:29:41 +0100
Message-ID: <1462303781-8686-4-git-send-email-matt@codeblueprint.co.uk>
References: <1462303781-8686-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462303781-8686-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Josh Triplett <josh@joshtriplett.org>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>
List-Id: linux-efi@vger.kernel.org

=46rom: Josh Boyer <jwboyer@fedoraproject.org>

The promise of pretty boot splashes from firmware via BGRT was at
best only that; a promise.  The kernel diligently checks to make
sure the BGRT data firmware gives it is valid, and dutifully warns
the user when it isn't.  However, it does so via the pr_err log
level which seems unnecessary.  The user cannot do anything about
this and there really isn't an error on the part of Linux to
correct.

This lowers the log level by using pr_notice instead.  Users will
no longer have their boot process uglified by the kernel reminding
us that firmware can and often is broken when the 'quiet' kernel
parameter is specified.  Ironic, considering BGRT is supposed to
make boot pretty to begin with.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: M=C3=B4she van der Sterre <me@moshe.nl>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi-bgrt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/e=
fi-bgrt.c
index a2433817c987..6a2f5691b1ab 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -43,40 +43,40 @@ void __init efi_bgrt_init(void)
 		return;
=20
 	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
-		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
+		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
 		       bgrt_tab->header.length, sizeof(*bgrt_tab));
 		return;
 	}
 	if (bgrt_tab->version !=3D 1) {
-		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
 		       bgrt_tab->version);
 		return;
 	}
 	if (bgrt_tab->status & 0xfe) {
-		pr_err("Ignoring BGRT: reserved status bits are non-zero %u\n",
+		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
 		       bgrt_tab->status);
 		return;
 	}
 	if (bgrt_tab->image_type !=3D 0) {
-		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
+		pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
 		       bgrt_tab->image_type);
 		return;
 	}
 	if (!bgrt_tab->image_address) {
-		pr_err("Ignoring BGRT: null image address\n");
+		pr_notice("Ignoring BGRT: null image address\n");
 		return;
 	}
=20
 	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMRE=
MAP_WB);
 	if (!image) {
-		pr_err("Ignoring BGRT: failed to map image header memory\n");
+		pr_notice("Ignoring BGRT: failed to map image header memory\n");
 		return;
 	}
=20
 	memcpy(&bmp_header, image, sizeof(bmp_header));
 	memunmap(image);
 	if (bmp_header.id !=3D 0x4d42) {
-		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4=
d42)\n",
+		pr_notice("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected =
0x4d42)\n",
 			bmp_header.id);
 		return;
 	}
@@ -84,14 +84,14 @@ void __init efi_bgrt_init(void)
=20
 	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!bgrt_image) {
-		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %=
zu bytes)\n",
+		pr_notice("Ignoring BGRT: failed to allocate memory for image (wante=
d %zu bytes)\n",
 		       bgrt_image_size);
 		return;
 	}
=20
 	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP=
_WB);
 	if (!image) {
-		pr_err("Ignoring BGRT: failed to map image memory\n");
+		pr_notice("Ignoring BGRT: failed to map image memory\n");
 		kfree(bgrt_image);
 		bgrt_image =3D NULL;
 		return;
--=20
2.7.3
