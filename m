Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590333;
	b=ipAzBs8e2LGXFsKq6m/08LVz6Po51pz+temFPLd0MXb7app08PwFv1KZdxWtQ7+KKFfy
	 O6LbraNp/88V++2IMfpZ7neICDvqbUbugkjnr4TzHdbgPIa1wz1lE5Z8jQCNAXWe6Y3LT
	 hetF92rFlfAhIPD8zwZ4GR5Uo6DmxmkJdGEkygIdjHLNAMkNamvrCth5m9rKzFQGJYnPM
	 38IXUZZ5BaOaLO8xnBBRD7GOdy6g0BzNULa1k5+/b9CwBXOHshk3C9DWQABPi9bIihv1I
	 ZQ7icV1G2K/2cAJ5SW6a8JhsEQvG0+Q1lAc2f7MiV9q8shmCToSn1EWlCEWjT1qsecA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590333;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=oY0rx5TQF/hPAT2fp/OqppYSUqnj9x266slaImcxxI8=;
	b=e14bawmH0nw+A4ztGPiU7+LLz8sZc6ds5u4baksEndHl8/22zvvUSLUzOzWnZwCEA0Ih
	 iRmIBrhzm9ODoI5Djl5bz/rvMX3oNPLkC3GzgLSsgQv9Wu52ulsheZbu2NJUUiI0yQTin
	 WMX2zgpZcX7h9sRG9FX1990zkwnf0SleY3IVWBxzbEkU+zQHyNzG4bB0VCr5JC3jeYIim
	 vajt4UQSsEGvbY4vIgtq8nQYQgmTYD9nKelLND48l+mzGqkbEMZSlVScBQMQqB28fhrU+
	 48qJhO1W1GBY5kvoVa2g8rNGAhi9/FjlNqYRRFW/oGr5N4duuQbmdHmPH3hTmsQOmXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkVvS+OF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B47F606A321;
	Wed, 25 Nov 2026 07:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkVvS+OF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE9C1F01569;
	Wed, 25 Nov 2026 07:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590333;
	bh=oY0rx5TQF/hPAT2fp/OqppYSUqnj9x266slaImcxxI8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=BkVvS+OFWxcEyUnwscVtdtKPmqsRWwvopXk56h+zXZQAoZ/h2wL+MD8SQMN86bqQR
	 2uImi9ia77CGaDTgSxCbZrZxBaOucb8WMt1P4U1aZubqQ8luti7eE7pTGVbFC5+cwj
	 Mu0kvKWXbaYXzoBoexes8vdN20iYhHqHoJGSEblWV/piowNn9rPxxRr6QV4KTYMewu
	 +GK0LDN2Jm/p2oUxeA1sdIlLOXcTgVbbyfwI9+CNvY2KiccpnO/Wcg3XChnfblbsF+
	 vLS7VXOEyQ4D9SSyVeJVqT0OqE55F/HzqqLaYQzPvdVPnltFksbCmR9k2OlZLYIL8W
	 37RPucQuuHBlg==
Content-Type: multipart/mixed; boundary="===============0970350896364781427=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <b05067a07bd4d9c4a038deda4d8dced4a84bfc13a0dee3e89bfe1a092a679dce@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-4-irogers@google.com>
References: <20261125061523.1540234-4-irogers@google.com>
Subject: Re: [RFC PATCH v2 03/30] unwind_user: Support Minimal DWARF CFI user-space unwinding
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:28 +0000 (UTC)

--===============0970350896364781427==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> unwind_user: Support Minimal DWARF CFI user-space unwinding

TL;DR:
- Possible misclassification of executable private /dev/zero mappings as ELF
  bases in user_cfi.c; likely harmless (extra user read, or CFI from
  user-written bytes if ELF-like)
- Commit message nit: explain why CFI unwinding is needed

> unwind_user: Support Minimal DWARF CFI user-space unwinding
>
> Extend the generic user-space unwinder (kernel/unwind/user.c) with
> UNWIND_USER_TYPE_CFI (CONFIG_HAVE_UNWIND_USER_CFI), resolving ELF
> PT_GNU_EH_FRAME headers across executable VMAs in kernel/unwind/user_cfi.c.
> Key design details:
>  - Find the executable VMA and its base ELF mapping (vm_pgoff == 0)
>    under mmap_read_lock_killable(), then drop mmap_read_lock() before
>    issuing any faultable copy_from_user() reads.
> [ ... ]

this isn't a bug, but could the changelog say briefly why CFI-based user
unwinding is needed, for example what fails with frame pointers alone,
before it lists the design details?

> diff --git a/kernel/unwind/user_cfi.c b/kernel/unwind/user_cfi.c
> new file mode 100644
> --- /dev/null
> +++ b/kernel/unwind/user_cfi.c
> @@ -0,0 +1,392 @@

[ ... ]

> +static bool lookup_vma_elf_base_locked(struct mm_struct *mm, unsigned long ip,
> +				       unsigned long *vma_start,
> +				       unsigned long *vma_end,
> +				       unsigned long *elf_base)
> +{
> +	struct vm_area_struct *vma = vma_lookup(mm, ip);

[ ... ]

> +	if (vma_is_anonymous(vma) || !vma->vm_file) {
> +		if (vma->vm_pgoff == 0) {
> +			/* Special mappings such as [vdso] */
> +			*elf_base = vma->vm_start;
> +			return true;
> +		}

A subsystem pattern flags this as potentially concerning: this branch is
entered for vma_is_anonymous(vma) || !vma->vm_file, and vm_pgoff == 0 is
then taken to mean a special mapping such as [vdso].

For a purely anonymous VMA, vm_pgoff equals vm_start >> PAGE_SHIFT, so that
works.  A private /dev/zero mapping is also vma_is_anonymous(), but vm_file
is set and vm_pgoff holds the file offset passed to mmap(), usually 0.

Can an executable MAP_PRIVATE /dev/zero region at offset 0 be classified as
an ELF base here, so that *elf_base = vma->vm_start is returned and
find_user_eh_frame_hdr() parses the first bytes of the region as an ELF
header instead of negative-caching it?

The guide's safe forms are to test vma_is_anonymous(vma) && !vma->vm_file,
or to use vma_start_anon_pgoff() for the anonymous offset.

On the other side, the misclassified region is the task's own memory and is
only read through copy_from_user().  JIT code at vm_start would normally
fail the ELF magic check, so parse_user_elf64_eh_hdr() or
parse_user_elf32_eh_hdr() would return -EINVAL, the slot would stay
negative-cached and unwind_user_next() would fall back to FP.  The visible
effect would be one extra user read per walk, or CFI evaluated from
user-written bytes if the region happens to start with an ELF header.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============0970350896364781427==--
