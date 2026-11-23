Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394423;
	b=ESMgCN9ZZgoS4z/OCBgyB3HS9Dkn7roBbXCGgoe35Ibe/HG6SZuPVQGQcYN+HLWXOWnE
	 BlN2W1ci7YBloCUWrCri8VV/P4lOrVx6MzF5C3/5EfV1VD6rrRRgqgwLvxzQAAwweQO0t
	 q6XK9/AJrTD0FmL22vCSnv9ppblFPPYLQkP0IUuOkg1DlJuQ7wy0rKARDKluK8uygEFAj
	 O/jqyJQo2jtXL+Gt7ZFswjgaFYFQ4psrUMrvUYDuICjV2cgRBegfDL25fMFzVAZykVUv/
	 oj+ugR6cUM/To8iCfZzTqaSaVsRjlnOZhsmA3HCh4U0J+1tRgJpk+NLP7gHZvEnABag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394423;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=vvX7FxyAeqZ8LNbdDutoA2XUQbgC5esuzUM1lgllSu8=;
	b=YE3q5Ur8dEZQAySLUOJAL7cF4qRjQCHPo7aZ4GN5OzZKWfqFJEAuXmuK/8+es0R33drn
	 d1+OvY8aAVA89uZHBkRGt56937QL5QSUgyH1FtZjAGkCTkHizfLtvugVBdz1R2AtsEztE
	 Qe+slYZuR4bCpxJeJ51mrYqFU+Pe5Z0lP4jfAfTEBs1XNZMdZmSXS/61PktMo+cZbKWuG
	 3AdTu4Dy5nuJa+YGc6ySxKTOH3i8NO4Ilz82hay4rUGHNnn29p8sUnbPP496L37tWzetA
	 qkLsbWxPPRlYlsNx9ZMGtj2klur/qGU/xrXdapNYzMjtiYoPmfmTU8sKuu9w+kO8GTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXEHzbfF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D5606A69A;
	Mon, 23 Nov 2026 00:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXEHzbfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FBE1F000CF;
	Mon, 23 Nov 2026 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795394422;
	bh=vvX7FxyAeqZ8LNbdDutoA2XUQbgC5esuzUM1lgllSu8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=JXEHzbfF8FivyAPYlaHLt/sjbu+sMiIjeW4J+JAcZF6DHPGHnSyZEpAWSwINg/QtG
	 qMvwlT/dWevDFNZE3EmB0+EkujzNQv14fIUwxBlg1u97hvPQJwRQnnmknUtnGSLqKp
	 +w5Um1rJbFy/7SBBmUFzG6PI0EN+0XZSOaBoPzsvzRgHkXsEq4GgASFguFoLMWjWp8
	 pki1qgTUTfJ2n1dkykh8Sx93oxX6Z8qzQ4/xFm3kvMlIB6UOQ+FNx+6SDa9dAoC1g2
	 a4qmqFwXmDraqu/60o0Pgvn+4KIPfMe0B0GUm210pl1FgrO0ZXdh5vy5fgaMO4wlqy
	 O+/vKLTVv+O+A==
Content-Type: multipart/mixed; boundary="===============5817084910596839964=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <7e1d3d4067c817a0ae6137044406af1138613ce289199ca065c65fc6d611f990@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-4-irogers@google.com>
References: <20261122235757.3456048-4-irogers@google.com>
Subject: Re: [RFC PATCH v1 03/11] scripts, unwind: Add build-time .eh_frame minifier
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:40:18 +0000 (UTC)

--===============5817084910596839964==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> scripts, unwind: Add build-time .eh_frame minifier

TL;DR:
- On big-endian build hosts, min_eh_frame may silently skip minifying every
  object, so the size reduction is lost
- Kconfig depends on UNWINDER_DWARF_CFI, which is defined only later in the
  series
- min_eh_frame is missing from scripts/.gitignore

> diff --git a/arch/Kconfig b/arch/Kconfig
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -528,6 +528,16 @@ config HAVE_UNWIND_USER_CFI
>  	select UNWIND_USER
>  	select UNWIND_DWARF_CFI
>
> +config UNWINDER_DWARF_CFI_MINIFY
> +	bool "Minify .eh_frame tables at build time"
> +	depends on UNWINDER_DWARF_CFI

A subsystem pattern flags this as potentially concerning: a depends on
naming a symbol that no Kconfig file defines.

UNWINDER_DWARF_CFI is not defined anywhere at this commit, so this option
evaluates to n on every architecture.  That leaves the hostprogs-always
entry in scripts/Makefile, the cmd_min_eh_frame hooks in Makefile.lib,
Makefile.build, Makefile.vmlinux_o and rust/Makefile, and
scripts/min_eh_frame.c itself unreachable here, so the results quoted in
the commit message cannot be reproduced from this commit.

The symbol is defined later in the series, in 6cf5792e969e ("x86/unwind:
Add Minimal DWARF CFI kernel unwinder"), efdfa5f38673 ("arm64/unwind: Add
Minimal DWARF CFI kernel unwinder") and 90a680847a32 ("riscv/unwind: Add
Minimal DWARF CFI kernel unwinder"), so this looks like a forward
reference rather than a misspelling, and bisection is not broken.

Would it make sense to reorder the series so the unwinder Kconfig symbol
comes before its consumers?

> +	default y
> +	help
> +	  Strip unneeded callee-saved register opcodes and coalesce PC-advance
> +	  bytecodes in .eh_frame sections at build time, reducing kernel unwind
> +	  table memory usage while ensuring only Minimal DWARF CFA bytecodes
> +	  remain in vmlinux and modules.

[ ... ]

> diff --git a/scripts/Makefile b/scripts/Makefile
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -12,6 +12,7 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
>  hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_builder
>  hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_gen
>  hostprogs-always-$(CONFIG_TRACEPOINTS)			+= tracepoint-update
> +hostprogs-always-$(CONFIG_UNWINDER_DWARF_CFI_MINIFY)	+= min_eh_frame

Should /min_eh_frame be added to scripts/.gitignore?

Every other host program built here has an entry there (/kallsyms,
/sorttable, /tracepoint-update, /insert-sys-cert, and so on), and
git check-ignore -v scripts/min_eh_frame matches no rule.  After an in-tree
build with the option enabled, the binary shows up as untracked and could be
picked up by git add -A.  No later commit in the series adds the entry.

[ ... ]

> diff --git a/scripts/min_eh_frame.c b/scripts/min_eh_frame.c
> new file mode 100644
> --- /dev/null
> +++ b/scripts/min_eh_frame.c

[ ... ]

> +int main(int argc, char **argv)
> +{

[ ... ]

> +		if (memcmp(map, ELFMAG, SELFMAG) == 0 &&
> +		    map[EI_DATA] == ELFDATA2LSB &&
> +		    map[EI_CLASS] == ELFCLASS64)
> +			rc = process_elf64(map, (size_t)st.st_size);

main() checks that the target object is little-endian, but not the byte
order of the host the tool runs on.  process_elf64() then reads and writes
the ELF header, section header, symbol and Elf64_Rela fields as native
structs, and only the .eh_frame payload goes through get_le32()/put_le32().

On a big-endian build host cross-compiling an x86_64, arm64 or riscv64
kernel, the first check in process_elf64() sees the bytes 01 00 of e_type
as 0x0100:

    if (ehdr->e_type != ET_REL)
        return 0;

Won't every object then be silently left unminified while the build still
succeeds?  CONFIG_UNWINDER_DWARF_CFI_MINIFY is default y and its help text
says only Minimal DWARF CFA bytecodes remain in vmlinux and modules, but on
such a host nothing is stripped, coalesced or dropped, and nothing reports
it.

Other ELF host tools in scripts/ handle this: scripts/elf-parse.c picks
rle/rbe accessors from EI_DATA, and scripts/mod/modpost.c applies
TO_NATIVE() to the ELF header fields.

The resulting kernel should still work, since kernel/unwind/dwarf_cfi.c
parses unminified CIEs and FDEs, but the documented size reduction would
not apply.

Could this either fail the build with a message when the host is not
little-endian, or read the ELF header, section, symbol and rela fields
through le16/le32/le64 accessors as elf-parse.c does?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============5817084910596839964==--
