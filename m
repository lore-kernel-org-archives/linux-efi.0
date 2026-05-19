Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1DF2DA756;
	Tue, 19 May 2026 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217834; cv=none; b=TMDpk2jjESYpvnvoRkBjZhlGgjZ30GTtGChNJKo9gVvb6EH/UVuLTm8zF6Q2jcwm6yfvQin/eLcHl4NJG2oTqa3C2ULiF7qmW+F+L0HsXcBiu/WsJSdeRAJf1LHMpuSbt95Hu1MlM1onVA2BkEPnJL1RwB2kWLdr0yuSjbfcz6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217834; c=relaxed/simple;
	bh=jiIWfMA/RNWQsPN7OPtmXFk3Boi9ysbWIn6YyQ+sgZE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=W5wKe6HfS/RzRXBwCt3lrnFt2rFzAp19YBnmjtUu8dwhh96KLUujt2f+CvPzPQv0EI3bliBmNTg3klrRx+k7srvgsQYWRQTbSub1cIdKGa25e9I76blgT3skNRYkeJ2RppHU0fKSNHUlXQfce/tWYDEwhRo6dM/RUyCLf15+Dbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ds7OmLDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ds7OmLDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336F51F000E9;
	Tue, 19 May 2026 19:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217832;
	bh=fgNZdK3NJsaTp5IvqSVDZRft25fsIJfb+L1i4SHqdtA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ds7OmLDkvieL4R92S3Zhu9KQe+lkz4nqE5rwqXqvFxRW9Rc9cfTflUhCYGVpKwCG0
	 auLpjWdgmZimtBBjpQje2vujXXAI5UfyXliSqdTHZXTKvAGvMvHLLWBOtOfTMX3PI3
	 YLtBoq/8zqaAzKZpG4uqyrBcIN2LgMQStvd4aTtY=
Date: Tue, 19 May 2026 12:10:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Charlie Jenkins
 <thecharlesjenkins@gmail.com>, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti <alex@ghiti.fr>, Ard Biesheuvel <ardb@kernel.org>,
 linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 0/8] lib and lib/cmdline enhancements
Message-Id: <20260519121031.95ff192c46f02eb05e847e42@linux-foundation.org>
In-Reply-To: <20260519172259.908980-1-dmantipov@yandex.ru>
References: <20260519172259.908980-1-dmantipov@yandex.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 May 2026 20:22:51 +0300 Dmitry Antipov <dmantipov@yandex.ru> wrote:

> This series is a merge of the recently posted [1] and [2]. The first
> one is intended to adjust '_parse_integer_limit()' and 'memparse()' to
> not ignore overflows, extend string to 64-bit integer conversion tests,
> add KUnit-based test for 'memparse()' and fix kernel-doc glitches found
> in lib/cmdline.c. The second one was originated from RISCV-specific
> build fixes needed to integrate the former and now aims to provide
> platform-specific double-word shifts and corresponding KUnit test.
> 
> This series was briefly tested on X86, RISCV32, ARM, and MIPS using QEMU,
> and compile-tested for LoongArch32 as well.
> 
> Getting feedback from RISCV core maintainers would be very helpful.
> 
> Special thanks to Andy Shevchenko, Charlie Jenkins, and Andrew Morton.
> 
> [1] https://lore.kernel.org/linux-riscv/20260403103338.1122415-1-dmantipov@yandex.ru
> [2] https://lore.kernel.org/linux-riscv/20260427090105.705529-1-dmantipov@yandex.ru

Thanks.  I updated mm.git's mm-nonmm-unstable branch to this version.

Below is how v11 altered mm.git.  Please note that it's conventional to
changelog the updates in the [0/N].  I see it there in the [6/8] and
[7/8] changelogs:

v11: add prototypes to arch/riscv/include/asm/asm-prototypes.h (Sashiko)
v11: explicitly depends on arm/xtensa/microblaze or 32-bit riscv/sparc (Sashiko)


 arch/riscv/include/asm/asm-prototypes.h |    4 ++++
 lib/Kconfig.debug                       |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/asm-prototypes.h~b
+++ a/arch/riscv/include/asm/asm-prototypes.h
@@ -5,6 +5,10 @@
 #include <linux/ftrace.h>
 #include <asm-generic/asm-prototypes.h>
 
+long long __lshrdi3(long long a, int b);
+long long __ashrdi3(long long a, int b);
+long long __ashldi3(long long a, int b);
+
 long long __lshrti3(long long a, int b);
 long long __ashrti3(long long a, int b);
 long long __ashlti3(long long a, int b);
--- a/lib/Kconfig.debug~b
+++ a/lib/Kconfig.debug
@@ -2974,7 +2974,7 @@ config BITS_TEST
 config SHDI3_KUNIT_TEST
 	tristate "KUnit test for __ashldi3(), __ashrdi3(), and __lshrdi3()"
 	depends on KUNIT
-	depends on (32BIT || ARM)
+	depends on ARM || XTENSA || MICROBLAZE || ((RISCV || SPARC) && !64BIT)
 	help
 	  This builds the unit test for __ashldi3(), __ashrdi3(), and
 	  __lshrdi3() helper functions used to implement 64-bit arithmetic
_

