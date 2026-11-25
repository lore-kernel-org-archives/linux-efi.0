Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590320;
	b=hTtNI70VmhDDGrDsNvXNCG+FS47EiiR6d7QcrAKlcoUFwkqYhVRJ9viO9Y4Indzer+WB
	 3Hu5z+SCt0oeqBEMNynP+Za6RPG8wrPGdfM+d1KcsRzSOzD/Z/NugMEHyREwmwp3q3yeO
	 EU6hM4xFZ/h8OIz4Hs7aBNqIcvmdM9xU8hbbv/VBf0idnoSUNfilme9R9NPcfH0biQ6H6
	 zweAQ86ZkF2XCHJfI9xLrY3kLb59DFxwkSRjqGhX7gyZeMxBygj3fwsevcMxkPaNLzuAn
	 egVONft/K6rWuwtXOAjFVKoUuwAS4qrycZsdaARzTMFwE4BFiKgSYaak1VpBPsi4cgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590320;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=MgT1YyHFc5vAkk1nIM2L3NOs9FPcWgxQDn2k/WL0F3g=;
	b=4veTPqdVKOUBs0b85KRPtdV35V1Ei78SLiWjURkYPeHq7PHoIrPp9JYBEb8huWHt6I3X
	 wh6fdPj436CcMNZU20v6rPns6cJvAqV1qb++57Aq8VRTliPt1W+oqz0BCRpfR0xEUmyQ9
	 AikOHTWpHJTEH4I0ySWkTwAobgnsMHZFCyllkpYiibuUk976vvN9SD8ZeujXgcn5XRDBr
	 fmLlnRKcbmDi36uZnJAWP/qgm71MVgQWRPLDkibT2yR9IKrdaty3GWyh2FtjI9BRYXhKx
	 6UfzepZvNHeDNyonxCyeOjM6+h8vdD1FlvuhN1dWkY+2qVhK9CWjTNl4/loBWsAa+pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VF1k79s2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A61C606A321;
	Wed, 25 Nov 2026 07:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VF1k79s2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219D11F000D4;
	Wed, 25 Nov 2026 07:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590319;
	bh=MgT1YyHFc5vAkk1nIM2L3NOs9FPcWgxQDn2k/WL0F3g=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=VF1k79s2oMcJZqu3w4TXb/uZpIRltc5cnLADLHBenWr+OnopFLWbdN+8kjXweuQYz
	 DWBKkg5nRx45BboGpgdEObUcidSHfiZ8sz1EJ1LSzy0jVCufvuOCcAJJ7n7IYVD1av
	 +5Xr4jvCS8Bpq/raHsQXmjWQS6H66iGwYAulPoW+St3+8ny5XmHLeduziLVwu3itlK
	 ZO8qGWXG5/T08anrWxZjnSyhfzu4u/fK8YD7N6CYgTarzd9BdnnXHBPjVvpLKHuymL
	 y+Pne5ooVBEPIMOJSPWD46aAjgNJixJInOu6cVb6VwAqAbPKZsIYwMY9T3mldFKIRv
	 97W/1WHzA6kOw==
Content-Type: multipart/mixed; boundary="===============7632220386014004542=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <88fec51b898796fa41775d55085d7fa38e2214a80c86b14e0fb90088e192ef83@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-3-irogers@google.com>
References: <20261125061523.1540234-3-irogers@google.com>
Subject: Re: [RFC PATCH v2 02/30] unwind: Add KUnit tests for Minimal DWARF CFI interpreter
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:15 +0000 (UTC)

--===============7632220386014004542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> unwind: Add KUnit tests for Minimal DWARF CFI interpreter

TL;DR: Nit only, in the KUnit tests: the same blob-derived arguments are
repeated in about 26 dwarf_cfi_eval_fde_kmem() calls; a small eval_blob()
helper could make them easier to scan.

> diff --git a/kernel/unwind/dwarf_cfi_kunit.c b/kernel/unwind/dwarf_cfi_kunit.c
> new file mode 100644
> --- /dev/null
> +++ b/kernel/unwind/dwarf_cfi_kunit.c

[ ... ]

> +static void test_cfi_drap_realigned_frame(struct kunit *test)
> +{

[ ... ]

> +	build_test_eh_blob(&blob, "zR", 0x04, 0x2800, 0x40, insns, sizeof(insns));
> +
> +	/* Transient prologue at 0x2806: DWARF_CFI_BASE_REG (r10) */
> +	KUNIT_ASSERT_EQ(test, 0,
> +			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
> +						blob.buf + blob.total_len, 0x2806,
> +						&test_x86_64_arch, &row));

this isn't a bug, but would a small helper such as eval_blob(&blob, pc,
arch, &row) make these tests easier to scan?

The same three blob-derived arguments (blob.buf + blob.fde_off, blob.buf,
blob.buf + blob.total_len) are spelled out in every
dwarf_cfi_eval_fde_kmem() call, across test_cfi_drap_realigned_frame(),
test_cfi_sigreturn_frame() and test_cfi_arm64_pac_and_riscv_leaf(), and
about 26 times in the file.  Only the PC and the arch descriptor vary
between the calls.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============7632220386014004542==--
