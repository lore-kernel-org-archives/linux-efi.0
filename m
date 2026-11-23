Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394417;
	b=bxfYx54XYSzTwkFpHnPLCWKVZKmcltYBV84E1Ktw1IMrPEcXLkr/j/rp9shbUaATVz3H
	 bkvpMtg9BedH47jAUJ8yMiCePylqfZPs+OWHNFM4ewblzoD8zSTUwMBaGpvDHvGpCistT
	 ublBo4I/2kVqkT+AoehW4Q4DM2S+ZY+KO6aw+FmJ7C3ZEfR2nqWK3sMRtqmKqdxaVN0Sr
	 eup+JOPhea1tXNb7e+IJxanoP7X98J+dOp8/KejdPvFoOxiUQYS4sPXfBEf5gkgafRfit
	 Zn0WDHgnupfogG+ufC9rJ4sjSpxM59yZH8XDOXJEXlYWHwujZt8wI9CYS6X7nXCWPWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394417;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=7l+dD/W+BgV5YgI2G/09krvBCEN+4VhBdym5+PJEAjA=;
	b=dV89DLpZ5UU51csQ131FNHKmSgKcjhZOjF0P2+li77JtqyMD74KzUEMElUWamI9EVaLV
	 q5KC08xp8JUvf3uD9x6cfEMet8vPXYi3Km9AnaOHjk37PHAWRFrF2EFZrKB7vMVeD1xkh
	 YoiCBfohxTylXvMYzfaffDhTpGYaYefawK6afjHdSsXD/U6N89MBCDnMbR97PhbTkEgs7
	 5MRlq3ODIv1zhfASSDaDG6CqiiEuegS+PVFKOphvAOqH3mKB51gFGuswgyb9cgs3Atgoq
	 qurTPUX5rwABIwjCLZ8WKSKNa65OixJIaAM/QLNOfZOht2DhFxihY0aCE6Lu74iQA9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P+PR/x1I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111DC606A337;
	Mon, 23 Nov 2026 00:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P+PR/x1I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203561F0157D;
	Mon, 23 Nov 2026 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795394416;
	bh=7l+dD/W+BgV5YgI2G/09krvBCEN+4VhBdym5+PJEAjA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=P+PR/x1Ic0FMmBINkGnzjlhVNTqrgdSr6ODVINX+75rWP5OpP9BGalwwv3/d9VNSA
	 CQSh4D/rjj+1M78cLXWFTLgo0IhKgin2cw7xejAJ/2t5KFGRNF0veGEbH542pRDqUm
	 081AAu0XpDF+e5fpQJVItumdlwggjHlPCpjJwOHGu7cry04g4HGn7tU9Swacdn41GB
	 Y1u78LgnGiCs2JXBPJJ6DoB/CVl7rRrSn3dd+KNGu/KGrW9eYuN6hbyMTOarrxji+v
	 gh4lB1GtH/zgNAbIL2J0RQ98Af1tfequRK2bprfqw4IGS2+elLrOMQuxA6i0eMc9fn
	 hTY8CIZMbclgw==
Content-Type: multipart/mixed; boundary="===============0669259821457419272=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <3ae6b586116787e3221428028ac62cb6cd4fc70ba1740a541f515f78bb2c8ce0@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-11-irogers@google.com>
References: <20261122235757.3456048-11-irogers@google.com>
Subject: Re: [RFC PATCH v1 10/11] selftests/perf_events: Add Minimal DWARF CFI deferred user unwind test
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:40:12 +0000 (UTC)

--===============0669259821457419272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/perf_events: Add Minimal DWARF CFI deferred user unwind test

TL;DR:
- Selftest may report false "not ok" for 32-bit ARM builds on arm64 COMPAT
  kernels, since __arm__ is listed as supported (unverified)
- Redundant PERF_RECORD_CALLCHAIN_DEFERRED #ifndef (nit)

> diff --git a/tools/testing/selftests/perf_events/unwind_user_cfi.c b/tools/testing/selftests/perf_events/unwind_user_cfi.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/perf_events/unwind_user_cfi.c

[ ... ]

> +#include "../../../../include/linux/compiler_attributes.h"
> +
> +#ifndef PERF_RECORD_CALLCHAIN_DEFERRED
> +#define PERF_RECORD_CALLCHAIN_DEFERRED 22
> +#endif

this isn't a bug, but PERF_RECORD_CALLCHAIN_DEFERRED is an enumerator of
enum perf_event_type, not a preprocessor macro, so the #ifndef is always
true.

The defer_callchain and defer_output attr fields used later in main() come
from the same uapi change as the enumerator, so any header that compiles
this file already has it.

Could this #ifndef/#define fallback be dropped?

[ ... ]

> +#if !defined(__x86_64__) && !defined(__i386__) && !defined(__aarch64__) && \
> +	!defined(__arm__) && !defined(__riscv)
> +	ksft_test_result_skip("Architecture lacks Minimal DWARF CFI user unwind support\n");
> +	ksft_finished();
> +#endif

A subsystem pattern flags this as potentially concerning: exiting with a
status other than KSFT_SKIP when a feature is missing makes run_one()
record "not ok".

Is __arm__ correct in this list of supported architectures?

The kernel CFI user unwinder finds unwind data only through
PT_GNU_EH_FRAME.  parse_user_elf32_eh_hdr() returns -ENOENT without it:

    if (!have_load0 || !have_eh || !eh_memsz)
        return -ENOENT;

As far as I know, arm-linux-gnueabi(hf) toolchains emit ARM EHABI tables
(.ARM.exidx) rather than .eh_frame, so a normal AArch32 binary would have
no PT_GNU_EH_FRAME.  I did not have an ARM cross compiler to confirm this.

On a native arm32 kernel, arch/arm does not select HAVE_UNWIND_USER_FP or
HAVE_UNWIND_USER_CFI, so no deferred record arrives and the test reaches
its "No PERF_RECORD_CALLCHAIN_DEFERRED records" skip.

On an arm64 kernel with CONFIG_COMPAT, deferred records are produced since
unwind_user_cfi_arch() accepts ws == 4.  Each frame gets -ENOENT from
unwind_user_next_cfi(), and unwind_user_next() falls back to
unwind_user_next_fp(), which expects APCS frames at compat_fp (r11).  A
-fomit-frame-pointer build does not have those.

The record then stops after one or two entries and saw_full_chain stays
false:

    ksft_test_result(saw_full_chain, "unwind_user Minimal DWARF CFI across ...\n");
    ksft_finished();

ksft_finished() exits with KSFT_FAIL, so a 32-bit ARM build run on an
arm64 COMPAT kernel reports "not ok" because of an unsupported unwind
format rather than a kernel regression.

Should __arm__ be dropped from the supported list so the existing skip
runs, or should the test skip when the binary has no PT_GNU_EH_FRAME?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============0669259821457419272==--
