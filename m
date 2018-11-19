From: Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 2/3] selftests/ima: kexec_load syscall test
Date: Mon, 19 Nov 2018 14:56:10 -0500
Message-ID: <1542657371-7019-3-git-send-email-zohar@linux.ibm.com>
References: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

The kernel CONFIG_KEXEC_VERIFY_SIG option is limited to verifying a
kernel image's signature, when loaded via the kexec_file_load syscall.
There is no method for verifying a kernel image's signature loaded
via the kexec_load syscall.

This test verifies loading the kernel image via the kexec_load syscall
fails when the kernel CONFIG_KEXEC_VERIFY_SIG option is enabled on
systems with secureboot enabled[1].

[1] Detecting secureboot enabled is architecture specific.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 tools/testing/selftests/Makefile               |  1 +
 tools/testing/selftests/ima/Makefile           | 11 ++++++
 tools/testing/selftests/ima/config             |  4 ++
 tools/testing/selftests/ima/test_kexec_load.sh | 54 ++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)
 create mode 100644 tools/testing/selftests/ima/Makefile
 create mode 100644 tools/testing/selftests/ima/config
 create mode 100755 tools/testing/selftests/ima/test_kexec_load.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index f1fe492c8e17..552c447af03d 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -13,6 +13,7 @@ TARGETS += firmware
 TARGETS += ftrace
 TARGETS += futex
 TARGETS += gpio
+TARGETS += ima
 TARGETS += intel_pstate
 TARGETS += ipc
 TARGETS += kcmp
diff --git a/tools/testing/selftests/ima/Makefile b/tools/testing/selftests/ima/Makefile
new file mode 100644
index 000000000000..0b3adf5444b6
--- /dev/null
+++ b/tools/testing/selftests/ima/Makefile
@@ -0,0 +1,11 @@
+# Makefile for kexec_load
+
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+
+ifeq ($(ARCH),x86)
+TEST_PROGS := test_kexec_load.sh
+
+include ../lib.mk
+
+endif
diff --git a/tools/testing/selftests/ima/config b/tools/testing/selftests/ima/config
new file mode 100644
index 000000000000..6bc86d4d9bb4
--- /dev/null
+++ b/tools/testing/selftests/ima/config
@@ -0,0 +1,4 @@
+CONFIG_IMA_APPRAISE
+CONFIG_IMA_ARCH_POLICY
+CONFIG_SECURITYFS
+CONFIG_KEXEC_VERIFY_SIG
diff --git a/tools/testing/selftests/ima/test_kexec_load.sh b/tools/testing/selftests/ima/test_kexec_load.sh
new file mode 100755
index 000000000000..3aafc6f6a400
--- /dev/null
+++ b/tools/testing/selftests/ima/test_kexec_load.sh
@@ -0,0 +1,54 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Loading a kernel image via the kexec_load syscall should fail
+# when the kerne is CONFIG_KEXEC_VERIFY_SIG enabled and the system
+# is booted in secureboot mode.
+
+TEST="$0"
+EFIVARFS="/sys/firmware/efi/efivars"
+rc=0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+# kexec requires root privileges
+if [ $UID != 0 ]; then
+	echo "$TEST: must be run as root" >&2
+	exit $ksft_skip
+fi
+
+# Make sure that efivars is mounted in the normal location
+if ! grep -q "^\S\+ $EFIVARFS efivarfs" /proc/mounts; then
+	echo "$TEST: efivars is not mounted on $EFIVARFS" >&2
+	exit $ksft_skip
+fi
+
+# Get secureboot mode
+file="$EFIVARFS/SecureBoot-*"
+if [ ! -e $file ]; then
+	echo "$TEST: unknown secureboot mode" >&2
+	exit $ksft_skip
+fi
+secureboot=`hexdump $file | awk '{print substr($4,length($4),1)}'`
+
+# kexec_load should fail in secure boot mode
+KERNEL_IMAGE="/boot/vmlinuz-`uname -r`"
+kexec -l $KERNEL_IMAGE &>> /dev/null
+if [ $? == 0 ]; then
+	kexec -u
+	if [ "$secureboot" == "1" ]; then
+		echo "$TEST: kexec_load succeeded [FAIL]"
+		rc=1
+	else
+		echo "$TEST: kexec_load succeeded [PASS]"
+	fi
+else
+	if [ "$secureboot" == "1" ]; then
+		echo "$TEST: kexec_load failed [PASS]"
+	else
+		echo "$TEST: kexec_load failed [FAIL]"
+		rc=1
+	fi
+fi
+
+exit $rc
-- 
2.7.5
