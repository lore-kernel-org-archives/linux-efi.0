From: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] efi: Resolve some shadow warnings
Date: Sat,  6 Sep 2014 06:02:53 -0700
Message-ID: <1410008573-444-1-git-send-email-jeffrey.t.kirsher@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=46rom: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It is a really bad idea to declare variables or parameters that
have the same name as common types. It is valid C, but it gets
surprising if a macro expansion attempts to declare an inner
local with that type. Change the local names to eliminate the
hazard.

Change s16 =3D> str16, s8 =3D> str8.

This resolves warnings seen when using W=3D2 during make, for instance:

drivers/firmware/efi/vars.c: In function =E2=80=98dup_variable_bug=E2=80=
=99:
drivers/firmware/efi/vars.c:324:44: warning: declaration of =E2=80=98s1=
6=E2=80=99 shadows a global declaration [-Wshadow]
 static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_gui=
d,

drivers/firmware/efi/vars.c:328:8: warning: declaration of =E2=80=98s8=E2=
=80=99 shadows a global declaration [-Wshadow]
  char *s8;

Signed-off-by: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

v2: Updated patch description to add warning information and modified t=
he
    variable names to str* instead of ps*, based on feed back from Matt
    Fleming

 drivers/firmware/efi/vars.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 5abe943..afa3596 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -321,11 +321,11 @@ static unsigned long var_name_strnsize(efi_char16=
_t *variable_name,
  * Print a warning when duplicate EFI variables are encountered and
  * disable the sysfs workqueue since the firmware is buggy.
  */
-static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_gui=
d,
+static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_g=
uid,
 			     unsigned long len16)
 {
 	size_t i, len8 =3D len16 / sizeof(efi_char16_t);
-	char *s8;
+	char *str8;
=20
 	/*
 	 * Disable the workqueue since the algorithm it uses for
@@ -334,16 +334,16 @@ static void dup_variable_bug(efi_char16_t *s16, e=
fi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled =3D false;
=20
-	s8 =3D kzalloc(len8, GFP_KERNEL);
-	if (!s8)
+	str8 =3D kzalloc(len8, GFP_KERNEL);
+	if (!str8)
 		return;
=20
 	for (i =3D 0; i < len8; i++)
-		s8[i] =3D s16[i];
+		str8[i] =3D str16[i];
=20
 	printk(KERN_WARNING "efivars: duplicate variable: %s-%pUl\n",
-	       s8, vendor_guid);
-	kfree(s8);
+	       str8, vendor_guid);
+	kfree(str8);
 }
=20
 /**
--=20
1.9.3
