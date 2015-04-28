From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] efi: dmi: List SMBIOS3 table before SMBIOS table
Date: Tue, 28 Apr 2015 09:30:12 +0200
Message-ID: <20150428093012.4c859240@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The SMBIOS3 table should appear before the SMBIOS table in
/sys/firmware/efi/systab. This allows user-space utilities which
support both to pick the SMBIOS3 table with a single pass on systems
where both are implemented. The SMBIOS3 entry point is more capable
than the SMBIOS entry point so it should be preferred.

This follows the same logic as the ACPI20 table being listed before
the ACPI table.

Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-4.1-rc1.orig/drivers/firmware/efi/efi.c	2015-04-27 02:59:10.000000000 +0200
+++ linux-4.1-rc1/drivers/firmware/efi/efi.c	2015-04-28 09:19:20.910416344 +0200
@@ -85,10 +85,10 @@ static ssize_t systab_show(struct kobjec
 		str += sprintf(str, "ACPI20=0x%lx\n", efi.acpi20);
 	if (efi.acpi != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "ACPI=0x%lx\n", efi.acpi);
-	if (efi.smbios != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
 	if (efi.smbios3 != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "SMBIOS3=0x%lx\n", efi.smbios3);
+	if (efi.smbios != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
 	if (efi.hcdp != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "HCDP=0x%lx\n", efi.hcdp);
 	if (efi.boot_info != EFI_INVALID_TABLE_ADDR)


-- 
Jean Delvare
SUSE L3 Support
