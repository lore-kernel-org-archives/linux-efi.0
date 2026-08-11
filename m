Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115983FCB32;
	Tue, 11 Aug 2026 16:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465626; cv=none; b=lIxovFcv/+F810b6wtbSe/URKVJ//sL/NxqYnqi81rwnm3HroQGjsgZ6fN7+/tYF3aBLAEpQF1hZ7gC83Rck1UHKFXqbfa+njT89HTJQJ9bdTMloYJjFMqlG8Jm4hdVaxN4IRZo8uNeHWI4qY9gutz1pqB/s+4nWOJQu6WKw6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465626; c=relaxed/simple;
	bh=A/Q1igBL85VsYHeA3f+iHKzogdE6M3Zo3VQDz4KkgMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8+aCUZFVYr1rhp2YmeYfTQrkFXcMdOzsR/2dFmvX/KcxSlPswoS5jnsNoT3OwK/MD5x7wEvDTyeekBGFUtjIRFtJh/RORypHA75mWKCpWREKfWOF1rV52cChX77gMDeyTrKQ599nqCteuzseaMt2zkZcUcC/FDv6fV6XRWTVMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WB6oAKSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WB6oAKSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306711F00A3F;
	Tue, 11 Aug 2026 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465621;
	bh=cCTSbjH+AbQqxolqBee1+aQwt0omi5VUnJSkZiGnZF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WB6oAKSjESjeGTBWIaFg2Vz80ThcWdcNc2PPEL6VBsod2UdMjfrko6q/E0sjykUte
	 6mD7MLWnhAzolIHI2EbfKgajXhMSmsgDGKMmBRj88tvW+HM+cdnIOs62Pn7/DR2TOe
	 Nb0ECAbcH6l9mJhl3ShiWdATBjF2TyWlC7CWORVjG7Ha4BNLkjmPTwUea0YDbx1vHG
	 useowan7Pb0zS0OkHo1eI+YGo9ig9bp1J2XQYhBM1D3OQTiMjCG94Y9tzAMZdtwH1B
	 FOxdzs6svGvf7QDDWxH10dF9KyiZ/qcp2LdSdfbCPX4RKhk4wcGc6be/CyndAfnZXO
	 JD4H3Pot+cLjA==
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
Subject: [PATCH 1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
Date: Tue, 11 Aug 2026 18:26:37 +0200
Message-ID: <20260811162642.3504565-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
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
index 9e0ca4824905..5415e0b38b5d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -485,10 +485,6 @@ config HAVE_GUP_FAST
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
index 37e06e70c1d0..8e425791ad66 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -112,7 +112,7 @@ unsigned long min_low_pfn;
 unsigned long max_pfn;
 unsigned long long max_possible_pfn;
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 /* When set to true, only allocate from MEMBLOCK_KHO_SCRATCH ranges */
 static bool kho_scratch_only;
 #else
@@ -2597,7 +2597,7 @@ int reserve_mem_release_by_name(const char *name)
 	return 1;
 }
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+#ifdef CONFIG_KEXEC_HANDOVER
 __init void memblock_set_kho_scratch_only(void)
 {
 	kho_scratch_only = true;
-- 
2.55.0.679.g6767b8d81c-goog

