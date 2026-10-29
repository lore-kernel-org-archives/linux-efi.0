Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.204
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295067;
	b=FkNqALdMiGvbAjU8cYZozikAlQzZqPVwZVSGTm1efHet65dMuGMsU3IkaEVieyZjF/jl
	 zGaiWOmW798pd5fqjSl92e8XiP3Xuzw4GITF23D8VpcYZKL8BL/mgqCJ4iURWLzObUIft
	 BE0AF/SceCRvmFTDFZhtjcvVjaAc7OasoVM1enyeeVpZXIuIkDK4Kg2OMJPetbW/vQveC
	 tQahiVEikBiymcKV6ztcOoEx6YHr3ZDKdn7ryZqPE6oVFhblqeHawDi85YPS2Cm+gHQAe
	 nN2nWl84HG4s6V7QMrhQVuvdORV+1qEe0jZpDdoh5FlQYm+4EdTiSoI8jLujexbGdrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295067;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hjl3YWLB9mIMK4NxN5xFoTsa4zvmwEeXlgSjnO0OUbA=;
	b=xnMzwoFNCzTi25Hh0Kwhc4L1nk4fmqaHMJfEUrrfMYF325YVStOSDjFevgBnKDrrDelM
	 BALTab59Jg3c7Zlz5r/hmABYSs5s2wLnSBlz/KexmJ4zWFcaq3vdevmcHMOBK8iOIawBQ
	 7fCgId2+rxrV2X77nH1qGE5USkKNFSLWrTquTrw05Q4Pv2oSnAxoUbn1xZzWk27ZjJH2/
	 8rkLZ7CYB51if+h6S8eWOEuMunHXB5jh1/Y+/zu1UFZ4mSxfm2PmG6Ytpos04spJvHFYT
	 K9Pt3/TT7CUDNtRzlCoM6AiE9uLi6Ie/gOvHq8XepU3hqUQToah47Ul9AUAENFV+vng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W9LFoFBs;
	arc=none smtp.remote-ip=91.218.175.204
Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2C6606A327
	for <linux-efi@vger.kernel.org>; Thu, 29 Oct 2026 17:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A2C6606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W9LFoFBs
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GBih4azSAalhMpwQa4vAt/wr7df5ETSpm+lkTN2YYcw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295064; v=1; x=1793899864;
 b=W9LFoFBszpWry1/NSZbVhjNsFbcVuSrt/CoO/JfaLe7WiVW7vFpNJY7uGjKf+aJPQSKJXkIV
 06V+5qqpODl9AsLap7BQ8oVrkrYL+GpTR9hNsSgs8TMSSct9wgIdgHD1c/40EKKFuVfRSevj1BA
 V7H11bHuwTRyacCfRGC8mjeE=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d28391d344248cfb;
	Thu, 29 Oct 2026 17:31:04 +0000
X-Mizu-Trace-ID: d28391d344248cfb
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
Subject: [PATCH v6 8/8] selftests/liveupdate: Add LoongArch vmtest support
Date: Fri, 30 Oct 2026 02:29:55 +0900
Message-ID: <20261029172956.20791-9-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

Add the LoongArch kernel configuration, target and cross-compiler
detection, and include loongarch64 in the VM test suite.

Boot vmlinux.efi through EFI firmware so the EFI stub installs the KHO
table. Allow the firmware path to be set with QEMU_EFI and skip the test
if it is unavailable.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 .../selftests/liveupdate/config.loongarch64        |  5 +++++
 tools/testing/selftests/liveupdate/run-vmtests.sh  |  4 ++--
 tools/testing/selftests/liveupdate/vmtest.sh       | 14 +++++++++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.loongarch64

diff --git a/tools/testing/selftests/liveupdate/config.loongarch64 b/tools/testing/selftests/liveupdate/config.loongarch64
new file mode 100644
index 000000000000..264067ef5ab1
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config.loongarch64
@@ -0,0 +1,5 @@
+CONFIG_ACPI_SPCR_TABLE=y
+CONFIG_PCI_HOST_GENERIC=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SMP=y
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index d656ce58c5a7..f6cfb76b1dac 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -4,7 +4,7 @@
 SCRIPT_DIR=$(dirname "$(realpath "$0")")
 TEST_RUNNER="$SCRIPT_DIR/vmtest.sh"
 
-TARGETS=("x86_64" "aarch64")
+TARGETS=("x86_64" "aarch64" "loongarch64")
 
 GREEN='\033[0;32m'
 RED='\033[0;31m'
@@ -72,7 +72,7 @@ function main() {
 		for test_name in "${TEST_NAMES[@]}"; do
 			log="$output_dir/${arch}_${test_name}.log"
 
-			printf "  -> %-8s %-24s ... " "$arch" "$test_name"
+			printf "  -> %-11s %-24s ... " "$arch" "$test_name"
 
 			"$TEST_RUNNER" -t "$arch" -T "$test_name" &> "$log"
 			exit_code=$?
diff --git a/tools/testing/selftests/liveupdate/vmtest.sh b/tools/testing/selftests/liveupdate/vmtest.sh
index 69beda6c961d..ffe82512f3e4 100755
--- a/tools/testing/selftests/liveupdate/vmtest.sh
+++ b/tools/testing/selftests/liveupdate/vmtest.sh
@@ -21,6 +21,12 @@ function get_arch_conf() {
 		QEMU_CMD="qemu-system-aarch64 -M virt -cpu max"
 		KERNEL_IMAGE="Image"
 		KERNEL_CMDLINE="console=ttyAMA0"
+	elif [[ "$arch" == "loongarch" ]]; then
+		local qemu_efi="${QEMU_EFI:-/usr/share/edk2/loongarch64/QEMU_EFI.fd}"
+		[ -r "$qemu_efi" ] || skip "EFI firmware '$qemu_efi' not found, set QEMU_EFI"
+		QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464 -bios $qemu_efi"
+		KERNEL_IMAGE="vmlinux.efi"
+		KERNEL_CMDLINE="console=ttyS0 earlycon"
 	elif [[ "$arch" == "x86" ]]; then
 		QEMU_CMD="qemu-system-x86_64"
 		KERNEL_IMAGE="bzImage"
@@ -37,11 +43,15 @@ $0 [-d build_dir] [-j jobs] [-t target_arch] [-T test_name] [-w workspace_dir] [
 Options:
 	-d)	path to the kernel build directory (default: .luo_test_build.<arch>)
 	-j)	number of jobs for compilation
-	-t)	run test for target_arch (aarch64, x86_64)
+	-t)	run test for target_arch (aarch64, loongarch64, x86_64)
 	-T)	test name to run (default: luo_kexec_simple)
 	-w)	custom workspace directory (default: creates temp dir)
 	-k)	keep workspace directory after successful test
 	-h)	display this help
+
+Environment:
+	QEMU_EFI	LoongArch EFI firmware path
+			(default: /usr/share/edk2/loongarch64/QEMU_EFI.fd)
 EOF
 }
 
@@ -86,6 +96,7 @@ function detect_cross_compile() {
 	local candidate=""
 	case "$target" in
 		aarch64) candidate="aarch64-linux-gnu-" ;;
+		loongarch64) candidate="loongarch64-linux-gnu-" ;;
 		x86_64)  candidate="x86_64-linux-gnu-" ;;
 		*)       skip "Auto-detection for target '$target' not supported. Please set CROSS_COMPILE manually." ;;
 	esac
@@ -193,6 +204,7 @@ function target_to_arch() {
 	local target=$1
 	case $target in
 	     aarch64) echo "arm64" ;;
+	     loongarch64) echo "loongarch" ;;
 	     x86_64) echo "x86" ;;
 	     *) skip "architecture $target is not supported"
 	esac
-- 
2.53.0

