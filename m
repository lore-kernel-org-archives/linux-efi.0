Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165241F346;
	Mon, 14 Sep 2026 09:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377741; cv=none; b=bsp2zc58HvrLtb5zEoWMVx7Vd//b45EnqSHjdQtDWaoVqWINhuXk05TpxzqU0uR8iOdbOyQC+NCWgJwaJnEl2o79ElkPhXP3+UDBNQxtNWte5fVkec3djrk1lOH5LBaHJSudhxyQSxKuQ6KTpjqNjv8ffYtZ0vCk56oZ3+dlhBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377741; c=relaxed/simple;
	bh=F8WfQDMkV22k7Xee/QxYJu6nbqqC5fAW05GHdYushLY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZnRXYEE1QAOhTbMpXYnobD7VLKgdZU0DO7rz8xmm4ferurCvzwPvr+SKHoW3rf5DNGuNaglW3VE1rqg6GYAVBk/YVMgNjxyVKrNAbBdnFSzmzix2TJLhrtjenV3YmFR+U444L2OqYF8EMebDX2KRMyPI/7ZTcexLqw5A0P2rZpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1upJ6Sd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1upJ6Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B371F000FF;
	Mon, 14 Sep 2026 09:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377739;
	bh=hHSj9n82z6aW6OsnFuS1F6nFyt7m0H5Cd4xsZmRoDCU=;
	h=From:Subject:Date:To:Cc;
	b=P1upJ6SdarkTy1XPA9CR99tJ3iKa+/ElopdvjjcyC8GXgFdRR3XHJz7Yoj5ZAAS1C
	 u1W+utqDSXzDUjUnyxVTDTttzQD2hOkgxX5dy5gdjIpZig9/cvmq14lvATGvqYIvmx
	 nyx30RHcxGJV9/2lTwklM4T+veew0ya2OEoYBwDnxuOpDzKgfKSTr/3U+vDrF9h6OJ
	 LZh/d2O3vG/oKe9cCOD3xZU8myn6gVSQex3/4NwG/Se/qyejImBP6Qdk391Nvq9xgF
	 4PCe2lw7WJ8/Onra7mCkWeuYoqGrER/gyEf7REdEu/Kxtc62HahbFTsAu/SaUZWg8T
	 HCMypY18zbcbA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
Date: Mon, 14 Sep 2026 10:21:59 +0100
Message-Id: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/12NQQ6CMBBFr0Jm7ZhpFVRW3sOwgHaEUVJIC0RDu
 LsF48blS95/f4bAXjhAnszgeZIgnYugdwmYpnQ1o9jIoElndKEjVqO0FkPPbMcedcpKlUTVwRL
 ETe/5Lq+tdyu+HMbqwWZYI6vRSBg6/94OJ7V6v/b5rz0pJEytUaUhlZ20vT7ZO273na+hWJblA
 yvfueK9AAAA
X-Change-ID: 20260904-build-speedup-25e11a00b3d0
To: Linus Torvalds <torvalds@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 linux-hardening@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=16058; i=ljs@kernel.org;
 h=from:subject:message-id; bh=F8WfQDMkV22k7Xee/QxYJu6nbqqC5fAW05GHdYushLY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW79n9KdVa5c3h3VGNJycHPDdgZFAWX+HpKp+k97AwQ
 Zc1ZKpmRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYibs7IMDmUYZ9U6fKdE/8+
 YNnot5qNbzMjg9KZ1F9zzzzdlxfc78vwv4j31bJDFhFxzHsfqFctUMpfvGr/sXDbe8d0as+y79k
 azwUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

A typical kernel build consists of a frustratingly large amount of time
spent stuck in single-threaded bottlenecks.

It turns out that there's a lot we can do about this and doing so
significantly impacts kernel build times.

This series makes allmodconfig builds up to 36% faster, incremental builds
up to ~70% faster, and noop builds up to ~90% faster.

Builds are faster across the board on every device I tested.

Machines used for perf testing:

* Threadripper -   x86, AMD Threadripper 9980X, 64 cores, 128 threads
* EPYC         -   x86, 2 socket EPYC 9754, 256 cores, 512 threads
* M2           - arm64, 2022 M2 macbook pro, 8 cores, 8 threads
                        (4 perf, 4 efficiency)

Cutting to the chase:

		== IMPORTANT NOTE on dependencies/build configuration ==

Performance numbers are based on a build which:

* Has these series applied (as these supersede changes from a previous
  version of this series):
	https://lore.kernel.org/linux-modules/20260731-module_ver_remove-v2-0-c9163858f382@linuxfoundation.org/
	https://lore.kernel.org/9d4b8ccfed745ac47a954aa2e1de62a85197122d.1788899473.git.jpoimboe@kernel.org/
* Runs `make KBUILD_RUST_THREADS=8 -j $(nproc) ...`.
* Runs with the pigz tool installed locally.

		== allmodconfig FULL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc       344.2s   278.6s    -65.6s (-19%)
Threadripper, clang     342.6s   266.8s    -75.8s (-22%)
EPYC, gcc               188.0s   121.1s    -66.9s (-36%)
EPYC, clang             259.5s   184.6s    -74.9s (-29%)

		== allmodconfig INCREMENTAL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        40.1s    15.4s    -24.7s (-62%)
Threadripper, clang      40.3s    15.6s    -24.8s (-61%)
EPYC, gcc                70.9s    24.3s    -46.6s (-66%)
EPYC, clang              70.4s    24.3s    -46.1s (-65%)

		== allmodconfig NO-OP build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        15.3s     1.4s    -13.9s (-91%)
Threadripper, clang      16.2s     1.8s    -14.4s (-89%)
EPYC, gcc                30.6s     1.5s    -29.1s (-95%)
EPYC, clang              32.3s     2.2s    -30.1s (-93%)

		== defconfig FULL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        32.5s    26.3s     -6.1s (-19%)
Threadripper, clang      34.5s    27.2s     -7.3s (-21%)
EPYC, gcc                28.7s    20.6s     -8.1s (-28%)
EPYC, clang              39.8s    32.2s     -7.6s (-19%)
M2, gcc                 519.3s   512.4s     -6.9s (-1%)
M2, clang               634.5s   569.4s    -65.1s (-10%)

		== defconfig INCREMENTAL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        11.2s     6.0s     -5.3s (-47%)
Threadripper, clang      11.3s     5.4s     -5.9s (-52%)
EPYC, gcc                18.6s     9.2s     -9.4s (-51%)
EPYC, clang              19.6s     8.6s    -11.0s (-56%)
M2, gcc                  18.0s     9.9s     -8.1s (-45%)
M2, clang                18.1s     8.2s     -9.9s (-55%)

		== defconfig NO-OP build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc         1.1s    0.60s    -0.50s (-45%)
Threadripper, clang       1.3s    0.66s    -0.63s (-49%)
EPYC, gcc                 1.7s    0.66s     -1.0s (-61%)
EPYC, clang               2.0s    0.80s     -1.2s (-60%)
M2, gcc                   6.4s     1.7s     -4.7s (-74%)
M2, clang                 7.1s     1.7s     -5.4s (-76%)

Further performance numbers are provided for each commit giving a sense of
what each contributes to the final result.

			== Testing ==

Beyond x86, allmodconfig was built with the series for arm64, arm, riscv,
powerpc64, s390 and loongarch, and for arm64, arm, s390 and loongarch the
System.map is identical to what the previous shell mksysmap produces for
the same vmlinux.

Also tested were parisc64 and m68k build as far as mainline lets them
(a driver's static assertion and an undefined-symbol check on parisc, gcc
16 internal compiler errors on m68k, none of it from this series).

Kernels for x86, arm64, arm, riscv, loongarch, powerpc64, s390, m68k and
parisc64 all boot under qemu, every text symbol of System.map is in
/proc/kallsyms at the relocated address, and a module loads and unloads.
The s390, arm and loongarch kernels also pass the kallsyms selftest.

An x86 kernel with CONFIG_MODVERSIONS, CONFIG_EXTENDED_MODVERSIONS and
CONFIG_MODULE_SRCVERSION_ALL boots, loads and unloads modules. External
modules build against both in-tree and O= builds, and every commit builds
on x86 defconfig.

Build times are the best of several runs, no unexpected errors or
warnings were seen.

While some aspects of the build process have been changed, all tooling
should function identically to before.

			== LLM usage ==

An LLM was used to first determine where the bottlenecks were then to
figure out how to improve them.

It generated a lot of code, much of it hideous.

I extensively audited and rewrote a lot of it, and heavily edited commit
messages, the cover letter and comments.

The LLM has also orchestrated build runs, testing, debugging and analysis.

I have manually checked for correctness in both build and running kernels
generated with this series applied.

Performance improvements were also verified manually.

Since an LLM was used extensively, each commit carries an Assisted-by tag.

			== What was changed? ==

Fundamentally the series improves build times by parallelising
single-threaded tasks as much as possible and improving the efficiency of
code used in the build process.

kbuild, kallsyms, modpost, objtool, mksysmap and the rust build system were
all updated as part of this change.

Nothing too controversial was included. There are further improvements that
could be made, but they would either by very invasive (large scale C header
changes) or generate diminishing returns.

			== Patches ==

   kbuild (1):       Make .modinfo an INFO section.

   kallsyms (2, 3):  Some efficiency improvements through use of a cache.

   kbuild (4, 5):    Don't sort nm output unnecessarily, do not include
                     relocations in the kallsyms trial links.

   elf-parse (6):    Section flags, symbol binding and a read-only mapping,
                     for the next patch.

   kallsyms (7):     Don't use nm, read the ELF symbol table directly.

   kbuild (8, 9):    Implement a cache to track objects, check dependency
                     timestamps more efficiently.

   kbuild (10):      Move the toolchain checks into their own Kconfig file.

   kbuild (11):      Probe compiler, linker flags once at top of build.

   modpost (12):     Improve performance through use of a cache.

   modules (13, 14): Emit module descriptors as assembly (*.mod.S) rather
                     than C (*.mod.c), reducing CPU seconds taken by 10x to
                     perform the task. Also shard module finalisation
                     rather than running 10's of thousands of tiny runs.

   objtool (15-17):  Avoid polluting the reloc hash with millions of DWARF
                     relocations, size the instruction hash to the code
                     rather than hard-code it, and decode large objects
                     over multiple threads.

   rust (18-20):     Optionally run the rustc front end on several threads,
                     set correct dependencies and build crates in parallel
                     with C code, retaining the requirement that rust/
                     crates are built first.

   kbuild (21):      Default to using a parallel implementation of gzip
                     (pigz) if available on the system.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Rebased on Linus's master branch.
* Removed the first 2 fix patches as they have been taken to upstream in
  commit 281b61d408d4 ("scripts/mksysmap: drop the MODULE_INFO() symbols
  from kallsyms") and commit 59351365ac27 ("scripts/mksysmap: fix escape of
  '$' in the __pi_ pattern") - thanks Nicolas!
* Fixed patch 3/21 (previously 4/23) to check error on close via ferror()
  and fclose() as per David Laight.
* Updated 21/21 to not use threads for modules, only for vmlinux, and
  updated docs to reflect this.
* Dropped patches (as was) 13 and 17 as the equivalent work is being
  performed upstream:
  https://lore.kernel.org/linux-modules/20260731-module_ver_remove-v2-0-c9163858f382@linuxfoundation.org/
* Updated the cover letter to mention the dependency on this series for
  perf numbers.
* Fixed various typos.
* Checked all of the hallucinated sashiko reports. Replied inline to emails
  to keep a record of them but not going to repeat here, unless people want
  a list.
* Fixed up 9/21 (was 11/23) to fix the bit of sashiko's report that wasn't
  hallucinated - check ferror() to bring depcheck in line with fixdep and
  kallsyms.
* Fixed up patch 13/21 (was 15/23) to emit the __this_module fields in
  offset order to handle CONFIG_RANDSTRUCT as per Sashiko.
* Fixed up patch 19/23 (now 17/21) to resolve various races. Sashiko
  hallucinated a lot of the report, and missed some stuff thread sanitizer
  found. Resolve call destinations serially to resolve most of the valid
  stuff and add a lock around pv_ops, and instruction hash freed
  properly. Tested and confirmed resolved locally, as per Sashiko.
* Fixed up patch 20/21 (was 22/23) to only build rust/ when modules_prepare
  is one of several make goals, rather than the only one. This matches the
  rest of the Makefile's behaviour on this and ensures rust components are
  built if multiple build choices are passed to make, as per Sashiko.
* Fixed up patch 5/21 (was 6/23) to test CONFIG_ARCH_VMLINUX_NEEDS_RELOCS
  directly in link-vmlinux.sh rather than plumbing a var through, for a far
  smaller patch as per Nathan.
* Moved patch 1/21 (was 9/23) to the front of the series and dropped two
  comments, as per Nathan, so it can go in ahead of the rest.
* Added patch 10/21 moving the existing toolchain checks out of
  init/Kconfig into init/Kconfig.toolchain, as per Nathan, with 11/21
  adding to it.
* In 11/21 (previously 12/23) Moved -fno-stack-clash-protection back to
  the Makefile to fix an issue with ppc32 as per Nathan.
* Updated patch 15/21 (was 18/23) to drop the dead end cache as Josh has
  one in his noreturn series:
  https://lore.kernel.org/9d4b8ccfed745ac47a954aa2e1de62a85197122d.1788899473.git.jpoimboe@kernel.org
* Also updated patch 15/21 (was 18/23) to hash relocation sections objtool
  creates itself and moved cache-to-hash copy into elf_create_reloc(), as
  per Josh.
* Split the instruction hash sizing out of patch 17/21 (was 19/23) into its
  own patch 16/21, as per Josh.
* Made the rustc parallel front end opt-in in patch 18/21 (was 20/23) via
  KBUILD_RUST_THREADS, as its output is not yet reproducible, and dropped
  the probe for the planned -j flag, as per Björn, Miguel and Nicolas.
* Tested changes to ensure any flagged issues were resolved and that
  nothing broke.
* Did a re-run of profiling numbers to reflect changes and updated cover
  letter and commit messages.

v1:
https://lore.kernel.org/r/20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org

---
Lorenzo Stoakes (ARM) (21):
      kbuild: do not allocate .modinfo in vmlinux
      kallsyms: index symbols by token to speed up table compression
      kallsyms: output binary data to speed output and kallsyms assembly
      kbuild: do not sort nm output where the order is irrelevant
      kbuild: only emit vmlinux relocations when required
      elf-parse: add section flags, symbol binding and a read-only mapping
      kallsyms: reimplement mksysmap in C
      kbuild: cache list, composite object state per object
      kbuild: implement and use depcheck to check dependency timestamps
      kbuild: move the toolchain checks into init/Kconfig.toolchain
      kbuild: avoid re-running compiler and linker probes
      modpost: cache section relocation mismatch state
      modpost: emit module descriptors as assembly
      kbuild: batch module finalisation
      objtool: cache relocations, do less work
      objtool: size the instruction hash to the text
      objtool: decode instructions and resolve branch targets in parallel
      kbuild: rust: optionally parallelise rustc front end
      rust: make exports.o depend on the headers generated for it
      kbuild: build rust crates in parallel with the rest of the build
      kbuild: use pigz for gzip compression if available

 .gitignore                                   |   1 +
 Documentation/kbuild/kbuild.rst              |  22 +
 Documentation/kbuild/reproducible-builds.rst |  16 +
 Kbuild                                       |   5 +
 Makefile                                     |  47 +-
 arch/arm64/kernel/pi/Makefile                |   2 +-
 arch/riscv/kernel/pi/Makefile                |   2 +-
 arch/x86/Kconfig                             |  17 +
 arch/x86/Makefile                            |  12 +-
 arch/x86/boot/Makefile                       |   2 +-
 arch/x86/boot/compressed/Makefile            |   2 +-
 drivers/firmware/efi/libstub/Makefile        |   2 +-
 include/asm-generic/vmlinux.lds.h            |   2 +-
 include/linux/vermagic.h                     |   2 +-
 init/Kconfig                                 | 197 +------
 init/Kconfig.toolchain                       | 272 ++++++++++
 rust/Makefile                                |   5 +
 scripts/Makefile                             |   4 +-
 scripts/Makefile.build                       |  27 +-
 scripts/Makefile.lib                         |   7 +-
 scripts/Makefile.modfinal                    |  36 +-
 scripts/Makefile.modinst                     |   4 +-
 scripts/Makefile.modpost                     |   2 +-
 scripts/Makefile.vmlinux                     |  22 +-
 scripts/Makefile.warn                        |  28 +-
 scripts/basic/.gitignore                     |   1 +
 scripts/basic/Makefile                       |   2 +-
 scripts/basic/depcheck.c                     | 443 +++++++++++++++
 scripts/check-function-names.sh              |   3 +-
 scripts/elf-parse.c                          |  48 +-
 scripts/elf-parse.h                          |  19 +
 scripts/kallsyms-sysmap.c                    | 269 ++++++++++
 scripts/kallsyms.c                           | 374 +++++++++----
 scripts/kallsyms.h                           |  44 ++
 scripts/link-vmlinux.sh                      |  24 +-
 scripts/mksysmap                             |  94 ----
 scripts/mod/.gitignore                       |   1 +
 scripts/mod/Makefile                         |   8 +
 scripts/mod/modpost.c                        | 703 ++++++++++++++++++------
 scripts/mod/module-offsets.c                 |  35 ++
 scripts/tags.sh                              |   5 +-
 tools/objtool/Makefile                       |   2 +-
 tools/objtool/check.c                        | 768 ++++++++++++++++++++-------
 tools/objtool/elf.c                          | 246 ++++++++-
 tools/objtool/include/objtool/elf.h          |   2 +
 tools/objtool/include/objtool/objtool.h      |   3 +-
 tools/objtool/objtool.c                      |  15 +-
 47 files changed, 2982 insertions(+), 865 deletions(-)
---
base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
change-id: 20260904-build-speedup-25e11a00b3d0

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

