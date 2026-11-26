Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795733071;
	b=z8Rqxty0mYg6phOlalHm5Uian2kWSwLzhRqFRBsdpicHFIVN8w6frH0eixwgGrSrVMaR
	 gsaajZ/9NaUGg3+/yOWN/dzCi6tetFDR4PV7VWZJJf9/mdzfmg/XM6OUitLLdHN3Ho9aR
	 stw8Q3K7+64N2aI8aIOwHAnD/hpCqfshKtyekCtOXeFkrhG49lS9w8Edo2P31t2oZYpTl
	 2Qib9UpDKQYDJ4RlR7v5Q3V9RvzfAgs3af83JsOSZn9xpk278n5I3tJab/r8DImlgLKjl
	 oKcUzO7Vu5HqEW0+J/Yj9UuivSVJM+zKKf8vfhqmN3F7QL769klsEpDTzQQMdylWUsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795733071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=e+arfCJUIntNa3qi3vQWPhIy/1Siw1ogZ1oQJGBLREM=;
	b=VTxH0e7v3JoGY/ZaMhvNXHIy+1cs1hCJg5wtWfqZ+A7e3PGoBShLthVXLngMmfZWdG8a
	 wQPNfNwh4qUSAL5Vo5Pz4cTLsLvmeFqklu+iaU50q+m/vxzwu1VcwPxTx7nv9dkpzepTM
	 Qhn31oGRyS4a2od4hm3Jsq8rcSY3gUT9Xx7n3XHc15jtMfjhjCKgXwAW9UZY2jA9VhtTs
	 m72CnY2eFYEPYJn6tzoYAU9qLbkAowVSHl2Ul3hemtjSeWmVuUqBz1HX8fePLj7QFmf0R
	 3S4m57WyEaHy7h2nPZg/2EIwRqMbBunZ40H7Z3tuBlmw23FWVBawEpNwuyNG48bepDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZjuqd3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FB3606A31C;
	Thu, 26 Nov 2026 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZjuqd3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5271F000C1;
	Thu, 26 Nov 2026 22:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795733070;
	bh=e+arfCJUIntNa3qi3vQWPhIy/1Siw1ogZ1oQJGBLREM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZjuqd3oDrfS1lYVGby1Orwejd7JEY7urv89OHNukKQ890WmhOlG6K/LxBIbIGBIL
	 gGY1jV7s7m7iBV6W5TMOO9PnbogZ9kSoX1h+R/e7/V7QDq4YWshQHHkbag6b6GR3Om
	 OX6peJBwVoEVGJWtMJDvX5ilBgRmzKlsobKnv0QuPr3llcMj3JmrmwQTzhEYNBC1Pg
	 0MSuyunrWX3hQGqVFvcwlUuBgCLWnm6stSRqoagiBtpZ3++n2n+XLVZ7UTrFzlUZdB
	 8jh63/a/VP8PEisO23PIWJ7b1/VaAjS342QTp1oZn1/hs2ERLzNVWClSC5Jbye6GMG
	 Y2FaCRmBA7Kig==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	linux-kbuild@vger.kernel.org
Subject: [PATCH 1/2] scripts/Makefile.lib: Capture decompressed size in ZSTD22 metadata
Date: Thu, 26 Nov 2026 23:44:02 +0100
Message-ID: <20261126224400.10147-5-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126224400.10147-4-ardb@kernel.org>
References: <20261126224400.10147-4-ardb@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=ardb@kernel.org; h=from:subject; bh=6NpCgYjpW+H8yYa1jLnrekB9/FZ9LHjPTRhcbnfDRyw=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZtjm5nihigDSY9nE3z1tD7NvPqj5vjzuYf3Mm/xSP85p 4N1OYdxRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIzwWMDO92n4qxOccXsG9C JF/Kp3ffKneKK4lrcZzpTLi51bl0qjbD/4gH3J+lQx+25FRGhDxNdtCfE+0cEh60bbHT6w0d5YG HWQE=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Tweak the [unused] ZSTD22 compression rule so that the combined size of
the uncompressed input is recorded in the ZSTD metadata. This allows
ZSTD standard tooling to query it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 scripts/Makefile.lib | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 19e96b30a122f..5b58577b158af 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -344,13 +344,17 @@ quiet_cmd_gzip = GZIP    $@
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = printf $(shell						\
+total_file_size = $(shell						\
 dec_size=0;								\
 for F in $(real-prereqs); do					\
 	fsize=$$($(CONFIG_SHELL) $(srctree)/scripts/file-size.sh $$F);	\
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x\n" $$dec_size |						\
+printf "%d\n" $$dec_size						\
+)
+
+size_append = printf $(shell						\
+printf "%08x\n" $(total_file_size) |					\
 	sed 's/\(..\)/\1 /g' | {					\
 		read ch0 ch1 ch2 ch3;					\
 		for ch in $$ch3 $$ch2 $$ch1 $$ch0; do			\
@@ -479,7 +483,7 @@ quiet_cmd_zstd = ZSTD    $@
       cmd_zstd = cat $(real-prereqs) | $(ZSTD) -19 > $@
 
 quiet_cmd_zstd22 = ZSTD22  $@
-      cmd_zstd22 = cat $(real-prereqs) | $(ZSTD) -22 --ultra > $@
+      cmd_zstd22 = cat $(real-prereqs) | $(ZSTD) -22 --ultra --stream-size=$(total_file_size) > $@
 
 quiet_cmd_zstd22_with_size = ZSTD22  $@
       cmd_zstd22_with_size = { cat $(real-prereqs) | $(ZSTD) -22 --ultra; $(size_append); } > $@
-- 
2.47.3

