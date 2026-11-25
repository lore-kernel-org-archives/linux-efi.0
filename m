Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590353;
	b=4rswo5CWnZU3wnwhaTogRlX03B48t46FLkXBvGFtLaQrXCiGj62Sx56Fw/T2bm3P38WV
	 16rISQl8vIw7yC8IGtQ8j2vTnauCasJIWMTXwxC5eDSOa5biZtrAvi5jHS2qKrwMn/1O7
	 FHs8i+/I9OFmyWch1xGZr59oaRbgackPDlvN5WcfJkEZZGl38vOFuBKOKX3LfA9Z8T0cu
	 IS+Kw57PNqQ7nLYBjAhfsbghYG2JgRIqO66EU5HH8qczMIT722OYiSEuJEY9oUr+S4az+
	 IQUGvkv+fTW+/+g5TrZDe9Zyo9dZjRmZJ2HNkuTFaA/NMNjlPX8PeexORmFQKnrNyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590353;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=eY8MxL4CQsiYqvHInHyteTrR1VjWiJ0DqyBDBb2ppMM=;
	b=FuGHNS8WoDNucip8AXPuPBd4PvgbCPYO6JjVhLOsAwExRkh/zFKTnWNOnqFAlxMhGZzE
	 IPyJ7ZmubZ34CMCO9y/vzkADeIlZCinm1ZPmOFrO+xPqoToi51rwS+nVOm9SYrjzzWwI5
	 En9E2y/zBPCf3rnuzqPgjShDe7WIJtybbpQ2cAb93jS1sg6BdX1e0BZTEdcO+YBILyPXj
	 EF6AEUkw2jxL66ZxjV5B5f5BrbCXHAZDou0c4vCSwQVNWuxvTQ30JmJTBqvX6RlUU1nM+
	 FIRoRULC/V51TzSH9CRch+EBMSprhYMMBKCE/Lj1EFNKA+B8x7VuOsIaFZqZfB/kbNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mae69HOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99A3606A321;
	Wed, 25 Nov 2026 07:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mae69HOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05151F00A36;
	Wed, 25 Nov 2026 07:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590353;
	bh=eY8MxL4CQsiYqvHInHyteTrR1VjWiJ0DqyBDBb2ppMM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=mae69HOvNQF9iQmI9mch+Buz/1p55Vrhqg5GHI/FdhPJ1Spt80vXovSrv+jIYfmHC
	 NFnqRJ8MRH6Khi2QuQ3siO1GiDVva/m9Gf138mpYqxIunhIoVx0NILfAhA4jCwQums
	 42Dpu0zZVX7VxsAn+bK/23NrzJYqWYOXj/dTDvrw4e2ZsSeKFHSitMKlsiWfHmoRIC
	 iki4HZdpMKVDUdfKadRjNbm2iUhlzqZ2iSQjYc+OV7zNvHUu7RpIZiPFiHZQaik0rO
	 0PKeesZeBT8Z/tK5uLiWpN/lH7FqCp8mRZF+mvHaxDIfXwo8VnWYepsjJ/K60cyuHf
	 9rG+fRZfX9+1A==
Content-Type: multipart/mixed; boundary="===============1142665870477895472=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <1c6ad7441ca027dcd0f305477f5e65c82e85f5b049d06a8970bcfb67aa451162@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-21-irogers@google.com>
References: <20261125061523.1540234-21-irogers@google.com>
Subject: Re: [RFC PATCH v2 20/30] selftests/perf_events: Add Minimal DWARF CFI deferred user unwind test
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:48 +0000 (UTC)

--===============1142665870477895472==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/perf_events: Add Minimal DWARF CFI deferred user unwind test

TL;DR: Test issues only, low severity: unwind_user_cfi.c includes a
kernel-internal header and #undefs macros, and may report "not ok" instead of
skip when perf_event_open returns ENOSYS.

> diff --git a/tools/testing/selftests/perf_events/unwind_user_cfi.c b/tools/testing/selftests/perf_events/unwind_user_cfi.c
> new file mode 100644
> index 000000000000..a36e9f4d39e2
> --- /dev/null
> +++ b/tools/testing/selftests/perf_events/unwind_user_cfi.c
> @@ -0,0 +1,482 @@

[ ... ]

> +#include "../kselftest.h"
> +#undef __always_inline
> +#undef __attribute_const__
> +#undef __must_check
> +#undef __printf
> +#include "../../../../include/linux/compiler_attributes.h"

This isn't a bug, but would it be simpler to spell the few attributes this
test needs directly, for example __attribute__((noinline, noclone)) and
__attribute__((aligned(64))), instead of including
include/linux/compiler_attributes.h and #undef'ing the clashing macros
first?

From tools/testing/selftests/perf_events/ that path resolves to the
kernel-internal include/linux/ header rather than a tools/include copy, and
no other selftest includes a kernel-internal header this way.  Also,
__must_check is not defined by either earlier include, so that #undef
appears to do nothing.

[ ... ]

> +	fd = (int)sys_perf_event_open(&attr, /*pid=*/0, /*cpu=*/-1,
> +				      /*group_fd=*/-1, /*flags=*/0);
> +	if (fd < 0) {
> +		if (jit_page != MAP_FAILED)
> +			munmap(jit_page, page_sz);
> +		if (errno == EACCES || errno == EPERM || errno == EINVAL) {
> +			ksft_test_result_skip("perf_event_open(defer_callchain) unavailable: %s\n",
> +					      strerror(errno));
> +			ksft_finished();
> +		}
> +		ksft_exit_fail_msg("perf_event_open failed: %s\n", strerror(errno));
> +	}

Should ENOSYS be treated as a skip here as well?

On a kernel built without CONFIG_PERF_EVENTS, perf_event_open is a
COND_SYSCALL and returns -ENOSYS, so main() reaches ksft_exit_fail_msg()
and the runner records "not ok" instead of a skip.  The selftests guide
flags exiting nonzero other than KSFT_SKIP when a feature or config option
is missing.

The other missing prerequisites in main() (unsupported architecture, no
PT_GNU_EH_FRAME, defer bits unknown to an older kernel) are already
reported as skips, so adding ENOSYS to the errno check would make this case
consistent with them.  The neighbouring perf_events tests also fail rather
than skip when perf_event_open() fails, so this is low severity.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============1142665870477895472==--
