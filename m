Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B697B57C73A;
	Tue,  8 Sep 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883017; cv=none; b=twMu6trgSmsR4V6QRJLIfQsvux+UEx06s0XXp8ANeCPw9HuiEh9FwQ9D8sy0R8vn0AXosf6qVh2UYSnhpr+Id0RPQsZZxfDWyJgHxcCuaYActRl3SAycvRaBel3sjJVu74d6r7N5X9QJ6BWo0goWwUst94bKMcmP05CjX7qGXLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883017; c=relaxed/simple;
	bh=eeWrYG/5EbxTNbC6g1mL6zpX9xLS3sBPAC/s8HdcDwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlfRkapc08u/sEZPpNGbnfnx5y2n5AnZPVu976rRMqQ1TU0F3nhAQEeqe05u29PfoPttdu7B0/XM8NgwnHZNC6AyFSBTN9dvC4m2W4Xogmkms52lc4Bkw65j8Kkv0GNE1oqJrYoAKzKYKZJsblRK7wzrqv9ZPyTv+11rgHOBtVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnNqH/UQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnNqH/UQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457E61F00A3E;
	Tue,  8 Sep 2026 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788883014;
	bh=Tcijen+XrkE1sKKJX8CkIKKooxVBnQd0uzlIx9kSVSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnNqH/UQFVYnXra3IOHQ/cSX+xcE9Gtflza4237iNzbU/emeQIcdFaFSEbmxT34Ah
	 7Mc7hfUaC0iEvJlhSwl7XOxg60TDmRvikCOiTgwVLAM5VImOq6qIMbukd03QYVSwPJ
	 PmgeFd9GIF66wvENo0/46QR8MbGs6TlXSePQaUiBaf5EWrtEPtoE0/zKps9Qb9G8J8
	 ex8McOjWWn7qQoI5U6se5codMlXNQ6NR7YEHTlNmH6C+qYSrLgXUwdbSFeZXIO8Hu2
	 0YL9+81ECY8oWT45na2qdN4jrVvWW+FObaNB764wG4B/ajp8jvv5E8PgAPd0efZBVB
	 xPDJ103/UfgbA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v2 1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
Date: Tue,  8 Sep 2026 17:56:35 +0200
Message-ID: <20260908155639.2496551-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
In-Reply-To: <20260908155639.2496551-1-pratyush@kernel.org>
References: <20260908155639.2496551-1-pratyush@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

This config is only a proxy for CONFIG_KEXEC_HANDOVER. It is only
enabled by KHO. No point in the indirection. Use CONFIG_KEXEC_HANDOVER
directly.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h  | 2 +-
 kernel/liveupdate/Kconfig | 1 -
 mm/Kconfig                | 4 ----
 mm/memblock.c             | 4 ++--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d62db9e776cf..db3b106c6335 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,7 +614,7 @@ static inline void early_memtest(phys_addr_t start, phys_addr_t end) { }
 static inline void memtest_report_meminfo(struct seq_file *m) { }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
 #else
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..f50daee8eff0 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -5,7 +5,6 @@ menu "Live Update and Kexec HandOver"
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select LIBFDT
 	select CMA
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..631a410eaee9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -483,10 +483,6 @@ config HAVE_GUP_FAST
 	depends on MMU
 	bool
 
-# Enable memblock support for scratch memory which is needed for kexec handover
-config MEMBLOCK_KHO_SCRATCH
-	bool
-
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..197d854c18d5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -113,7 +113,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 /* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
 static bool kho_scratch_only;
 #else
@@ -2596,7 +2596,7 @@ int reserve_mem_release_by_name(const char *name)
 	return 1;
 }
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 __init void memblock_set_kho_scratch_only(void)
 {
 	kho_scratch_only = true;
-- 
2.55.0.979.g7e5102b832-goog

