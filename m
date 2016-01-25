From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Mon, 25 Jan 2016 10:56:12 -0800
Message-ID: <1453748172.2363.36.camel@HansenPartnership.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1453567445.2470.24.camel@HansenPartnership.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295BF3B840@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BF3B840-W1gbDvblbosSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-01-25 at 18:02 +0000, Elliott, Robert (Persistent Memory)
wrote:
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
> > ]
> > Sent: Saturday, January 23, 2016 10:44 AM
> > To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; Matt
> > Fleming
> > <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>; Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>;
> > Ingo
> > Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; H . Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>; linux-
> > efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>;
> > Andrew
> > Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>; linux-kernel @ vger . kernel .
> > org
> > <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Cc: Elliott, Robert (Persistent Memory) <elliott-ZPxbGqLxI0U@public.gmane.org>
> > Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
> > efi_print_memmap
> > 
> > On Sat, 2016-01-23 at 16:55 +0200, Andy Shevchenko wrote:
> > > From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> > > 
> > > Print the size in the best-fit B, KiB, MiB, etc. units rather
> > > than
> > > always MiB. This avoids rounding, which can be misleading.
> > > 
> 
> ...
> > 
> > What if size is zero, which might happen on a UEFI screw up?  
> 
> > Also it gives really odd results for non power of two memory sizes.
> > 16384MB prints as 16GiB but 16385 prints as 16385MiB.
> > If the goal is to have a clean interface reporting only the first
> > four
> > significant figures and a size exponent, then a helper would be
> > much
> > better than trying to open code this ad hoc.
> 
> An impetus for the patch was to stop rounding the sub-MiB values,
> which is misleading and can hide bugs.  For my systems, the
> minimum size of a range happens to be 4 KiB, so I wanted at least
> that resolution. However, I don't want to print everything as KiB,
> because that makes big sizes less clear.
> 
> Example - old output:
> efi: mem00: [Conventional Memory...] range=[0x0000000000000000
> -0x0000000000001000) (0MB)
> efi: mem01: [Loader Data        ...] range=[0x0000000000001000
> -0x0000000000002000) (0MB)
> efi: mem02: [Conventional Memory...] range=[0x0000000000002000
> -0x0000000000093000) (0MB)
> efi: mem03: [Reserved           ...] range=[0x0000000000093000
> -0x0000000000094000) (0MB)
> 
> Proposed output:
> efi: mem00: [Conventional Memory...] range=[0x0000000000000000
> -0x0000000000092fff] (588 KiB @ 0 B)
> efi: mem01: [Reserved           ...] range=[0x0000000000093000
> -0x0000000000093fff] (4 KiB @ 588 KiB)
> efi: mem02: [Conventional Memory...] range=[0x0000000000094000
> -0x000000000009ffff] (48 KiB @ 592 KiB)
> efi: mem03: [Loader Data        ...] range=[0x0000000000100000
> -0x00000000013e8fff] (19364 KiB @ 1 MiB)
> (notes:
>  - from a different system
>  - including both base and size
>  - Matt didn't like printing the base so that's been removed)
> 
> With persistent memory (NVDIMMs) bringing storage device capacities
> into the memory subsystem, MiB is too small.  Seeing a 1 TiB NVDIMM
> as 1 TiB is a lot clearer than having to recognize 1048576 MiB as
> the same value (especially since these power-of-two quantities
> don't just chop off zeros on the right).
> 
> Examples:
> efi: mem50: [Runtime Data       ...] range=[0x00000000784ff000
> -0x00000000788fefff] (4 MiB @ 1971196 KiB)
> efi: mem56: [Conventional Memory...] range=[0x0000000100000000
> -0x000000087fffffff] (30 GiB @ 4 GiB)
> efi: mem58: [Memory Mapped I/O  ...] range=[0x0000000080000000
> -0x000000008fffffff] (256 MiB @ 2 GiB)
> efi: mem60: [Persistent Memory  ...] range=[0x0000001480000000
> -0x0000001a7fffffff] (24 GiB @ 82 GiB)

OK, this is getting a bit out of hand: I didn't say your aim was bad
... I think it's a reasonable desire; I said the proposed
implementation was bad.  Using ffs leads to precision runaway and
exporting an array from string_helpers.c is simply the wrong way to do
it.

Since we've now spent more time arguing about this than it would take
to do a correct patch, this is what I was thinking.  It extracts the
precision reduction core from string_helpers.c and exposes it to all
users who want to convert to units.  I added a nozeros option becuase I
think you want it to print 1 GiB rather than 1.00 GiB for exact powers
of two.  (OK, and I fixed a bug where it will report small amounts as
1.00 B instead of whole number of bytes).  Absent the nozero option,
you could simply have used string_get_size(), with a block size of 1.

James

---

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index dabe643..78935fae 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -10,6 +10,8 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
+void string_get_units(u64 size, const enum string_size_units units,
+		      char *buf, int len, bool nozeros);
 void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 5c88204..ab6b332 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -13,21 +13,13 @@
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 
-/**
- * string_get_size - get the size in the specified units
- * @size:	The size to be converted in blocks
- * @blk_size:	Size of the block (use 1 for size in bytes)
- * @units:	units to use (powers of 1000 or 1024)
- * @buf:	buffer to format to
- * @len:	length of buffer
- *
- * This function returns a string formatted to 3 significant figures
- * giving the size in the required units.  @buf should have room for
- * at least 9 bytes and will always be zero terminated.
- *
- */
-void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
-		     char *buf, int len)
+static const unsigned int divisor[] = {
+	[STRING_UNITS_10] = 1000,
+	[STRING_UNITS_2] = 1024,
+};
+
+static void string_reduce(u64 size, int log, const enum string_size_units units,
+			  char *buf, int len, bool nozeros)
 {
 	static const char *const units_10[] = {
 		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
@@ -39,52 +31,23 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		[STRING_UNITS_10] = units_10,
 		[STRING_UNITS_2] = units_2,
 	};
-	static const unsigned int divisor[] = {
-		[STRING_UNITS_10] = 1000,
-		[STRING_UNITS_2] = 1024,
-	};
 	static const unsigned int rounding[] = { 500, 50, 5 };
-	int i = 0, j;
-	u32 remainder = 0, sf_cap;
+	char zeros[] = ".00";
+
+	int j;
+	u32 sf_cap, remainder = 0;
 	char tmp[8];
 	const char *unit;
 
 	tmp[0] = '\0';
 
-	if (blk_size == 0)
-		size = 0;
 	if (size == 0)
 		goto out;
 
-	/* This is Napier's algorithm.  Reduce the original block size to
-	 *
-	 * coefficient * divisor[units]^i
-	 *
-	 * we do the reduction so both coefficients are just under 32 bits so
-	 * that multiplying them together won't overflow 64 bits and we keep
-	 * as much precision as possible in the numbers.
-	 *
-	 * Note: it's safe to throw away the remainders here because all the
-	 * precision is in the coefficients.
-	 */
-	while (blk_size >> 32) {
-		do_div(blk_size, divisor[units]);
-		i++;
-	}
-
-	while (size >> 32) {
-		do_div(size, divisor[units]);
-		i++;
-	}
-
-	/* now perform the actual multiplication keeping i as the sum of the
-	 * two logarithms */
-	size *= blk_size;
-
-	/* and logarithmically reduce it until it's just under the divisor */
+	/* Logarithmically reduce it until it's just under the divisor */
 	while (size >= divisor[units]) {
 		remainder = do_div(size, divisor[units]);
-		i++;
+		log++;
 	}
 
 	/* work out in j how many digits of precision we need from the
@@ -109,21 +72,93 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		size += 1;
 	}
 
-	if (j) {
+	if (j && log) {
 		snprintf(tmp, sizeof(tmp), ".%03u", remainder);
 		tmp[j+1] = '\0';
+		zeros[j+1] = '\0';
+		if (nozeros && strcmp(tmp, zeros) == 0)
+			tmp[0]='\0';
 	}
 
  out:
-	if (i >= ARRAY_SIZE(units_2))
+	if (log >= ARRAY_SIZE(units_2))
 		unit = "UNK";
 	else
-		unit = units_str[units][i];
+		unit = units_str[units][log];
 
 	snprintf(buf, len, "%u%s %s", (u32)size,
 		 tmp, unit);
 }
-EXPORT_SYMBOL(string_get_size);
+
+/**
+ * string_get_units - convert size to specified units
+ * @size:	The quantity to be converted
+ * @units:	units to use (powers of 1000 or 1024)
+ * @buf:	buffer to format to
+ * @len:	length of buffer
+ * @nozereos:	eliminate zeros after the decimal point if true
+ *
+ * This function returns a string formatted to 3 significant figures
+ * giving the size in the required units.  @buf should have room for
+ * at least 9 bytes and will always be zero terminated.
+ */
+void string_get_units(u64 size, const enum string_size_units units,
+		      char *buf, int len, bool nozeros)
+{
+	string_reduce(size, 0, units, buf, len, nozeros);
+}
+
+/**
+ * string_get_size - get the size in the specified units
+ * @size:	The size to be converted in blocks
+ * @blk_size:	Size of the block (use 1 for size in bytes)
+ * @units:	units to use (powers of 1000 or 1024)
+ * @buf:	buffer to format to
+ * @len:	length of buffer
+ *
+ * This function returns a string formatted to 3 significant figures
+ * giving the size in the required units.  @buf should have room for
+ * at least 9 bytes and will always be zero terminated.
+ *
+ */
+void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
+		     char *buf, int len)
+{
+	int i = 0;
+
+	if (blk_size == 0)
+		size = 0;
+	if (size == 0)
+		goto out;
+
+	/* This is Napier's algorithm.  Reduce the original block size to
+	 *
+	 * coefficient * divisor[units]^i
+	 *
+	 * we do the reduction so both coefficients are just under 32 bits so
+	 * that multiplying them together won't overflow 64 bits and we keep
+	 * as much precision as possible in the numbers.
+	 *
+	 * Note: it's safe to throw away the remainders here because all the
+	 * precision is in the coefficients.
+	 */
+	while (blk_size >> 32) {
+		do_div(blk_size, divisor[units]);
+		i++;
+	}
+
+	while (size >> 32) {
+		do_div(size, divisor[units]);
+		i++;
+	}
+
+	/* now perform the actual multiplication keeping i as the sum of the
+	 * two logarithms */
+	size *= blk_size;
+
+ out:
+	string_reduce(size, i, units, buf, len, false);
+}
 
 static bool unescape_space(char **src, char **dst)
 {
