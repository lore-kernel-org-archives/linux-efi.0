From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 09/14] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit is 0
Date: Mon,  1 Feb 2016 22:07:03 +0000
Message-ID: <1454364428-494-10-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>, Matt Fleming <matt@codeblueprint.co.uk>, Josh Triplett <josh@joshtriplett.org>
List-Id: linux-efi@vger.kernel.org

=46rom: M=C3=B4she van der Sterre <me@moshe.nl>

Unintuitively, the BGRT graphic is apparently meant to be usable if
the valid bit in not set. The valid bit only conveys uncertainty
about the validity in relation to the screen state.

Windows 10 actually uses the BGRT image for its boot screen even if
not 'valid', for example when the user triggered the boot menu.
Because it is unclear if all firmwares will provide a usable graphic
in this case, we now look at the BMP magic number as an additional
check.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: M=C3=B4she van der Sterre <me@moshe.nl>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi-bgrt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/e=
fi-bgrt.c
index b0970661870a..a2433817c987 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -57,11 +57,6 @@ void __init efi_bgrt_init(void)
 		       bgrt_tab->status);
 		return;
 	}
-	if (bgrt_tab->status !=3D 1) {
-		pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
-			 bgrt_tab->status);
-		return;
-	}
 	if (bgrt_tab->image_type !=3D 0) {
 		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
 		       bgrt_tab->image_type);
@@ -80,6 +75,11 @@ void __init efi_bgrt_init(void)
=20
 	memcpy(&bmp_header, image, sizeof(bmp_header));
 	memunmap(image);
+	if (bmp_header.id !=3D 0x4d42) {
+		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4=
d42)\n",
+			bmp_header.id);
+		return;
+	}
 	bgrt_image_size =3D bmp_header.size;
=20
 	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
--=20
2.6.2
