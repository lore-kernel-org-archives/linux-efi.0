From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] x86/efi: Always map boot service regions into new EFI page tables
Date: Fri, 11 Mar 2016 11:19:23 +0000
Message-ID: <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457695163-29632-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some machines have EFI regions in page zero (physical address
0x00000000) and historically that region has been added to the e820
map via trim_bios_range(), and ultimately mapped into the kernel page
tables. It was not mapped via efi_map_regions() as one would expect.

Alexis reports that with the new separate EFI page tables some boot
services regions, such as page zero, are not mapped. This triggers an
oops during the SetVirtualAddressMap() runtime call.

For the EFI boot services quirk on x86 we need to memblock_reserve()
boot services regions until after SetVirtualAddressMap(). Doing that
while respecting the ownership of regions that may have already been
reserved by the kernel was the motivation behind commit 7d68dc3f1003
("x86, efi: Do not reserve boot services regions within reserved
areas").

That patch was merged at a time when the EFI runtime virtual mappings
were inserted into the kernel page tables as described above, and the
trick of setting ->numpages (and hence the region size) to zero to
track regions that should not be freed in efi_free_boot_services()
meant that we never mapped those regions in efi_map_regions(). Instead
we were relying solely on the existing kernel mappings.

Now that we have separate page tables we need to make sure the EFI
boot services regions are mapped correctly, even if someone else has
already called memblock_reserve(). Instead of stashing a tag in
->numpages, set the EFI_MEMORY_RUNTIME bit of ->attribute. Since it
generally makes no sense to mark a boot services region as required at
runtime, it's pretty much guaranteed the firmware will not have
already set this bit.

For the record, the specific circumstances under which Alexis
triggered this bug was that an EFI runtime driver on his machine was
responding to the EVT_SIGNAL_VIRTUAL_ADDRESS_CHANGE event during
SetVirtualAddressMap().

The event handler for this driver looks like this,

  sub rsp,0x28
  lea rdx,[rip+0x2445] # 0xaa948720
  mov ecx,0x4
  call func_aa9447c0  ; call to ConvertPointer(4, & 0xaa948720)
  mov r11,QWORD PTR [rip+0x2434] # 0xaa948720
  xor eax,eax
  mov BYTE PTR [r11+0x1],0x1
  add rsp,0x28
  ret

Which is pretty typical code for an EVT_SIGNAL_VIRTUAL_ADDRESS_CHANGE
handler. The "mov r11, QWORD PTR [rip+0x2424]" was the faulting
instruction because ConvertPointer() was being called to convert the
address 0x0000000000000000, which when converted is left unchanged and
remains 0x0000000000000000.

The output of the oops trace gave the impression of a standard NULL
pointer dereference bug, but because we're accessing physical
addresses during ConvertPointer(), it wasn't. EFI boot services code
is stored at that address on Alexis' machine.

Reported-by: Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=815125
Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 79 +++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 17 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 2326bf51978f..da35f957d4ed 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -164,6 +164,27 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
 
 /*
+ * Helper function for efi_reserve_boot_services() to figure out if we
+ * can free regions in efi_free_boot_services().
+ *
+ * Use this function to ensure we do not free regions owned by somebody
+ * else. We must only reserve (and then free) regions:
+ *
+ * - Not within any part of the kernel
+ * - Not the bios reserved area (E820_RESERVED, E820_NVS, etc)
+ */
+static bool can_free_region(u64 start, u64 size)
+{
+	if (start + size > __pa_symbol(_text) && start <= __pa_symbol(_end))
+		return false;
+
+	if (!e820_all_mapped(start, start+size, E820_RAM))
+		return false;
+
+	return true;
+}
+
+/*
  * The UEFI specification makes it clear that the operating system is free to do
  * whatever it wants with boot services code after ExitBootServices() has been
  * called. Ignoring this recommendation a significant bunch of EFI implementations 
@@ -180,26 +201,50 @@ void __init efi_reserve_boot_services(void)
 		efi_memory_desc_t *md = p;
 		u64 start = md->phys_addr;
 		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		bool already_reserved;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
-		/* Only reserve where possible:
-		 * - Not within any already allocated areas
-		 * - Not over any memory area (really needed, if above?)
-		 * - Not within any part of the kernel
-		 * - Not the bios reserved area
-		*/
-		if ((start + size > __pa_symbol(_text)
-				&& start <= __pa_symbol(_end)) ||
-			!e820_all_mapped(start, start+size, E820_RAM) ||
-			memblock_is_region_reserved(start, size)) {
-			/* Could not reserve, skip it */
-			md->num_pages = 0;
-			memblock_dbg("Could not reserve boot range [0x%010llx-0x%010llx]\n",
-				     start, start+size-1);
-		} else
+
+		already_reserved = memblock_is_region_reserved(start, size);
+
+		/*
+		 * Because the following memblock_reserve() is paired
+		 * with free_bootmem_late() for this region in
+		 * efi_free_boot_services(), we must be extremely
+		 * careful not to reserve, and subsequently free,
+		 * critical regions of memory (like the kernel image) or
+		 * those regions that somebody else has already
+		 * reserved.
+		 *
+		 * A good example of a critical region that must not be
+		 * freed is page zero (first 4Kb of memory), which may
+		 * contain boot services code/data but is marked
+		 * E820_RESERVED by trim_bios_range().
+		 */
+		if (!already_reserved) {
 			memblock_reserve(start, size);
+
+			/*
+			 * If we are the first to reserve the region, no
+			 * one else cares about it. We own it and can
+			 * free it later.
+			 */
+			if (can_free_region(start, size))
+				continue;
+		}
+
+		/*
+		 * We don't own the region. We must not free it.
+		 *
+		 * Setting this bit for a boot services region really
+		 * doesn't make sense as far as the firmware is
+		 * concerned, but it does provide us with a way to tag
+		 * those regions that must not be paired with
+		 * free_bootmem_late().
+		 */
+		md->attribute |= EFI_MEMORY_RUNTIME;
 	}
 }
 
@@ -216,8 +261,8 @@ void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		/* Could not reserve boot area */
-		if (!size)
+		/* Do not free, someone else owns it */
+		if (md->attribute & EFI_MEMORY_RUNTIME)
 			continue;
 
 		free_bootmem_late(start, size);
-- 
2.6.2
