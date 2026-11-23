Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394403;
	b=JHkcq3T/cUYDVPA0BhAlpvDjjOaQQKiTXQEpDAWP7fQ8zQlqHnoh804/F9Bb1AHsZmSI
	 iaWRCN4Z8e8oLFdBClfYVtFIpVFj8IhhfMbEMIhLLNWafbBjoFuRKHeGt7DWvR+VBXewq
	 q0yXPIGNo3C0zxoD5aPuF4PBpeUFtoGdFj0Xi7nMrKwjU+EQfnXQBscT53YB9xwpuTEXR
	 fX2vDQIX5ZDgNlA/Qzd9dEtjb/mTsr5ZeX5TdEozu6dtDwiQjSIwXE5x/8NvRD7l1qJ9G
	 4TQmr4CMfRes1xMqasfQ8+lQnuavlr8C1xjDUKT46wIc7uxu1Li73MG20McoLZ8/aiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394403;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=1twSl3tHPUl9qxbZpsjhW6gFoQYZkpCeQLSlAJ9FV3w=;
	b=tU3YrXy/QQxjVDRSKNa7ImGZuSoEyexN/tQCob+qLCTaa2LtCzKlMmsGAPiCA3I0A/bg
	 69pEgjQT5tjDRRTiYQFoyNSuswQzXk0/OI4qC09l0lX18F4+7xjm87I+WeXIICLWeiglG
	 j1fagXBubb0bnzZFIIvHnuEbS0PUiMJNDrvIi6y3OKVrEseH7UwxDTZjE/eEEzkZzLwxe
	 XtCfPGrVR7jsGJJKO9UN2+RAPrQZFWfpWiqHvhihrslDxuO4Ue/DGXI6qHnGLBN2CS21a
	 phc6hNtfr/hAiHEZbmT26ktuaonpBwtU6ym53ESQOC2kWfMC91N+GIwC22TCe/wL8cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EEtc/Bcn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D49F606A31A;
	Mon, 23 Nov 2026 00:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EEtc/Bcn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E501F000E0;
	Mon, 23 Nov 2026 00:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795394403;
	bh=1twSl3tHPUl9qxbZpsjhW6gFoQYZkpCeQLSlAJ9FV3w=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=EEtc/Bcnpi6Z/Pt54ni+2d7frj+tKbrLFgp3vT23zseQwzwema2z/ti4uYEX/Xhan
	 SwDmiK43LlmCakVxTQpOtdD47+vOGkWHJDc5ReGN/QX0rpoY4yMSTUJiRh0wyS7b+V
	 YNn0/jt7rHXRKB1wYVUJ1CeqGGusE+8rrwd2xaQce+HOYKIfV9MOQxrHkAhSqvlIPv
	 OhAhfz15uyMt80p0EtS36OzgyEf39qenc5rAkmp2rOUVt1GF0VaORlQfL3QykhChwb
	 721XL/2V0i0ZSZbkpoQkKdefynkmVdY5Vn/Et0uBt5456KfZ4eUkRUGnKnF7u6JEhS
	 kVwWxWeSd/TIQ==
Content-Type: multipart/mixed; boundary="===============2182094154944894056=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <9b6ccd51d0643f6b7733a24d4b7eb30aa32f5b93f1eb86482ffaddfd4a548d1d@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-3-irogers@google.com>
References: <20261122235757.3456048-3-irogers@google.com>
Subject: Re: [RFC PATCH v1 02/11] unwind_user: Support Minimal DWARF CFI user-space unwinding
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:39:58 +0000 (UTC)

--===============2182094154944894056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> unwind_user: Support Minimal DWARF CFI user-space unwinding

TL;DR:
- Possible wrong stack pointer after 32-bit compat vdso sigreturn FDE, giving
  bogus user callchain IPs
- Speculation fence in get_user_word() may be a no-op on all architectures
- Return: doc mismatch (nit)

> diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
> --- a/kernel/unwind/user.c
> +++ b/kernel/unwind/user.c

[ ... ]

> @@ -11,14 +12,38 @@
>  static inline int
>  get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
>  {
>  	unsigned long __user *addr = (void __user *)base + off;
> +
> +	/*
> +	 * On architectures whose get_user() uses a conditional access_ok()
> +	 * branch rather than branchless address masking, fence bad access_ok()
> +	 * speculation so chained cfa_indirect stack reads cannot transiently
> +	 * dereference kernel addresses.
> +	 */
> +	if (!can_do_masked_user_access()) {
> +		if (!access_ok(addr, ws)) {
> +			*word = 0;
> +			return -EFAULT;
> +		}
> +		barrier_nospec();
> +	}

The commit message says this block fences non-masked access_ok() checks "so
chained cfa_indirect user stack loads cannot speculatively dereference
kernel addresses".  Does this code provide that protection on any
architecture that uses it?

x86_64 is the only architecture selecting HAVE_UNWIND_USER_CFI at this
commit, and it defines masked_user_access_begin(), so
can_do_masked_user_access() is true and the whole block is compiled out.

arm64 and riscv enable this later in the series.  Neither defines
masked_user_access_begin(), so the branch is taken, but neither defines
barrier_nospec() either, so it falls back to the empty generic
definition:

    # define barrier_nospec() do { } while (0)

That leaves only an access_ok() check that get_user() repeats right
after.

The comment's condition also looks off for arm64, whose get_user()
already masks the pointer without a branch (__uaccess_mask_ptr()), yet it
still takes this branch.  can_do_masked_user_access() only reports
whether masked_user_access_begin() exists, not how get_user() is
implemented.

Should the comment and changelog describe what the code does (defer to
the arch barrier_nospec()), or should the block be dropped since
get_user() already does the access_ok() check?

[ ... ]

> diff --git a/kernel/unwind/user_cfi.c b/kernel/unwind/user_cfi.c
> --- /dev/null
> +++ b/kernel/unwind/user_cfi.c

[ ... ]

> + * Return: 0 on success, -ENOENT if no PT_GNU_EH_FRAME covers @ip's VMA,
> + * -EINTR if killed while waiting for mmap_lock, -EFAULT on user copy fault, or
> + * -EINVAL if current->mm is absent or @state->ws is unsupported.
> + */
> +static int find_user_eh_frame_hdr(struct unwind_user_state *state,

This isn't a bug, but does this Return: list match the code?

parse_user_elf64_eh_hdr() and parse_user_elf32_eh_hdr() also return
-EINVAL for bad magic, wrong EI_CLASS, a bad e_phentsize, or e_phnum of 0
or above 64, and find_user_eh_frame_hdr() passes that through:

    if (state->ws == 8)
        err = parse_user_elf64_eh_hdr(elf_base, out_hdr_uaddr, out_hdr_size);
    ...
    if (err)
        return err;

That happens for any VM_EXEC file mapping at vm_pgoff 0 that is not an ELF
image of the task's class, for example a memfd JIT region, the [uprobes]
XOL page, or an x32 binary (ws == 8 but ELFCLASS32).

The errno also changes once the VMA is cached.  The slot is marked valid
with eh_hdr_uaddr = 0 before parsing, so the first lookup returns -EINVAL
or -EFAULT, and every later lookup in the same VMA hits:

    if (!c->eh_hdr_uaddr)
        return -ENOENT;

So the documented -EFAULT/-EINVAL distinction only holds for the first
lookup.  The walk falls back to FP either way.  Could the Return: list
name the invalid-ELF -EINVAL case and say that cached negative entries
report -ENOENT, or should the cache keep the original error?

[ ... ]

> +	lookup_ip = (state->topmost || state->signal) ? state->ip : state->ip - 1;
> +
> +	err = find_user_eh_frame_hdr(state, lookup_ip, &hdr_uaddr, &hdr_size);
> +	if (!err)
> +		err = dwarf_cfi_unwind_user_eh_frame_hdr(hdr_uaddr, hdr_size,
> +							 lookup_ip, &arch, &row);
> +	if (err == -ENOENT && lookup_ip != state->ip) {
> +		/*
> +		 * A signal trampoline without a leading NOP has state->ip at
> +		 * the exact start of its FDE, where state->ip - 1 misses.
> +		 */
> +		err = find_user_eh_frame_hdr(state, state->ip, &hdr_uaddr,
> +					     &hdr_size);
> +		if (!err)
> +			err = dwarf_cfi_unwind_user_eh_frame_hdr(hdr_uaddr,
> +								 hdr_size,
> +								 state->ip,
> +								 &arch, &row);
> +		if (!err && !row.signal)
> +			err = -ENOENT;
> +	}

For 32-bit compat tasks on x86_64, does this retry path accept the vdso32
sigreturn FDE and then hand back the wrong caller stack pointer?

Compat tasks that do not set SA_RESTORER return from signal handlers
through the vDSO trampolines (vdso32_image.sym___kernel_rt_sigreturn).  In
arch/x86/entry/vdso/vdso32/sigreturn.S the FDE starts exactly at
__kernel_rt_sigreturn, and the nop in front of it is outside any FDE.  So
the first lookup at state->ip - 1 returns -ENOENT, and this retry at
state->ip finds the 'S' FDE and accepts it.

That FDE describes the interrupted registers as:

    CFI_DEF_CFA	esp,	\sc - 4
    CFI_OFFSET	eip,    IA32_SIGCONTEXT_ip
    ...
    CFI_OFFSET	esp,    IA32_SIGCONTEXT_sp
    CFI_OFFSET	ebp,    IA32_SIGCONTEXT_bp

The interrupted esp is the value saved at CFA + IA32_SIGCONTEXT_sp, not
the CFA itself.  dwarf_cfi_exec_insns() only applies DW_CFA_offset* to
fp_reg and ra_reg:

    if (lo == arch->fp_reg || lo == cie->ra_reg)

so the esp rule is silently dropped.  unwind_user_next_cfi() then builds
a row with cfa_base SP, cfa_indirect false, cfa_off = sc - 4, and
unwind_user_next_common() gets the correct RA and FP from the sigcontext
but sets state->sp = cfa, which is the address of the sigcontext inside
the signal frame rather than the interrupted esp.

The next step uses state->ip with this wrong SP.  If the interrupted
function's CFA is SP-based (default -fomit-frame-pointer i386 code, or
any prologue/epilogue/leaf), the CFA becomes &sigcontext + N, the
progression check passes, and the RA is read from inside the sigcontext
(for example the gs/ds selector words).  The result is bogus IPs in the
deferred user callchain, and the walk never falls back to FP.

The commit message claims "32-bit compat user unwinding on x86" and
support for "signal trampolines without leading NOPs", which is this
trampoline.  Should a signal row whose SP is restored from memory either
be translated, for example by treating "esp at CFA+off" as an SP-indirect
CFA, or be rejected so the unwind falls back to FP instead of producing
wrong frames?

No later commit in the series changes dwarf_cfi.c, user_cfi.c or user.c.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============2182094154944894056==--
