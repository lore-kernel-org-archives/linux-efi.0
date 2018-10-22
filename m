From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Mon, 22 Oct 2018 11:42:05 -0400
Message-ID: <20181022154204.kagmdb55jtoez4ca@gabell>
References: <20181011055154.GB6667@localhost.localdomain>
 <20181013201958.zfzv5ahhe3xz7bwi@gabell>
 <20181013203429.GE31650@zn.tnic>
 <20181013214550.ag5qzokhkrkwnzsy@gabell>
 <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
 <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
 <20181016195429.tovdgqq77gz3eek2@gabell>
 <20181016195902.GK5212@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181016195902.GK5212@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Boris,

On Tue, Oct 16, 2018 at 09:59:02PM +0200, Borislav Petkov wrote:
> On Tue, Oct 16, 2018 at 03:54:30PM -0400, Masayoshi Mizuma wrote:
> > Ah, sorry, I misunderstood your suggetion...
> > In parse_setup_data(), the data is picked up from boot_params,
> 
> Yes, this is the pointer to the setup_data linked list head. See
> 
> Documentation/ABI/testing/sysfs-kernel-boot_params
> Documentation/x86/boot.txt
> 
> for more information and basically grep the tree for examples.

I'm trying to store the SRAT info and pass it to kernel_randomize_memory(),
looks like add_e820ext()/parse_setup_data().

Is the approach useful only EFI environment? I'm not sure how I
allocate memory to store the data in legacy bios environment...
On EFI, I can use efi_call_early(allocate_pool, EFI_LOADER_DATA, ...).

Am I missing something? I would appreciate if you could help my
understanding.

Following patch is a prototype for EFI enviromnent.
---
 arch/x86/boot/compressed/acpitb.c     | 23 ++++++++++-
 arch/x86/boot/compressed/eboot.c      | 36 +++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 arch/x86/mm/kaslr.c                   | 58 ++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
index d119663..b79560c 100644
--- a/arch/x86/boot/compressed/acpitb.c
+++ b/arch/x86/boot/compressed/acpitb.c
@@ -309,6 +309,20 @@ static struct acpi_table_header *get_acpi_srat_table(void)
 	return NULL;
 }

+static void store_possible_addr(unsigned long long possible)
+{
+	struct setup_data *data;
+
+	data = (struct setup_data *)(unsigned long)boot_params->hdr.setup_data;
+	while (data) {
+		if (data->type == SETUP_KASLR) {
+			*(unsigned long long *)data->data = possible;
+			return;
+		}
+		data = (struct setup_data *)(unsigned long)data->next;
+	}
+}
+
 /*
  * According to ACPI table, filter the immvoable memory regions
  * and store them in immovable_mem[].
@@ -319,6 +333,7 @@ void get_immovable_mem(void)
 	struct acpi_subtable_header *table;
 	struct acpi_srat_mem_affinity *ma;
 	unsigned long table_end;
+	unsigned long long possible_addr, max_possible_addr = 0;
 	int i = 0;

 	if (!cmdline_find_option_bool("movable_node") ||
@@ -338,7 +353,12 @@ void get_immovable_mem(void)
 		       sizeof(struct acpi_subtable_header) < table_end) {
 		if (table->type == ACPI_SRAT_TYPE_MEMORY_AFFINITY) {
 			ma = (struct acpi_srat_mem_affinity *)table;
-			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
+
+			if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+				possible_addr = ma->base_address + ma->length;
+				if (possible_addr > max_possible_addr)
+					max_possible_addr = possible_addr;
+			} else {
 				immovable_mem[i].start = ma->base_address;
 				immovable_mem[i].size = ma->length;
 				i++;
@@ -351,4 +371,5 @@ void get_immovable_mem(void)
 			((unsigned long)table + table->length);
 	}
 	num_immovable_mem = i;
+	store_possible_addr(max_possible_addr);
 }
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 1458b17..9b95fba 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -192,6 +192,40 @@ static void setup_efi_pci(struct boot_params *params)
 	efi_call_early(free_pool, pci_handle);
 }

+#ifdef CONFIG_RANDOMIZE_MEMORY
+static void setup_kaslr(struct boot_params *params)
+{
+	struct setup_data *kaslr_data = NULL;
+	struct setup_data *data;
+	unsigned long size;
+	efi_status_t status;
+
+	size = sizeof(struct setup_data) + sizeof(unsigned long long);
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+			size, (void **)&kaslr_data);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to allocate memory for 'kaslr_data'\n");
+		return;
+	}
+
+	kaslr_data->type = SETUP_KASLR;
+	kaslr_data->next = 0;
+	kaslr_data->len = size;
+
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
+	if (data)
+		data->next = (unsigned long)kaslr_data;
+	else {
+		while (data->next)
+			data = (struct setup_data *)(unsigned long)data->next;
+		data->next = (unsigned long)kaslr_data;
+	}
+}
+#else
+static void setup_kaslr(struct boot_params *params) {}
+#endif
+
 static void retrieve_apple_device_properties(struct boot_params *boot_params)
 {
 	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
@@ -770,6 +804,8 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)

 	setup_efi_pci(boot_params);

+	setup_kaslr(boot_params);
+
 	setup_quirks(boot_params);

 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index a06cbf0..0a44d83 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -10,6 +10,7 @@
 #define SETUP_EFI			4
 #define SETUP_APPLE_PROPERTIES		5
 #define SETUP_JAILHOUSE			6
+#define SETUP_KASLR			7

 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 61db77b..6f91cf4 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -28,6 +28,7 @@
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/kaslr.h>
+#include <linux/io.h>

 #include "mm_internal.h"

@@ -69,6 +70,61 @@ static inline bool kaslr_memory_enabled(void)
 	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
 }

+#ifdef CONFIG_MEMORY_HOTPLUG
+static unsigned long long __init get_max_possible_addr(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+	unsigned long long max = 0;
+
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_memremap(pa_data, sizeof(*data));
+		if (!data)
+			return 0;
+
+		if (data->type == SETUP_KASLR) {
+			max = *(unsigned long long *)data->data;
+			early_memunmap(data, sizeof(*data));
+			return max;
+		}
+		pa_data = data->next;
+		early_memunmap(data, sizeof(*data));
+	}
+
+	return max;
+}
+
+static unsigned int __init kaslr_padding(void)
+{
+	unsigned long long max_possible_addr;
+	unsigned long long max_possible_phys, max_actual_phys, threshold;
+	unsigned int rand_mem_physical_padding =
+				CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
+
+	max_possible_addr = get_max_possible_addr();
+	if (!max_possible_addr)
+		goto out;
+
+	max_actual_phys = roundup(PFN_PHYS(max_pfn), 1ULL << TB_SHIFT);
+	max_possible_phys = roundup(max_possible_addr,
+					1ULL << TB_SHIFT);
+	threshold = max_actual_phys +
+		((unsigned long long)rand_mem_physical_padding << TB_SHIFT);
+
+	if (max_possible_phys > threshold)
+		rand_mem_physical_padding =
+			(max_possible_phys - max_actual_phys) >> TB_SHIFT;
+out:
+	return rand_mem_physical_padding;
+}
+#else
+static unsigned int __init kaslr_padding(void)
+{
+	return CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
+}
+#endif
+
 /* Initialize base and padding for each memory region randomized with KASLR */
 void __init kernel_randomize_memory(void)
 {
@@ -102,7 +158,7 @@ void __init kernel_randomize_memory(void)
 	 */
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
 	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
-		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
+		kaslr_padding();

 	/* Adapt phyiscal memory region size based on available memory */
 	if (memory_tb < kaslr_regions[0].size_tb)
--

Thanks!
Masa
