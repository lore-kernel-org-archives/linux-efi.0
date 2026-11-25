Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587376;
	b=DjPVJ0levJOZz1KQ8a2R+QoPlV85gUvxaRsAVOdyOhIoHhXenSax/IVABkC6O4qFzIXq
	 zj4JnhAthdj2+5cIi+uuoQiHlVBiYo3M6elKfu5swEMA1JjZod6zZ/6c4Ruh+6OykufbQ
	 8RRm3H8bFkzv/Njs0FpJQEuAadkJYndBA4Qituu3Kg2tsr1YJHmNaFt/Tl9hWY/eTVG4O
	 +lSYAVfx2A22aBIzVFVA9AGEPat/LYZBj6yWCXtQ6x6MVR19nq/kULgn9vs/oE14s3vUu
	 SWMBiKV2CTCxxRdBHlxgBMeYuB21qmefUXk3nTJ+1r62F0WwC+62sK69D0ZwefECYOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=GGDahMitB3LSpaFaJkVUo1Pzx9kbamS5IbDP2+gBQRY=;
	b=bI5m1cPItK7CRZ1//fKcyr77IN5AiMiK7tpu/fVvknThNG2VUtQ+s+CunXeT8ADrvYQ5
	 2CKU4xofOa6o0eS048UWmpWQTYLgnVbAoYsbsJkYuF/9D/3wpjWvy9ZIglG8y5m8Ws5J4
	 axJGsGCJa4D2aB4JDR/rcvuXJWkifT3/Z0bqWHqt4jVydLpwK37cv5c94iLDdDaDWApWZ
	 iBidNpYDC+19vN728h90/Fyhf80Ga4sWPpzsHaI0RfiqviR2Ufq82eol/hdj7bfVUumuw
	 T4KoppINtJHvj75GEH/NNVBTDyltj3LrBUwqiklB21Xv3QbmKbs84RfV3nDGCqFqyyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NC8TFIwL;
	arc=none smtp.remote-ip=74.125.82.70
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41C60A381C
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A41C60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NC8TFIwL
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1b3b45597c7so409826c88.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587375; x=1796192175; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GGDahMitB3LSpaFaJkVUo1Pzx9kbamS5IbDP2+gBQRY=;
        b=NC8TFIwLTkPbzeWjMCBEzMycXowBO7nwlg1PQhGSIEdoRdcynFgU3xj0z346DalUvK
         CclzOOgsc08nnESEFqDQN8grEdC2dvQQay+O8qqF/cXS/Sx/3fHPHv22bsBKHsHYhqhL
         N7MKQrt38DWZocIKvHgSCP6atdy4p9PvnCrh+EVUWREweUMREZchFqy91Sxrc/M3Gq0x
         4IxBXWtMXRPrVFIYr3Tg854QTdurR/WVRTSLuOea9bx7plqd3QRfrjLI4E++6f3fadBC
         EcD9m8j1xBeixoCWAUp7sngoetkh00EBHTIE3CwevkPOOdyD58gjHWhr5ITeQvpeR1pk
         iPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587375; x=1796192175;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GGDahMitB3LSpaFaJkVUo1Pzx9kbamS5IbDP2+gBQRY=;
        b=jKfujuM332vaj9HXDLWK5UttLRSZV2zBJ9I6mHSkUqGShtLQND3Jto8D33V8JF811Y
         bv8WdJU3GelB6uflxP/sKEjMIw0SmDON1ixASwjuX1626e6bQY5Ifcjot1AU7NsNVkGy
         h2jTFjSWNsrq9VOgerzp5U7wLESmSkoiMZKhowHu2RcZBiz3R6KMApF/J72DMQkLxUHG
         TQfpoER1kJjw4UpHmFuqn08SpTG2lexxEMp+eYC1wDV1tzqr8tf5YmbTUYNMDWJG8owz
         KKEkpkwy0zRmEwd9dR17wsuVeYwGo6amrbX8dYDi9vrNG99ZRcctnPqQ4x1j9+GSf+bp
         lWXA==
X-Forwarded-Encrypted: i=1; AL+hErFA0iAXIm4UyFL014MCzFYx+dDxA6NmmtXATkWKWfz6aVyVF6v6yMAiPqcBhuRZMpNy7eSPGMfg/9I=@vger.kernel.org
X-Gm-Message-State: APuU4Z/QTNRAjecQuUviRPrZeN/5VuKy/Q4top5ye5qjCKx6obD3Wq+h
	bRr46/o/IteyZ+InOWZnfAI5ol5CmRj7Sgo+Km1tJOw+AJvtcD2v7m1xl5tE7zgLsxNTgsteBUi
	jDBN3N272Qg==
X-Received: from dloo27-n2.prod.google.com ([2002:a05:7023:a5b:20b0:1b5:8761:cc11])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:b902:b0:1a5:9abb:fdd7
 with SMTP id a92af1059eb24-1b556877a2bmr15589113c88.9.1795587374885; Tue, 24
 Nov 2026 22:16:14 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:02 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-10-irogers@google.com>
Subject: [RFC PATCH v2 09/30] efi/libstub: Disable unwind tables in x86 and
 RISC-V EFI stubs
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass -fno-unwind-tables and -fno-asynchronous-unwind-tables when
building x86 and RISC-V EFI libstub objects so enabling kernel-wide
asynchronous unwind tables under CONFIG_UNWINDER_DWARF_CFI does not emit
unwanted .eh_frame sections into the standalone EFI boot stub.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/firmware/efi/libstub/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index bbab12b8eb4b..19c2822eb302 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,7 +19,8 @@ cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
 				     $(PADDING_CFLAGS), $(cflags-y))
 cflags-$(CONFIG_X86_32)		+= -march=i386
 cflags-$(CONFIG_X86_64)		+= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -fPIC
+cflags-$(CONFIG_X86)		+= -fPIC -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 # Nothing enables IBT while the stub runs, so ENDBR would only take space.
 cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)
 
@@ -29,7 +30,9 @@ cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
 				   -DEFI_HAVE_STRCMP -fno-builtin -fpic \
 				   $(call cc-option,-mno-single-pic-base)
-cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax
+cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax \
+				   -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt
-- 
2.56.1.831.g720f3f5937-goog

