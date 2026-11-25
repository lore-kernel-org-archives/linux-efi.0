Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590347;
	b=RO14IudfjT7slz1n0p76qwRWsWHjrp9RhFhtpSgC69SPwJniCGHCNltekxwxFjYNbyAi
	 43HKUj+c3QlV3HfzEr6qHSn21e0UCoUBB49FHqVFMSN9c9PG7gKO+MnimC7BiU89JelNU
	 yDuiXerwS65MaRWiX0Y3EV8Usd06vs/5cA6yjvmDJ0uXCQZDcjlYoG9BCqW5O3EapowOo
	 el1QWMB6yhhsHs7+UyFY+TzGIjIJRLffBZ2ZnNVGOPqB02W72TD99AXgEqOaCgevOf1sl
	 sT/GVShq4YETBDUjN/B28s9cpBUpAcIoY2F0iSHr4tY/ZQiuWDGuTgXCQAZnj2FMxQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590347;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=mk40sVkFOHQ4mbTFK0Wk1/9jOwYnq/31sZddGtTn2r8=;
	b=a+l1185YH302LrxcUcsaksginpR6XTDfnvymSXe+JlGcNUs/5Gw2UQ9j2krBo74SaL6P
	 m4aWiwD78+FXsD07/pgI2Rpr1dDn7fYYo1CfPCbiZCHf6zj4IHeWIjQtCKPnuSL6SWjhm
	 U1UaM9QOE+hDU/5Dzm3q7ha9hbdVwQJXwz9zTISXX0Et8ng0/9SiLNFu8lPO6aqDVkSZ7
	 ULXpHzyQY4DaCd39FdQiviyU+XLRa3jmZasrIgg3LWC3vAJL2UmP+on4WHfZoMLKYz7Wn
	 bpZogElr/Yg8Eztxk2Qxf9f10aC8NO8cYXofqjF9JoVb/VGhzYfkQZznea8OQnbhbFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRtb5FE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9F606A32A;
	Wed, 25 Nov 2026 07:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRtb5FE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBF51F000D1;
	Wed, 25 Nov 2026 07:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590346;
	bh=mk40sVkFOHQ4mbTFK0Wk1/9jOwYnq/31sZddGtTn2r8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=GRtb5FE9lgsDE/bKoL3Rvn8xFaB0dRigQLL/uapE7WEJ9NrqYdC4bDZmSEiPNd2b8
	 KwepLUjS19i7xjS1fa4NNbAvwbLCYbsXa3rFCUCkbOCGUZnAtWIEMGtNbVTXItAYpl
	 tKGbhNHwVtywRWlLsPF6x38bvO1Kv74ZYblJybqw8/cQ1IrXlAsYu1WyzkMDnwT72t
	 sgWbsLSCDMI/iW1jut/6aM+59Ro0o70Ow8n/cjrno0+UcQ2REbKZ6WFdrbTK2L6YEK
	 Cf5989xM6AHFMlDEiHafzz+v+qU9yWhnIesHbszYK/VYmzrNtsfhvRdDYTfSiKxJ02
	 h7NG/b4Bu98qw==
Content-Type: multipart/mixed; boundary="===============8094284997810905034=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <85612bab718b4dff389065a2f1e9b1a6339da01193ffaff6c5d8aedfbf46904a@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-22-irogers@google.com>
References: <20261125061523.1540234-22-irogers@google.com>
Subject: Re: [RFC PATCH v2 21/30] scripts: Add eh_frame_min.py .eh_frame coverage and size analyzer
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:42 +0000 (UTC)

--===============8094284997810905034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> scripts: Add eh_frame_min.py .eh_frame coverage and size analyzer

TL;DR:
- eh_frame_min.py may misreport sizes for RISC-V relocatable objects
  (relocated advances unread), so savings and --minify output are wrong
- FDE byte total counts unsupported FDEs, skewing the average
- Two comment nits

> diff --git a/scripts/eh_frame_min.py b/scripts/eh_frame_min.py
> --- /dev/null
> +++ b/scripts/eh_frame_min.py

[ ... ]

> +        if name in sections:
> +            # Accumulate sizes for multi-section objects (e.g. .text.*)
> +            prev_addr, prev_sz, prev_b = sections[name]

This isn't a bug, but this branch only runs when two section headers have
the identical name.  Per-function sections such as .text.foo and .text.bar
have distinct names and never reach it; they are summed later in
analyze_elf() by the name.startswith(".text") prefix check.  Does the
"(e.g. .text.*)" comment point at the right place?

[ ... ]

> +            elif ch == "B":
> +                # BTI / PAC key on arm64
> +                pass

This isn't a bug, but 'B' in the AArch64 DWARF ABI only means that frames
use the B key for return address signing.  BTI has no CIE augmentation, so
should "BTI" be dropped from this comment?

[ ... ]

> +            if hi == 0x40:
> +                op_counts["DW_CFA_advance_loc"] += 1
> +                pending_adv += lo
> +                continue

On RISC-V relocatable objects, are the DW_CFA_advance_loc and
advance_loc1/2/4 bytes stored in .eh_frame the real PC deltas?

With linker relaxation, those deltas are filled in at link time from
R_RISCV_SET6/SUB6 (and SET8/SUB8, SET16/SUB16, SET32/SUB32) relocation
pairs, and the stored bytes are placeholders.  The script never reads
.rela.eh_frame.

arch/riscv/Makefile only adds -mno-relax through KBUILD_CFLAGS_MODULE and
KBUILD_AFLAGS_MODULE, so objects such as the example mm/vmscan.o keep
relaxation.  The build-time minifier in this series handles this case in
scripts/min_eh_frame.c:

    * Buffered output event emitted by minify_insns(). Adjacent non-relocated
    * PC-advance events are coalesced before serialization, whereas relocated
    * DW_CFA_advance_loc* instructions (e.g. RISC-V R_RISCV_ADD/SUB pairs) are
    * preserved verbatim ...

Here a relocated advance read as 0 leaves pending_adv at 0, so emit_op()
flushes no "adv" event and the next kept rule is attached to the previous
PC.  For riscv .o inputs that makes the 'FDE bytecode payload ... -> N B'
figure and the 'Minified .eh_frame' size understated, which overstates the
savings percentage, and the --minify blob, documented as being for
differential tests, is not equivalent to the input CFI.

Neither the commit message nor the docstring lists this as a limitation.
Should the script read .rela.eh_frame and keep relocated advances verbatim,
as min_eh_frame.c does, or refuse or flag ET_REL EM_RISCV inputs?

[ ... ]

> +            res = decode_and_minify_insns(fde_insns, cie, arch, init_row=cie_init_rows[cie_off])
> +            total_op_counts.update(res["op_counts"])
> +            total_min_insn_bytes += len(res["min_insns"])

[ ... ]

> +            if not reasons:
> +                supported_fdes += 1

[ ... ]

> +    print(f"  FDE bytecode payload    : {total_orig_insn_bytes:10,d} B -> {total_min_insn_bytes:,d} B "
> +          f"(avg {total_min_insn_bytes / max(supported_fdes, 1):.1f} B/FDE)")

Is total_min_insn_bytes computed over the same set of FDEs as
supported_fdes?

total_min_insn_bytes is incremented for every FDE, before the
"if not reasons:" check.  Unsupported FDEs are never written to
min_eh_stream, but their minified bytecode is still counted, and the
average then divides by supported_fdes only.

For example, with 100 FDEs of which 50 are supported and 50 unsupported,
each with 10 B of minified bytecode, total_min_insn_bytes is 1000 and
supported_fdes is 50.  The script prints "avg 20.0 B/FDE", while the
emitted FDEs average 10 B and only 500 B of FDE bytecode is in the
minified stream.

This is reachable with the listed inputs.  The x86_64 .plt FDE in /bin/bash
uses a DW_CFA_def_cfa_expression that ends in DW_OP_plus, not DW_OP_deref,
so it is added to reasons and treated as unsupported, yet its earlier
def_cfa_offset ops still add to total_min_insn_bytes.

Should total_min_insn_bytes be accumulated only inside the
"if not reasons:" branch, or should the average divide by total_fdes and
the line be labelled as covering all FDEs?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============8094284997810905034==--
