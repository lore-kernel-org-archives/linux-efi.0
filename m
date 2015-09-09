From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 9 Sep 2015 12:21:23 +0100
Message-ID: <20150909112123.GB4973@codeblueprint.co.uk>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <20150907040752.GW13182@linux-rxt1.site>
 <20150908204147.GC2854@codeblueprint.co.uk>
 <20150909003307.GJ2266@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150909003307.GJ2266@linux-rxt1.site>
Sender: stable-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, LeifLindholm@linux-rxt1.site, leif.lindholm@linaro.org, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@Odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Sep, at 08:33:07AM, joeyli wrote:
> 
> Yes, the machine on my hand has EFI_PROPERTIES_TABLE enabled, and it doesn't
> boot without your patch.

Awesome. Could you test the following patch instead?

---

>From 24d324b781a3b688dcc265995949a9cf4e8af687 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Thu, 3 Sep 2015 15:56:25 +0100
Subject: [PATCH v2] x86/efi: Map EFI memmap entries in-order at runtime

Beginning with UEFI v2.5 EFI_PROPERTIES_TABLE was introduced that
signals that the firmware PE/COFF loader supports splitting code and
data sections of PE/COFF images into separate EFI memory map entries.
This allows the kernel to map those regions with strict memory
protections, e.g. EFI_MEMORY_RO for code, EFI_MEMORY_XP for data, etc.

Unfortunately, an unwritten requirement of this new feature is that
the regions need to be mapped with the same offsets relative to each
other as observed in the EFI memory map. If this is not done crashes
like this may occur,

 [    0.006391] BUG: unable to handle kernel paging request at fffffffefe6086dd
 [    0.006923] IP: [<fffffffefe6086dd>] 0xfffffffefe6086dd
 [    0.007000] Call Trace:
 [    0.007000]  [<ffffffff8104c90e>] efi_call+0x7e/0x100
 [    0.007000]  [<ffffffff81602091>] ? virt_efi_set_variable+0x61/0x90
 [    0.007000]  [<ffffffff8104c583>] efi_delete_dummy_variable+0x63/0x70
 [    0.007000]  [<ffffffff81f4e4aa>] efi_enter_virtual_mode+0x383/0x392
 [    0.007000]  [<ffffffff81f37e1b>] start_kernel+0x38a/0x417
 [    0.007000]  [<ffffffff81f37495>] x86_64_start_reservations+0x2a/0x2c
 [    0.007000]  [<ffffffff81f37582>] x86_64_start_kernel+0xeb/0xef

Here 0xfffffffefe6086dd refers to an address the firmware expects to
be mapped but which the OS never claimed was mapped. The issue is that
included in these regions are relative addresses to other regions
which were emitted by the firmware toolchain before the "splitting" of
sections occurred at runtime.

Needless to say, we don't satisfy this unwritten requirement on x86_64
and instead map the EFI memory map entries in reverse order. The above
crash is almost certainly triggerable with any kernel newer than v3.13
because that's when we rewrote the EFI runtime region mapping code, in
commit d2f7cbe7b26a ("x86/efi: Runtime services virtual mapping"). For
kernel versions before v3.13 things may work by pure luck depending on
the fragmentation of the kernel virtual address space at the time we
map the EFI regions.

Instead of mapping the EFI memory map entries in reverse order, where
entry N has a higher virtual address than entry N+1, map them in the
same order as they appear in the EFI memory map to preserve this
relative offset between regions.

This patch has been kept as small as possible with the intention that
it should be applied aggressively to stable and distribution kernels.
It is very much a bugfix rather than support for a new feature, since
when EFI_PROPERTIES_TABLE is enabled we must map things as outlined
above to even boot - we have no way of asking the firmware not to
split the code/data regions.

In fact, this patch doesn't even make use of the more strict memory
protections available in UEFI v2.5. That will come later.

Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2: Use Ard's reverse iteration scheme so that we can reuse the
existing efi_map_region() implementation that maps things top-down.

 arch/x86/platform/efi/efi.c | 67 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4308fe6afe8..c6835bfad3a1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -705,6 +705,70 @@ out:
 }
 
 /*
+ * Iterate the EFI memory map in reverse order because the regions
+ * will be mapped top-down. The end result is the same as if we had
+ * mapped things forward, but doesn't require us to change the
+ * existing implementation of efi_map_region().
+ */
+static inline void *efi_map_next_entry_reverse(void *entry)
+{
+	/* Initial call */
+	if (!entry)
+		return memmap.map_end - memmap.desc_size;
+
+	entry -= memmap.desc_size;
+	if (entry < memmap.map)
+		return NULL;
+
+	return entry;
+}
+
+/*
+ * efi_map_next_entry - Return the next EFI memory map descriptor
+ * @entry: Previous EFI memory map descriptor
+ *
+ * This is a helper function to iterate over the EFI memory map, which
+ * we do in different orders depending on the current configuration.
+ *
+ * To begin traversing the memory map @entry must be %NULL.
+ *
+ * Returns %NULL when we reach the end of the memory map.
+ */
+static void *efi_map_next_entry(void *entry)
+{
+	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
+		/*
+		 * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
+		 * config table feature requires us to map all entries
+		 * in the same order as they appear in the EFI memory
+		 * map. That is to say, entry N must have a lower
+		 * virtual address than entry N+1. This is because the
+		 * firmware toolchain leaves relative references in
+		 * the code/data sections, which are split and become
+		 * separate EFI memory regions. Mapping things
+		 * out-of-order leads to the firmware accessing
+		 * unmapped addresses.
+		 *
+		 * Since we need to map things this way whether or not
+		 * the kernel actually makes use of
+		 * EFI_PROPERTIES_TABLE, let's just switch to this
+		 * scheme by default for 64-bit.
+		 */
+		return efi_map_next_entry_reverse(entry);
+	}
+
+	/* Initial call */
+	if (!entry)
+		return memmap.map;
+
+	entry += memmap.desc_size;
+	if (entry >= memmap.map_end)
+		return NULL;
+
+	return entry;
+}
+
+/*
  * Map the efi memory ranges of the runtime services and update new_mmap with
  * virtual addresses.
  */
@@ -714,7 +778,8 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
 	unsigned long left = 0;
 	efi_memory_desc_t *md;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+	p = NULL;
+	while ((p = efi_map_next_entry(p))) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
 #ifdef CONFIG_X86_64
-- 
2.1.0

-- 
Matt Fleming, Intel Open Source Technology Center
