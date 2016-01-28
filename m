From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Thu, 28 Jan 2016 13:15:18 +0200
Message-ID: <1453979718.2521.249.camel@linux.intel.com>
References: <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453567445.2470.24.camel@HansenPartnership.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295BF3B840@G9W0745.americas.hpqcorp.net>
	 <1453748172.2363.36.camel@HansenPartnership.com>
	 <CAHp75VdYRzC9TcDpKxq=xddA0zgVk=5_25uXaimn1tOMZVeK4Q@mail.gmail.com>
	 <1453751131.2363.54.camel@HansenPartnership.com>
	 <CAHp75VeXHoyOgFSb4vzWBmELH_yJx1mSN+quxue=tSZCh5sTXw@mail.gmail.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295BF3BBD3@G9W0745.americas.hpqcorp.net>
	 <20160126115041.GA7478@codeblueprint.co.uk>
	 <1453809566.2521.239.camel@linux.intel.com>
	 <20160128092959.GA2571@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160128092959.GA2571@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2016-01-28 at 09:29 +0000, Matt Fleming wrote:
> On Tue, 26 Jan, at 01:59:26PM, Andy Shevchenko wrote:
> > On Tue, 2016-01-26 at 11:50 +0000, Matt Fleming wrote:
> > > On Mon, 25 Jan, at 08:37:58PM, Elliott, Robert (Persistent
> > > Memory)
> > > wrote:
> > > >=20
> > > > For the UEFI memory map, that was indeed my intention.=C2=A0=C2=
=A0I
> > > > don't want it silently round to "20 GiB".=C2=A0=C2=A0Even round=
ing
> > > > to "19.999 GiB" is imprecise.
> > >=20
> > > OK, let's just go with your original patch Robert (minus the @
> > > addr
> > > bit) since it's pretty small and does what we want for this
> > > specific
> > > case.
> >=20
> > However I am against this, but seems reviewers do not leave a
> > chance to
> > us, I would propose to copy-and-paste table of binary prefixes and
> > use
> > __ffs64().
>=20
> Is there a benefit to this approach other than __ffs64() being
> faster?
> It is a neglibible performance gain anyway because this is hidden
> behind efi=3Ddebug, and so by definition you're not looking for ultra
> performance.
>=20
> Which makes picking between __ffs64() and non-__ffs64() a wash if
> we're not going to be reusing existing code.

=46or me it looks cleaner, smaller, thus better to maintenance, and
faster. So, my variant below, though it's up to you what to choose.

=46rom e16660cf999aec754a0f7a95604b8f9e86c40d55 Mon Sep 17 00:00:00 200=
1
=46rom: Robert Elliott <elliott@hpe.com>
Date: Tue, 12 Jan 2016 15:13:06 +0200
Subject: [PATCH 1/1] x86/efi: print size in binary units in
efi_print_memmap

Print the size in the best-fit B, KiB, MiB, etc. units rather than
always MiB. This avoids rounding, which can be misleading.

Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
decimal units (KB, MB, etc.).

old:
=C2=A0=C2=A0=C2=A0=C2=A0efi: mem61: [Persistent
Memory=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=
=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0|WB|WT|WC|UC] range=3D[=
0x0000000880000000-
0x0000000c7fffffff) (16384MB)

new:
=C2=A0=C2=A0=C2=A0=C2=A0efi: mem61: [Persistent
Memory=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=
=A0|=C2=A0=C2=A0|=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0|WB|WT|WC|UC] range=3D[=
0x0000000880000000-
0x0000000c7fffffff] (16 GiB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
=C2=A0arch/x86/platform/efi/efi.c | 25 ++++++++++++++++++-------
=C2=A01 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e0846b5..63fb5cf 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -35,6 +35,7 @@
=C2=A0#include <linux/efi.h>
=C2=A0#include <linux/efi-bgrt.h>
=C2=A0#include <linux/export.h>
+#include <linux/bitops.h>
=C2=A0#include <linux/bootmem.h>
=C2=A0#include <linux/slab.h>
=C2=A0#include <linux/memblock.h>
@@ -117,6 +118,17 @@ void efi_get_time(struct timespec *now)
=C2=A0	now->tv_nsec =3D 0;
=C2=A0}
=C2=A0
+static char * __init efi_size_format(char *buf, size_t size, u64
bytes)
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
=C2=A0void __init efi_find_mirror(void)
=C2=A0{
=C2=A0	void *p;
@@ -225,21 +237,20 @@ int __init efi_memblock_x86_reserve_range(void)
=C2=A0void __init efi_print_memmap(void)
=C2=A0{
=C2=A0#ifdef EFI_DEBUG
-	efi_memory_desc_t *md;
=C2=A0	void *p;
=C2=A0	int i;
=C2=A0
=C2=A0	for (p =3D memmap.map, i =3D 0;
=C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0p < memmap.map_end;
=C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0p +=3D memmap.desc_size, i++) {
-		char buf[64];
+		efi_memory_desc_t *md =3D p;
+		u64 size =3D md->num_pages << EFI_PAGE_SHIFT;
+		char buf[64], buf3[32];
=C2=A0
-		md =3D p;
-		pr_info("mem%02u: %s range=3D[0x%016llx-0x%016llx]
(%lluMB)\n",
+		pr_info("mem%02u: %s range=3D[0x%016llx-0x%016llx]
(%s)\n",
=C2=A0			i, efi_md_typeattr_format(buf, sizeof(buf),
md),
-			md->phys_addr,
-			md->phys_addr + (md->num_pages <<
EFI_PAGE_SHIFT) - 1,
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			md->phys_addr, md->phys_addr + size - 1,
+			efi_size_format(buf3, sizeof(buf3), size));
=C2=A0	}
=C2=A0#endif=C2=A0=C2=A0/*=C2=A0=C2=A0EFI_DEBUG=C2=A0=C2=A0*/
=C2=A0}
--=C2=A0
2.7.0.rc3


--=20
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
