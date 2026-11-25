Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587408;
	b=mF8LHYX1xYKLToIr5HAC9YU5NdF1nimFVmkvCE5G95AUBTjRnYluZ46+732eVAGLT/1U
	 dAgh4d4JBBtjZxaYuPC92hXqne/sNryoaSDvwk01X5MhhtjSiP0Bh5aqL3XXxi+Du6ON2
	 CBvvGUagF7uQwGRgnGDjvnBQU7xMklQbAeVLUKTUgt6zJnCK7ov8DYwRbn014n9AcaiQK
	 W5etRXlehbiMTEpfqcDmShmXaoNTU1MTApPRGHcPGVf2ztnFHnSIb6UM5l85VKxUdjNnc
	 S0XNxkCOocK8qBkFJXQraopWp/wlq936Vlk88NZRuiM+ZWvQ6P7n9AO+yOTD1R222DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587408;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=XJ5Bj2HUeqnSIN+0jmezTl4ea1LIGCfrIoPbd+y7XVY=;
	b=q4DyHWycbJ+zKnD4xI1QoZ7R4d/ZzalRQf4BZRq0gG2vr4d54S3orxSYhZN5pr8A9ZMv
	 QC9Cz8upGg0hYfewX/m2pMits28QpTR8NJQiX+fcF/Sr4gTxtKvSQofgbHZBa/yUXczwy
	 JOFEpBSKaqQS4LeGmQznmBCCab7Wfg/5rg+g/yPXlBh2EDoFhog75O2S/33OfBTAdh4Gq
	 y4gnxJ8FNPt6yBnijlZIPTQmu1bxPj0OClCax5e9YNOl3YAysxjGEo69dZha17+SAjBcK
	 gqMd74eeAyupkLnG8zi648161Fgcc4XUBwcD8aNbMNws0bh2FaVq7DRqtxReWUC6UCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A2pTrFMJ;
	arc=none smtp.remote-ip=74.125.82.71
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA4607AC0A
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AAA4607AC0A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A2pTrFMJ
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b587ffea77so325977c88.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587408; x=1796192208; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJ5Bj2HUeqnSIN+0jmezTl4ea1LIGCfrIoPbd+y7XVY=;
        b=A2pTrFMJIfsCkS+FQGT671ur2Mpg3phgQVSo+9pmmEK/kDi+RicDzAm8UjcOxLv9DR
         AybPZBi6Y+YuhtClXyN8ZamlY8PXM6mVORzZnlcdPtBI66DKDm+UOEGp8v3ddu6/1DVA
         AfALevxeVBpIYk00sNHVb/r2xPOvmgJa40SuT81YOoeNUveMVAen4g2b/P9k+UNw758h
         poWfHwmbONsayWFaGylPvNwzADThwwn2Bp6VGZ1uhkk2EMIxxS/tMKL3J/0N4CD7GJNo
         FHP7/p8Sm0bKjfes0PV8ZmvMVRV9GvtY26teD+BMwZqA/z5VrrQsXD91XBVRa4JR4Gqe
         p3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587408; x=1796192208;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJ5Bj2HUeqnSIN+0jmezTl4ea1LIGCfrIoPbd+y7XVY=;
        b=MTS1SdTFToCOPzOtnlBZyHFAx7SojfW72oDOhMMOAFLkY+r7s/E+HzfKDmUE8pIN9R
         kXnbj6JXPFlSQh4ia0UxAUGNv09EKo20EeZoLWqpseVk47FJkvBo/EOULfsFsOMi5/E3
         9gA+h4uDOhoaWVKcUHRpoe29FO+PAdIIP9d64AlnUqo9SjaVHzRTnIj25at/+IDw/Lvl
         TErAPCKYkRDyyro2YX2ke4kSCbqnYb+/jk1INpbnMaCM5sjVcmTFAFXN/SM1Q6M7jTsv
         Cow9ekdzmoDkewEOYfesjqZ1DCMAxhoCyraUNNc+O66BKRHRbL0B/5jh0INkG5DwJ1nw
         UNVQ==
X-Forwarded-Encrypted: i=1; AL+hErHayKcy7uBDuEmT8PqLZwjxis+IYdKNsUKnwVaJ8ytuFNvDJS7EJqTBCVKD0E9z5M0C7SS+lnH7d64=@vger.kernel.org
X-Gm-Message-State: APuU4Z9huiaQcDjDJooTG/dN9jCD3kuk1FMS0r3SV46rkkzSzV/RPNqP
	iZMwYBbHIA3DnM6M7kccSmI9PRXq2pbu0Q8jpzc982uVxBEzsHvYDantOkg1Y0vM3xaStu0gvjD
	qn5GKp1wG7g==
X-Received: from dlar8.prod.google.com ([2002:a05:701b:21c8:b0:1b5:345d:ed30])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701a:cc88:10b0:151:6e80:ba7e
 with SMTP id a92af1059eb24-1b5567dcec1mr15970822c88.4.1795587407220; Tue, 24
 Nov 2026 22:16:47 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:18 -0800
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
Message-ID: <20261125061523.1540234-26-irogers@google.com>
Subject: [RFC PATCH v2 25/30] tools include: Add linux/uaccess.h stub for
 userspace tools
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

Add a minimal tools/include/linux/uaccess.h providing a no-op
might_fault() stub so userspace tools under tools/ can compile shared
kernel code that includes <linux/uaccess.h>.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/include/linux/uaccess.h | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 tools/include/linux/uaccess.h

diff --git a/tools/include/linux/uaccess.h b/tools/include/linux/uaccess.h
new file mode 100644
index 000000000000..5a9e6bf4cfb5
--- /dev/null
+++ b/tools/include/linux/uaccess.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+#ifndef _TOOLS_INCLUDE_LINUX_UACCESS_H
+#define _TOOLS_INCLUDE_LINUX_UACCESS_H
+
+#ifndef might_fault
+#define might_fault() do { } while (0)
+#endif
+
+#endif /* _TOOLS_INCLUDE_LINUX_UACCESS_H */
-- 
2.56.1.831.g720f3f5937-goog

