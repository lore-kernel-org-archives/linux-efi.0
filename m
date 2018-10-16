From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Tue, 16 Oct 2018 11:13:54 -0400
Message-ID: <20181016151353.punyk7exekut2543@gabell>
References: <20181010091923.GC5533@zn.tnic>
 <20181010093057.GA22088@MiWiFi-R3L-srv>
 <20181010194443.sgdvplwdnltshwwi@gabell>
 <20181011002955.GJ25297@MiWiFi-R3L-srv>
 <20181011055154.GB6667@localhost.localdomain>
 <20181013201958.zfzv5ahhe3xz7bwi@gabell>
 <20181013203429.GE31650@zn.tnic>
 <20181013214550.ag5qzokhkrkwnzsy@gabell>
 <20181013220541.GI31650@zn.tnic>
 <20181015005035.z3xym6nx43hogdge@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181015005035.z3xym6nx43hogdge@gabell>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Boris, Baoquan and all,

I have created a RFC patch for adjust KASLR padding size.
This patch is based on Can's v8 patch [1/3], and the Can's patch
will be changed in the future, so this patch is just RFC.

Welcome to any comments and suggestions. Thanks!

---
 arch/x86/boot/compressed/acpitb.c     |  8 ++++++-
 arch/x86/include/uapi/asm/bootparam.h |  3 ++-
 arch/x86/mm/kaslr.c                   | 31 ++++++++++++++++++++++++++-
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
index 6b869e3f9780..1504b46f2a04 100644
--- a/arch/x86/boot/compressed/acpitb.c
+++ b/arch/x86/boot/compressed/acpitb.c
@@ -367,6 +367,7 @@ void get_immovable_mem(void)
 	struct acpi_subtable_header *table;
 	struct acpi_srat_mem_affinity *ma;
 	unsigned long table_end;
+	unsigned long long possible_addr, max_possible_addr = 0;
 	int i = 0;
 
 	if (!strstr(args, "movable_node") || strstr(args, "acpi=off"))
@@ -384,7 +385,11 @@ void get_immovable_mem(void)
 	while (((unsigned long)table) + table->length < table_end) {
 		if (table->type == 1) {
 			ma = (struct acpi_srat_mem_affinity *)table;
-			if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
+			if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+				possible_addr = ma->base_address + ma->length;
+				if (possible_addr > max_possible_addr)
+					max_possible_addr = possible_addr;
+			} else {
 				immovable_mem[i].start = ma->base_address;
 				immovable_mem[i].size = ma->length;
 				i++;
@@ -397,6 +402,7 @@ void get_immovable_mem(void)
 			((unsigned long)table + table->length);
 	}
 	num_immovable_mem = i;
+	boot_params->possible_mem_addr = max_possible_addr;
 }
 #else
 void get_immovable_mem(void)
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index a06cbf019744..c987c725e93a 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -191,7 +191,8 @@ struct boot_params {
 	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
 	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
 	struct boot_e820_entry e820_table[E820_MAX_ENTRIES_ZEROPAGE]; /* 0x2d0 */
-	__u8  _pad8[48];				/* 0xcd0 */
+	__u8  _pad8[40];				/* 0xcd0 */
+	__u64 possible_mem_addr;			/* 0xcf8 */
 	struct edd_info eddbuf[EDDMAXNR];		/* 0xd00 */
 	__u8  _pad9[276];				/* 0xeec */
 } __attribute__((packed));
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 61db77b0eda9..8c5aca792b51 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -69,6 +69,35 @@ static inline bool kaslr_memory_enabled(void)
 	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static unsigned int __init kaslr_padding(void)
+{
+	unsigned long long max_possible_phys, max_actual_phys, threshold;
+	unsigned int rand_mem_physical_padding =
+				CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
+
+	if (!boot_params.possible_mem_addr)
+		goto out;
+
+	max_actual_phys = roundup(PFN_PHYS(max_pfn), 1ULL << TB_SHIFT);
+	max_possible_phys = roundup(boot_params.possible_mem_addr,
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
@@ -102,7 +131,7 @@ void __init kernel_randomize_memory(void)
 	 */
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
 	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
-		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
+		kaslr_padding();
 
 	/* Adapt phyiscal memory region size based on available memory */
 	if (memory_tb < kaslr_regions[0].size_tb)
-- 
2.18.0

- Masa
