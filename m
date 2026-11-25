Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587411;
	b=V6dXQcnGxJW/DRVErxx1DBvrqYuPa3xLVzSy3OPzuExZ/FjrFzo2yDAqf/Pnee1CimiK
	 gR7Z5XtBBJhGZVfZ3E0JY66xKwfo6WNoU9PUlZTsDgNESKnhofmjhRYwOhf2B/es/DoYc
	 KTN7MzQba34F7all5RbhHn83+N4gJyhnBW0EgxeaGLZ4XUXFfipVjvCdm1UWnnBtUbOFL
	 OPXdMa20ixHWv7VvEtmvpuDkt7p9vZ0FIrtxNNbm3Uz8cmfOCSB9RsLej38fr/iL5OT/s
	 xx38p0CiURavbGO6X/rEmEpoWOhDYz6U/AhOVPr9TMeZNNATJ/DoWSQmOUsM/vIWSNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=PGUaOXcAUgKDNV4MrYudUGzscZJWJkWDT1OV8fdzh5s=;
	b=SgCjoLA1xMeNaPW/v2b866SzKBg9sKtPu/P5MsdKCFPxiXauzlbBWLXrqYVclhx8BwMe
	 x8U/33wMfLeiPETOQCV5rWMfueXxXkTCusVtvgQBHwY5uy8rRh+69RcF3MYF6bmfQ16VP
	 Hiv6jbCXXbGOfH/Dhve9TOmbu5xvcdcjhHnJNBzkkP3hC9iTXZqF5/sFCoQLplkNnpxsQ
	 SXulInC2j4QfriihgajqpPGTlzRml1uMBOUqW9l1Nai7hno7jArX5GR9SE9DM2Tulm3rr
	 gyLO0kcDId25vUKwJ+r2HNKMMIF/DOvUDgnkR1DBURWaIufjmkcISPzxzVSG7iJ/szQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E+zie7c5;
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C2E606DE59
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3C2E606DE59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E+zie7c5
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b55f4f3bb8so3025064c88.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587410; x=1796192210; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGUaOXcAUgKDNV4MrYudUGzscZJWJkWDT1OV8fdzh5s=;
        b=E+zie7c52eirMuFQidxFwDA9swm2Zqqb5ljzQLHsm79PsfY+WcIzbPXklDL1xE1ZCs
         BwcsSkadInDb4jNBTAXKFTe20dOIv8rtWGb6QNjtRuwte4+Ab4OWpbm5BiNvRKgbAzfJ
         2Hnlmu/btzY3IY96GbZdPIY8954wgFkgRI0vChbf30wahdUkiAooWX7QN1rMqFvIrpCK
         2mnLiGTVUbnQ3VqyMm+aBEZzgNceGIOX2CQzjEufLB+8zt1bmn5kPPIDfVqdAnwfISOj
         Ckp4iwt0NQdTiBu9H0SnQ+RqCWbMuZhqNeOVMkR7KV5V8tp9C0siquF71HdAkPCOmBF4
         D23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587410; x=1796192210;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PGUaOXcAUgKDNV4MrYudUGzscZJWJkWDT1OV8fdzh5s=;
        b=PqJTXCZFe0Xhg8AezExYKaNg6iBdruQ2y8TZpqd/yixWmtwWTuAb+4sVi55ecgoCZz
         dFVl1plLX3C3KwXGs98EwDnQADIZ7aO7jZYNb3vOhgwhS3Xa7BMXRhhwe79lp2WUC9IQ
         VF8UXJck3Nej0Ge+FL2+JnuR5YwqvLzx4jjrPZyy/IHfQ1YLlwljQee98NcTvP3nzL0Z
         aT8dkBXFNbSe7H45Y2NEb9VQiFscHCU2PujKDG+LEAni6eAN4dX0JrBpkfnCfzVZvA8l
         0Q3Y6YiwZT5Ap8J+dXVehU7qyoCGMclnrKMTnaL6TUuR6KvsOKIm8D5HSfyPFGpKTZY8
         UgyQ==
X-Forwarded-Encrypted: i=1; AL+hErHXqeBsPZOlD8Wq3EMFhbx13HAqtn3OK04UHkoWJrjZ7FLEI39flLv53HflqMaI0hQRVBXhn2ghkuQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9B5bSK3nbDwt/ovehsm3JoHFOIqCcD/HCnxMjQYZIWx3RQBS6u
	Q8pC/AOa6uBccbYIi2hgMIM9rH03FxW5aKAgCUCfWsorU5lhQIJNbdfCNnmIuAfUZb3JH1wLoF7
	LXVTJHhc1hg==
X-Received: from dlak28.prod.google.com ([2002:a05:701b:291c:b0:1b5:88f8:91d6])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701a:cc86:20b0:1b5:87b6:2906
 with SMTP id a92af1059eb24-1b587b62983mr1774824c88.13.1795587409494; Tue, 24
 Nov 2026 22:16:49 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:19 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-27-irogers@google.com>
Subject: [RFC PATCH v2 26/30] tools/unwind: Add standalone libLLVM Minimal
 DWARF CFI verifier
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Add an optional standalone host verification tool (tools/unwind/verify_cfi,
built via `make -C tools/unwind` or `make tools/unwind` when libLLVM is
detected via tools/build/Makefile.feature, and gracefully skipped
otherwise) linked directly against kernel/unwind/dwarf_cfi.c.

This initial commit implements the CLI harness, host VMA and kmem buffer
wrappers (dwarf_cfi_host.c), and Oracle 1 (verifyOracle1Dwarf()), which
evaluates libLLVM's full reference DWARFUnwindTable
(llvm::dwarf::createUnwindTable) and verifies exact agreement with both
dwarf_cfi_unwind_user_eh_frame_hdr() and dwarf_cfi_unwind_eh_frame_hdr()
at every FDE start, row-transition boundary (pc - 1 and pc), and end PC.

Across 207,450 vmlinux FDEs (2,575,276 transition PCs) on x86_64, arm64,
and riscv64, plus user-space shared libraries (libc.so.6, libstdc++.so.6,
libcrypto.so.3, /bin/bash), Oracle 1 reports 0 mismatches.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/Makefile                |  13 +-
 tools/unwind/.gitignore       |   4 +
 tools/unwind/Makefile         | 123 ++++++
 tools/unwind/dwarf_cfi_host.c |  80 ++++
 tools/unwind/dwarf_cfi_host.h |  42 ++
 tools/unwind/verify_cfi.cpp   | 789 ++++++++++++++++++++++++++++++++++
 tools/unwind/verify_cfi.hpp   | 147 +++++++
 7 files changed, 1192 insertions(+), 6 deletions(-)
 create mode 100644 tools/unwind/.gitignore
 create mode 100644 tools/unwind/Makefile
 create mode 100644 tools/unwind/dwarf_cfi_host.c
 create mode 100644 tools/unwind/dwarf_cfi_host.h
 create mode 100644 tools/unwind/verify_cfi.cpp
 create mode 100644 tools/unwind/verify_cfi.hpp

diff --git a/tools/Makefile b/tools/Makefile
index cb40961a740f..0890921e56b2 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -37,6 +37,7 @@ help:
 	@echo '  thermal                - thermal library'
 	@echo '  tracing                - misc tracing tools'
 	@echo '  turbostat              - Intel CPU idle stats and freq reporting tool'
+	@echo '  unwind                 - Minimal DWARF CFI static verifier'
 	@echo '  usb                    - USB testing tools'
 	@echo '  virtio                 - vhost test module'
 	@echo '  mm                     - misc mm tools'
@@ -70,7 +71,7 @@ acpi: FORCE
 cpupower: FORCE
 	$(call descend,power/$@)
 
-counter dma firewire hv guest bootconfig spi usb virtio mm bpf iio gpio objtool leds wmi firmware debugging tracing: FORCE
+counter dma firewire hv guest bootconfig spi usb virtio mm bpf iio gpio objtool leds wmi firmware debugging tracing unwind: FORCE
 	$(call descend,$@)
 
 bpf/%: FORCE
@@ -127,7 +128,7 @@ all: acpi counter cpupower dma gpio hv firewire \
 		perf selftests bootconfig spi turbostat usb \
 		virtio mm bpf x86_energy_perf_policy \
 		tmon freefall iio objtool kvm_stat wmi \
-		debugging tracing thermal thermometer thermal-engine ynl
+		debugging tracing thermal thermometer thermal-engine unwind ynl
 
 acpi_install:
 	$(call descend,power/$(@:_install=),install)
@@ -135,7 +136,7 @@ acpi_install:
 cpupower_install:
 	$(call descend,power/$(@:_install=),install)
 
-counter_install dma_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install mm_install bpf_install objtool_install wmi_install debugging_install tracing_install:
+counter_install dma_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install mm_install bpf_install objtool_install wmi_install debugging_install tracing_install unwind_install:
 	$(call descend,$(@:_install=),install)
 
 selftests_install:
@@ -171,7 +172,7 @@ install: acpi_install counter_install cpupower_install dma_install gpio_install
 		virtio_install mm_install bpf_install x86_energy_perf_policy_install \
 		tmon_install freefall_install objtool_install kvm_stat_install \
 		wmi_install debugging_install intel-speed-select_install \
-		tracing_install thermometer_install thermal-engine_install ynl_install
+		tracing_install thermometer_install thermal-engine_install unwind_install ynl_install
 
 acpi_clean:
 	$(call descend,power/acpi,clean)
@@ -179,7 +180,7 @@ acpi_clean:
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-counter_clean dma_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean mm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean firmware_clean debugging_clean tracing_clean:
+counter_clean dma_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean mm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean firmware_clean debugging_clean tracing_clean unwind_clean:
 	$(call descend,$(@:_clean=),clean)
 
 libapi_clean:
@@ -231,6 +232,6 @@ clean: acpi_clean counter_clean cpupower_clean dma_clean hv_clean firewire_clean
 		freefall_clean build_clean libbpf_clean libsubcmd_clean \
 		gpio_clean objtool_clean leds_clean wmi_clean firmware_clean debugging_clean \
 		intel-speed-select_clean tracing_clean thermal_clean thermometer_clean thermal-engine_clean \
-		sched_ext_clean ynl_clean
+		sched_ext_clean unwind_clean ynl_clean
 
 .PHONY: FORCE
diff --git a/tools/unwind/.gitignore b/tools/unwind/.gitignore
new file mode 100644
index 000000000000..1fa1fbaca9b0
--- /dev/null
+++ b/tools/unwind/.gitignore
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only OR MIT
+verify_cfi
+FEATURE-DUMP*
+feature/
diff --git a/tools/unwind/Makefile b/tools/unwind/Makefile
new file mode 100644
index 000000000000..ca6b84dbd31a
--- /dev/null
+++ b/tools/unwind/Makefile
@@ -0,0 +1,123 @@
+# SPDX-License-Identifier: GPL-2.0-only OR MIT
+include ../scripts/Makefile.include
+
+bindir ?= /usr/bin
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(CURDIR)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+endif
+
+ifneq ($(LLVM),)
+  $(call allow-override,HOSTCXX,$(LLVM_PREFIX)clang++$(LLVM_SUFFIX))
+else
+  $(call allow-override,HOSTCXX,g++)
+endif
+
+# verify_cfi is a host analysis tool; ensure feature checks probe the host
+# compiler even when CROSS_COMPILE is set in the environment.
+CC  := $(HOSTCC)
+CXX := $(HOSTCXX)
+
+# Auto-discover versioned llvm-config (e.g. Debian/Ubuntu llvm-config-21) when
+# the default unversioned binary is absent, and export it for Makefile.feature.
+ifeq ($(shell command -v $(firstword $(LLVM_CONFIG)) >/dev/null 2>&1 && echo y),)
+  LLVM_CONFIG_CANDIDATES := llvm-config-22 llvm-config-21 llvm-config-20 \
+			    llvm-config-19 llvm-config-18
+  FOUND_LLVM_CONFIG := $(firstword $(foreach c,$(LLVM_CONFIG_CANDIDATES), \
+			 $(if $(shell command -v $(c) >/dev/null 2>&1 && echo y),$(c))))
+  ifneq ($(FOUND_LLVM_CONFIG),)
+    LLVM_CONFIG := $(FOUND_LLVM_CONFIG)
+  endif
+endif
+export LLVM_CONFIG
+
+FEATURE_USER := .verify_cfi
+FEATURE_TESTS := llvm
+FEATURE_DISPLAY := llvm
+
+check_feat := 1
+NON_CHECK_FEAT_TARGETS := clean
+ifdef MAKECMDGOALS
+ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
+  check_feat := 0
+endif
+endif
+ifeq ($(SKIP_LLVM),1)
+  check_feat := 0
+endif
+
+ifeq ($(check_feat),1)
+ifeq ($(FEATURES_DUMP),)
+include $(srctree)/tools/build/Makefile.feature
+else
+include $(FEATURES_DUMP)
+endif
+endif
+
+LLVM_COMPONENTS := debuginfodwarf object mc mcdisassembler all-targets support
+
+ifeq ($(feature-llvm),1)
+ifneq ($(SKIP_LLVM),1)
+  LLVM_INCDIR := $(shell $(LLVM_CONFIG) --includedir 2>/dev/null)
+  ifneq ($(wildcard $(LLVM_INCDIR)/llvm/DebugInfo/DWARF/LowLevel/DWARFUnwindTable.h),)
+    HAS_LIBLLVM := 1
+    LLVM_CXXFLAGS := $(filter-out -D_GNU_SOURCE -std=%,$(shell $(LLVM_CONFIG) --cxxflags 2>/dev/null))
+    LLVM_LDFLAGS  := $(shell $(LLVM_CONFIG) --ldflags 2>/dev/null)
+    LLVM_LIBS     := $(shell $(LLVM_CONFIG) --link-shared --libs $(LLVM_COMPONENTS) 2>/dev/null)
+    ifeq ($(LLVM_LIBS),)
+      LLVM_LIBS   := $(shell $(LLVM_CONFIG) --libs $(LLVM_COMPONENTS) 2>/dev/null) \
+		     $(shell $(LLVM_CONFIG) --system-libs $(LLVM_COMPONENTS) 2>/dev/null)
+    endif
+  endif
+endif
+endif
+
+TOOLS_INCLUDES := -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi \
+		  -I$(srctree)/tools/arch/x86/include
+
+SHIM_CFLAGS := -O2 -g -Wall -Wextra -Wno-unused-parameter -Wno-maybe-uninitialized \
+	$(TOOLS_INCLUDES)
+
+VERIFY_CXXFLAGS := -O2 -g -Wall -Wextra -std=gnu++20 $(LLVM_CXXFLAGS) \
+	-I$(CURDIR) $(TOOLS_INCLUDES) $(CXXFLAGS)
+VERIFY_LDFLAGS  := $(LLVM_LDFLAGS) $(LDFLAGS)
+
+KERNEL_CFI_DEPS := $(srctree)/kernel/unwind/dwarf_cfi.c \
+		   $(srctree)/tools/include/linux/unwind_dwarf_cfi.h
+
+VERIFY_OBJS := $(OUTPUT)dwarf_cfi_host.o \
+		 $(OUTPUT)verify_cfi.o
+
+ifeq ($(HAS_LIBLLVM),1)
+all: $(OUTPUT)verify_cfi
+else
+all:
+ifeq ($(REQUIRE_LLVM),1)
+	$(error libLLVM 17+ development headers/libraries not found (LLVM_CONFIG=$(LLVM_CONFIG)))
+else
+	@echo "  SKIP    verify_cfi (libLLVM dev files not found; set LLVM_CONFIG=...)"
+endif
+endif
+
+$(OUTPUT)dwarf_cfi_host.o: dwarf_cfi_host.c dwarf_cfi_host.h $(KERNEL_CFI_DEPS)
+	$(QUIET_CC)$(HOSTCC) $(SHIM_CFLAGS) -c $< -o $@
+
+$(OUTPUT)%.o: %.cpp $(wildcard *.hpp) dwarf_cfi_host.h
+	$(QUIET_CXX)$(HOSTCXX) $(VERIFY_CXXFLAGS) -c $< -o $@
+
+$(OUTPUT)verify_cfi: $(VERIFY_OBJS)
+	$(QUIET_LINK)$(HOSTCXX) $(VERIFY_CXXFLAGS) $(VERIFY_OBJS) \
+		-o $@ $(VERIFY_LDFLAGS) $(LLVM_LIBS)
+
+install: all
+	@if [ -x "$(OUTPUT)verify_cfi" ]; then \
+		install -d -m 755 $(DESTDIR)$(bindir); \
+		install $(OUTPUT)verify_cfi $(DESTDIR)$(bindir); \
+	fi
+
+clean:
+	$(RM) -r $(OUTPUT)*.o $(OUTPUT)verify_cfi \
+		$(OUTPUT)feature $(OUTPUT)FEATURE-DUMP*
+
+.PHONY: all install clean
diff --git a/tools/unwind/dwarf_cfi_host.c b/tools/unwind/dwarf_cfi_host.c
new file mode 100644
index 000000000000..307b18fc6fe1
--- /dev/null
+++ b/tools/unwind/dwarf_cfi_host.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * Host userspace wrapper compiling kernel/unwind/dwarf_cfi.c verbatim against
+ * tools/include/ headers so verify_cfi exercises the exact kernel Minimal DWARF
+ * CFI interpreter on both the 128-byte windowed user stream path and the direct
+ * kmem noinstr path.
+ */
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <string.h>
+
+#include "dwarf_cfi_host.h"
+
+static const struct host_vma_seg *g_segs;
+static size_t g_nsegs;
+
+void host_set_vma_segs(const struct host_vma_seg *segs, size_t nsegs)
+{
+	g_segs = segs;
+	g_nsegs = nsegs;
+}
+
+static unsigned long host_copy_from_vma(void *to, const void *from_ptr,
+					unsigned long n)
+{
+	unsigned long addr = (unsigned long)from_ptr;
+	unsigned char *dst = to;
+
+	while (n > 0) {
+		bool found = false;
+		size_t i;
+
+		for (i = 0; i < g_nsegs; i++) {
+			unsigned long start = g_segs[i].vma;
+
+			if (addr >= start && (addr - start) < g_segs[i].size) {
+				unsigned long off = addr - start;
+				unsigned long avail = g_segs[i].size - off;
+				unsigned long chunk = n < avail ? n : avail;
+
+				memcpy(dst, g_segs[i].data + off, chunk);
+				dst += chunk;
+				addr += chunk;
+				n -= chunk;
+				found = true;
+				break;
+			}
+		}
+		if (!found)
+			return n;
+	}
+	return 0;
+}
+
+/*
+ * In userspace, <linux/limits.h> resolves to the UAPI header rather than
+ * kernel-internal include/linux/limits.h, and tools/include/linux/kernel.h
+ * avoids defining fixed-width integer bounds globally because other tools/
+ * targets define their own U8_MAX/U32_MAX macros.
+ */
+#ifndef U8_MAX
+#define U8_MAX		((u8)~0U)
+#endif
+#ifndef U32_MAX
+#define U32_MAX		((u32)~0U)
+#endif
+#ifndef S32_MAX
+#define S32_MAX		((s32)(U32_MAX >> 1))
+#endif
+#ifndef S32_MIN
+#define S32_MIN		((s32)(-S32_MAX - 1))
+#endif
+#ifndef noinstr
+#define noinstr
+#endif
+#define copy_from_user(to, from, n) host_copy_from_vma(to, from, n)
+
+#include "../../kernel/unwind/dwarf_cfi.c"
diff --git a/tools/unwind/dwarf_cfi_host.h b/tools/unwind/dwarf_cfi_host.h
new file mode 100644
index 000000000000..c797f9992bf1
--- /dev/null
+++ b/tools/unwind/dwarf_cfi_host.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+#ifndef _TOOLS_UNWIND_DWARF_CFI_HOST_H
+#define _TOOLS_UNWIND_DWARF_CFI_HOST_H
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+
+/*
+ * Note: In C++ files using LLVM headers, include this header AFTER <llvm/...>
+ * headers (matching tools/perf/util/llvm-c-helpers.cpp) because
+ * tools/include/linux/compiler.h defines macros such as 'noinline' that
+ * conflict with LLVM attribute declarations.
+ */
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#ifndef CONFIG_UNWIND_DWARF_CFI
+#define CONFIG_UNWIND_DWARF_CFI 1
+#endif
+#include <linux/unwind_dwarf_cfi.h>
+
+/**
+ * struct host_vma_seg - Simulated user VMA backing range for host CFI testing
+ * @vma: Starting virtual address of the ELF section/segment.
+ * @size: Length in bytes of the backing buffer @data.
+ * @data: Pointer to in-memory ELF section contents on the host.
+ */
+struct host_vma_seg {
+	unsigned long vma;
+	size_t size;
+	const uint8_t *data;
+};
+
+void host_set_vma_segs(const struct host_vma_seg *segs, size_t nsegs);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* _TOOLS_UNWIND_DWARF_CFI_HOST_H */
diff --git a/tools/unwind/verify_cfi.cpp b/tools/unwind/verify_cfi.cpp
new file mode 100644
index 000000000000..15d99ba57ce3
--- /dev/null
+++ b/tools/unwind/verify_cfi.cpp
@@ -0,0 +1,789 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * Standalone Multi-Architecture Minimal DWARF CFI Verifier using libLLVM.
+ *
+ * Entry point and Oracle 1 (libLLVM reference DWARFUnwindTable vs. kernel
+ * Minimal DWARF interpreter across both user-stream and kmem paths), with
+ * optional compile-time hooks for Oracle 2 (HAVE_VERIFY_INSN) and Oracle 3
+ * (HAVE_VERIFY_ORC).
+ */
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wunused-parameter"
+#include "llvm/ADT/SmallVector.h"
+#include "llvm/BinaryFormat/Dwarf.h"
+#include "llvm/BinaryFormat/ELF.h"
+#include "llvm/DebugInfo/DWARF/DWARFContext.h"
+#include "llvm/DebugInfo/DWARF/DWARFDebugFrame.h"
+#include "llvm/DebugInfo/DWARF/LowLevel/DWARFExpression.h"
+#include "llvm/DebugInfo/DWARF/LowLevel/DWARFUnwindTable.h"
+#include "llvm/MC/MCAsmInfo.h"
+#include "llvm/MC/MCContext.h"
+#include "llvm/MC/MCObjectFileInfo.h"
+#include "llvm/MC/MCTargetOptions.h"
+#include "llvm/MC/TargetRegistry.h"
+#include "llvm/Object/ELFObjectFile.h"
+#include "llvm/Object/ObjectFile.h"
+#include "llvm/Support/InitLLVM.h"
+#include "llvm/Support/MemoryBuffer.h"
+#include "llvm/Support/TargetSelect.h"
+#include "llvm/Support/raw_ostream.h"
+#pragma GCC diagnostic pop
+
+#include "verify_cfi.hpp"
+
+#include <algorithm>
+#include <cinttypes>
+#include <cstdio>
+#include <cstdlib>
+#include <cstring>
+#include <memory>
+
+using namespace llvm;
+using namespace llvm::object;
+
+/**
+ * getArchSpec() - Populate target architecture metadata from an ELF ObjectFile
+ * @Obj: Parsed LLVM ObjectFile under inspection.
+ * @Out: Output &struct ArchSpec populated on success.
+ *
+ * Return: true if @Obj targets a supported architecture (x86_64, aarch64, or
+ * riscv64); false otherwise.
+ */
+static bool getArchSpec(const ObjectFile &Obj, ArchSpec &Out)
+{
+	auto A = Obj.getArch();
+	if (A == Triple::x86_64) {
+		Out = {Triple::x86_64, "x86_64-unknown-linux-gnu", "",
+		       {8, 7, 6, 16}, 8, true};
+		return true;
+	}
+	if (A == Triple::aarch64) {
+		Out = {Triple::aarch64, "aarch64-unknown-linux-gnu",
+		       "+v8.5a,+pauth,+bti", {8, 31, 29, 30}, 0, false};
+		return true;
+	}
+	if (A == Triple::riscv64) {
+		Out = {Triple::riscv64, "riscv64-unknown-linux-gnu",
+		       "+m,+a,+f,+d,+c,+zicsr,+zifencei",
+		       {8, 2, 8, 1}, 0, false};
+		return true;
+	}
+	return false;
+}
+
+/**
+ * rowsEqual() - Compare two evaluated Minimal DWARF unwind rows for equality
+ */
+bool rowsEqual(const dwarf_cfi_row &a, const dwarf_cfi_row &b)
+{
+	if (a.cfa_base != b.cfa_base || a.cfa_off != b.cfa_off ||
+	    a.sp_rule != b.sp_rule || a.fp_rule != b.fp_rule ||
+	    a.ra_rule != b.ra_rule || a.signal != b.signal ||
+	    a.ra_signed != b.ra_signed)
+		return false;
+	if (a.cfa_base == DWARF_CFI_BASE_REG && a.cfa_reg != b.cfa_reg)
+		return false;
+	if (a.sp_rule == DWARF_CFI_RULE_OFFSET && a.sp_off != b.sp_off)
+		return false;
+	if ((a.fp_rule == DWARF_CFI_RULE_OFFSET ||
+	     a.fp_rule == DWARF_CFI_RULE_FP_OFFSET ||
+	     a.fp_rule == DWARF_CFI_RULE_SP_OFFSET) &&
+	    a.fp_off != b.fp_off)
+		return false;
+	if ((a.ra_rule == DWARF_CFI_RULE_OFFSET ||
+	     a.ra_rule == DWARF_CFI_RULE_SP_OFFSET) &&
+	    a.ra_off != b.ra_off)
+		return false;
+	return true;
+}
+
+void recordIssue(VerifyStats &st, const VerifyOptions &opts,
+		 const std::string &reason, const std::string &detail)
+{
+	uint64_t cnt = ++st.mismatch_reasons[reason];
+	if (cnt <= opts.max_samples &&
+	    st.sample_issues.size() < opts.max_samples * 8)
+		st.sample_issues.push_back("[" + reason + "] " + detail);
+}
+
+ArrayRef<uint8_t> findExecBytes(const std::vector<ExecSec> &exec_secs,
+				uint64_t addr, uint64_t len)
+{
+	for (const auto &es : exec_secs) {
+		if (addr >= es.vma && len <= es.bytes.size() &&
+		    (addr - es.vma) <= es.bytes.size() - len) {
+			const uint8_t *p =
+				reinterpret_cast<const uint8_t *>(es.bytes.data()) +
+				(addr - es.vma);
+			return ArrayRef<uint8_t>(p, len);
+		}
+	}
+	return {};
+}
+
+/**
+ * llvmRowToMinimal() - Convert an LLVM reference UnwindRow to Minimal DWARF
+ */
+static bool llvmRowToMinimal(const dwarf::UnwindRow &UR, const dwarf::CIE *Cie,
+			     const dwarf_cfi_arch &arch, dwarf_cfi_row &out)
+{
+	memset(&out, 0, sizeof(out));
+	out.signal = Cie && Cie->getAugmentationString().contains('S');
+
+	if (arch.ra_reg == 30) {
+		if (auto Loc = UR.getRegisterLocations().getRegisterLocation(34)) {
+			if (Loc->getLocation() == dwarf::UnwindLocation::Constant)
+				out.ra_signed = (Loc->getConstant() != 0);
+		}
+	}
+
+	const auto &CFA = UR.getCFAValue();
+	if (CFA.getLocation() == dwarf::UnwindLocation::RegPlusOffset &&
+	    !CFA.getDereference()) {
+		uint32_t r = CFA.getRegister();
+		if (r > 255)
+			return false;
+		if (r == arch.sp_reg)
+			out.cfa_base = DWARF_CFI_BASE_SP;
+		else if (r == arch.fp_reg)
+			out.cfa_base = DWARF_CFI_BASE_FP;
+		else
+			out.cfa_base = DWARF_CFI_BASE_REG;
+		out.cfa_reg = (uint8_t)r;
+		out.cfa_off = CFA.getOffset();
+	} else if (CFA.getLocation() == dwarf::UnwindLocation::DWARFExpr) {
+		auto ExprOpt = CFA.getDWARFExpressionBytes();
+		if (!ExprOpt)
+			return false;
+		SmallVector<DWARFExpression::Operation, 4> Ops;
+		for (auto &Op : *ExprOpt) {
+			if (Op.isError())
+				return false;
+			Ops.push_back(Op);
+		}
+		uint8_t breg_fp = dwarf::DW_OP_breg0 + arch.fp_reg;
+		uint8_t breg_sp = dwarf::DW_OP_breg0 + arch.sp_reg;
+		if (CFA.getDereference() && Ops.size() == 1 &&
+		    (Ops[0].getCode() == breg_fp ||
+		     Ops[0].getCode() == breg_sp)) {
+			out.cfa_base = (Ops[0].getCode() == breg_fp)
+					   ? DWARF_CFI_BASE_FP_INDIRECT
+					   : DWARF_CFI_BASE_SP_INDIRECT;
+			out.cfa_off = (int32_t)(int64_t)Ops[0].getRawOperand(0);
+		} else if (!CFA.getDereference() && Ops.size() == 2 &&
+			   (Ops[0].getCode() == breg_fp ||
+			    Ops[0].getCode() == breg_sp) &&
+			   Ops[1].getCode() == dwarf::DW_OP_deref) {
+			out.cfa_base = (Ops[0].getCode() == breg_fp)
+					   ? DWARF_CFI_BASE_FP_INDIRECT
+					   : DWARF_CFI_BASE_SP_INDIRECT;
+			out.cfa_off = (int32_t)(int64_t)Ops[0].getRawOperand(0);
+		} else {
+			return false;
+		}
+	} else {
+		return false;
+	}
+
+	auto mapRegRule = [&](uint32_t reg, uint8_t &rule, int32_t &off,
+			      bool is_sp, bool is_ra) -> bool {
+		auto LocOpt = UR.getRegisterLocations().getRegisterLocation(reg);
+		if (!LocOpt) {
+			rule = DWARF_CFI_RULE_SAME;
+			off = 0;
+			return true;
+		}
+		const auto &L = *LocOpt;
+		switch (L.getLocation()) {
+		case dwarf::UnwindLocation::Unspecified:
+		case dwarf::UnwindLocation::Same:
+			rule = DWARF_CFI_RULE_SAME;
+			off = 0;
+			return true;
+		case dwarf::UnwindLocation::Undefined:
+			rule = DWARF_CFI_RULE_UNDEFINED;
+			off = 0;
+			return true;
+		case dwarf::UnwindLocation::CFAPlusOffset:
+			if (!L.getDereference())
+				return false;
+			rule = DWARF_CFI_RULE_OFFSET;
+			off = L.getOffset();
+			return true;
+		case dwarf::UnwindLocation::DWARFExpr: {
+			if (!L.getDereference())
+				return false;
+			auto ExprOpt = L.getDWARFExpressionBytes();
+			if (!ExprOpt)
+				return false;
+			SmallVector<DWARFExpression::Operation, 4> Ops;
+			for (auto &Op : *ExprOpt) {
+				if (Op.isError())
+					return false;
+				Ops.push_back(Op);
+			}
+			uint8_t breg_fp = dwarf::DW_OP_breg0 + arch.fp_reg;
+			uint8_t breg_sp = dwarf::DW_OP_breg0 + arch.sp_reg;
+			if (Ops.size() == 1 &&
+			    (Ops[0].getCode() == breg_fp ||
+			     Ops[0].getCode() == breg_sp)) {
+				int32_t o =
+					(int32_t)(int64_t)Ops[0].getRawOperand(0);
+				if (is_sp) {
+					if (Ops[0].getCode() == breg_sp &&
+					    out.cfa_base ==
+						    DWARF_CFI_BASE_SP_INDIRECT &&
+					    o == out.cfa_off) {
+						rule = DWARF_CFI_RULE_SAME;
+						off = 0;
+						return true;
+					}
+					return false;
+				}
+				if (is_ra && Ops[0].getCode() != breg_sp)
+					return false;
+				rule = (Ops[0].getCode() == breg_fp)
+					   ? DWARF_CFI_RULE_FP_OFFSET
+					   : DWARF_CFI_RULE_SP_OFFSET;
+				off = o;
+				return true;
+			}
+			return false;
+		}
+		default:
+			return false;
+		}
+	};
+
+	uint32_t ra_col = Cie ? (uint32_t)Cie->getReturnAddressRegister()
+			      : arch.ra_reg;
+	if (!mapRegRule(arch.fp_reg, out.fp_rule, out.fp_off, false, false))
+		return false;
+	if (!mapRegRule(ra_col, out.ra_rule, out.ra_off, false, true))
+		return false;
+	if (!mapRegRule(arch.sp_reg, out.sp_rule, out.sp_off, true, false))
+		return false;
+
+	return true;
+}
+
+static bool isRelativeEhEncoding(uint8_t enc)
+{
+	if (enc == dwarf::DW_EH_PE_omit)
+		return true;
+	uint8_t adj = enc & 0x70;
+	return adj == dwarf::DW_EH_PE_pcrel || adj == dwarf::DW_EH_PE_datarel;
+}
+
+/**
+ * verifyOracle1Dwarf() - Cross-check libLLVM DWARFUnwindTable vs. dwarf_cfi.c
+ */
+static int verifyOracle1Dwarf(const ObjectFile &Obj, const ArchSpec &AS,
+			      uint64_t eh_hdr_vma, StringRef eh_hdr_bytes,
+			      uint64_t min_eh_vma, bool can_test_kmem,
+			      const std::vector<uint8_t> &kmem_arena,
+			      const uint8_t *kmem_hdr,
+			      const uint8_t *kmem_eh_start,
+			      const uint8_t *kmem_eh_end,
+			      const VerifyOptions &opts, VerifyStats &st,
+			      std::vector<FDERange> &fde_ranges)
+{
+	std::unique_ptr<DWARFContext> DCtx = DWARFContext::create(Obj);
+	auto EHOrErr = DCtx->getEHFrame();
+	if (!EHOrErr) {
+		consumeError(EHOrErr.takeError());
+		return 1;
+	}
+	const DWARFDebugFrame *EH = *EHOrErr;
+
+	for (const dwarf::FrameEntry &FE : EH->entries()) {
+		const auto *Fde = dyn_cast<dwarf::FDE>(&FE);
+		if (!Fde || Fde->getAddressRange() == 0)
+			continue;
+		st.fdes_total++;
+
+		uint64_t fstart = Fde->getInitialLocation();
+		uint64_t fend = fstart + Fde->getAddressRange();
+
+		auto UTOrErr = dwarf::createUnwindTable(Fde);
+		if (!UTOrErr) {
+			consumeError(UTOrErr.takeError());
+			st.fdes_outside_minimal++;
+			fde_ranges.push_back({fstart, fend, false, false});
+			continue;
+		}
+		const dwarf::UnwindTable &UT = *UTOrErr;
+		if (UT.size() == 0) {
+			st.fdes_outside_minimal++;
+			fde_ranges.push_back({fstart, fend, false, false});
+			continue;
+		}
+
+		bool all_rows_minimal = true;
+		std::vector<std::pair<uint64_t, dwarf_cfi_row>> exp_rows;
+		exp_rows.reserve(UT.size());
+		for (size_t i = 0; i < UT.size(); i++) {
+			dwarf_cfi_row mr;
+			if (!llvmRowToMinimal(UT[i], Fde->getLinkedCIE(),
+					      AS.karch, mr)) {
+				all_rows_minimal = false;
+				break;
+			}
+			exp_rows.push_back({UT[i].getAddress(), mr});
+		}
+
+		if (!all_rows_minimal) {
+			st.fdes_outside_minimal++;
+			fde_ranges.push_back({fstart, fend, false, false});
+			continue;
+		}
+		st.fdes_minimal_supported++;
+		const dwarf::CIE *Cie = Fde->getLinkedCIE();
+		bool is_sig = Cie && Cie->getAugmentationString().contains('S');
+		bool fde_rel = Cie &&
+			       isRelativeEhEncoding(Cie->getFDEPointerEncoding());
+		fde_ranges.push_back({fstart, fend, true, is_sig});
+
+		SmallVector<uint64_t, 16> check_pcs;
+		check_pcs.push_back(fstart);
+		for (auto &pr : exp_rows) {
+			if (pr.first >= fstart && pr.first < fend) {
+				if (pr.first > fstart)
+					check_pcs.push_back(pr.first - 1);
+				check_pcs.push_back(pr.first);
+			}
+		}
+		check_pcs.push_back(fend - 1);
+		std::sort(check_pcs.begin(), check_pcs.end());
+		check_pcs.erase(std::unique(check_pcs.begin(), check_pcs.end()),
+				check_pcs.end());
+
+		for (uint64_t pc : check_pcs) {
+			const dwarf_cfi_row *exp = &exp_rows[0].second;
+			for (auto &pr : exp_rows) {
+				if (pr.first <= pc)
+					exp = &pr.second;
+				else
+					break;
+			}
+
+			dwarf_cfi_row krow_user{};
+			int err_u = dwarf_cfi_unwind_user_eh_frame_hdr(
+				(unsigned long)eh_hdr_vma, eh_hdr_bytes.size(),
+				(unsigned long)pc, &AS.karch, &krow_user);
+			st.fde_pc_checks++;
+
+			if (err_u != 0 || !rowsEqual(krow_user, *exp)) {
+				st.llvm_vs_kernel_mismatches++;
+				char buf[200];
+				snprintf(buf, sizeof(buf),
+					 "PC=0x%" PRIx64 " err_u=%d kernel(cfa=%u:%d fp=%u:%d ra=%u:%d)"
+					 " llvm(cfa=%u:%d fp=%u:%d ra=%u:%d)",
+					 pc, err_u, krow_user.cfa_base,
+					 krow_user.cfa_off, krow_user.fp_rule,
+					 krow_user.fp_off, krow_user.ra_rule,
+					 krow_user.ra_off, exp->cfa_base,
+					 exp->cfa_off, exp->fp_rule,
+					 exp->fp_off, exp->ra_rule,
+					 exp->ra_off);
+				recordIssue(st, opts, "llvm_vs_kernel_dwarf",
+					    buf);
+			}
+
+			if (can_test_kmem && fde_rel) {
+				dwarf_cfi_row krow_kmem{};
+				uintptr_t base_u =
+					reinterpret_cast<uintptr_t>(kmem_arena.data());
+				unsigned long kpc = (unsigned long)(
+					base_u +
+					static_cast<uintptr_t>(pc - min_eh_vma));
+				int err_k = dwarf_cfi_unwind_eh_frame_hdr(
+					kmem_hdr, eh_hdr_bytes.size(),
+					kmem_eh_start, kmem_eh_end, kpc,
+					&AS.karch, &krow_kmem);
+				st.kmem_pc_checks++;
+				if (err_k != err_u ||
+				    (err_u == 0 &&
+				     !rowsEqual(krow_kmem, krow_user)))
+					st.kmem_vs_user_mismatches++;
+			}
+		}
+	}
+
+	std::sort(fde_ranges.begin(), fde_ranges.end(),
+		  [](const FDERange &a, const FDERange &b) {
+			  return a.start < b.start;
+		  });
+	return 0;
+}
+
+static int verifyFile(const char *path, const VerifyOptions &opts)
+{
+	auto BufOrErr = MemoryBuffer::getFile(path);
+	if (!BufOrErr) {
+		errs() << "Failed to open " << path << "\n";
+		return 1;
+	}
+	auto ObjOrErr =
+		ObjectFile::createObjectFile(BufOrErr.get()->getMemBufferRef());
+	if (!ObjOrErr) {
+		consumeError(ObjOrErr.takeError());
+		errs() << "Not an object file: " << path << "\n";
+		return 1;
+	}
+	ObjectFile &Obj = *ObjOrErr.get();
+
+	if (Obj.is64Bit() && sizeof(unsigned long) < 8) {
+		errs() << path
+		       << ": 64-bit ELF verification requires a 64-bit host build\n";
+		return 1;
+	}
+
+	ArchSpec AS;
+	if (!getArchSpec(Obj, AS)) {
+		errs() << "Unsupported architecture in " << path << "\n";
+		return 1;
+	}
+
+	StringRef eh_bytes, eh_hdr_bytes, orc_bytes, orc_ip_bytes;
+	uint64_t eh_vma = 0, eh_hdr_vma = 0, orc_ip_vma = 0;
+	std::vector<ExecSec> exec_secs;
+
+	for (const SectionRef &Sec : Obj.sections()) {
+		Expected<StringRef> NameOrErr = Sec.getName();
+		if (!NameOrErr) {
+			consumeError(NameOrErr.takeError());
+			continue;
+		}
+		StringRef Name = *NameOrErr;
+		Expected<StringRef> DataOrErr = Sec.getContents();
+		if (!DataOrErr) {
+			consumeError(DataOrErr.takeError());
+			continue;
+		}
+		StringRef Data = *DataOrErr;
+		uint64_t Addr = Sec.getAddress();
+
+		if (Name == ".eh_frame") {
+			eh_bytes = Data;
+			eh_vma = Addr;
+		} else if (Name == ".eh_frame_hdr") {
+			eh_hdr_bytes = Data;
+			eh_hdr_vma = Addr;
+		} else if (Name == ".orc_unwind") {
+			orc_bytes = Data;
+		} else if (Name == ".orc_unwind_ip") {
+			orc_ip_bytes = Data;
+			orc_ip_vma = Addr;
+		}
+		if (Sec.isText() && !Data.empty())
+			exec_secs.push_back({Name.str(), Addr, Data});
+	}
+
+	if (eh_bytes.empty() || eh_hdr_bytes.empty() ||
+	    eh_hdr_bytes.size() < 12) {
+		errs() << path << ": missing .eh_frame or .eh_frame_hdr\n";
+		return 1;
+	}
+
+	host_vma_seg segs[2] = {
+		{(unsigned long)eh_hdr_vma, eh_hdr_bytes.size(),
+		 reinterpret_cast<const uint8_t *>(eh_hdr_bytes.data())},
+		{(unsigned long)eh_vma, eh_bytes.size(),
+		 reinterpret_cast<const uint8_t *>(eh_bytes.data())},
+	};
+	host_set_vma_segs(segs, 2);
+
+	uint64_t min_eh_vma = std::min(eh_hdr_vma, eh_vma);
+	uint64_t max_eh_end = std::max(eh_hdr_vma + eh_hdr_bytes.size(),
+				       eh_vma + eh_bytes.size());
+	std::vector<uint8_t> kmem_arena;
+	bool can_test_kmem =
+		(max_eh_end >= min_eh_vma) &&
+		(max_eh_end - min_eh_vma) <= (64ULL * 1024 * 1024) &&
+		isRelativeEhEncoding((uint8_t)eh_hdr_bytes[1]) &&
+		isRelativeEhEncoding((uint8_t)eh_hdr_bytes[3]);
+	const uint8_t *kmem_hdr = nullptr;
+	const uint8_t *kmem_eh_start = nullptr;
+	const uint8_t *kmem_eh_end = nullptr;
+	if (can_test_kmem) {
+		kmem_arena.assign(max_eh_end - min_eh_vma, 0);
+		memcpy(kmem_arena.data() + (eh_hdr_vma - min_eh_vma),
+		       eh_hdr_bytes.data(), eh_hdr_bytes.size());
+		memcpy(kmem_arena.data() + (eh_vma - min_eh_vma),
+		       eh_bytes.data(), eh_bytes.size());
+		kmem_hdr = kmem_arena.data() + (eh_hdr_vma - min_eh_vma);
+		kmem_eh_start = kmem_arena.data() + (eh_vma - min_eh_vma);
+		kmem_eh_end = kmem_eh_start + eh_bytes.size();
+		uintptr_t h_addr = reinterpret_cast<uintptr_t>(kmem_hdr);
+		if (h_addr < 0x80000000ULL ||
+		    h_addr > UINTPTR_MAX - 0x80000000ULL)
+			can_test_kmem = false;
+	}
+
+	VerifyStats st;
+	std::vector<FDERange> fde_ranges;
+	if (verifyOracle1Dwarf(Obj, AS, eh_hdr_vma, eh_hdr_bytes, min_eh_vma,
+			       can_test_kmem, kmem_arena, kmem_hdr,
+			       kmem_eh_start, kmem_eh_end, opts, st,
+			       fde_ranges) != 0) {
+		errs() << path << ": LLVM getEHFrame() failed\n";
+		return 1;
+	}
+
+#if defined(HAVE_VERIFY_INSN) || defined(HAVE_VERIFY_ORC)
+	std::string TargetErr;
+	const Target *TheTarget =
+		TargetRegistry::lookupTarget(AS.triple_str, TargetErr);
+	if (!TheTarget) {
+		errs() << "lookupTarget failed: " << TargetErr << "\n";
+		return 1;
+	}
+
+	MCTargetOptions MCOpts;
+	std::unique_ptr<MCRegisterInfo> MCRI(
+		TheTarget->createMCRegInfo(AS.triple_str));
+	std::unique_ptr<MCAsmInfo> MAI(
+		TheTarget->createMCAsmInfo(*MCRI, AS.triple_str, MCOpts));
+	std::unique_ptr<MCSubtargetInfo> STI(
+		TheTarget->createMCSubtargetInfo(AS.triple_str, "",
+						 AS.features));
+	std::unique_ptr<MCInstrInfo> MCII(TheTarget->createMCInstrInfo());
+	std::unique_ptr<MCInstrAnalysis> MIA(
+		TheTarget->createMCInstrAnalysis(MCII.get()));
+	MCContext Ctx(Triple(AS.triple_str), MAI.get(), MCRI.get(), STI.get());
+	std::unique_ptr<MCObjectFileInfo> MOFI(
+		TheTarget->createMCObjectFileInfo(Ctx, /*PIC=*/false));
+	Ctx.setObjectFileInfo(MOFI.get());
+	std::unique_ptr<MCDisassembler> Disasm(
+		TheTarget->createMCDisassembler(*STI, Ctx));
+	std::unique_ptr<MCInstPrinter> InstPrinter(
+		TheTarget->createMCInstPrinter(Triple(AS.triple_str), 0, *MAI,
+					       *MCII, *MCRI));
+
+	std::vector<FuncSym> func_syms;
+	std::unordered_set<uint64_t> noreturn_addrs;
+
+	auto collectSyms = [&](symbol_iterator begin, symbol_iterator end) {
+		for (auto it = begin; it != end; ++it) {
+			SymbolRef Sym = *it;
+			auto TypeOrErr = Sym.getType();
+			auto AddrOrErr = Sym.getAddress();
+			auto NameOrErr = Sym.getName();
+			if (!TypeOrErr || !AddrOrErr || !NameOrErr) {
+				if (!TypeOrErr)
+					consumeError(TypeOrErr.takeError());
+				if (!AddrOrErr)
+					consumeError(AddrOrErr.takeError());
+				if (!NameOrErr)
+					consumeError(NameOrErr.takeError());
+				continue;
+			}
+			uint64_t addr = *AddrOrErr;
+			StringRef name = *NameOrErr;
+			if ((AS.llvm_arch == Triple::aarch64 ||
+			     AS.llvm_arch == Triple::riscv64) &&
+			    (name.starts_with("$x") || name.starts_with("$d")))
+				continue;
+#ifdef HAVE_VERIFY_INSN
+			if (!name.empty() && isKnownNoreturnName(name))
+				noreturn_addrs.insert(addr);
+#endif
+			if (*TypeOrErr == SymbolRef::ST_Function) {
+				uint64_t sz = ELFSymbolRef(Sym).getSize();
+				func_syms.push_back({addr, sz, name.str()});
+			}
+		}
+	};
+	collectSyms(Obj.symbol_begin(), Obj.symbol_end());
+	if (const auto *EObj = dyn_cast<ELFObjectFileBase>(&Obj)) {
+		auto DynSyms = EObj->getDynamicSymbolIterators();
+		collectSyms(DynSyms.begin(), DynSyms.end());
+	}
+
+	std::sort(func_syms.begin(), func_syms.end(),
+		  [](const FuncSym &a, const FuncSym &b) {
+			  return a.addr != b.addr ? a.addr < b.addr
+						  : a.size > b.size;
+		  });
+	func_syms.erase(std::unique(func_syms.begin(), func_syms.end(),
+				    [](const FuncSym &a, const FuncSym &b) {
+					    return a.addr == b.addr;
+				    }),
+			func_syms.end());
+
+#ifdef HAVE_VERIFY_INSN
+	verifyOracle2Instructions(AS, eh_hdr_vma, eh_hdr_bytes, exec_secs,
+				  func_syms, noreturn_addrs, fde_ranges,
+				  *Disasm, *MCII, *MCRI, MIA.get(), opts, st);
+#endif
+
+#ifdef HAVE_VERIFY_ORC
+	if (AS.llvm_arch == Triple::x86_64 && !orc_bytes.empty() &&
+	    !orc_ip_bytes.empty()) {
+		verifyOracle3Orc(AS, eh_hdr_vma, eh_hdr_bytes, orc_bytes,
+				 orc_ip_bytes, orc_ip_vma, exec_secs, func_syms,
+				 *Disasm, *STI, *InstPrinter, opts, st);
+	}
+#else
+	(void)orc_bytes;
+	(void)orc_ip_bytes;
+	(void)orc_ip_vma;
+#endif
+#else
+	(void)orc_bytes;
+	(void)orc_ip_bytes;
+	(void)orc_ip_vma;
+	(void)exec_secs;
+#endif
+
+	bool oracle1_fail = (st.llvm_vs_kernel_mismatches > 0 ||
+			     st.kmem_vs_user_mismatches > 0);
+	bool strict_fail = opts.strict &&
+			   (st.insns_cfa_mismatch > 0 ||
+			    st.insns_ra_mismatch > 0 ||
+			    st.insns_fp_mismatch > 0 ||
+			    st.orc_cfa_mismatch > 0 ||
+			    st.orc_bp_mismatch > 0);
+
+	if (opts.quiet && !oracle1_fail && !strict_fail) {
+		if (st.has_insn_oracle) {
+			printf("%s: OK (FDEs: %" PRIu64 "/%" PRIu64
+			       ", funcs clean: %" PRIu64 "/%" PRIu64 ")\n",
+			       path, st.fdes_minimal_supported, st.fdes_total,
+			       st.funcs_clean, st.funcs_verified);
+		} else {
+			printf("%s: OK (FDEs: %" PRIu64 "/%" PRIu64 ")\n",
+			       path, st.fdes_minimal_supported, st.fdes_total);
+		}
+		fflush(stdout);
+		return 0;
+	}
+
+	printf("=== %s (%s) ===\n", path, AS.triple_str);
+	printf("  [Oracle 1: LLVM Reference DWARF vs Kernel Minimal DWARF]\n");
+	printf("    FDEs total / Minimal-supported : %" PRIu64 " / %" PRIu64
+	       " (%.2f%%)\n",
+	       st.fdes_total, st.fdes_minimal_supported,
+	       st.fdes_total ? 100.0 * st.fdes_minimal_supported / st.fdes_total
+			     : 0.0);
+	printf("    Transition PCs evaluated       : %" PRIu64 "\n",
+	       st.fde_pc_checks);
+	printf("    LLVM vs Kernel mismatches      : %" PRIu64 "\n",
+	       st.llvm_vs_kernel_mismatches);
+	if (st.kmem_pc_checks > 0)
+		printf("    kmem vs user stream mismatches : %" PRIu64
+		       " (%" PRIu64 " PCs)\n",
+		       st.kmem_vs_user_mismatches, st.kmem_pc_checks);
+
+	if (st.has_insn_oracle) {
+		printf("  [Oracle 2: Machine-Instruction Abstract Execution & Clobber Check]\n");
+		printf("    STT_FUNC total / verified      : %" PRIu64
+		       " / %" PRIu64 " (no-FDE: %" PRIu64
+		       ", split/custom-entry: %" PRIu64 ")\n",
+		       st.funcs_total, st.funcs_verified, st.funcs_no_fde,
+		       st.funcs_mid_frame_split);
+		printf("    Functions 100%% instruction-clean: %" PRIu64
+		       " / %" PRIu64 " (%.2f%%)\n",
+		       st.funcs_clean, st.funcs_verified,
+		       st.funcs_verified
+			   ? 100.0 * st.funcs_clean / st.funcs_verified
+			   : 0.0);
+		printf("    Reachable instructions checked : %" PRIu64
+		       " (CFA diff: %" PRIu64 ", RA diff: %" PRIu64
+		       ", FP diff: %" PRIu64 ")\n",
+		       st.insns_verified, st.insns_cfa_mismatch,
+		       st.insns_ra_mismatch, st.insns_fp_mismatch);
+	}
+	for (const auto &kv : st.mismatch_reasons)
+		printf("      - %-28s : %" PRIu64 "\n", kv.first.c_str(),
+		       kv.second);
+	for (const auto &s : st.sample_issues)
+		printf("      sample: %s\n", s.c_str());
+
+	if (st.has_orc) {
+		uint64_t denom = st.orc_call_insns - st.orc_no_fde;
+		printf("  [Oracle 3: Direct x86-64 ORC (.orc_unwind) vs Kernel Minimal DWARF]\n");
+		printf("    ORC_TYPE_CALL insns (with FDE) : %" PRIu64
+		       " (no-FDE asm: %" PRIu64 ")\n",
+		       denom, st.orc_no_fde);
+		printf("    Exact ORC == CFI matches       : %" PRIu64
+		       " / %" PRIu64 " (%.4f%%)\n",
+		       st.orc_matched, denom,
+		       denom ? 100.0 * st.orc_matched / denom : 0.0);
+		printf("    ORC diffs (CFA / BP)           : %" PRIu64
+		       " / %" PRIu64 "\n",
+		       st.orc_cfa_mismatch, st.orc_bp_mismatch);
+		for (const auto &s : st.sample_orc_diffs)
+			printf("      orc_diff: %s\n", s.c_str());
+	}
+	printf("\n");
+	fflush(stdout);
+	return (oracle1_fail || strict_fail) ? 1 : 0;
+}
+
+static void printUsage(const char *prog)
+{
+	printf("Usage: %s [options] <elf_file> [elf_file...]\n"
+	       "\n"
+	       "Options:\n"
+	       "  --strict           Fail (exit 1) on any instruction or ORC diff\n"
+	       "                     (Oracle 1 DWARF interpreter mismatches always fail)\n"
+	       "  --max-samples <N>  Maximum sample diagnostics per category (default: 6)\n"
+	       "  -q, --quiet        Print single-line summary when verification succeeds\n"
+	       "  -h, --help         Show this help message\n",
+	       prog);
+}
+
+int main(int argc, char **argv)
+{
+	InitLLVM X(argc, argv);
+	InitializeAllTargetInfos();
+	InitializeAllTargetMCs();
+	InitializeAllDisassemblers();
+
+	VerifyOptions opts;
+	std::vector<const char *> files;
+
+	for (int i = 1; i < argc; i++) {
+		StringRef arg(argv[i]);
+		if (arg == "-h" || arg == "--help") {
+			printUsage(argv[0]);
+			return 0;
+		} else if (arg == "--strict") {
+			opts.strict = true;
+		} else if (arg == "-q" || arg == "--quiet") {
+			opts.quiet = true;
+		} else if (arg == "--max-samples") {
+			if (i + 1 >= argc) {
+				errs() << "--max-samples requires an integer argument\n";
+				return 1;
+			}
+			char *endp = nullptr;
+			unsigned long v = strtoul(argv[++i], &endp, 10);
+			if (!endp || *endp != '\0') {
+				errs() << "Invalid --max-samples value: "
+				       << argv[i] << "\n";
+				return 1;
+			}
+			opts.max_samples = (size_t)v;
+		} else if (arg.starts_with("-")) {
+			errs() << "Unknown option: " << arg << "\n";
+			printUsage(argv[0]);
+			return 1;
+		} else {
+			files.push_back(argv[i]);
+		}
+	}
+
+	if (files.empty()) {
+		printUsage(argv[0]);
+		return 1;
+	}
+
+	int rc = 0;
+	for (const char *f : files)
+		rc |= verifyFile(f, opts);
+	return rc;
+}
diff --git a/tools/unwind/verify_cfi.hpp b/tools/unwind/verify_cfi.hpp
new file mode 100644
index 000000000000..10bb77302e38
--- /dev/null
+++ b/tools/unwind/verify_cfi.hpp
@@ -0,0 +1,147 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+#ifndef _TOOLS_UNWIND_VERIFY_CFI_H
+#define _TOOLS_UNWIND_VERIFY_CFI_H
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wunused-parameter"
+#include "llvm/ADT/ArrayRef.h"
+#include "llvm/ADT/StringRef.h"
+#include "llvm/MC/MCDisassembler/MCDisassembler.h"
+#include "llvm/MC/MCInstPrinter.h"
+#include "llvm/MC/MCInstrAnalysis.h"
+#include "llvm/MC/MCInstrInfo.h"
+#include "llvm/MC/MCRegisterInfo.h"
+#include "llvm/MC/MCSubtargetInfo.h"
+#include "llvm/TargetParser/Triple.h"
+#pragma GCC diagnostic pop
+
+#include <cstddef>
+#include <cstdint>
+#include <map>
+#include <string>
+#include <unordered_set>
+#include <vector>
+
+#include "dwarf_cfi_host.h"
+
+/**
+ * struct VerifyOptions - Command-line configuration for verify_cfi
+ * @strict: Return exit status 1 if Oracle 2 or Oracle 3 finds any instruction
+ *          or ORC discrepancy (Oracle 1 mismatches always return exit status 1).
+ * @quiet: Emit a single-line summary per verified file when no failure occurs.
+ * @max_samples: Maximum number of diagnostic mismatch samples printed per kind.
+ */
+struct VerifyOptions {
+	bool strict = false;
+	bool quiet = false;
+	size_t max_samples = 6;
+};
+
+/**
+ * struct ArchSpec - Target architecture parameters for LLVM MC and kernel CFI
+ * @llvm_arch: LLVM Triple::ArchType identifier.
+ * @triple_str: Target triple passed to LLVM TargetRegistry / MCDisassembler.
+ * @features: Subtarget feature string enabling ISA extensions in disassembly
+ *            (e.g. PAC/BTI on AArch64, compressed RVC on RISC-V).
+ * @karch: Kernel DWARF register mapping passed to kernel/unwind/dwarf_cfi.c.
+ * @entry_cfa_off: Byte offset from entry SP to caller's SP (8 on x86_64 where
+ *                 CALL pushes the 8-byte return address; 0 on arm64/riscv64).
+ * @ra_on_entry_stack: True if the return address starts at *(entry_SP + 0)
+ *                     rather than in @karch.ra_reg.
+ */
+struct ArchSpec {
+	llvm::Triple::ArchType llvm_arch;
+	const char *triple_str;
+	const char *features;
+	dwarf_cfi_arch karch;
+	int32_t entry_cfa_off;
+	bool ra_on_entry_stack;
+};
+
+/**
+ * struct VerifyStats - Aggregated verification counters and diagnostic samples
+ */
+struct VerifyStats {
+	// Oracle 1: LLVM Reference DWARF vs Kernel Minimal DWARF
+	uint64_t fdes_total = 0;
+	uint64_t fdes_minimal_supported = 0;
+	uint64_t fdes_outside_minimal = 0;
+	uint64_t fde_pc_checks = 0;
+	uint64_t kmem_pc_checks = 0;
+	uint64_t kmem_vs_user_mismatches = 0;
+	uint64_t llvm_vs_kernel_mismatches = 0;
+
+	// Oracle 2: Instruction Abstract Execution & Clobber Check
+	bool has_insn_oracle = false;
+	uint64_t funcs_total = 0;
+	uint64_t funcs_no_fde = 0;
+	uint64_t funcs_mid_frame_split = 0;
+	uint64_t funcs_verified = 0;
+	uint64_t funcs_clean = 0;
+	uint64_t insns_verified = 0;
+	uint64_t insns_cfa_mismatch = 0;
+	uint64_t insns_ra_mismatch = 0;
+	uint64_t insns_fp_mismatch = 0;
+	std::map<std::string, uint64_t> mismatch_reasons;
+	std::vector<std::string> sample_issues;
+
+	// Oracle 3: ORC vs Kernel Minimal DWARF
+	bool has_orc = false;
+	uint64_t orc_call_insns = 0;
+	uint64_t orc_matched = 0;
+	uint64_t orc_no_fde = 0;
+	uint64_t orc_cfa_mismatch = 0;
+	uint64_t orc_bp_mismatch = 0;
+	std::vector<std::string> sample_orc_diffs;
+};
+
+struct FDERange {
+	uint64_t start;
+	uint64_t end;
+	bool supported;
+	bool signal;
+};
+
+struct ExecSec {
+	std::string name;
+	uint64_t vma;
+	llvm::StringRef bytes;
+};
+
+struct FuncSym {
+	uint64_t addr;
+	uint64_t size;
+	std::string name;
+};
+
+bool rowsEqual(const dwarf_cfi_row &a, const dwarf_cfi_row &b);
+
+void recordIssue(VerifyStats &st, const VerifyOptions &opts,
+		 const std::string &reason, const std::string &detail);
+
+llvm::ArrayRef<uint8_t> findExecBytes(const std::vector<ExecSec> &exec_secs,
+				      uint64_t addr, uint64_t len);
+
+bool isKnownNoreturnName(llvm::StringRef Name);
+
+void verifyOracle2Instructions(
+	const ArchSpec &AS, uint64_t eh_hdr_vma, llvm::StringRef eh_hdr_bytes,
+	const std::vector<ExecSec> &exec_secs,
+	const std::vector<FuncSym> &func_syms,
+	const std::unordered_set<uint64_t> &noreturn_addrs,
+	const std::vector<FDERange> &fde_ranges,
+	const llvm::MCDisassembler &Disasm, const llvm::MCInstrInfo &MCII,
+	const llvm::MCRegisterInfo &MCRI, const llvm::MCInstrAnalysis *MIA,
+	const VerifyOptions &opts, VerifyStats &st);
+
+void verifyOracle3Orc(const ArchSpec &AS, uint64_t eh_hdr_vma,
+		      llvm::StringRef eh_hdr_bytes, llvm::StringRef orc_bytes,
+		      llvm::StringRef orc_ip_bytes, uint64_t orc_ip_vma,
+		      const std::vector<ExecSec> &exec_secs,
+		      const std::vector<FuncSym> &func_syms,
+		      const llvm::MCDisassembler &Disasm,
+		      const llvm::MCSubtargetInfo &STI,
+		      llvm::MCInstPrinter &InstPrinter,
+		      const VerifyOptions &opts, VerifyStats &st);
+
+#endif /* _TOOLS_UNWIND_VERIFY_CFI_H */
-- 
2.56.1.831.g720f3f5937-goog

