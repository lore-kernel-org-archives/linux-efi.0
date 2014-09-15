From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] x86/efi: Delete misleading efi_printk() error message
Date: Mon, 15 Sep 2014 16:20:54 +0100
Message-ID: <1410794454-17961-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, =?UTF-8?q?Andre=20M=C3=BCller?= <andre.muller-S0/GAf8tV78@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=46rom: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A number of people are reporting seeing the "setup_efi_pci() failed!"
error message in what used to be a quiet boot,

  https://bugzilla.kernel.org/show_bug.cgi?id=3D81891

The message isn't all that helpful because setup_efi_pci() can return a
non-success error code for a variety of reasons, not all of them fatal.

Drop the efi_printk() now that we have more fine-grained, and more
specific, error messages throughout the *setup_efi_pci*() code paths.

Reported-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reported-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
Cc: Andre M=C3=BCller <andre.muller-S0/GAf8tV78@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

This patch is based on top of Andre's ("x86/efi: Adding efi_printks on
memory allocationa and pci.reads") sitting on the 'next' branch.

 arch/x86/boot/compressed/eboot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compresse=
d/eboot.c
index ed8e06c59a4c..87398f9434f3 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1394,10 +1394,7 @@ struct boot_params *efi_main(struct efi_config *=
c,
=20
 	setup_graphics(boot_params);
=20
-	status =3D setup_efi_pci(boot_params);
-	if (status !=3D EFI_SUCCESS) {
-		efi_printk(sys_table, "setup_efi_pci() failed!\n");
-	}
+	setup_efi_pci(boot_params);
=20
 	status =3D efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
--=20
1.9.3
