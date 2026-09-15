Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7863BCD2E;
	Tue, 15 Sep 2026 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476867; cv=none; b=uNrMiJRDZ/YAuYfdMPtbOagl2QkenhKT7Fq8bOY6m5XkytHqs/jFRx8GH9J9PjIucwyjowJhbbXWxTY7VWeG6BeTxFCGciXKjbxrqOM54O9j0M1+I4RbcOXiDlz4LpqFDe7OlU4evrpBxwkYXHrHhRI13NLm7Lpkr7HCHOhDvdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476867; c=relaxed/simple;
	bh=sLHT+4xqfDFZam/oooAorDETruuddEAL1m7pml8eFaM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HAw+1YtY1TqvapqEuRLZ1O5VfcSk1y24jqYW9BitS4NA/p/2pEZ08LWf/7HyPXxqO/CZcoqT+bs63xgIzFMU4kTl0rqQhvCWbkI+Z2PjrKDgkoFwoWXIYdYM5cfhWZEbLSnonxe/V9PezSON38Hbed4WJckmXLHhmUfsJ+GqLJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=fzls2op0; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="fzls2op0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=6sbKIdMXcwwn7L1BaySMDKOdtYe9fziacJ6jCoPK7kY=; b=fzls2op0NmrUJGvLS3Apt9OLKB
	QhDOGb7fV/aVpQjgfJJiu6YLatzow2J1R5kpV7NrljaEmKOdbaTc5KxiAeYVbdm95QDSXcyOMpRdK
	LqTRhT+I1tgmyv54A5EV7z1XpmwImfT6/sSEWCjwoOmHs9cH+l/JaCqV2ezWwnBSKH6ZxPMEsVsX7
	4yIjBHN5/ZPFGBfxSpTCZrDPn8PriJRzma71RDcQ6diQqx0dbGTFs32pGcgDZN2BHKhRAYqkWvbQ1
	WTwnsWO83STeYn7LG4c2+V74a/G7q0dqF4cVTpTDdVcc4gPatL/gDeFbnh3tpNZ6x3KZaikfHun/i
	cWEoQpgg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sg0-004P6i-2R;
	Tue, 15 Sep 2026 12:54:21 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:37 -0700
Subject: [PATCH v5 3/9] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6897; i=leitao@debian.org;
 h=from:subject:message-id; bh=sLHT+4xqfDFZam/oooAorDETruuddEAL1m7pml8eFaM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e1zXAaiv2HwVTbVYoxnE6rSOAIQJI/r/qd
 3gK45gDUdqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bd+uD/9UJeIaTyr/JhRDZz04VltzrfTU4SQt7/Y+5CC6OgL8wR0o3SYAmos2ZOqxmHYzrF0Suq/
 y17CAuPnRUHzKCbsRshDiePc99PAw0lVxe7umBwfqiBWxDwT8omkVaBqCb6FYibVVXttDicgYxK
 wFu5ORfC2P2FTvy+SvWmI8wbNHlViMeLqu2bWUDAVZhqxIEbkoZVr8XMnWWiBpi4ndgg6L/UC2f
 Cu/9WMAhhxqTLGE0f+NarOz0XjU1Qew0YwQ92OP9rNcZ6Pz2R2Wtuw0/7Q/e3C8Fpb1CcachTLL
 Y0qFq7BHoT5MOmrf7+obAFw3sAYJBB9vt9PUjFy979RtrF28uBXthaqO394dIW2jmvPcmeZzfwZ
 SEO4NpjYF133SAif3uTZIRB2ilq4CCDILemOgbOm8pfIXyS0quSuKdeyOoeOQI5thTGWhr0TMM+
 HHfuKNDstaMOBE9wEMbiYptbfckDqxHL00oRWSRQOJKieLj1GvUxQX7QLytbhWx5m5PTj3KOht5
 HtxnQQgBdI+Gj2tZ9TqyB4mQiEn+mk0ZUcCfwbKrCHybaXmji0maIs9Xs1BMulLklwAJTAfOpS1
 MIoqO7LWGUnWV+eULPcnxNsUwY2h4aeK0728LaSA74SwBNxGC6dC3WHIjN98sQUqBnbLXy/QbVP
 PyWsMZmQQ6rtWbQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A EFI config table can only be installed while boot services are still
up, so the stub has to create it; the running kernel can only flip bits
in a table that already exists.

Size the bitmap from the span the UEFI memory map describes, which
efi_get_ram_range() walks since the stub has no max_pfn. Bit 0 covers
the bottom of that span, recorded in phys_base, so a machine whose RAM
starts high does not pay for the hole below it. Memory the firmware
hot-adds later sits outside the span and is not carried across a kexec.

One table has to serve every architecture, and what they agree on is the
attribute: setup_e820() takes a descriptor as RAM only if it is writeback
cacheable, and so does is_usable_memory() on arm64.

The bitmap spans from the lowest to the highest descriptor that is
write-back cacheable or unaccepted memory, as discussed with Kiryl. That
leaves out the MMIO apertures, which sit high enough to stretch it far
past the RAM it needs to describe.

At one bit per 2M that is 64K per TiB, and 256M at the 4PB x86
architectural maximum. The 2M granule is called "unit" here, and the
table carries it so the granule can change later without breaking the
kernels already reading it.

Allocate it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take
it for free RAM, and install it empty.

A table installed by an earlier boot rides the system table across kexec
and is reused as-is.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 103 +++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 ++
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 4 files changed, 112 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 48f93f7758e9e9..9c66e06c972c5a 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -774,3 +774,106 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 			efi_warn("Failed to remap data region non-executable\n");
 	}
 }
+
+#ifdef CONFIG_EFI_POISONED_MEMORY
+/*
+ * Find the base and top of the memory, so, we can create the bitmap for
+ * the full range.
+ */
+static efi_status_t efi_get_ram_range(u64 *base, u64 *top)
+{
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
+	u64 ram_base = ULLONG_MAX, ram_top = 0;
+	efi_status_t status;
+	int i, nr_desc;
+
+	status = efi_get_memory_map(&map, false);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	nr_desc = map->map_size / map->desc_size;
+	for (i = 0; i < nr_desc; i++) {
+		efi_memory_desc_t *d;
+
+		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
+		if (!(d->attribute & EFI_MEMORY_WB) &&
+		    d->type != EFI_UNACCEPTED_MEMORY)
+			continue;
+		ram_base = min(ram_base, d->phys_addr);
+		ram_top = max(ram_top,
+			      d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
+	}
+	if (!ram_top || ram_base == ULLONG_MAX)
+		return EFI_NOT_FOUND;
+
+	*base = round_down(ram_base, EFI_POISON_UNIT_SIZE);
+	*top = round_up(ram_top, EFI_POISON_UNIT_SIZE);
+
+	return EFI_SUCCESS;
+}
+
+/* The size of the bitmap */
+static u64 efi_poison_bitmap_size(u64 span)
+{
+	u64 bytes = DIV_ROUND_UP(DIV_ROUND_UP(span, EFI_POISON_UNIT_SIZE),
+				 BITS_PER_BYTE);
+
+	return round_up(bytes, sizeof(unsigned long));
+}
+
+static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
+							  u64 bitmap_size)
+{
+	struct linux_efi_poisoned_memory *pm;
+	efi_status_t status;
+
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     sizeof(*pm) + bitmap_size, (void **)&pm);
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	pm->version = 1;
+	pm->unit_size = EFI_POISON_UNIT_SIZE;
+	pm->phys_base = phys_base;
+	pm->size = bitmap_size;
+	memset(pm->bitmap, 0, bitmap_size);
+
+	return pm;
+}
+
+/* This needs to be done while boot service is still active */
+void install_poisoned_memory_table(void)
+{
+	efi_guid_t poisoned_memory_table_guid = LINUX_EFI_POISONED_MEMORY_TABLE_GUID;
+	struct linux_efi_poisoned_memory *pm;
+	u64 ram_base, ram_top, bitmap_size;
+	efi_status_t status;
+
+	/* A table installed by an earlier boot rides the system table across kexec. */
+	pm = get_efi_config_table(poisoned_memory_table_guid);
+	if (pm) {
+		if (pm->version != 1)
+			efi_err("Unknown version of poisoned-memory table\n");
+		return;
+	}
+
+	if (efi_get_ram_range(&ram_base, &ram_top) != EFI_SUCCESS) {
+		efi_err("Failed to size the poisoned-memory table!\n");
+		return;
+	}
+
+	bitmap_size = efi_poison_bitmap_size(ram_top - ram_base);
+	pm = efi_poison_alloc(ram_base, bitmap_size);
+	if (!pm) {
+		efi_err("Failed to allocate poisoned-memory table!\n");
+		return;
+	}
+
+	status = efi_bs_call(install_configuration_table,
+			     &poisoned_memory_table_guid, pm);
+	if (status != EFI_SUCCESS) {
+		efi_bs_call(free_pool, pm);
+		efi_err("Failed to install poisoned-memory config table!\n");
+	}
+}
+#endif
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 235c9738da2d63..22a315e2814a1a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -179,6 +179,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
 
 	install_memreserve_table();
+	install_poisoned_memory_table();
 
 	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810b..44436869c4efe1 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1169,6 +1169,12 @@ efi_enable_reset_attack_mitigation(void) { }
 
 void efi_retrieve_eventlog(void);
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void install_poisoned_memory_table(void);
+#else
+static inline void install_poisoned_memory_table(void) { }
+#endif
+
 struct sysfb_display_info *alloc_primary_display(void);
 struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 0bae0f06b6763a..3136132b9628ab 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1024,6 +1024,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 
 	setup_unaccepted_memory();
 
+	install_poisoned_memory_table();
+
 	status = exit_boot(boot_params, handle);
 	if (status != EFI_SUCCESS) {
 		efi_err("exit_boot() failed!\n");

-- 
2.53.0-Meta

