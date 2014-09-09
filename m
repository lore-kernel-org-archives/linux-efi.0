From: Andre <andre.muller-S0/GAf8tV78@public.gmane.org>
Subject: [RFC] [PATCH] x86/efi: Adding efi_printks on memory allocationa and
 pci.reads
Date: Wed, 10 Sep 2014 01:00:22 +0200
Message-ID: <20140910010022.21b2707b@bert>
References: <20140906230251.140a99c9@bert>
 <20140907021133.7184c28c@bert>
 <20140908211856.GC18582@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140908211856.GC18582-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

All other calls to allocate memory seem to make some noise already, wit=
h the
exception of two calls (for gop, uga) in the setup_graphics path.

The purpose is to be noisy on worrysome errors immediately.

> commit fb86b2440de0ec10fe0272eb19d262ae7a01adb8
> Author: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
> Date:   Thu Jul 10 02:12:41 2014 +0200
>
>     x86/efi: Add better error logging to EFI boot stub

introduces printing false alarms for lots of hardware. Rather than play=
ing
Whack a Mole with non-fatal exit conditions, try the other way round.

This is per Matt Fleming's suggestion:

> Where I think we could improve things
> is by adding efi_printk() message in certain error paths. Clearly, no=
t
> all error paths need such messages, e.g. the EFI_INVALID_PARAMETER pa=
th
> you highlighted above, but it makes sense for memory allocation and P=
CI
> read failures.

http://article.gmane.org/gmane.linux.kernel.efi/4628

After this, the status check on the setup_efi_pci() function
can go away again.

Signed-off-by: Andre M=FCller <andre.muller-S0/GAf8tV78@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compresse=
d/eboot.c
index f277184..f296ee9 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -323,8 +323,10 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, str=
uct pci_setup_rom **__rom)
 	size =3D pci->romsize + sizeof(*rom);
=20
 	status =3D efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom)=
;
-	if (status !=3D EFI_SUCCESS)
+	if (status !=3D EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for rom\n");
 		return status;
+	}=09
=20
 	memset(rom, 0, sizeof(*rom));
=20
@@ -337,14 +339,18 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, st=
ruct pci_setup_rom **__rom)
 	status =3D efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_VENDOR_ID, 1, &(rom->vendor));
=20
-	if (status !=3D EFI_SUCCESS)
+	if (status !=3D EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->vendor\n");
 		goto free_struct;
+	}
=20
 	status =3D efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_DEVICE_ID, 1, &(rom->devid));
=20
-	if (status !=3D EFI_SUCCESS)
+	if (status !=3D EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->devid\n");
 		goto free_struct;
+	}
=20
 	status =3D efi_early->call(pci->get_location, pci, &(rom->segment),
 				 &(rom->bus), &(rom->device), &(rom->function));
@@ -427,8 +433,10 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, str=
uct pci_setup_rom **__rom)
 	size =3D pci->romsize + sizeof(*rom);
=20
 	status =3D efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom)=
;
-	if (status !=3D EFI_SUCCESS)
+	if (status !=3D EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for rom\n");
 		return status;
+	}
=20
 	rom->data.type =3D SETUP_PCI;
 	rom->data.len =3D size - sizeof(struct setup_data);
@@ -439,14 +447,18 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, st=
ruct pci_setup_rom **__rom)
 	status =3D efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_VENDOR_ID, 1, &(rom->vendor));
=20
-	if (status !=3D EFI_SUCCESS)
+	if (status !=3D EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->vendor\n");
 		goto free_struct;
+	}
=20
 	status =3D efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_DEVICE_ID, 1, &(rom->devid));
=20
-	if (status !=3D EFI_SUCCESS)
+	if (status !=3D EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->devid\n");
 		goto free_struct;
+	}
=20
 	status =3D efi_early->call(pci->get_location, pci, &(rom->segment),
 				 &(rom->bus), &(rom->device), &(rom->function));
@@ -526,8 +538,10 @@ static efi_status_t setup_efi_pci(struct boot_para=
ms *params)
 					EFI_LOADER_DATA,
 					size, (void **)&pci_handle);
=20
-		if (status !=3D EFI_SUCCESS)
+		if (status !=3D EFI_SUCCESS) {
+			efi_printk(sys_table, "Failed to alloc mem for pci_handle\n");
 			return status;
+		}
=20
 		status =3D efi_call_early(locate_handle,
 					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
--=20
1.8.5.5
