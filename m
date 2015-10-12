From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/efi: Fix multiple GOP device support
Date: Mon, 12 Oct 2015 15:13:56 +0100
Message-ID: <1444659236-24837-2-git-send-email-matt@codeblueprint.co.uk>
References: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: =?UTF-8?q?K=C5=91v=C3=A1g=C3=B3=2C=20Zolt=C3=A1n?= <dirty.ice.hu@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, =?UTF-8?q?K=C5=91v=C3=A1g=C3=B3=2C=20Zolt=C3=A1n?= <DirtY.iCE.hu@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, stable@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

=46rom: K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n <dirty.ice.hu@gmail.com>

When multiple GOP devices exists, but none of them implements ConOut,
the code should just choose the first GOP (according to the comments).
But currently fb_base will refer to the last GOP, while other parameter=
s
to the first GOP, which will likely result in a garbled display.

I can reliably reproduce this bug using my ASRock Z87M Extreme4
motherboard with CSM and integrated GPU disabled, and two PCIe video
cards (NVidia GT640 and GTX980), booting from efi-stub (booting from
grub works fine).  On the primary display the asrock logo remains and o=
n
the secondary screen is garbled up completely.

Signed-off-by: K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n <DirtY.iCE.hu@gmail.c=
om>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compresse=
d/eboot.c
index ee1b6d346b98..db51c1f27446 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -667,6 +667,7 @@ setup_gop32(struct screen_info *si, efi_guid_t *pro=
to,
 		bool conout_found =3D false;
 		void *dummy =3D NULL;
 		u32 h =3D handles[i];
+		u32 current_fb_base;
=20
 		status =3D efi_call_early(handle_protocol, h,
 					proto, (void **)&gop32);
@@ -678,7 +679,7 @@ setup_gop32(struct screen_info *si, efi_guid_t *pro=
to,
 		if (status =3D=3D EFI_SUCCESS)
 			conout_found =3D true;
=20
-		status =3D __gop_query32(gop32, &info, &size, &fb_base);
+		status =3D __gop_query32(gop32, &info, &size, &current_fb_base);
 		if (status =3D=3D EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -692,6 +693,7 @@ setup_gop32(struct screen_info *si, efi_guid_t *pro=
to,
 			pixel_format =3D info->pixel_format;
 			pixel_info =3D info->pixel_information;
 			pixels_per_scan_line =3D info->pixels_per_scan_line;
+			fb_base =3D current_fb_base;
=20
 			/*
 			 * Once we've found a GOP supporting ConOut,
@@ -770,6 +772,7 @@ setup_gop64(struct screen_info *si, efi_guid_t *pro=
to,
 		bool conout_found =3D false;
 		void *dummy =3D NULL;
 		u64 h =3D handles[i];
+		u32 current_fb_base;
=20
 		status =3D efi_call_early(handle_protocol, h,
 					proto, (void **)&gop64);
@@ -781,7 +784,7 @@ setup_gop64(struct screen_info *si, efi_guid_t *pro=
to,
 		if (status =3D=3D EFI_SUCCESS)
 			conout_found =3D true;
=20
-		status =3D __gop_query64(gop64, &info, &size, &fb_base);
+		status =3D __gop_query64(gop64, &info, &size, &current_fb_base);
 		if (status =3D=3D EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -795,6 +798,7 @@ setup_gop64(struct screen_info *si, efi_guid_t *pro=
to,
 			pixel_format =3D info->pixel_format;
 			pixel_info =3D info->pixel_information;
 			pixels_per_scan_line =3D info->pixels_per_scan_line;
+			fb_base =3D current_fb_base;
=20
 			/*
 			 * Once we've found a GOP supporting ConOut,
--=20
2.1.0
