Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590408;
	b=Wd5w2AIFC24hZ3go/LMFHrC7Mfa9qO+vp5b7hUQot3jt6KsmQ8um5vIMYZPn3e/hMgq1
	 CHjNshiXoMaQNT+nUz6Mvjz9T2uAcIMIzDwjEMLEwGDxgMP1hanD/Z8Msr3DI8GIedvyJ
	 FK27TN9ST2JHp+p3+V/vzhPMA/msUZ77yIVlQAgFsXU+upv78WZodggCnf195UGEKRbiY
	 HAXZhskgmStNg/x4pyxsQhX4mXQhI6EE1TDx7m9TAYThpk88+EeglZ1VpJLIefkwX4v0T
	 T7gyzNFQINTDoDzP7i8v0LzsFRAD5A6VSImP5NeSe4yO35uEJHb8xrmviinI3uM/tbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590408;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=n3MLBtiYeIpiEnkA99VPmmYVKGU+MSxkyWa6TupOZME=;
	b=m+oyFQ+oO4c/A8AEn5ezStwdg+yz/adQixmBvUdi8s3LrHk3SZ09MFGrIjxLFOdomIYn
	 iI0cITJ3vURZwh5gmS0X8fJ8h3w6VxcoHho9utoncJb7ppcwr8o0eL0iBwXmKVSoF4dhW
	 76iD/kS+u7Cag352TvpErP3SuopXogdWFrUVaZaclD+N5Vn7nKgy6mXpXzDg3c3l4P7wA
	 M8sQEoMOQ4h5JBiiqN3wPQD4EqvXiCOhCKtJ5PyoeN1LrGQAVR4w/MUxmJvyYNJO9YF/4
	 jDUhoskBvxal4ZmjYj/kjSNz/idtfJaL3HmC0R/kctfkHEd8W72wIhvOuUj+3/WDs+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvnhU81u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2696E606A68B;
	Wed, 25 Nov 2026 07:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvnhU81u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E01F01565;
	Wed, 25 Nov 2026 07:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590407;
	bh=n3MLBtiYeIpiEnkA99VPmmYVKGU+MSxkyWa6TupOZME=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=mvnhU81ukFk5RPexZr6HPjyrO1NfEQODZo2ujvLPl5ecmACid33CViEQj0CTeM3A6
	 G7xz5xJ3DxrsPpb/57zI4thfMa3tDOJS+8LVmhNci+avMsmh2ATVH+bdbBUhMZxcuU
	 yNUzBMz0DyDAUR0Thk0LBJUgwRAqzg85tg8eLRoYvyUUM9PcTpmVvtAZ2eZXO0nZNE
	 b3IM9zN4uBaGh1t9SQ2cN660rMzMBVr/I5/FVsI+a1nxl09rKrPZ7cgTtvvotfMNE9
	 TQMsxHAgK9a/kJVpCqfFoazhonhLnVPDfP8yk3o+6Slox6XWt8NgIVePklvnM23Gt8
	 rROh2bXY1AMQQ==
Content-Type: multipart/mixed; boundary="===============2007885903183298956=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <b0d84d31f548d5426a26b626146b21ffacaeae455c7dac4353fe4955536a3c2c@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-20-irogers@google.com>
References: <20261125061523.1540234-20-irogers@google.com>
Subject: Re: [RFC PATCH v2 19/30] riscv/unwind: Add Minimal DWARF CFI kernel unwinder
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:42 +0000 (UTC)

--===============2007885903183298956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv/unwind: Add Minimal DWARF CFI kernel unwinder

TL;DR: Without KEEP(), GNU ld --gc-sections (LD_DEAD_CODE_DATA_ELIMINATION)
may discard the core kernel .eh_frame in vmlinux.lds.S, so the DWARF CFI
unwinder would fail silently for every kernel PC and degrade stack traces.

> diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
> --- a/arch/riscv/kernel/vmlinux.lds.S
> +++ b/arch/riscv/kernel/vmlinux.lds.S

[ ... ]

> @@ -125,6 +125,19 @@ SECTIONS
>  		*(.srodata*)
>  	}
>  
> +#ifdef CONFIG_UNWINDER_DWARF_CFI
> +	.eh_frame_hdr : ALIGN(4) {
> +		__start_eh_frame_hdr = .;
> +		*(.eh_frame_hdr)
> +		__stop_eh_frame_hdr = .;
> +	}
> +	.eh_frame : ALIGN(8) {
> +		__start_eh_frame = .;
> +		*(.eh_frame)
> +		__stop_eh_frame = .;
> +	}
> +#endif

Can the core kernel .eh_frame be discarded here when linking with GNU ld
and CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y?

riscv selects HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !LD_IS_LLD, and the
top-level Makefile then adds --gc-sections to LDFLAGS_vmlinux.
UNWINDER_DWARF_CFI in arch/riscv/Kconfig.debug does not exclude that
option.

Nothing references the .eh_frame input sections, and the
__start_eh_frame/__stop_eh_frame assignments do not keep them alive, so
without KEEP() the garbage collector would be free to drop them.

If that happens, .eh_frame_hdr would have no FDE table and
dwarf_cfi_unwind_eh_frame_hdr() would return -EINVAL for every core
kernel PC.  Oops, WARN and perf/BPF callchains would then shrink to the
heuristic fallbacks, and arch_stack_walk_reliable() would always return
-EINVAL, with no build or runtime warning.

The other sections in this file that nothing references use KEEP, for
example .alternative and __soc_early_init_table, and the riscv vDSO
script uses:

    .eh_frame : { KEEP (*(.eh_frame)) }

Should this be KEEP(*(.eh_frame)), or should UNWINDER_DWARF_CFI depend
on !LD_DEAD_CODE_DATA_ELIMINATION?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============2007885903183298956==--
