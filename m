Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795426961;
	b=woK9tIFqcsAUI2RbF4iJ1ealGO5DkgbfBgVMJX07I1+w9h4uUUL2/J9D2ZJYxicvhMpA
	 dPQ3lsB75xWLi+WC4CCJkHLkgxi49NZ4UEJs0pV5WfvAJ22gErxcF5+J6tjfxOOIU7OtI
	 u5W7NZuZFVtuscLMqI09AP6hffyfoRfmNCdG3sU4VlNvfmhuMDfiFhvvXNcYy5ytmZmLI
	 H4bTrYqm9kqSTcNLfpX/ydDMu3HBJ+Pkeghopi8mHZd7ZEqK+o4HncFy2cs+8F8XwKSJm
	 rEPxNlkRsi/eMHJjmNUjymyAJv0bXAS1Iy0NAkrrce/e6dPM8FKlF8Pvlmcz5nbFlbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795426961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=YT2Upu+y3WXJ7gG+mJi7voHOi2XmZ7UXv9rZxPK3v+o=;
	b=H3PRCyBb56v6eYXrV3S0vm658I/x5R4JsdI8f2O3RKCY1mykk87afgNgyUas9hOTnVMy
	 Sy12CYO3EOe3vk8F+ctcUARBiZO2Bn25fNIARpXj9JrRCDeAGWelEELSSdB1tr0LCORzV
	 BnThGk6D1EmLBBrpTFXP/3fGa0HtknIRCtq/SBWHaiQmime9OnGTrRQq4SFR1KijQ7v1Y
	 x392rFOwpAL5T7jm21+7HE8q3gXFSLk0uDDB5Ixg3Ta1IK1VYXMn3NYhPiDfZ5hqc+EKO
	 PT4vPdrM+QqY0IKJkDHx/GPr7STSC97LjSt4OdLejfESDIx5MwPsMXbBOZYK38WKN4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MKrkETQx;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB25606A31E
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 09:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDB25606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MKrkETQx
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e0389d6f9so1800341f8f.1
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 01:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795426959; x=1796031759; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YT2Upu+y3WXJ7gG+mJi7voHOi2XmZ7UXv9rZxPK3v+o=;
        b=MKrkETQxAkTRKuAQDLIc1u1TBKp2XsG7x8Tc+Q2sYYSy+CBVLDHN9skq9WNKFHYn7s
         u8o4EHZLF2IB0I38vX5qh83mQAVatVr9j//vtSHTxvAKQlpA+A3GxLPEPinax1xOPkNO
         M2FKjQiGtHPO+Zvg+f5q4uvOlFjmBpgiFgFBxkTE0C8lQ1ltJwkIRzm/DcnBvC7+otVD
         /lOeYKWJ5LA5Cf7G6OkopgmmsOaUPhaViW+BGZ0DwVohxs9N+zLmcIi7yiTY4gMXyPpm
         /ZdVYvUq4sQWxptOHDijUxbZYTAXWt2BvJ1ZvSgCdI/fXRq7ogzoZEq32Uf+GfxnGuSQ
         Gt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795426959; x=1796031759;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YT2Upu+y3WXJ7gG+mJi7voHOi2XmZ7UXv9rZxPK3v+o=;
        b=LK3ZnRbMkms2s2eysYvHV4Pu/iZ93kt/jzSU7tUacOhKcTqmcLuCP0tnNSdh4cvNQ5
         JgV5Lhry9gDy7/Rq1UrK5hQ84yUBy/e8Ji4gCfJNHn6OcKuxiwvvHdczDblKtVMUG7F2
         VMD6Qwsn4/8ofwM3KEFkDLSWZ9C8K5E0SWslJR1K/psoyeEUhGLBYjjJtiDhbM0g9+rf
         EE706UFE6HNb57gcCJS3RZ8LEiYWRe33mXP3AWxQDCudIhD+Oh8gUE3epzeReJzsa6kk
         4QmvqSgF7F3Sov6XIyHyJbHBfQPBUNz0UHaPd0n1s4Xb8jfOFTphF9BXw9+Fj4HqciFb
         Y6fw==
X-Gm-Message-State: APuU4Z+oqMEjWcOD2dQm/jM1ZAPY6m9CvzypWXeRqHMbBllGckPpkcXH
	+zR03j18DE0ETo7W9Vh6ezVTxHuzkqxg0BEp0XDwZVD0Sv4toLWwWP3hEI/z71OdKYpa6QTztMF
	nyRWyGkfSiKjjrnJCo2JTQs/ghaixK3psTJ0T5Dc9hPFEZ5ANWIehitSSHFfthgWaQhT33L0Hqw
	GDl62UL1UhtNA0pNA6QsFNWtn6p0mH3A==
X-Received: from wrxc11.prod.google.com ([2002:a05:6000:104b:b0:4a7:85c3:7bf9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4812:b0:491:a219:8506
 with SMTP id ffacd0b85a97d-4abb55183dbmr21022935f8f.48.1795426959038; Mon, 23
 Nov 2026 01:42:39 -0800 (PST)
Date: Mon, 23 Nov 2026 10:42:31 +0100
In-Reply-To: <20261123094228.466164-4-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261123094228.466164-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3914; i=ardb@kernel.org;
 h=from:subject; bh=oselDBCI6TvXzU0e6mg4IV26t5y2uI06DwAwp+7rg30=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZuFqyOAtzX8558rszl2mC/mdT6duMlh8sqiitM7G1pns
 uy752vVUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyUpGRYdLUR0Uefns52URl
 D9zex1dkHs6qeV9JyD+R0TpQUf3kIob/1bHdfA0d9utZa9z79+/5EFPw6yJ/r+MH/S39stfzZtn wAQA=
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123094228.466164-6-ardb+git@google.com>
Subject: [PATCH 2/2] efi/tpm: Allocate the event log from EFI loader data again
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The EFI stub currently allocates the TPM event log as
EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
in the E820 map.

On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
can place this allocation at different physical addresses across boots.
Since x86 hibernation validates architecture-specific data from
the firmware E820 map, this causes an otherwise valid hibernation image
to be rejected on resume with the following error:

  Hibernate inconsistent memory map detected!
  PM: hibernation: Image mismatch: architecture specific data

Allocating the event log as EFI_LOADER_DATA avoids changing the E820
map, but doing that alone would regress the kexec corruption issue fixed
by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
log to avoid corruption"): the E820 map that kexec passes on to the next
kernel describes EFI loader data as ordinary RAM, and so the event log
may get clobbered before the next kernel gets around to reserving it.

So use the x86 implementation of efi_config_table_is_usable() to
disregard the TPM event log table after kexec, just like the INITRD
table, and go back to allocating it as EFI_LOADER_DATA. This is simpler
than preserving the event log across kexec, e.g., by installing the
memreserve table on x86 and using efi_mem_reserve_persistent(), and the
utility of the event log after kexec is questionable to begin with.

This also protects kexec'd kernels from a clobbered event log if the
previous kernel predates the change above, and allocated the table from
EFI loader data as well. The kexec issue was specific to x86, so other
architectures can use EFI loader data as before.

Fixes: 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c        | 6 ++++++
 drivers/firmware/efi/libstub/tpm.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c2817c7415ce..db1b179db0a5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -442,6 +442,11 @@ static int __init efi_systab_init(unsigned long phys)
  *   data, which is released to the page allocator once the kernel is up and
  *   running, and so the table is stale by the time kexec boots the next kernel.
  *
+ * - The TPM event log table is installed by the EFI stub too, and allocated
+ *   from EFI loader data as well. It is reserved by the kernel, but the E820
+ *   memory map that kexec passes on describes it as ordinary RAM, and so it
+ *   may get clobbered before the next kernel gets around to reserving it.
+ *
  * - The Memory Attributes table may reside in EFI boot services data, which is
  *   released to the page allocator as well. Even if it is still intact, the
  *   sanity check in efi_memattr_init() may fail spuriously, given that only
@@ -455,6 +460,7 @@ bool __init x86_efi_config_table_is_usable(const efi_guid_t *guid,
 		return true;
 
 	return efi_guidcmp(*guid, LINUX_EFI_INITRD_MEDIA_GUID) &&
+	       efi_guidcmp(*guid, LINUX_EFI_TPM_EVENT_LOG_GUID) &&
 	       efi_guidcmp(*guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID);
 }
 
diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index 73f001114732..b8183bfdbaa3 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -96,7 +96,7 @@ static void efi_retrieve_tcg2_eventlog(int version, efi_physical_addr_t log_loca
 	}
 
 	/* Allocate space for the logs and copy them. */
-	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
 			     sizeof(*log_tbl) + log_size, (void **)&log_tbl);
 
 	if (status != EFI_SUCCESS) {
-- 
2.56.1.750.gf70dc682cf-goog

