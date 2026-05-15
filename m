Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909C24C8FEB
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879719; cv=none; b=DHGP8R1If+u7p0Ctsy7g1gQ2HTxGxnbing6B+CSK9O4k8GGAS8T57/wZnSo/g/hU1PKcvzsYISCfT9Jf+EaCTBPVYUS836333u+yA62868OcLPfQwkodal5B35jucl9ZFajVF8zwtRTG0zKJwIWS7ZIZg28nfbuShbRmBJ7kPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879719; c=relaxed/simple;
	bh=Zcwz++VNrXh9y6soBYCC7hxdmV5RO3C0KhJ6H3w36Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIf/6PKLkdZmdSo9Z7qduHFmJuy8ykloxWk7rfdE415eALaaW8PGyLX1BaAbzpLn0epll35oBpUMpMCvxs2Jo97UWOi+9X1zqnSVz+chmfROPn7ms7xiZMrovm5Kllk8o5CSLwx6KFhpApurhC3QkAYDbAhGoWT9RbFmgL6VtYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pS456OJH; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pS456OJH"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2f0d3e07e30so1352949eec.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879718; x=1779484518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8RkPwRSQGNgtwFGhMa45mhqNtBX9nLmlB3IzWi1i0E=;
        b=pS456OJH1AEeHSLqDqw4ui/jbQksci7GOMA5UlZbGUKa3b3cKwqxQ6MWm5xwlX57PI
         IZDJIMG8QqVi0ayPNo4/ypRXZdgRlhu+XjkAk73EqC7nB0IRpSRqGXxoy8vQd8Bgt0CQ
         WzXiDAw6KrRaOGBb/z0v7a61im0dlEScKq/wb4E9/cTIbcx67pmRYk290CD9S+K1KRL/
         l6Fry/b26nnViZfxl9z6fED8dgvP5m7O9o1LjTQeMg92Ky/sK7+4svsAdj3UWxQlrHwX
         SF0UYmimTDOTR1kBR9t4IKWksrJIgXR9XanS7ZoycxoKXpmFEuhgVKLoq5LCGKnBYZTA
         SWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879718; x=1779484518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h8RkPwRSQGNgtwFGhMa45mhqNtBX9nLmlB3IzWi1i0E=;
        b=ejVs1xl/y+pB3kRHyxrg3IZnOjCGLeNUgHWErF4ddT+s2dGpGJTLE8PZknoByL+f4g
         8tJTn9PBQXYcg2ECSlbu/2a3xxi59VyqQctviuRKCoz+COfXkqU2d9yaWAW8XYJW4Ral
         wFr0V1G9N73DrhYy0JlHlbfcEnQrGrVdUxp3bGr68419rz8/Ecq9V1U14TCvyhIqs+R0
         cUj+4iBXP9E6iTi5oevMTpBTo+kdoPioQETuyEi0320TSfeEisPhjK0jFkzOlUTCh2Fa
         EhIAuslZ4iq03PwrsHbXL2Y5sUCNz2t/lpGitH+gOSkR/606XBgJEvsRMhA9a1S7szXx
         goew==
X-Forwarded-Encrypted: i=1; AFNElJ+rpSq8W5Dxjd1V+jBp+Pw4qdljrpuyqHDkaWKS2eVh7J8uNEpgff/FnWeCnGT7f1gsqWS0fo6iRtU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH6N4bIiKxGbiIDEw/3F3nUvNgb20kbhQwi86SF9Q24KDF+GEH
	iUNcfyGFBPlLpkUyfRZwAurWH6beH54aCYSXKOLGdHEwgtQUySr87FRX4iFuGupl
X-Gm-Gg: Acq92OHJWZFTqyIhssbF9g7BZj/Txs2FEruDGZRzKf6h75aabfp+npyWLh1yH5/xHG6
	guQFZhCzRYWmdUZb3oMw5XEbNqWMo2P/KnG02mjM/AlONcDnCUmxSL9z421BoEHfIA8aTThYwIy
	Kzz2WsDcgkHvRAhCzVP4X7IE4yaYKavtFXF0EIivxYYoCFOzJmOyTc3OQz1XUkxrdZ6RIRKYFD1
	h8LMmPur6I8WefWkeXoYEX78Xkwfnqe9IO8wqN4UxiGkjuAF8YShcYqcd7z/eL4F2jcT37MyNKI
	aDBMGMyfeKgzS7MKCvz07I+SrhPM7c1pT7IKgwJhXeF3RHN0oo3MLOAw1U/F4tg64KwBIaL5Q/n
	HybluOOBjpAGlMZqku/KjELUxJR4bpIaJtBHbENtgwNYrxx/kYA7LeH/Rlsl3z9OEksi1AK+IRX
	amOBgNw5FQPY0aDjlQL5RVEZ6p1niymKo=
X-Received: by 2002:a05:7300:ad30:b0:2e7:5737:8364 with SMTP id 5a478bee46e88-303984e17ffmr3028118eec.15.1778879717789;
        Fri, 15 May 2026 14:15:17 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302947e917dsm8005268eec.12.2026.05.15.14.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:17 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 23/38] x86: Allow WARN_trap() macro to be included in pre-boot environments
Date: Fri, 15 May 2026 14:13:55 -0700
Message-ID: <20260515211410.31440-24-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For pre-boot environments, do not use the static call definition of the
WARN_trap() macro.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/include/asm/bug.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 80c1696d8d59..7899768ae644 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -138,8 +138,14 @@ do {									\
 #ifdef HAVE_ARCH_BUG_FORMAT_ARGS
 
 #ifndef __ASSEMBLER__
+
+#ifndef __DISABLE_EXPORTS
 #include <linux/static_call_types.h>
 DECLARE_STATIC_CALL(WARN_trap, __WARN_trap);
+#define WARN_trap(...)	static_call_mod(WARN_trap)(__VA_ARGS__)
+#else /* __DISABLE_EXPORTS */
+#define WARN_trap(...)	__WARN_trap(__VA_ARGS__)
+#endif /* __DISABLE_EXPORTS */
 
 struct pt_regs;
 struct sysv_va_list { /* from AMD64 System V ABI */
@@ -172,7 +178,7 @@ extern void *__warn_args(struct arch_va_list *args, struct pt_regs *regs);
 #define __WARN_print_arg(flags, format, arg...)				\
 do {									\
 	int __flags = (flags) | BUGFLAG_WARNING | BUGFLAG_ARGS ;	\
-	static_call_mod(WARN_trap)(__WARN_bug_entry(__flags, format), ## arg); \
+	WARN_trap(__WARN_bug_entry(__flags, format), ## arg);		\
 	asm (""); /* inhibit tail-call optimization */			\
 } while (0)
 
-- 
2.47.3

