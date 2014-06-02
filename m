From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] efi: Fix compiler warnings (unused, const, type)
Date: Mon,  2 Jun 2014 11:31:06 +0100
Message-ID: <1401705066-2808-1-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This patch fixes a few compiler warning in the efi code for unused
variable, discarding const qualifier and wrong pointer type:

drivers/firmware/efi/fdt.c|66 col 22| warning: unused variable =E2=80=98=
name=E2=80=99 [-Wunused-variable]
drivers/firmware/efi/efi.c|368 col 3| warning: passing argument 3 of =E2=
=80=98of_get_flat_dt_prop=E2=80=99 from incompatible pointer type [enab=
led by default]
drivers/firmware/efi/efi.c|368 col 8| warning: assignment discards =E2=80=
=98const=E2=80=99 qualifier from pointer target type [enabled by defaul=
t]

Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
---

Matt,

Unless you have fixed these already, please consider applying (warnings=
 in
latest next/master branch).

Thanks,

Catalin


 drivers/firmware/efi/efi.c | 6 +++---
 drivers/firmware/efi/fdt.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb619fa..eff1a2f22f09 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -353,10 +353,10 @@ static int __init fdt_find_uefi_params(unsigned l=
ong node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info =3D data;
-	void *prop, *dest;
-	unsigned long len;
+	const void *prop;
+	void *dest;
 	u64 val;
-	int i;
+	int i, len;
=20
 	if (depth !=3D 1 ||
 	    (strcmp(uname, "chosen") !=3D 0 && strcmp(uname, "chosen@0") !=3D=
 0))
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 5c6a8e8a9580..82d774161cc9 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -63,7 +63,7 @@ static efi_status_t update_fdt(efi_system_table_t *sy=
s_table, void *orig_fdt,
 	 */
 	prev =3D 0;
 	for (;;) {
-		const char *type, *name;
+		const char *type;
 		int len;
=20
 		node =3D fdt_next_node(fdt, prev, NULL);
