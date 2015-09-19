From: "=?UTF-8?q?K=C5=91v=C3=A1g=C3=B3=2C=20Zolt=C3=A1n?="
	<dirty.ice.hu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] x86/efi: fix multiple GOP device support
Date: Sat, 19 Sep 2015 15:40:23 +0200
Message-ID: <fce1886dc0b07f374eb49a13746df5e47518d338.1442666763.git.DirtY.iCE.hu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When multiple GOP devices exists, but none of them implements ConOut,
the code should just choose the first GOP (according to the comments).
But currently fb_base will refer to the last GOP, while other parameter=
s
to the first GOP, which will likely result in a garbled display.

Signed-off-by: K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n <DirtY.iCE.hu@gmail.c=
om>
---

I can reliably reproducible this bug using my ASRock Z87M Extreme4
motherboard with CSM and integrated GPU disabled, and two PCIe video
cards (NVidia GT640 and GTX980), booting from efi-stub (booting from
grub works fine).  On the primary display the asrock logo remains and o=
n
the secondary screen is garbled up completely.

 arch/x86/boot/compressed/eboot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compresse=
d/eboot.c
index ee1b6d3..db51c1f 100644
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
2.5.2
