Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069810;
	b=4G2th2ukZExDevyYXUNMiwirLYSLESrPJNJY+Ux6ngilXB5YwfHDcvB0DCee6eaVZu4I
	 st5wc9QmLod2N9iYW5o79Eg0gq4PfPUJFWC7SZ+IQr3BsYlUZsKnIzYxV2SLCpS5w7AAW
	 zKwiyKg9hYE5f62FjiCgRAtWtBkIyAUCFBcs0QJaOMRVaK9k4vcrqX48erSD97OzFaB7v
	 8De7RnWN4dLQzK1nCEhPyz1xaJCrgj6GW77Fdcb3DeIHqqg1JPxcLIsSxjPqvrf0WhDJx
	 vHX+AS09FU+0ySMq+P9n3gLAI6m7FAnCLejY15IDtZKG5ioJJcYy9WEVShniAyh2RVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069810;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=i2TVROB2tkypKL2JwuC8PelARTqsfICvFAyjnT/ZhdE=;
	b=Y4UeJbfU+VAvkokfmwDxXsLPARoCy/4LNR4kV44gwa6DuCgXzNpDLkF8LlH+N/BkzzKh
	 f2IWJP2NImpMA3uCr2d6ixFVTmgOJDc4OAoGZDF2+es8EogivBFzczb3weF48PeCtWWWA
	 U9SrlX8adyZI8D/FK/GXne8bDen5NRQdnv2U1tCuQ/jLJYIQMDWBzS8jSCoSHgzyniPPN
	 8yihVc4YEmYpX5n7fs5qGgrvc6DU0X2GcErrMp6PYAejrNEcoVm+JYubZ8WtP6orRn5eI
	 57eD+3DfVujM0nGgjXPexo2A9WaVoVaXDV0sXszn8C0jKaSFhOy5yEFcxcNQ/eGSz+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MhItgJNJ;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B82606A336
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4B82606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MhItgJNJ
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-82322894f5aso855109a34.1
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069808; x=1793674608; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i2TVROB2tkypKL2JwuC8PelARTqsfICvFAyjnT/ZhdE=;
        b=MhItgJNJ0cdY3jdgIElKrexHG6T+yYFG111MXWaZtJYBVa7ALbqstqCNkrrgXN5rYQ
         P9nu5JED7oW7ldsm6ST2iNJXxfMrIB8LIPD0lJnFMw4dwO58NZ6qArlQyq31mfv8Qgod
         yEHRGxZWItprLBTssvgMg7s6J3pVVXQedoiMl3UaAjYJp9A3DdHL6xje93DV7P5TsIR1
         6w0z7fy9DgiMR6B5abvk1jRMClV28cKQIVO1L6XS0R4KH+3TK07V+Pw/lYgSFs9YEa4O
         a9phGSyeBfAIu3RdEDl3ZKQDuvsj7wqSOOR+mDOFkz6Okaktf5rzoyAJmRhYEBPOMTXH
         xkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069808; x=1793674608;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i2TVROB2tkypKL2JwuC8PelARTqsfICvFAyjnT/ZhdE=;
        b=clKEikuaf+nQAxKd1RQjnNNrd4HNLzEPiOFAro5V9aGJ3peoJBSbzEU4R/6yVXyr2S
         SF27N1Y/KV5NlqWI522kzoSiWU+YyB8OJhc36wKpPYPLDVyn1DAO0dLehbHppde+5Dm/
         8nq+AKd1LI36p2osRzb3kzhZgjFKbvjn2YUr74cnF1NoVWAubd4xqHbUnHzfBt1UCYY/
         +eOnFdvXczekx18hH6lafeQy5d5oUULih7NC2Inn5aI/+UUdehWKFgQUtVm8dT/l4J9+
         AXK1aC9x2F0p2PKXBSH/5MsA5TwoTsEonznCztsQzPzIefUc+xtcxYe+kCZYGxweWuAE
         1SrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZ9zKZtmeQFU2Di32dxMmZkOrr4RbUf/XLQSoOpKqeLu9i0nHMoWVao1Zf5DIEFhXiu0WEthZ1SMs=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8PCr3XU0xShBvop1bhLHs9dK4uWPruLaEVkg3v75p9SuTHrML
	7ugTBvVVk8EaMZpD4ZU/3KyNCJgNXbyKg2XiOhcykAvFz6Uc0/NTwDSdy3yDGEGKofWmt/3qcti
	WYAqEWKMjjNV19jbrP9hjKX7jeajdqz4bAg==
X-Received: from ioyd21.prod.google.com ([2002:a05:6602:2bf5:b0:9c4:de2b:c40f])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1ca4:b0:702:c1a4:7563 with SMTP id 006d021491bc7-7126910deb4mr1003099eaf.8.1793069808399;
 Mon, 26 Oct 2026 19:56:48 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:08 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-6-kevinloughlin@google.com>
Subject: [PATCH 05/13] efi/libstub: start unaccepted bitmap at address 0
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"

When EFI_UNACCEPTED_MEMORY is present in the EFI memory map or the
platform supports dynamic memory unacceptance (such as AMD SEV-SNP),
start the EFI unaccepted memory bitmap at physical address 0
(phys_base = 0) instead of the lowest initial unaccepted address.

This ensures that pre-accepted low memory below the initial unaccepted
region is addressable in the bitmap so it can be dynamically marked
unaccepted and re-accepted later via virtio-balloon or free page
reporting. Non-confidential guests without EFI_UNACCEPTED_MEMORY
continue to skip allocating the table.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 .../firmware/efi/libstub/unaccepted_memory.c  | 45 ++++++++++++++-----
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/unaccepted_memory.c b/drivers/firmware/efi/libstub/unaccepted_memory.c
index 757dbe734a47..fcb622ac0564 100644
--- a/drivers/firmware/efi/libstub/unaccepted_memory.c
+++ b/drivers/firmware/efi/libstub/unaccepted_memory.c
@@ -2,15 +2,28 @@
 
 #include <linux/efi.h>
 #include <asm/efi.h>
+#if defined(CONFIG_X86) && defined(CONFIG_AMD_MEM_ENCRYPT)
+#include <asm/sev.h>
+#endif
 #include "efistub.h"
 
 struct efi_unaccepted_memory *unaccepted_table;
 
+static bool efi_stub_has_dynamic_unaccepted_memory(void)
+{
+#if defined(CONFIG_X86) && defined(CONFIG_AMD_MEM_ENCRYPT)
+	return sev_get_status() & MSR_AMD64_SEV_SNP_ENABLED;
+#else
+	return false;
+#endif
+}
+
 efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 					struct efi_boot_memmap *map)
 {
 	efi_guid_t unaccepted_table_guid = LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID;
-	u64 unaccepted_start = ULLONG_MAX, unaccepted_end = 0, bitmap_size;
+	bool has_unaccepted = efi_stub_has_dynamic_unaccepted_memory();
+	u64 unaccepted_end = 0, bitmap_size;
 	efi_status_t status;
 	int i;
 
@@ -30,19 +43,27 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 		unsigned long m = (unsigned long)map->map;
 
 		d = efi_memdesc_ptr(m, map->desc_size, i);
-		if (d->type != EFI_UNACCEPTED_MEMORY)
-			continue;
-
-		unaccepted_start = min(unaccepted_start, d->phys_addr);
-		unaccepted_end = max(unaccepted_end,
-				     d->phys_addr + d->num_pages * PAGE_SIZE);
+		switch (d->type) {
+		case EFI_UNACCEPTED_MEMORY:
+			has_unaccepted = true;
+			fallthrough;
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			unaccepted_end = max(unaccepted_end,
+					     d->phys_addr +
+					     d->num_pages * EFI_PAGE_SIZE);
+			break;
+		default:
+			break;
+		}
 	}
 
-	if (unaccepted_start == ULLONG_MAX)
+	if (!has_unaccepted || unaccepted_end == 0)
 		return EFI_SUCCESS;
 
-	unaccepted_start = round_down(unaccepted_start,
-				      EFI_UNACCEPTED_UNIT_SIZE);
 	unaccepted_end = round_up(unaccepted_end, EFI_UNACCEPTED_UNIT_SIZE);
 
 	/*
@@ -59,7 +80,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 	 * The bitmap will be populated in setup_e820() according to the memory
 	 * map after efi_exit_boot_services().
 	 */
-	bitmap_size = DIV_ROUND_UP(unaccepted_end - unaccepted_start,
+	bitmap_size = DIV_ROUND_UP(unaccepted_end,
 				   EFI_UNACCEPTED_UNIT_SIZE * BITS_PER_BYTE);
 
 	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
@@ -72,7 +93,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 
 	unaccepted_table->version = 1;
 	unaccepted_table->unit_size = EFI_UNACCEPTED_UNIT_SIZE;
-	unaccepted_table->phys_base = unaccepted_start;
+	unaccepted_table->phys_base = 0;
 	unaccepted_table->size = bitmap_size;
 	memset(unaccepted_table->bitmap, 0, bitmap_size);
 
-- 
2.56.0.307.g5fe7bd680c-goog

