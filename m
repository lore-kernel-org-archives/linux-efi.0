From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 14/14] x86/efi: Print size in binary units in efi_print_memmap
Date: Mon,  1 Feb 2016 22:07:08 +0000
Message-ID: <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Laszlo Ersek <lersek@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

=46rom: Robert Elliott <elliott@hpe.com>

Print the size in the best-fit B, KiB, MiB, etc. units rather than
always MiB. This avoids rounding, which can be misleading.

Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
decimal units (KB, MB, etc.).

old:
=C2=A0=C2=A0=C2=A0=C2=A0efi: mem61: [Persistent Memory=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A0|WB|WT|WC|UC] range=3D[0x0000000880000000-0x00=
00000c7fffffff) (16384MB)

new:
=C2=A0=C2=A0=C2=A0=C2=A0efi: mem61: [Persistent Memory=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A0|WB|WT|WC|UC] range=3D[0x0000000880000000-0x00=
00000c7fffffff] (16 GiB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e80826e6f3a9..2c457c5e8203 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -35,6 +35,7 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <linux/memblock.h>
@@ -117,6 +118,17 @@ void efi_get_time(struct timespec *now)
 	now->tv_nsec =3D 0;
 }
=20
+static char * __init efi_size_format(char *buf, size_t size, u64 bytes=
)
+{
+	static const char *const units_2[] =3D {
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
+	};
+	unsigned long i =3D bytes ? __ffs64(bytes) / 10 : 0;
+
+	snprintf(buf, size, "%llu %s", bytes >> (i * 10), units_2[i]);
+	return buf;
+}
+
 void __init efi_find_mirror(void)
 {
 	void *p;
@@ -225,21 +237,20 @@ int __init efi_memblock_x86_reserve_range(void)
 void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
-	efi_memory_desc_t *md;
 	void *p;
 	int i;
=20
 	for (p =3D memmap.map, i =3D 0;
 	     p < memmap.map_end;
 	     p +=3D memmap.desc_size, i++) {
-		char buf[64];
+		efi_memory_desc_t *md =3D p;
+		u64 size =3D md->num_pages << PAGE_SHIFT;
+		char buf[64], buf2[64];
=20
-		md =3D p;
-		pr_info("mem%02u: %s range=3D[0x%016llx-0x%016llx] (%lluMB)\n",
+		pr_info("mem%02u: %s range=3D[0x%016llx-0x%016llx] (%s)\n",
 			i, efi_md_typeattr_format(buf, sizeof(buf), md),
-			md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			md->phys_addr, md->phys_addr + size - 1,
+			efi_size_format(buf2, sizeof(buf2), size));
 	}
 #endif  /*  EFI_DEBUG  */
 }
--=20
2.6.2
