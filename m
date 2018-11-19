From: Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 0/3] selftest/ima: fail kexec_load syscall
Date: Mon, 19 Nov 2018 14:56:08 -0500
Message-ID: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

The "ima: add support for arch specific policies" patch set introduced
architecture specific policies, including an x86 policy which prevents
loading a kernel image via the kexec_load syscall.

This patch set preq's that patch set, adding a missing kexec_load
syscall failure message, extending the existing support for detecting
secureboot mode, and defining a kexec_load syscall selftest to
simplify testing.

To run the kexec_load test requires root privileges.  Execute:
	"sudo make TARGETS=ima kselftest".

With secure boot enabled, the kexec_load fails, but the test
succeeds.

selftests: ima: test_kexec_load.sh
========================================
./test_kexec_load.sh: kexec_load failed [PASS]
ok 1..1 selftests: ima: test_kexec_load.sh [PASS]


Mimi

Mimi Zohar (3):
  ima: add error mesage to kexec_load
  selftests/ima: kexec_load syscall test
  x86/ima: retry detecting secure boot mode

 arch/x86/kernel/Makefile                       |  2 +
 arch/x86/kernel/ima_arch.c                     | 46 +++++++++++++++++++++-
 include/linux/ima.h                            |  2 +-
 security/integrity/ima/ima_main.c              |  4 +-
 tools/testing/selftests/Makefile               |  1 +
 tools/testing/selftests/ima/Makefile           | 11 ++++++
 tools/testing/selftests/ima/config             |  4 ++
 tools/testing/selftests/ima/test_kexec_load.sh | 54 ++++++++++++++++++++++++++
 8 files changed, 120 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/ima/Makefile
 create mode 100644 tools/testing/selftests/ima/config
 create mode 100755 tools/testing/selftests/ima/test_kexec_load.sh

-- 
2.7.5
