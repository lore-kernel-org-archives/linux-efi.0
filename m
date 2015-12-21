From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] x86/efi-bgrt: Replace early_memremap() with memremap()
Date: Mon, 21 Dec 2015 14:12:52 +0000
Message-ID: <1450707172-12561-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me-A/3C56C7qwM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

M=C3=B4she reported the following warning triggered on his machine sinc=
e
commit 50a0cb565246 ("x86/efi-bgrt: Fix kernel panic when mapping BGRT
data"),

  [    0.026936] ------------[ cut here ]------------
  [    0.026941] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:137 __ear=
ly_ioremap+0x102/0x1bb()
  [    0.026941] Modules linked in:
  [    0.026944] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-rc1 #2
  [    0.026945] Hardware name: Dell Inc. XPS 13 9343/09K8G1, BIOS A05 =
07/14/2015
  [    0.026946]  0000000000000000 900f03d5a116524d ffffffff81c03e60 ff=
ffffff813a3fff
  [    0.026948]  0000000000000000 ffffffff81c03e98 ffffffff810a0852 00=
000000d7b76000
  [    0.026949]  0000000000000000 0000000000000001 0000000000000001 00=
0000000000017c
  [    0.026951] Call Trace:
  [    0.026955]  [<ffffffff813a3fff>] dump_stack+0x44/0x55
  [    0.026958]  [<ffffffff810a0852>] warn_slowpath_common+0x82/0xc0
  [    0.026959]  [<ffffffff810a099a>] warn_slowpath_null+0x1a/0x20
  [    0.026961]  [<ffffffff81d8c395>] __early_ioremap+0x102/0x1bb
  [    0.026962]  [<ffffffff81d8c602>] early_memremap+0x13/0x15
  [    0.026964]  [<ffffffff81d78361>] efi_bgrt_init+0x162/0x1ad
  [    0.026966]  [<ffffffff81d778ec>] efi_late_init+0x9/0xb
  [    0.026968]  [<ffffffff81d58ff5>] start_kernel+0x46f/0x49f
  [    0.026970]  [<ffffffff81d58120>] ? early_idt_handler_array+0x120/=
0x120
  [    0.026972]  [<ffffffff81d58339>] x86_64_start_reservations+0x2a/0=
x2c
  [    0.026974]  [<ffffffff81d58485>] x86_64_start_kernel+0x14a/0x16d
  [    0.026977] ---[ end trace f9b3812eb8e24c58 ]---
  [    0.026978] efi_bgrt: Ignoring BGRT: failed to map image memory

early_memremap() has an upper limit on the size of mapping it can
handle which is ~200KB. Clearly the BGRT image on M=C3=B4she's machine =
is
much larger than that.

There's actually no reason to restrict ourselves to using the early_*
version of memremap() - the ACPI BGRT driver is invoked late enough in
boot that we can use the standard version, with the benefit that the
late version allows mappings of arbitrary size.

Reported-by: M=C3=B4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Tested-by: M=C3=B4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi-bgrt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/e=
fi-bgrt.c
index bf51f4c02562..b0970661870a 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -72,14 +72,14 @@ void __init efi_bgrt_init(void)
 		return;
 	}
=20
-	image =3D early_memremap(bgrt_tab->image_address, sizeof(bmp_header))=
;
+	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMRE=
MAP_WB);
 	if (!image) {
 		pr_err("Ignoring BGRT: failed to map image header memory\n");
 		return;
 	}
=20
 	memcpy(&bmp_header, image, sizeof(bmp_header));
-	early_memunmap(image, sizeof(bmp_header));
+	memunmap(image);
 	bgrt_image_size =3D bmp_header.size;
=20
 	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
@@ -89,7 +89,7 @@ void __init efi_bgrt_init(void)
 		return;
 	}
=20
-	image =3D early_memremap(bgrt_tab->image_address, bmp_header.size);
+	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP=
_WB);
 	if (!image) {
 		pr_err("Ignoring BGRT: failed to map image memory\n");
 		kfree(bgrt_image);
@@ -98,5 +98,5 @@ void __init efi_bgrt_init(void)
 	}
=20
 	memcpy(bgrt_image, image, bgrt_image_size);
-	early_memunmap(image, bmp_header.size);
+	memunmap(image);
 }
--=20
2.6.2
