From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] x86/mm, efi: Check for valid image type
Date: Wed, 22 Jul 2015 17:32:44 +0200
Message-ID: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I usually see
|Ignoring BGRT: failed to allocate memory for image (wanted 264301314 b=
ytes)
|Ignoring BGRT: failed to allocate memory for image (wanted 3925872891 =
bytes)

sometimes I get

|------------[ cut here ]------------
|WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:136 __early_ioremap.const=
prop.0+0x113/0x1d3()
=E2=80=A6
| [<ffffffff81b3de8c>] __early_ioremap.constprop.0+0x113/0x1d3
| [<ffffffff81b3e106>] early_ioremap+0x13/0x15
| [<ffffffff81b2c4a9>] efi_bgrt_init+0x1e2/0x27d
=E2=80=A6

now and then. The data behind that pointer changes on each boot because
nobody preserves the content across kexec.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---

I don't know much about the requirement of having the .bmp in memory al=
l the
time. Would it be a bad thing to compress the bmp and uncompress on cat=
 from
userland? In my case the bmp has 272 KiB and LZO gets it down to 12KiB,
XZ 7.4KiB.

 arch/x86/platform/efi/efi-bgrt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/e=
fi-bgrt.c
index d7f997f7c26d..59710f0875bb 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -79,6 +79,10 @@ void __init efi_bgrt_init(void)
 	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
 	if (ioremapped)
 		early_iounmap(image, sizeof(bmp_header));
+	if (bmp_header.id !=3D 0x4d42) {
+		pr_err("BGRT: Not a valid BMP file.\n");
+		return;
+	}
 	bgrt_image_size =3D bmp_header.size;
=20
 	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
--=20
2.1.4
