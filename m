Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7994372B3C;
	Fri, 16 Oct 2026 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152980; cv=none; b=BKUWtwQ8C/JNvzJ5R8/6HbjwtqKmtEXnL9Dxs4d4u9mu+OkpFp1HbcRbmu9B8EjdTI+91hYTIGDuZ/ZnZrfB8RWGNqF+ji5EyCdL0c9yHKhVo5LXLjB3Z5Q+qCq0LF3M5dnsNGDM6Iy+lBkADc5CfxosTE04lBMCf99zmERLAd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152980; c=relaxed/simple;
	bh=TZAZEdFgh6ZrIGE/ZagpHGTrCcQOqwFNn+LakPr479E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S5Y6tBTNCOj6BnDdLtbm6gW18Vr8Sywg2t+ZHgXtnoYsWGZTLzbwQhLR62d3RlRG9f/56WNSTQ/Q85UrilDebHf4lfYdSna2llFNIVoEXX6s+fIC98dk9Q+m2tCQCU/rws/f4SlYH4V757iSifWPd9RivRjMXj3NWzMdeGHfbO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=TqLQ666W; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="TqLQ666W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ojjYtQh43bC+vi04ki8U6V/KKjiHj8BalpRCWljStRA=; b=TqLQ666WDqV6RUZk6NR3JQVIMB
	UdPqLqaQASkk+l9mOiFruRm1XgkrHgdxqKrLAJYNh8BfzfsWlEThrehslrsoupb3EXFUGwWFrWAd5
	2J9KSzBpiZs1o+WxwPv2CHf/b9FFskwTGiuWR0P+4PSDLwdZi+bxukuG3EYekD6bhMwQeNtfp8iGz
	2o+IIOIAQOM2LZolMMjzEQ661AW4yf/jPtmKAqddXaLIRIh02Xst4Du7pTrNyLfYvWb9M8mPY2RY9
	02o9+f+bEfG1LYwKIeHcd9nkqKoCIcdGFXgFiaPqkAYJtM+MPUjxhfqqmmAuXrfn8JQcCukHrCg+F
	HZK98GSA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgqy-005xSg-2j;
	Fri, 16 Oct 2026 12:16:05 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:41 -0700
Subject: [PATCH v6 1/7] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-1-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6024; i=leitao@debian.org;
 h=from:subject:message-id; bh=TZAZEdFgh6ZrIGE/ZagpHGTrCcQOqwFNn+LakPr479E=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0jUKXc63ziNZ+4w5tiGa2kxptbOf6tsMC/
 PqxCb4wd5uJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bUk8D/sE89175sxKV2NWtklw5VOucGRb/VKl+hHa52CSou+cw8zYPs7yE8HYkKD5mjHiBPV+LO7
 QVfyTJNPpUW56oD6cPPOY6uzXsnERX+Jm+sF1S7JnCqPgrwQPTh1pEUFAn0vXwZ7FuN5UmVQSvE
 oUpa9QPFwcFgTktFfvcj+Pz0UaAiTynKIaemLFCkcebZcv+EM5+7Q6I2/iV/mTnpaK1WWFUR2GR
 +e+HRlwsSuWlIAp+ysmgRIZSYtH64a2pxEioBfaW0+ESjsc55WC/vb944OFJGVmODP3LJh10u4C
 R5YqREIO4SYuB02HBmxINO3edi9gTCeXinhmAzEHwrTaMilkn9+lUTZVOWr4rlQBJY9X2ehGzyr
 Cd+jM2ZYkfYT9ThXRK/g0C/iZhaUJ8y7NI6W0Wg3JfVn1vll1xly9e7MUwB+UiOMNjT9y6ScCBN
 UrdYQQ5ORXV07MfLx9l7rIehodFWrTB1gE28SKL82+WrbjsrLwLAmglTKj6lnmbdHRd/lktnCxc
 YeZ8YdPCRnU0nGipcoC2VlbW8LiXnCir8IOjCHb3ETponoqXu+teQA7fkgYhUz+BCEfTdK5gT63
 8DK58p+CIWKIR1qIX8fTfpFsZzaRGhj02OKUkMBz2JR9SlzS9nV97vl1wxcI/AoiLk3KBgEIli9
 TWAANAHmG6N2F7Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Hardware-poisoned page frames are tracked only in the running kernel's
data structures, so a kexec loses them and the next kernel doesn't have
this information, thus, tripping into them again.

Add an EFI configuration table to carry that information across kexec.

It is a bitmap with one bit per EFI_POISON_UNIT_SIZE (2MiB) of physical
memory starting at phys_base, modeled on the LINUX_EFI_UNACCEPTED_MEMORY
table, and it rides the EFI system table to every kernel in the chain.
Basing the bitmap keeps a machine whose RAM starts high from paying for
the hole below it.

List the table in the x86 efi_tables[] too, so an SME host maps it
unencrypted like every other EFI table.

The Kconfig symbol has no prompt. There is nothing for a user to decide,
so it is on wherever it can be, and it only costs 64K per TiB of RAM on
a kernel that already has the EFI stub and MEMORY_FAILURE. It is
restricted to 64BIT because the unit arithmetic divides by a runtime
unit_size, which needs div_u64() on 32-bit. That combination is
reachable, X86_32 with FLATMEM selects ARCH_SUPPORTS_MEMORY_FAILURE and
has an EFI stub, so the dependency is what keeps the division out rather
than a config nobody can build.

The bitmap is an unsigned long array reached with the native bitops, like
the unaccepted memory table it copies. That is endian dependent, but
EFI_STUB && 64BIT is little-endian everywhere: arm64 turns EFI off under
CPU_BIG_ENDIAN, and no other architecture with the stub is big-endian.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 arch/x86/platform/efi/efi.c  |  3 +++
 drivers/firmware/efi/Kconfig |  8 ++++++++
 drivers/firmware/efi/efi.c   |  6 ++++++
 include/linux/efi.h          | 14 ++++++++++++++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c39adb96b912b..2b37b96a36e099 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -93,6 +93,9 @@ static const unsigned long * const efi_tables[] = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	&efi.unaccepted,
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	&efi.poisoned_memory,
+#endif
 };
 
 u64 efi_setup;		/* efi setup_data physical address */
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5bd..aafcd41bc00630 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -263,6 +263,14 @@ config EFI_COCO_SECRET
 	  virt/coco/efi_secret module to access the secrets, which in turn
 	  allows userspace programs to access the injected secrets.
 
+config EFI_POISONED_MEMORY
+	def_bool y
+	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
+	help
+	  Record page frames that are hardware-poisoned while this kernel runs
+	  into an EFI configuration table, and honor that table early on the
+	  next kernel so a kexec does not hand known-bad RAM back out.
+
 config OVMF_DEBUG_LOG
 	bool "Expose OVMF firmware debug log via sysfs"
 	depends on EFI
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 6d987d7f97781f..af1fa443839c4d 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -55,6 +55,9 @@ struct efi __read_mostly efi = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	.poisoned_memory	= EFI_INVALID_TABLE_ADDR,
+#endif
 };
 EXPORT_SYMBOL(efi);
 
@@ -677,6 +680,9 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	{LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID,	&efi.unaccepted,	"Unaccepted"	},
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	{LINUX_EFI_POISONED_MEMORY_TABLE_GUID,	&efi.poisoned_memory,	"POISON"	},
+#endif
 #ifdef CONFIG_EFI_GENERIC_STUB
 	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
 #endif
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c35446a0b66fac..efaf63f9a54edd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -23,6 +23,7 @@
 #include <linux/pstore.h>
 #include <linux/range.h>
 #include <linux/reboot.h>
+#include <linux/sizes.h>
 #include <linux/uuid.h>
 
 #include <asm/page.h>
@@ -422,6 +423,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_POISONED_MEMORY_TABLE_GUID	EFI_GUID(0xaf828a15, 0x0ef4, 0x439a,  0xb8, 0x6a, 0xd6, 0xd6, 0x9e, 0xaf, 0xba, 0xfa)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -650,6 +652,7 @@ extern struct efi {
 	unsigned long			mokvar_table;		/* MOK variable config table */
 	unsigned long			coco_secret;		/* Confidential computing secret table */
 	unsigned long			unaccepted;		/* Unaccepted memory table */
+	unsigned long			poisoned_memory;	/* Hardware-poisoned memory table */
 
 	efi_get_time_t			*get_time;
 	efi_set_time_t			*set_time;
@@ -1272,6 +1275,17 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
 	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
 
+/* Bit N covers the unit at @phys_base + N * @unit_size. */
+struct linux_efi_poisoned_memory {
+	u32		version;
+	u32		unit_size;	/* bytes of phys space per bitmap bit */
+	u64		phys_base;	/* address the first bit covers */
+	u64		size;		/* bitmap size in bytes */
+	unsigned long	bitmap[];
+};
+
+#define EFI_POISON_UNIT_SIZE	SZ_2M
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*

-- 
2.53.0-Meta

