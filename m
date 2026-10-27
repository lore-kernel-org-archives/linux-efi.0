Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069811;
	b=4Fh/Hd5ZkpVsD4PYqps/LQ46ui0/VEpN6T6Ob8B6z4M9igMhbO3xm2AGB3v/KVqhicRo
	 6iOSMl0GDrC4ODRRHYxy7XtTd7/T4dWu1eRIILWxz4eberLEsX+QDjzvtBCZz67bcmCuO
	 +54qzPUZKi4/F3rRkvcsd3bQeznzEJugnS158MXsKkhHv/5Zjybhl81xcf2Q2wW6NSbP9
	 Mu3vaeYFB0x8disjZqE32HSnlHfGQJVECYTlUt0byZ0Tflqsqy7oA+pguz4DOJ/buCBcB
	 yj+WppTsChYInvFIETI5UBbFK2NwtzwbM/0+xyvjgVCbhYElt5yTv9icKGdSJUob1EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069811;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=n7o+pR7kIh2/FhhUqUS8VpzKzJ7DErIKQHWtYktZq/o=;
	b=Vw8XQDE9WCSZkJtnqtwNwfLq8FE2gbUBs4J9yCFGsXG2PhwLvifBRh1ymXNgJALk3wtn
	 FCDkBToCF3j7EGYvogY58XQDPoD/andnh6YjkunCoZhETL53jl8RmODVfqS8v+UXUPCQ8
	 KGjaPp+FnZ7ubzBBVP6PGZ7u7Bgp0AY2x+SNysBH3Dq1O+KuBmuhztC5Ewmu3zhgsSHC/
	 CysUTXNXvpcMNkwPhEpn5MeUBj2Rf4Up9CTUcG2SYZLBKqAnRn1TNMk6tY1GSnZh7g0HM
	 pTerhwqPloD4kYMoPN8RrWD+9E9FcCX3nQajt8Ix0R7aaUFufPgfYysWUKwpcjhnWug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mZ4ysE6s;
	arc=none smtp.remote-ip=209.85.161.72
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B6606A31E
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 02:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C1B6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mZ4ysE6s
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6e0063e7a02so4449900eaf.2
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 19:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069810; x=1793674610; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n7o+pR7kIh2/FhhUqUS8VpzKzJ7DErIKQHWtYktZq/o=;
        b=mZ4ysE6s4wxtSc1ga3u9zzuERTm2H5lzvQWDIJcrWbilJxSmSrhha7KCElvpN+8jjd
         r+fy18NOFFv42sJ4CwHGbvSn8B+nuwMigZI39ccMRLA9vTT3OLuzxPyi6Rpl1Mz9Wx54
         sD5QxRemzzqDFuqtCSXYnzXKjWT5pWLmdjip+dzTbiGW4erLC5+egyxB/M/pdaXas5p9
         sIgP6eGVWi4kV2ygVfblCp9xiMGj5rlEmreDQimDsgyNx3TUIUi9ywD5xSUns6SQNuKz
         ++vGrJ87LVp6z5g14PnQVntWnvCRSTvP0ei5UvvIQ6XgdGZufqX9fjh1zDTPt/mCDPz6
         JeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069810; x=1793674610;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n7o+pR7kIh2/FhhUqUS8VpzKzJ7DErIKQHWtYktZq/o=;
        b=byjsCEWyoJMD9QflKaD00oo4gpt3RcZwrKM1q+FJ1w/cau70tA7kUAgMtI81eQ/K+r
         unE1Fx/tHkNzfAj+wCVlL7IsJ/bTj7q7M4zXWwiQui7M/+ObyCr2tOyZglw3FkegqgAm
         ZHlCw/VgVebJoRF47Ypub+HQ6ezT4WhPUCZ6iiw0Kl8Bv/S37DHL39mGEn29St9QBfOm
         LyD3/S7l7RkrGDjlP2GrxEU68jmaU8s1jkyGAW3Js4GmCIxYiQlrPis36846PsvfT88G
         rIJtMVmYQh7lkL6njoqR1SoTxEuKi4kOeMXfeEMI7CKuqo++TG2JC0Xj0+mxJKEqDpAV
         mcxA==
X-Forwarded-Encrypted: i=1; AKwUvBz6o5TcuGiv0bAd/QuBZ84+ptWv4x0nHKWRZQ+Vmka2BIbLBs+1YHT8Hq4einhLA9AYKJMMRl5B42U=@vger.kernel.org
X-Gm-Message-State: AFq9FYImIghfCQwZVUzXBiQZm70FLWsrFRN6UHUeRW1GJIvSza54xLHB
	x54GwQLVhrT5fN+9XOSDRXCcZaY/OHb/6XwWwDqP5JpEoOnjmroI5vVtny7IzIfaqM8Cqbn9tlx
	+IQ+t+wFXgFeRugKbagXPq+vGVycJmUCdgA==
X-Received: from ilbdx1-n2.prod.google.com ([2002:a05:6e02:4201:20b0:51a:af50:87cd])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:5601:b0:6c3:19de:d1ef with SMTP id 006d021491bc7-70ba0da3184mr2895148eaf.20.1793069810059;
 Mon, 26 Oct 2026 19:56:50 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:09 +0000
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
Message-ID: <20261027025616.1632690-7-kevinloughlin@google.com>
Subject: [PATCH 06/13] efi/unaccepted: add mark_memory_unaccepted()
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

Introduce mark_memory_unaccepted() to mark a physical memory range as
unaccepted in the EFI unaccepted memory bitmap. Use
unaccepted_memory_order() to query the page order matching the EFI
unaccepted memory unit_size granularity.

Synchronize mark_memory_unaccepted() with concurrent accept_memory()
callers via accepting_list and only invoke arch_unaccept_memory() on
sub-ranges that are currently marked accepted in the bitmap.

On platforms with dynamic unacceptance (arch_has_unaccept_memory()),
load_unaligned_zeropad() across page boundaries is recovered via
EX_TYPE_ZEROPAD exception fixup. Thus, skip extending accept_memory()
and range_contains_unaccepted_memory() by an extra unit_size guard
block to avoid corrupting the acceptance state of adjacent 2MB blocks.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/firmware/efi/unaccepted_memory.c | 107 ++++++++++++++++++++++-
 include/linux/mm.h                       |  12 +++
 2 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 4a8ec8d6a571..128bc1b113cd 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -5,6 +5,8 @@
 #include <linux/spinlock.h>
 #include <linux/crash_dump.h>
 #include <linux/nmi.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
 #include <asm/unaccepted_memory.h>
 
 /* Protects unaccepted memory bitmap and accepting_list */
@@ -86,7 +88,16 @@ void accept_memory(phys_addr_t start, unsigned long size)
 	 *    if 'size+end' is aligned on a unit_size boundary. (immediately
 	 *    following this comment)
 	 */
-	if (!(end % unit_size))
+	/*
+	 * On platforms without implemented dynamic unacceptance support,
+	 * load_unaligned_zeropad() across a page boundary into unaccepted
+	 * memory causes a fatal VMM exit rather than a recoverable exception.
+	 * When dynamic unacceptance is supported (arch_has_unaccept_memory()),
+	 * load_unaligned_zeropad() is recovered via EX_TYPE_ZEROPAD exception
+	 * fixup, whereas extending the range by unit_size would accept
+	 * adjacent dynamically-unaccepted blocks.
+	 */
+	if (!arch_has_unaccept_memory() && !(end % unit_size))
 		end += unit_size;
 
 	/* Make sure not to overrun the bitmap */
@@ -191,10 +202,11 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	end -= unaccepted->phys_base;
 
 	/*
-	 * Also consider the unaccepted state of the *next* page. See fix #1 in
-	 * the comment on load_unaligned_zeropad() in accept_memory().
+	 * Also consider the unaccepted state of the *next* page on platforms
+	 * without implemented dynamic unacceptance support. See fix #1 in the
+	 * comment on load_unaligned_zeropad() in accept_memory().
 	 */
-	if (!(end % unit_size))
+	if (!arch_has_unaccept_memory() && !(end % unit_size))
 		end += unit_size;
 
 	/* Make sure not to overrun the bitmap */
@@ -215,6 +227,93 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	return ret;
 }
 
+unsigned int unaccepted_memory_order(void)
+{
+	struct efi_unaccepted_memory *unaccepted = efi_get_unaccepted_table();
+
+	if (unaccepted && unaccepted->unit_size >= PAGE_SIZE)
+		return ilog2(unaccepted->unit_size >> PAGE_SHIFT);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(unaccepted_memory_order);
+
+int mark_memory_unaccepted(phys_addr_t start, unsigned long size)
+{
+	struct efi_unaccepted_memory *unaccepted;
+	unsigned long range_start, range_end;
+	struct accept_range range, *entry;
+	phys_addr_t end = start + size;
+	unsigned long flags;
+	u64 unit_size;
+
+	if (!arch_has_unaccept_memory())
+		return -EOPNOTSUPP;
+
+	unaccepted = efi_get_unaccepted_table();
+	if (!unaccepted)
+		return -EOPNOTSUPP;
+
+	unit_size = unaccepted->unit_size;
+	if (WARN_ON_ONCE(!IS_ALIGNED(start, unit_size) ||
+			 !IS_ALIGNED(size, unit_size)))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(start < unaccepted->phys_base || end <= start))
+		return -ERANGE;
+
+	start -= unaccepted->phys_base;
+	end -= unaccepted->phys_base;
+
+	/* Make sure not to overrun the bitmap */
+	if (WARN_ON_ONCE(end > unaccepted->size * unit_size * BITS_PER_BYTE))
+		return -ERANGE;
+
+	range.start = start / unit_size;
+	range.end = end / unit_size;
+retry:
+	spin_lock_irqsave(&unaccepted_memory_lock, flags);
+
+	list_for_each_entry(entry, &accepting_list, list) {
+		if (entry->end <= range.start)
+			continue;
+		if (entry->start >= range.end)
+			continue;
+
+		spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+		goto retry;
+	}
+
+	list_add(&range.list, &accepting_list);
+
+	range_start = range.start;
+	for_each_clear_bitrange_from(range_start, range_end,
+				     unaccepted->bitmap, range.end) {
+		unsigned long phys_start, phys_end;
+		unsigned long len = range_end - range_start;
+
+		phys_start = range_start * unit_size + unaccepted->phys_base;
+		phys_end = range_end * unit_size + unaccepted->phys_base;
+
+		bitmap_set(unaccepted->bitmap, range_start, len);
+		spin_unlock(&unaccepted_memory_lock);
+
+		debug_pagealloc_map_pages(pfn_to_page(PHYS_PFN(phys_start)),
+					  (phys_end - phys_start) >> PAGE_SHIFT);
+		arch_unaccept_memory(phys_start, phys_end);
+
+		spin_lock(&unaccepted_memory_lock);
+	}
+
+	list_del(&range.list);
+
+	touch_softlockup_watchdog();
+
+	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mark_memory_unaccepted);
+
 #ifdef CONFIG_PROC_VMCORE
 static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 						unsigned long pfn)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6882ad400935..27bb40651c85 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5362,6 +5362,8 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+unsigned int unaccepted_memory_order(void);
+int mark_memory_unaccepted(phys_addr_t start, unsigned long size);
 
 #else
 
@@ -5375,6 +5377,16 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline unsigned int unaccepted_memory_order(void)
+{
+	return 0;
+}
+
+static inline int mark_memory_unaccepted(phys_addr_t start, unsigned long size)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
-- 
2.56.0.307.g5fe7bd680c-goog

