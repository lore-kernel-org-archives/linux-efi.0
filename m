From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Mon, 11 Mar 2013 21:17:53 +0800
Message-ID: <1363007873.13754.44.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
	 <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362664663.15011.194.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,=20

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-03-07 =E6=96=BC 13:57 +0000=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 2013-03-07 at 11:39 +0000, Matt Fleming wrote:
> > On Thu, 2013-03-07 at 18:34 +0800, joeyli wrote:
> > > The VariableNameSize is not reliable when EFI_SUCCESS is returned
> > > because UEFI 2.3.1 spec only mention VariableNameSize should upda=
ted
> > > when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buf=
fer is
> > > from old UEFI spec. There doesn't have any size condition of vari=
able
> > > data or variable name in 2.3.1 spec.
> >=20
> > The spec may only mention what happens in the EFI_BUFFER_TOO_SMALL =
case,
> > but for EFI_SUCCESS, any behaviour other than leaving VariableNameS=
ize
> > alone or updating it with the required size of the buffer is just
> > completely insane.
> >=20
> > > I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO=
_SMALL,
> > > the behavior like what we do in efivarfs_file_read().
> >=20
> > Thanks, this does seem like the most robust solution.
>=20
> Also, you're probably going to need to update
> efivar_update_sysfs_entries() too.
>=20

Sorry for after I wrote patch, I think it's better we still use your
original patch to fix this bug, because I found the
efi_variable->VariableName allocated 1024 size and it also used by old
vars system.=20

The following is my patch for reference, but I think your original patc=
h
is better for backward compatible on variable name.

Please consider to merge your original patch!


Thanks a lot!
Joey Lee


>From c067288dbbb963b9cf9be4c5f59f5e39e88361ad Mon Sep 17 00:00:00 2001
=46rom: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Date: Mon, 11 Mar 2013 18:26:04 +0800
Subject: [PATCH] efivars: Sanitise length of variable name for register


Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efivars.c |   39 ++++++++++++++++++++++++++++++------=
---
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3edade0..1e854b3 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -111,7 +111,7 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
=20
 struct efi_variable {
-	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
+	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];		/* PROBLEM: 1=
024 size, need backward compatible to old vars */
 	efi_guid_t    VendorGuid;
 	unsigned long DataSize;
 	__u8          Data[1024];
@@ -1903,10 +1903,11 @@ int register_efivars(struct efivars *efivars,
 	efi_status_t status =3D EFI_NOT_FOUND;
 	efi_guid_t vendor_guid;
 	efi_char16_t *variable_name;
-	unsigned long variable_name_size =3D 1024;
+	unsigned long variable_name_size;
+	unsigned long variable_name_buff_size =3D 1024;
 	int error =3D 0;
=20
-	variable_name =3D kzalloc(variable_name_size, GFP_KERNEL);
+	variable_name =3D kzalloc(variable_name_buff_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");
 		return -ENOMEM;
@@ -1937,17 +1938,37 @@ int register_efivars(struct efivars *efivars,
 	 */
=20
 	do {
-		variable_name_size =3D 1024;
+		variable_name_size =3D 0;
=20
 		status =3D ops->get_next_variable(&variable_name_size,
 						variable_name,
 						&vendor_guid);
 		switch (status) {
-		case EFI_SUCCESS:
-			efivar_create_sysfs_entry(efivars,
-						  variable_name_size,
-						  variable_name,
-						  &vendor_guid);
+		case EFI_BUFFER_TOO_SMALL:
+			if (variable_name_size < sizeof(efi_char16_t) * 2) {
+				/* Bogus size - expect at least one char + NULL */
+				variable_name_size =3D variable_name_buff_size;
+			} else if (variable_name_size > variable_name_buff_size) {
+				kfree(variable_name);
+				variable_name =3D kzalloc(variable_name_size, GFP_KERNEL);
+				if (!variable_name) {
+					printk(KERN_ERR "efivars: Memory allocation failed.\n");
+					return -ENOMEM;
+				}
+				variable_name_buff_size =3D variable_name_size;
+			}
+			status =3D ops->get_next_variable(&variable_name_size,
+							variable_name,
+							&vendor_guid);
+			/* Length of the variable_name, plus terminating NULL */
+			variable_name_size =3D utf16_strsize(
+					variable_name, variable_name_buff_size)
+					+ sizeof(efi_char16_t);
+			if (status =3D=3D EFI_SUCCESS)
+				efivar_create_sysfs_entry(efivars,
+							  variable_name_size,	/* PROBLEM: variable_name_size could not =
larger then new_efivar->var.VariableName =3D 1024 */
+							  variable_name,
+							  &vendor_guid);
 			break;
 		case EFI_NOT_FOUND:
 			break;
--=20
1.6.4.2
