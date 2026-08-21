Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CA22C3257
	for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297048; cv=none; b=Lgcg7rFZVnhnXmq6byndye9ZRtEDubOPTIrzfFuUMv5ylUdvcSRva96RTNyZvu2hkHuVcN2RPTdFXMio6woOs3/dWV/qJXKIjJC3h89a8W/uEOMU5RltEK6EpKECefuMC/IS7m6g4n9wHcM3YzXSwUtwpd7RF0Vu1ysDNSB/KeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297048; c=relaxed/simple;
	bh=HJ+KOl/z62h9nc+ENRR4I1onjWaqSyUg5sCbCNs8DWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5gZsIlkPM1SicMXzRosvbyrQaIeHefih76YXoKeYjS9YxNz9uuSgTUN+1kQtdvjgX3ikkxUTFQXBz8CwRzYTkjU71WqcqyMFGNPts7RMonL2IcjkYXPyrt/jDNwWutWCbb3mrOTsDHIzqN9HivA5fqFl8MK0MpOElJsoZDrVrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fbxfOV3j; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbxfOV3j"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e041ea211so635108a91.0
        for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 00:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787297046; x=1787901846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eQFxRmlnw8HmCpfmtAekPjcWF4+b8s8z2XwbA4bbArA=;
        b=fbxfOV3jXXQa6rlejlwAMfr+hs027maIzLWaxJ37fLNUUKWtIoTjQF1GHo005UKQr7
         45wed3nWXJkv0BgO5c8FapmyY9zy+vf54a+7gv4KL/KCxJ1jSsJFfJVye+6yQC5eEqgs
         XJ574MrHgOH0/jtd67DKRB2zyzxEDfZ2jquqy6F31nrRZeaoq7sYNA/ZYR2+SYNiW9wK
         UhB/VkVWULWpz+NJnt3nRHTrt5YeqXSoCnD5eLdF3eYURUX81pBxSUHTyJZlqGN5xSoP
         tQ6UdLCpgH3Bxixufdm9+Ugw7DapyCccKCUseS4y8Q/rb4n8k88LsradJvM4VfXDJAlW
         8vBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787297046; x=1787901846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eQFxRmlnw8HmCpfmtAekPjcWF4+b8s8z2XwbA4bbArA=;
        b=tKvvJyIu452O8NOOQytGJ7c4ext7DXL04yitLsdYUWj+7mlEWJp6qzs+0AVcolpvzY
         Qr8bLG+TCtEZVVoJ8pdiINFfAuN4fHfDYk3tcIFfK8Ufs3cFwrK9YSyS4eDh+qpD6SEF
         H04fEnBc+f4f6ppQhkSgYbXt0ibdZGmHRqHbArQGxKvD4RmfkPi226MBmHx+08BrN0K+
         zE22EGuEtVOm9RcdhDHuJjpHLDhBFpGYH3gy0Xb2/HNiOMkntLEi5xnqaPCsJhwxYyjs
         m3NeyGnXPktssZNe8nndK64nAEZCX5CqzrFppqlkldm71+Kys59/jC3gY4IPOIaCXuPH
         dWWw==
X-Forwarded-Encrypted: i=1; AHgh+Rq8ctKEa+z+6wM9DgmHxMGa/TVcMpb8fw4XpYx2MVEvv2aq56i721/8ziOAL0kh7qX4CvYQ66jB4Ak=@vger.kernel.org
X-Gm-Message-State: AFuF++nhGtRulxw7cuoXHmWctXKAnihFk15jpsHMSW0i9LWe9QyDslRz
	7AVC9HRWfz25JYXsLcCLtENSfO6hlJWHl2RGsI9gA64iyFBatxFqHf3sVaKyC3p7
X-Gm-Gg: AR+sD125SVzXEB07DeQrXE7ZIfEuHwDo0ycD7wkqjynWCKy92BI5MIdkjn3fjHmnRmc
	agxov175FolAZUBZ83ODMk7lkxOf+8gM3rUph0RCWMM/BK8OrTmsKgqYignO/6k28I+/OtrKEuM
	7gGiD5/NlFPbk33GF3FAn3ttrIdHLwiRMK7alyPgi3iXV1wdCLhbweZJOO0lMHPvKuyi+EZejBq
	yywxhsSHegH+1XdcFD6YXihfW9nAIbf1Rb1DBFRXhuhQTP78XrLPyq+r3X0XfSsit8puRSbjhxH
	8bx6dMf7shBKepQcTubgH/mcuRvz50hsgz2lQYOCcle86G3wp/bty2JFiGkIEGJlWcgtIbVU0+z
	cNPoF1ORgBLFAh3+Sg0shIoYWAmbogRZhMYTgaGqs7dx5AcL0H/G9WV8Wk2Xux+6JWK3s86dvpn
	xdbzs3UME6ESVvNhUAcHWeQn+aA2LfMz4H2sCBQXeO6bWqv47cMaDtogps2G7g4eORzAaMxH1q
X-Received: by 2002:a17:90b:1e0d:b0:395:4e0d:bc60 with SMTP id 98e67ed59e1d1-395c354d7ebmr7329239a91.9.1787297046224;
        Fri, 21 Aug 2026 00:24:06 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c467d907sm2025485a91.7.2026.08.21.00.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 00:24:05 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jens Axboe <axboe@kernel.dk>,
	linux-efi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: [PATCH 2/2] block: partitions: efi: print GPT LBAs as unsigned
Date: Fri, 21 Aug 2026 15:23:55 +0800
Message-ID: <20260821072355.2006771-2-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260821072355.2006771-1-zhanxusheng@xiaomi.com>
References: <20260821072355.2006771-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

These values are read from the on-disk header, and the messages exist to
report the ones that are out of range, so a value with the top bit set is
exactly what they are asked to print.  %lld renders it as a negative
number: a my_lba of 0xffffffffffffffff is reported as -1.

The compiler does not catch it, since a signed/unsigned mismatch between
two types of the same width needs -Wformat-signedness, which the kernel
does not enable.

Drop the (unsigned long long) casts along with it.  alpha, mips and
powerpc select int-l64.h for userspace only, so in-kernel u64 is
unsigned long long everywhere and le64_to_cpu() already yields it.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 block/partitions/efi.c | 69 +++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 76994d3edd1a..54c595db12e8 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -344,10 +344,9 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 
 	/* Check the GUID Partition Table signature */
 	if (le64_to_cpu((*gpt)->signature) != GPT_HEADER_SIGNATURE) {
-		pr_debug("GUID Partition Table Header signature is wrong:"
-			 "%lld != %lld\n",
-			 (unsigned long long)le64_to_cpu((*gpt)->signature),
-			 (unsigned long long)GPT_HEADER_SIGNATURE);
+		pr_debug("GUID Partition Table Header signature is wrong: %llu != %llu\n",
+			 le64_to_cpu((*gpt)->signature),
+			 GPT_HEADER_SIGNATURE);
 		goto fail;
 	}
 
@@ -383,9 +382,9 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	/* Check that the my_lba entry points to the LBA that contains
 	 * the GUID Partition Table */
 	if (le64_to_cpu((*gpt)->my_lba) != lba) {
-		pr_debug("GPT my_lba incorrect: %lld != %lld\n",
-			 (unsigned long long)le64_to_cpu((*gpt)->my_lba),
-			 (unsigned long long)lba);
+		pr_debug("GPT my_lba incorrect: %llu != %llu\n",
+			 le64_to_cpu((*gpt)->my_lba),
+			 lba);
 		goto fail;
 	}
 
@@ -394,21 +393,21 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	 */
 	lastlba = last_lba(state->disk);
 	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
-		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
-			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
-			 (unsigned long long)lastlba);
+		pr_debug("GPT: first_usable_lba incorrect: %llu > %llu\n",
+			 le64_to_cpu((*gpt)->first_usable_lba),
+			 lastlba);
 		goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) > lastlba) {
-		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
-			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
-			 (unsigned long long)lastlba);
+		pr_debug("GPT: last_usable_lba incorrect: %llu > %llu\n",
+			 le64_to_cpu((*gpt)->last_usable_lba),
+			 lastlba);
 		goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
-		pr_debug("GPT: last_usable_lba incorrect: %lld < %lld\n",
-			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
-			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
+		pr_debug("GPT: last_usable_lba incorrect: %llu < %llu\n",
+			 le64_to_cpu((*gpt)->last_usable_lba),
+			 le64_to_cpu((*gpt)->first_usable_lba));
 		goto fail;
 	}
 	/* Check that sizeof_partition_entry has the correct value */
@@ -422,7 +421,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		le32_to_cpu((*gpt)->sizeof_partition_entry);
 	if (pt_size > KMALLOC_MAX_SIZE) {
 		pr_debug("GUID Partition Table is too large: %llu > %lu bytes\n",
-			 (unsigned long long)pt_size, KMALLOC_MAX_SIZE);
+			 pt_size, KMALLOC_MAX_SIZE);
 		goto fail;
 	}
 
@@ -484,32 +483,32 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
 		return;
 	if (le64_to_cpu(pgpt->my_lba) != le64_to_cpu(agpt->alternate_lba)) {
 		pr_warn("GPT:Primary header LBA != Alt. header alternate_lba\n");
-		pr_warn("GPT:%lld != %lld\n",
-		       (unsigned long long)le64_to_cpu(pgpt->my_lba),
-                       (unsigned long long)le64_to_cpu(agpt->alternate_lba));
+		pr_warn("GPT:%llu != %llu\n",
+			le64_to_cpu(pgpt->my_lba),
+			le64_to_cpu(agpt->alternate_lba));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->alternate_lba) != le64_to_cpu(agpt->my_lba)) {
 		pr_warn("GPT:Primary header alternate_lba != Alt. header my_lba\n");
-		pr_warn("GPT:%lld != %lld\n",
-		       (unsigned long long)le64_to_cpu(pgpt->alternate_lba),
-                       (unsigned long long)le64_to_cpu(agpt->my_lba));
+		pr_warn("GPT:%llu != %llu\n",
+			le64_to_cpu(pgpt->alternate_lba),
+			le64_to_cpu(agpt->my_lba));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->first_usable_lba) !=
             le64_to_cpu(agpt->first_usable_lba)) {
 		pr_warn("GPT:first_usable_lbas don't match.\n");
-		pr_warn("GPT:%lld != %lld\n",
-		       (unsigned long long)le64_to_cpu(pgpt->first_usable_lba),
-                       (unsigned long long)le64_to_cpu(agpt->first_usable_lba));
+		pr_warn("GPT:%llu != %llu\n",
+			le64_to_cpu(pgpt->first_usable_lba),
+			le64_to_cpu(agpt->first_usable_lba));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->last_usable_lba) !=
             le64_to_cpu(agpt->last_usable_lba)) {
 		pr_warn("GPT:last_usable_lbas don't match.\n");
-		pr_warn("GPT:%lld != %lld\n",
-		       (unsigned long long)le64_to_cpu(pgpt->last_usable_lba),
-                       (unsigned long long)le64_to_cpu(agpt->last_usable_lba));
+		pr_warn("GPT:%llu != %llu\n",
+			le64_to_cpu(pgpt->last_usable_lba),
+			le64_to_cpu(agpt->last_usable_lba));
 		error_found++;
 	}
 	if (efi_guidcmp(pgpt->disk_guid, agpt->disk_guid)) {
@@ -542,17 +541,17 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
 	}
 	if (le64_to_cpu(pgpt->alternate_lba) != lastlba) {
 		pr_warn("GPT:Primary header thinks Alt. header is not at the end of the disk.\n");
-		pr_warn("GPT:%lld != %lld\n",
-			(unsigned long long)le64_to_cpu(pgpt->alternate_lba),
-			(unsigned long long)lastlba);
+		pr_warn("GPT:%llu != %llu\n",
+			le64_to_cpu(pgpt->alternate_lba),
+			lastlba);
 		error_found++;
 	}
 
 	if (le64_to_cpu(agpt->my_lba) != lastlba) {
 		pr_warn("GPT:Alternate GPT header not at the end of the disk.\n");
-		pr_warn("GPT:%lld != %lld\n",
-			(unsigned long long)le64_to_cpu(agpt->my_lba),
-			(unsigned long long)lastlba);
+		pr_warn("GPT:%llu != %llu\n",
+			le64_to_cpu(agpt->my_lba),
+			lastlba);
 		error_found++;
 	}
 
-- 
2.43.0

