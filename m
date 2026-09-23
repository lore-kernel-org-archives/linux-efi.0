Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135383DA5C1;
	Wed, 23 Sep 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183909; cv=none; b=awfRYmcE/DWf5GzMsXdf4pJ9qiyzJ5N2S8xI5jwVyVFqaiFExDl2SqGy2EgO7TlT9j4lU8ELLInV7EsFplQPG1Gx5A0rTwAZWV95zpWkbqMIpueP72c0aBtUYN603kNfYFADjjb8msSvl3WEkj0LYZ0NIovnjNLL2hm/5bPz9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183909; c=relaxed/simple;
	bh=fRzBh1FIlhDb2lhfOitpZKtj4dtQtEk/LtvDLOGt4Ow=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ooX5NBkE1FNcXLOjr1OeHI812UrGJF6G+U530I1o05KtkFm2QsIfmWGEyAFHVZQxzABRG+n5lvJ0Nl97dRGjYA5CYDlZfYezZLJfEZLQrnAq8z7XKvD2WO0ESA+6h5A/1s6Cj+YthVzdV+LRQV0wTO2GW7eCyqCACY1TJmawOPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YY9pcPOy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YY9pcPOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295351F00893;
	Wed, 23 Sep 2026 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183906;
	bh=mh3OjA9OSV8IGzBfPib31p8/VyQLlBIWedx9dWKeK4o=;
	h=From:Subject:Date:To:Cc;
	b=YY9pcPOyFFblvgy2YBzYiMcIHrnmKMMFMDdIl92hJCXDkiPr7R2CggsLQjZyYOp4J
	 e02EGdcOQqweDq+4n4Ku2OPaIWmEbZrlLAlHvi2IYJAfbFUcPqJqFOOETd09l+YwQx
	 NXauO3VPZcaM/9wKF/FdiCWxIr/9dpYQit9+pMDvNw+xhEdeFezNDrwaW6oY/y15sh
	 mwKwkK6gFHStwr0PltCY5ue1HR6EDhCvvEfc2ord/wxBqIq2D1MahgLJhq40W1FSpF
	 VSnJA4fFJkmvaANbPrdxFlJ++9zXGI7GSBHOgdL22/ELKzRwgfuPdJRCruq6HUYlGk
	 A2dpZtycuHXQA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v4 00/22] kbuild: significantly speed up kernel builds
Date: Wed, 23 Sep 2026 18:17:49 +0100
Message-Id: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WQyW6DMBRFfwV5XSM/Gwxm1f+ouvDwSNyEoTagV
 lH+vQZaKaHLK91z3nAjEYPHSJrsRgIuPvqhT6F4yYg96/6E1LuUCWdcMsUKamZ/dTSOiG4eKS8
 RQDNmhGMkMWPA1n9tvrf3PcfZfKCdVsnaOPs4DeF7G7jA2vtz1wf3ApTR0lnQloGsuHu9YOjxm
 g/hRFb5wh9wOK628IQLVUOFtnSGi3+4eMSrIy4SrtC2BUjRtkI+4ff9toCfc3rZtB9MjI5I7dB
 1fmoyIV2hAUwptSaHOu0wRr09t8l+F1CMlYqL3Od1pegFMT5PvP8Apxl0bawBAAA=
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
 linux-hardening@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Nicolas Schier <n.schier@fritz.com>, 
 Manuel Ebner <manuelebnerli@mailbox.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=22633; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fRzBh1FIlhDb2lhfOitpZKtj4dtQtEk/LtvDLOGt4Ow=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cB5vvTtv5ZrfRtP+n5wdJ7Ov0fLtzPdCjCazXLb6t
 TNw3sjd2lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJpGUwMvStWV59Yi/PHrWG
 qMr5fKfS1RY6GNjdytjk+/2hmfYRjn0Mf2Un6SRetWnJlN1g2rzTLSR+p+z/WFXzE6tNaplkU/9
 94gcA
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

* Is based on commit 36d4a11b56aa in the kbuild tree, i.e.
  https://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux.git/commit/?id=36d4a11b56aa
* Has these series applied (as these supersede changes from a previous
  version of this series/provide functionality it uses):
	https://lore.kernel.org/linux-modules/20260731-module_ver_remove-v2-0-c9163858f382@linuxfoundation.org/
	https://lore.kernel.org/all/cover.1788899473.git.jpoimboe@kernel.org/
	https://lore.kernel.org/linux-kbuild/20260919005923.i.879-kees@kernel.org/
* Runs `make KRUSTFLAGS=-Zthreads=8 -j $(nproc) ...`.
* Runs with the pigz tool installed locally.

Note the dependencies will all be in place when the series is merged.

		== IMPORTANT NOTE for merging ==

Nathan - there are some updates to the patches you staged in
kbuild-next-speedups, let me know if you need anything from me to make life
easier with that.

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
M2, gcc			564.7s   512.1s    -52.6s (-9%)
M2, clang		615.1s   564.1s    -51.0s (-8%)

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

   sorttable (4):    Parse nm output correctly, for the next patch.

   kbuild (5, 6):    Don't sort nm output unnecessarily, do not include
                     relocations in the kallsyms trial links.

   elf-parse (7):    Section flags, symbol binding and a read-only mapping,
                     for the next patch.

   kallsyms (8):     Don't use nm, read the ELF symbol table directly.

   kbuild (9, 10):   Implement a cache to track objects, check dependency
                     timestamps more efficiently.

   kbuild (11):      Move the toolchain checks into their own Kconfig file.

   kbuild (12):      Probe compiler, linker flags once at top of build.

   modpost (13):     Improve performance through use of a cache.

   modules (14, 15): Emit module descriptors as assembly (*.mod.S) rather
                     than C (*.mod.c), reducing CPU seconds taken by 10x to
                     perform the task. Also shard module finalisation
                     rather than running 10's of thousands of tiny runs.

   objtool (16-19):  Replace reloc hash with a per-section index, size
                     the instruction hash to the code rather than hard-code
                     it, and decode large objects over multiple threads.

   rust (20, 21):    Set correct dependencies and build crates in parallel
                     with C code, retaining the requirement that rust/
                     crates are built first.

   kbuild (22):      Default to using a parallel implementation of gzip
                     (pigz) if available on the system.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v4:
* Added tags, thanks everybody!
* Fixed broken m2 numbers in cover letter as per Linus.
* Rebased onto 36d4a11b56aa as per Nathan, see
  https://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux.git/commit/?id=36d4a11b56aa
* Also rebased onto the cc-option-str series at
  https://lore.kernel.org/linux-kbuild/20260919005923.i.879-kees@kernel.org/
  as per Kees (impacts 12/22).
* Updated cover letter to declare these dependencies.
* Updated 1/22 to use /dev/null for objcopy output file, as per Kees.
* Updated 1/22 so the .modinfo dump no longer picks up the arch's image
  OBJCOPYFLAGS, as per Nicolas.
* Updated 2/22 to define NR_TOKENS for token count as per Kees.
* Updated 2/22 to Use ARRAY_SIZE() for token_profit iteration in
  find_best_token() as per Kees.
* Updated 2/22 to restore erroneously deleted comments as per Kees.
* Added 4/22, fixing an already-existing sorttable bug that didn't matter
  before but which the next patch can trigger in a problematic way, as
  vaguely kinda-reported by Sashiko (incorrect analysis, but right to query
  sorttable).
* Updated 6/22 to add a comment noting that --emit-relocs comes from
  link-vmlinux.sh, as per Kees.
* Updated 7/22 to provide elf_open_ro()/elf_close() and struct elf_file, as
  per Kees.
* Updated 7/22 to also handle the section 0 overflow case (SHN_XINDEX, zero
  e_shnum) in elf_open_ro() matching what sorttable does.
* Updated 8/22 to lay out omit tables one entry per line, resurrecting
  comments from the old mksysmap script, as per Kees.
* Updated 8/22 to add sysmap_omit_patterns[] rather than open-coding, as
  per Kees.
* Updated 8/22 to check ferror() before closing System.map output,
  as per Kees.
* Updated 8/22 to grow the kallsyms table by doubling rather than in fixed
  steps, as per Kees.
* Updated 8/22 to use the elf_file helper in elf-parse rather than
  open-coding it, as per Kees.
* Updated 9/22 to reword the commit message to say the object state is
  calculated rather than cached, as per Kees + Nicolas.
* Updated 10/22 to zero depcheck's dependency entries on allocation, as per
  Kees.
* Updated 10/22 to never treat targets in the dependency list as fresh, so
  that objects including a header regenerated in the same make run are
  rebuilt in the same run, as per Kees.
* Updated 10/22 so depcheck is not run for a non-existent directory/one
  that doesn't have .cmd files. Came up in a private tree kernel robot run
  for sh allnoconfig, as per kernel robot.
* Updated 11/22 to put the toolchain Kconfig entries in
  scripts/Kconfig.toolchain as per Kees, Nathan + Nicolas.
* Updated 11/22 to add scripts/Kconfig.toolchain to the KCONFIG entry in
  MAINTAINERS.
* Updated 12/22 to use Kees's new [cc, ld]-option-str functionality as per
  Kees and Nathan.
* Updated 12/22 to check negative options using the positive form, as gcc
  accepts unknown -Wno-xxx options without complaint, only warning later in
  the build. Came up in a private tree kernel robot run for arc, parisc
  randconfig's. As per kernel robot.
* Updated 14/22 to emit each export's ksymtab entry and CRC in one walk, as
  per Petr.
* Updated 14/22 to fold extended version emitters into one function, as per
  Petr.
* Updated 14/22 to fold dependency collection into add_asm_depends(), as
  per Petr.
* Updated 14/22 to add a weak __this_module symbol to module-common.c so
  debug info continues to be provided for it, as per Petr.
* Updated 17/22 to split the DWARF skipping in objtool into its own commit,
  as per Josh.
* Updated 17/22 to index out-of-order relocations over a sorted order
  rather than doing a linear scan, as per Josh.
* Updated 19/22 to rebuild dropped relocation index under a lock as a
  belts+braces measure (contention shouldn't actually happen).
* Updated 21/22 to add rust as a dependency to rustdoc and rusttest, as per
  kernel robot.
* Updated 22/22 (was 20/20) to add pigz to scripts/ver_linux as per Manuel
  (and previously I think Kees suggested it also? :)

v3:
* Rebased on Linus's master branch.
* Fixed link to Josh's series, which was wrongly pointing at a single
  commit as per Andre (off-list).
* Fixed typo in 11/20 (+ fixed a couple more), as per John.
* Hardened depcheck in 9/20 against a .cmd file with an empty name as per
  Sashiko.
* Updated 14/20 so only the top-level make instance builds .module-common.o
  the chunk instances treat it as a plain prerequisite, to prevent a child
  accidentally building it as per Sashiko.
* Updated 15/20 to drop the relocation hash altogether, building one
  section at a time incrementally, falling back to linear scan for anything
  out of order (not sure that'll ever happen though?) as per Josh, Linus.
* Updated 17/20 to limit the parallelisation to the --link step only (in
  practice - objtool's processing of vmlinux.o) + updated commit msg to
  reflect, as per Kees.
* Updated the commit message in 14/20 to give clearer rationales for the
  batching of modfinal instances, as per Kees.
* Dropped what was 18/21 - the rustc front end threading patch, as the
  parallel flag name is still uncertain and a user can set
  KRUSTFLAGS=-Zthreads=8 to get the behaviour without it. Also updated
  cover letter pre-requisite section to mention this, as per Miguel.
* Updated 19/20 (was 20/21) so modules_prepare no longer builds rust/
  when a goal that builds the tree is also given, ensuring duplicate rust/
  builds do not happen, as per Kees.
* Updated 20/20 (was 21/21) to remove the reproducible build doc update,
  as per Kees.
* Updated 20/20 (was 21/21) to have pigz use the make job server and to
  define a specific kernel build variable for this - KPGZIP - also fold
  in a further suggestion which eliminates a wrapper script, as per Kees.
https://lore.kernel.org/r/20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org

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
https://lore.kernel.org/r/20260914-build-speedup-v2-0-39817ec5db23@kernel.org

v1:
https://lore.kernel.org/r/20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org

---
Lorenzo Stoakes (ARM) (22):
      kbuild: do not allocate .modinfo in vmlinux
      kallsyms: index symbols by token to speed up table compression
      kallsyms: output binary data to speed output and kallsyms assembly
      sorttable: parse nm output correctly
      kbuild: do not sort nm output where the order is irrelevant
      kbuild: only emit vmlinux relocations when required
      elf-parse: add section flags, symbol binding and mapping helpers
      kallsyms: reimplement mksysmap in C
      kbuild: calculate list, composite object state per object
      kbuild: implement and use depcheck to check dependency timestamps
      kbuild: move the toolchain checks into scripts/Kconfig.toolchain
      kbuild: avoid re-running compiler and linker probes
      modpost: cache section relocation mismatch state
      modpost: emit module descriptors as assembly
      kbuild: batch module finalisation
      objtool: do not hash DWARF relocations
      objtool: cache relocations, do less work, eliminate relocation hash
      objtool: size the instruction hash to the text
      objtool: decode instructions and resolve branch targets in parallel
      rust: make exports.o depend on the headers generated for it
      kbuild: build rust crates in parallel with the rest of the build
      kbuild: compress the kernel with pigz if available

 .gitignore                              |   1 +
 Documentation/kbuild/kbuild.rst         |  17 +
 Documentation/process/changes.rst       |   8 +
 Kbuild                                  |   5 +
 MAINTAINERS                             |   1 +
 Makefile                                |  53 ++-
 arch/arm64/kernel/pi/Makefile           |   2 +-
 arch/riscv/kernel/pi/Makefile           |   2 +-
 arch/x86/Kconfig                        |  17 +
 arch/x86/Makefile                       |  12 +-
 arch/x86/boot/Makefile                  |   2 +-
 arch/x86/boot/compressed/Makefile       |   2 +-
 drivers/firmware/efi/libstub/Makefile   |   2 +-
 include/asm-generic/vmlinux.lds.h       |   2 +-
 include/linux/vermagic.h                |   2 +-
 init/Kconfig                            | 197 +-------
 kernel/Makefile                         |   6 +-
 rust/Makefile                           |   5 +
 scripts/Kconfig.toolchain               | 272 +++++++++++
 scripts/Makefile                        |   5 +-
 scripts/Makefile.build                  |  28 +-
 scripts/Makefile.lib                    |  11 +-
 scripts/Makefile.modfinal               |  40 +-
 scripts/Makefile.modpost                |   2 +-
 scripts/Makefile.vmlinux                |  10 +-
 scripts/Makefile.warn                   |  28 +-
 scripts/basic/.gitignore                |   1 +
 scripts/basic/Makefile                  |   2 +-
 scripts/basic/depcheck.c                | 481 ++++++++++++++++++++
 scripts/check-function-names.sh         |   3 +-
 scripts/elf-parse.c                     | 103 ++++-
 scripts/elf-parse.h                     |  54 +++
 scripts/jobserver-exec                  |   3 +-
 scripts/kallsyms-sysmap.c               | 248 ++++++++++
 scripts/kallsyms.c                      | 379 +++++++++++-----
 scripts/kallsyms.h                      |  44 ++
 scripts/link-vmlinux.sh                 |  24 +-
 scripts/mksysmap                        |  94 ----
 scripts/mod/.gitignore                  |   1 +
 scripts/mod/Makefile                    |   8 +
 scripts/mod/modpost.c                   | 672 +++++++++++++++++++++-------
 scripts/mod/module-offsets.c            |  35 ++
 scripts/module-common.c                 |   3 +
 scripts/sorttable.c                     |  15 +-
 scripts/tags.sh                         |   5 +-
 scripts/ver_linux                       |   1 +
 tools/lib/python/jobserver.py           |  13 +
 tools/objtool/Makefile                  |   2 +-
 tools/objtool/check.c                   | 771 ++++++++++++++++++++++++--------
 tools/objtool/elf.c                     | 271 +++++++++--
 tools/objtool/include/objtool/elf.h     |  10 +-
 tools/objtool/include/objtool/objtool.h |   3 +-
 tools/objtool/objtool.c                 |  15 +-
 53 files changed, 3101 insertions(+), 892 deletions(-)
---
base-commit: 36d4a11b56aa98da4b4652a2e34d229ffcf36070
change-id: 20260904-build-speedup-25e11a00b3d0

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

