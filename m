Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FFA3BF69E;
	Tue,  8 Sep 2026 20:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900934; cv=none; b=JABB2ssBNgCe3hr56v3Tin5xpH2Bb6mYjFI4wY5IVOn5Zeblytn+hSsNKPMhe8JInFGy/XpVDQj7OsC2M+IlSJJGkWjyRNNZJHcyVHiYOdGqa/DIahR2XpQO9b4k5CT2gcX94FB5U/pNhIDMox6bB5VRHoWlzLtp7NsX2n38+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900934; c=relaxed/simple;
	bh=r4zxWZsjLq+o+qJdnXb/cjOXHX0h7zTZcMS+AZOh2Tk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=js0MosJs3xzLDha8JKeV5y4rorv09L0phR5S1L4HSMQd1UF3D3dpHeKaypHjPy2w5PC7GKoHR7YQLkSlpvEK5ba8Db2Dv5mQOSngh5LxA9f9obuRYcsSY4RNA2Kn9so72riNrO05jvVYt4+Q/jeiaqLq//zskkXmV/FmDHKLkoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/BqhTCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/BqhTCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A871F00A3A;
	Tue,  8 Sep 2026 20:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900932;
	bh=Z6TT9h2uKDtEtXIE4l9d0BFbIHokBD+KKytpOJVveCc=;
	h=From:Subject:Date:To:Cc;
	b=a/BqhTCRMBH0KeWJYnRy7w1fkn/s863I1L51dbSgriOFlxPSRJTy2/WN0L+jMICVz
	 IsdWZvZ0Z0Y9ELHrBG8wYeF9Le4JKEqUhDTPUnw+Y7wgb3atyJD7fpCIg/iD/sUKa3
	 XWgjIZ9O/nCi7kHaZRLvQcL0kDjsewi7pBi/oxinfHbypkTQW8WvMtKzF2cInGNrCU
	 mPK4arybamW5Pp8VtL7+8gaU1AXjrQlEbqDf6yQ6SCnhtzDi0J77mmDHYO2g221b06
	 JvlTq8QdlwOHgyv4eeBGuJwDFXo5AlLfK45cTg8keJlqfnEC4JuqI07JTB3csrHInN
	 uWptR9RVl1guA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 00/23] kbuild: significantly speed up kernel builds
Date: Tue, 08 Sep 2026 21:55:00 +0100
Message-Id: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBG4avIrBuYRFuwVyldGPPbjhQNmaYI4
 t2Ndvkt3ltJkQRK92qlhJ+ozFOBvVTUv7vpBSOhmBy7G7fcGJ/lE4xGIORo3BXWdsy+DkyliQm
 DLOfv8fxbsx/Rf48JbdsOAJX9MHEAAAA=
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
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=12226; i=ljs@kernel.org;
 h=from:subject:message-id; bh=r4zxWZsjLq+o+qJdnXb/cjOXHX0h7zTZcMS+AZOh2Tk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlBntUPt6u8LBJW4V48k865+zckxe2Px/9usW94RjR
 3xMLqef6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE/qcy/LM8Uv9mseEbOcF9
 MnMDdyjOP/pnKlOPU/KksMe/Gpbfj4pkZNjqvvW0Ul6lak2G1Cl+teWmVW7tBUbbN5mmTW74GFw
 jzQwA
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

		== allmodconfig FULL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc       345.3s   275.2s    -70.1s (-20%)
Threadripper, clang     345.5s   265.7s    -79.8s (-23%)
EPYC, gcc               188.6s   121.1s    -67.5s (-36%)
EPYC, clang             261.7s   184.6s    -77.1s (-29%)

		== allmodconfig INCREMENTAL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        46.4s    15.3s    -31.1s (-67%)
Threadripper, clang      44.4s    15.2s    -29.1s (-66%)
EPYC, gcc                82.0s    24.3s    -57.7s (-70%)
EPYC, clang              77.6s    24.3s    -53.3s (-69%)

		== allmodconfig NO-OP build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc       12.97s    1.18s   -11.79s (-91%)
Threadripper, clang     13.84s    1.64s   -12.20s (-88%)
EPYC, gcc               25.92s    1.52s   -24.40s (-94%)
EPYC, clang             27.58s    2.17s   -25.41s (-92%)

		== defconfig FULL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        35.3s    28.6s     -6.7s (-19%)
Threadripper, clang      33.5s    26.1s     -7.4s (-22%)
EPYC, gcc                31.2s    20.6s    -10.6s (-34%)
EPYC, clang              38.6s    32.2s     -6.4s (-17%)
M2, gcc                 564.0s   512.4s    -51.6s (-9%)
M2, clang               616.1s   569.4s    -46.7s (-8%)

		== defconfig INCREMENTAL build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        11.6s     5.5s     -6.1s (-53%)
Threadripper, clang      11.6s     5.0s     -6.6s (-57%)
EPYC, gcc                19.3s     9.2s    -10.1s (-52%)
EPYC, clang              20.1s     8.6s    -11.5s (-57%)
M2, gcc                  18.6s     9.9s     -8.7s (-47%)
M2, clang                18.6s     8.2s    -10.4s (-56%)

		== defconfig NO-OP build ==

                        before    after     delta
                      ----------------------------------
Threadripper, gcc        0.96s    0.47s    -0.49s (-51%)
Threadripper, clang      1.21s    0.55s    -0.66s (-55%)
EPYC, gcc                1.47s    0.66s    -0.81s (-55%)
EPYC, clang              1.87s    0.80s    -1.07s (-57%)
M2, gcc                  5.59s    1.69s    -3.90s (-70%)
M2, clang                6.62s    1.74s    -4.88s (-74%)

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
messages, the cover letter and comments.x

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

   mksysmap (1, 2):  A couple of bugfixes the rest of the series relies
                     upon.

   kallsyms (3, 4):  Some efficiency improvements through use of a cache.

   kbuild (5, 6):    Don't sort nm output unnecessarily, do not include
                     relocations in the kallsyms trial links.

   elf-parse (7):    Section flags, symbol binding and a read-only mapping,
                     for the next patch.

   kallsyms (8):     Don't use nm, read the ELF symbol table directly.

   kbuild (9):       Make .modinfo an INFO section.

   kbuild (10, 11):  Implement a cache to track objects, check dependency
                     timestamps more efficiently.

   kbuild (12):      Probe compiler, linker flags once at top of build.

   modpost (13, 14): Hash module sources a file at a time not a byte at a
                     time,  also improve performance through use of a
		     cache.

   modules (15, 16): Emit module descriptors as assembly (*.mod.S) rather
                     than C (*.mod.c), reducing CPU seconds taken by 10x to
                     perform the task. Also shard module finalisation
                     rather than running 10's of thousands of tiny runs.

   modpost (17):     Compute srcversions in parallel using a thread pool.

   objtool (18, 19): Avoid polluting the reloc hash with millions of DWARF
                     relocations. Remember dead-ends and decode large
		     objects over multiple threads. Size instruction hash
		     to the code rather than hard-code it.

   rust (20-22):     Parallelise the frontend, set correct dependencies and
                     build crates in parallel with C code, retaining the
		     requirement that rust/ crates are built first.

   kbuild (23):      Default to using a parallel implementation of gzip
                     (pigz) if available on the system.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (23):
      scripts/mksysmap: drop the MODULE_INFO() symbols from kallsyms
      scripts/mksysmap: fix escape of '$' in the __pi_ pattern
      kallsyms: index symbols by token to speed up table compression
      kallsyms: output binary data to speed output and kallsyms assembly
      kbuild: do not sort nm output where the order is irrelevant
      kbuild: only emit vmlinux relocations when required
      elf-parse: add section flags, symbol binding and a read-only mapping
      kallsyms: reimplement mksysmap in C
      kbuild: do not allocate .modinfo in vmlinux
      kbuild: cache list, composite object state per object
      kbuild: implement and use depcheck to check dependency timestamps
      kbuild: avoid re-running compiler and linker probes
      modpost: hash module source per-file, not per-byte
      modpost: cache section relocation mismatch state
      modpost: emit module descriptors as assembly
      kbuild: batch module finalisation
      modpost: perform srcversion hashing in parallel
      objtool: cache relocations and function dead end state, do less work
      objtool: decode instructions and resolve branch targets in parallel
      kbuild: rust: parallelise rustc front end
      rust: make exports.o depend on the headers generated for it
      kbuild: build rust crates in parallel with the rest of the build
      kbuild: use pigz for gzip compression if available

 .gitignore                                   |   1 +
 Documentation/kbuild/kbuild.rst              |  13 +
 Documentation/kbuild/reproducible-builds.rst |  16 +
 Kbuild                                       |   5 +
 Makefile                                     |  49 +-
 arch/arm64/kernel/pi/Makefile                |   2 +-
 arch/riscv/kernel/pi/Makefile                |   2 +-
 arch/x86/Kconfig                             |  17 +
 arch/x86/Makefile                            |  12 +-
 arch/x86/boot/Makefile                       |   2 +-
 arch/x86/boot/compressed/Makefile            |   2 +-
 drivers/firmware/efi/libstub/Makefile        |   2 +-
 include/asm-generic/vmlinux.lds.h            |   2 +-
 include/linux/vermagic.h                     |   2 +-
 init/Kconfig                                 |  84 +++
 rust/Makefile                                |   5 +
 scripts/Makefile                             |   4 +-
 scripts/Makefile.build                       |  27 +-
 scripts/Makefile.lib                         |   7 +-
 scripts/Makefile.modfinal                    |  36 +-
 scripts/Makefile.modpost                     |   2 +-
 scripts/Makefile.vmlinux                     |  27 +-
 scripts/Makefile.warn                        |  28 +-
 scripts/basic/.gitignore                     |   1 +
 scripts/basic/Makefile                       |   2 +-
 scripts/basic/depcheck.c                     | 442 +++++++++++++++
 scripts/check-function-names.sh              |   3 +-
 scripts/elf-parse.c                          |  48 +-
 scripts/elf-parse.h                          |  19 +
 scripts/kallsyms-sysmap.c                    | 269 ++++++++++
 scripts/kallsyms.c                           | 387 ++++++++++----
 scripts/kallsyms.h                           |  44 ++
 scripts/link-vmlinux.sh                      |  25 +-
 scripts/mksysmap                             |  94 ----
 scripts/mod/.gitignore                       |   1 +
 scripts/mod/Makefile                         |   9 +
 scripts/mod/modpost.c                        | 757 ++++++++++++++++++++------
 scripts/mod/modpost.h                        |   2 +
 scripts/mod/module-offsets.c                 |  35 ++
 scripts/mod/sumversion.c                     |  57 +-
 scripts/tags.sh                              |   5 +-
 tools/objtool/Makefile                       |   2 +-
 tools/objtool/check.c                        | 767 ++++++++++++++++++++-------
 tools/objtool/elf.c                          | 242 ++++++++-
 tools/objtool/include/objtool/elf.h          |   4 +
 tools/objtool/include/objtool/objtool.h      |   3 +-
 tools/objtool/objtool.c                      |   1 -
 47 files changed, 2884 insertions(+), 682 deletions(-)
---
base-commit: 28924df2a08f440c73991b83028032c901de2ae4
change-id: 20260904-build-speedup-25e11a00b3d0

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

