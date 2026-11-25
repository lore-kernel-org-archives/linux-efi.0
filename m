Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587372;
	b=13GdyxYqrgPQg9R9T8CX40NJAGvUlxBMq6RjiRm5dnixZ16xGadI2dbdQ1wACisaR7Wo
	 1zpsuTngRaNOgRYFaiXOwYjWtK2q2evoAP6daYJYPFkeyLPnxx6+RWN75aQ+26qmMhuZD
	 zhvp90VGDvZlmKlZdhq4fbc8dFVffjEF+WC+Nzwb1YMgHrNaJWgyC7La6Zqso6bSLjBQJ
	 j7m3ObvyIO1UBnwwV56NwbsplD5BsNIzuoWNb/NAVEHZEXB9JxDgHypMyFsXDPNSaEvaD
	 cS8z/kN3gtOv8YLrMKIaJFsqf4sL90+ZLHVKPbZ42QaVDYUDaWEhYMiCPBMoDgAXxiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587372;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=bS1O6gZBZC8eMhEAflyw/nPs5CPcAQAclZg8OIJWUGg=;
	b=Gs6ekI60T56GlSVGiZwgGUyZ/gQGbkLmKDobcCrWe2VNjq+0AP/x98gzB38nyKcdfiom
	 cEBSzSdCYWJ6dZEw7NJZix+8qjlUJwpopBrC0fKiUK2kbQWOLlo7y+v1rlBovC0ELaVLI
	 Yex9olh70snn27Pz/0nIopzWn0TbF12wteeZgoPS+QqqvaLTBr3XVuQMIMGHTO95UIdxs
	 zCrO/mVr/c+R5y+nKm13S6tLe1CJVW7Nb5mUyDUyEcwDm1YvVfpbD/JISDodPo4kcWwYo
	 GIC7x8iau9rjvvja+ycrVdo4mLD8VX8i2ZCRzjceyfogoLVJXOj75cVdaZI80fEKucQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Db/cRPFL";
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3EF606E953
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA3EF606E953
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Db/cRPFL
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-386b8624cf7so555046eec.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587371; x=1796192171; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bS1O6gZBZC8eMhEAflyw/nPs5CPcAQAclZg8OIJWUGg=;
        b=Db/cRPFLfYVCp+2GdQfozLgX7xQ22/ZFmmU+8ONn0ztqKNHD5GQP6wLynJKPPmdp9v
         CjY4/zp3pIGiflimiES3q8iGcr0M9XMEu9XRaXQY1lXYRJ14v0lU/NxPyl3FNsagDWsm
         meKiuP4xhYuX5egFh4+zDmRCql+CDY3MNDoZ2Vjuom3u46bjoTR/E4w4/qkQ6ljAvVBC
         hvgS0Ll/7G0ispHlE9t1ZSd3RQtHvUMXRWroFpGoP5AjRsRc6A+psnQojtxX+CIgFxNl
         d7rElfx3LYYsCEoXoomSKrJg9l0SUi1X9vw9lifNDMMI6qq86Rpbqhqk3PDRLQoncrjp
         BmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587371; x=1796192171;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bS1O6gZBZC8eMhEAflyw/nPs5CPcAQAclZg8OIJWUGg=;
        b=NWC6IWtellrbqQ8Jey7y6PiRo366SaWrQiVks3btmwoGk8H+0bEHYT+ndkP2wdSTGD
         uGatI3Xe6gqyVbgKIp5ZzKzsR70XNZ8nVgfD9TdH0wsFMMFGDkVguF3YqzWE+I7v4Kqq
         KBi4ht1nMIE7+dQHlqmnLpyiXg/97PIGJcDPuHMK/3sxv3MF2pMp9bUSAaCn6dqyrdqs
         8036hl4to6udK3v5YCepekIfdao/hsbGzRwavfAOK8DNx/krjgyTcxipXJ0NA7A0xXvB
         1yA7YzFQYAAFdda7p/nfjJ5kOEUFne640rU3HLD1loMek7Rd+EwMQXfnKPD5f02WmCwy
         XffQ==
X-Forwarded-Encrypted: i=1; AL+hErHpqLYTQ5E+NgMrSnW7RKsgqo6OU9GlNm1GhNx+t2Xxfk9KWrsMsVZ7iWBzGHxmG6MwnQ7PxkcEvPA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8gy07UU2IVzYlCGA6W6CgpWv3Qmc8ULfmNa70tUrGM7YeB3d0Q
	SmqpD17PhsLiFH49aMMZO7ua0qTk80AK2UsqBVd904gNdxUhFlLLclIRDFnSULYZ4XJESW2vVkX
	QVk04ISUkQg==
X-Received: from dybou2.prod.google.com ([2002:a05:7300:e5c2:b0:384:c70c:3c65])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:269e:b0:376:5b99:a816
 with SMTP id 5a478bee46e88-3856c2c3fb4mr17120337eec.3.1795587370674; Tue, 24
 Nov 2026 22:16:10 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:00 -0800
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
Message-ID: <20261125061523.1540234-8-irogers@google.com>
Subject: [RFC PATCH v2 07/30] objtool/ibt: Ignore .eh_frame relocations during
 ENDBR validation
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

When vmlinux.o is built with -fasynchronous-unwind-tables and
CONFIG_X86_KERNEL_IBT=y, .eh_frame FDE headers contain PC-relative
relocations referencing function start addresses across .text. Because
.eh_frame is read-only unwind metadata rather than executable code or
indirect branch targets, skip .eh_frame* sections during objtool's IBT
relocation validation alongside .orc_unwind_ip and DWARF .debug_*
sections.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 931c5c412f15..e631b0da9bad 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4644,6 +4644,7 @@ static int validate_ibt(struct objtool_file *file)
 		if ((!strncmp(sec->name, ".discard", 8) &&
 		     strcmp(sec->name, ".discard.ibt_endbr_noseal"))	||
 		    !strncmp(sec->name, ".debug", 6)			||
+		    !strncmp(sec->name, ".eh_frame", 9)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".kcfi_traps")			||
-- 
2.56.1.831.g720f3f5937-goog

