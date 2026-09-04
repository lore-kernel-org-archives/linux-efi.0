Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4E945560A
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 10:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516651; cv=none; b=Ubhkk3StetbQCAcV3d9yl2SYyED8/OR01jd1NJhF32NQyANjFeJfXUuhMI4peCkOiJ7Aw1f8KgCj6uam6Ix6Cj+mIqI0785yooCa6ilIxfcXWdhSKz2EMPvEiHNj/tRTn6manSdrprcJNpjVDVFNhDnCWLjKb4Cl0e304ccxM9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516651; c=relaxed/simple;
	bh=/oiDxHrVDKa7VGrXp6hL5mHL7wu/IJpMsp5HWkvasdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVfRu/4Ruymm750MHWmJaQZdaDyZhpvDHv2k0wAvt7wSgcBzw9hHXRl0Zb4XwiSueCzZ4BD+oSNJpJUblYUynTqx8EjFzRl2918klyLj/2FQQnPBjjBESHV07PSiSJS+C/c8Eblt1JFCzt8gMw0CjEqGclCkV3OiiFOLv1zfY/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dg/D2y03; arc=none smtp.client-ip=91.218.175.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dg/D2y03"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/oiDxHrVDKa7VGrXp6hL5mHL7wu/IJpMsp5HWkvasdU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516638; v=1; x=1789121438;
 b=dg/D2y03QKFwv7tqBdzyogXQtKWJ6QyG1AcV3TJ7bsMddVZASTcVwj62I/0/wfZEFineU+UJ
 CnMSS7E65A4K0nrZe9VxlTxW2cOeDVyg0D8ncWkhy27GLqaMZuMNHGYTvO2pwJF8dwi1WXA3wLh
 UgCdLH577lFDOfuakyd6prj0=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6e5c0a65e25e0cdf;
	Fri, 04 Sep 2026 10:10:37 +0000
X-Mizu-Trace-ID: 6e5c0a65e25e0cdf
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v5 5/5] selftests/kho: add LoongArch vmtest support
Date: Fri,  4 Sep 2026 18:08:52 +0800
Message-ID: <20260904100852.26006-6-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

Add loongarch.conf to configure QEMU's LoongArch virtual machine with a
la464 CPU, an 8250 serial console, and the generic PCI host controller.
Extend vmtest.sh to recognize loongarch64 as a supported target and map
it to the loongarch kernel architecture name.

Boot vmlinux.efi through EFI firmware.  The KHO configuration table
channel is installed by the EFI stub during the initial boot, so direct
kernel boot bypasses the path that this test needs to exercise.  QEMU_EFI
defaults to the firmware shipped under /usr/share/edk2/loongarch64/ and
can be overridden for distributions that install it under a different
path, such as Debian's qemu-efi-loongarch64 package.

QEMU's LoongArch virt machine has no i8042 controller.  Enable the generic
PCI host so its I/O space is mapped before the i8042 fallback probe
accesses the legacy ports.  This avoids disabling the i8042 options and
allows the same kernel configuration to remain usable on physical hosts.

Enable ACPI_SPCR_TABLE so the bare earlycon parameter can obtain the UART
type, MMIO address and baud rate from the SPCR table installed by EDK2.
Unlike on x86, ACPI_SPCR_TABLE does not default to enabled on LoongArch.
Without it, no early console is registered for the EFI firmware boot path,
and vmtest cannot observe the early kernel output in its serial log.

The KHO vmtest requires CONFIG_DEFERRED_STRUCT_PAGE_INIT=y, which
depends on SPARSEMEM.  Select CONFIG_SPARSEMEM_MANUAL=y to satisfy the
dependency on LoongArch.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 11 +++++++++++
 tools/testing/selftests/kho/vmtest.sh      |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
new file mode 100644
index 000000000000..36153b03c4ef
--- /dev/null
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -0,0 +1,11 @@
+QEMU_EFI="${QEMU_EFI:-/usr/share/edk2/loongarch64/QEMU_EFI.fd}"
+QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464 -bios $QEMU_EFI"
+QEMU_KCONFIG="
+CONFIG_ACPI_SPCR_TABLE=y
+CONFIG_PCI_HOST_GENERIC=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SPARSEMEM_MANUAL=y
+"
+KERNEL_IMAGE="vmlinux.efi"
+KERNEL_CMDLINE="console=ttyS0 earlycon"
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 0014bd76e88d..d05ba0734b25 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -21,7 +21,7 @@ Options:
 	-d)	path to the kernel build directory
 	-j)	number of jobs for compilation, similar to -j in make
 	-t)	run test for target_arch, requires CROSS_COMPILE set
-		supported targets: aarch64, x86_64
+		supported targets: aarch64, loongarch64, x86_64
 	-h)	display this help
 EOF
 }
@@ -126,6 +126,7 @@ function target_to_arch() {
 
 	case $target in
 	     aarch64) echo "arm64" ;;
+	     loongarch64) echo "loongarch" ;;
 	     x86_64) echo "x86" ;;
 	     *) skip "architecture $target is not supported"
 	esac
-- 
2.53.0

