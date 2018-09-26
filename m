From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v4 0/6] Add support for architecture specific IMA policies
Date: Wed, 26 Sep 2018 17:52:04 +0530
Message-ID: <20180926122210.14642-1-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

The architecture specific policy, introduced in this patch set, permits
different architectures to define IMA policy rules based on kernel
configuration and system runtime information.

For example, on x86, there are two methods of verifying the kexec'ed kernel
image signature - CONFIG_KEXEC_VERIFY_SIG and IMA appraisal policy
KEXEC_KERNEL_CHECK. CONFIG_KEXEC_VERIFY_SIG enforces the kexec_file_load
syscall to verify file signatures, but does not prevent the kexec_load
syscall. The IMA KEXEC_KERNEL_CHECK policy rule verifies the kexec'ed
kernel image, loaded via the kexec_file_load syscall, is validly signed and
prevents loading a kernel image via the kexec_load syscall. When secure
boot is enabled, the kexec'ed kernel image needs to be signed and the
signature verified. In this environment, either method of verifying the
kexec'ed kernel image is acceptable, as long as the kexec_load syscall is
disabled.

The previous version of this patchset introduced a new IMA policy rule to
disable the kexec_load syscall, when CONFIG_KEXEC_VERIFY_SIG was enabled,
however that is removed from this version by introducing a different
mechanism.

The patchset defines an arch_ima_get_secureboot() function to retrieve the
secureboot state of the system. If secureboot is enabled and
CONFIG_KEXEC_VERIFY_SIG is configured, it denies permission to kexec_load
syscall.

To support architecture specific policies, a new function
arch_get_ima_policy() is defined. This patch set defines IMA
KERNEL_KEXEC_POLICY rules for x86 only if CONFIG_KEXEC_VERIFY_SIG is
disabled and secure boot is enabled.

This patch set includes a patch, which refactors ima_init_policy() to
remove code duplication.

Changelog:

v4:
* ima: refactor ima_init_policy()
	- Fixed the issue reported by Dan Carpenter. Replaced logical
	operator (&&) with bitwise operator (&).

v3:
* x86/ima: define arch_ima_get_secureboot
	- Edited subject line, added x86.

* x86/ima: define arch_get_ima_policy() for x86
	- Fixed the error reported by kbuild test robot. The error was
	appearing when CONFIG_X86 is enabled, but CONFIG_IMA_ARCH_POLICY
	is disabled.

v2:
* ima: define arch_ima_get_secureboot
	- New Patch - to retrieve secureboot state of the system
* ima: prevent kexec_load syscall based on runtime secureboot flag
	- New Patch - disables kexec_load if KEXEC_VERIFY_SIG is
	  configured and secureboot is enabled
* ima: refactor ima_init_policy()
	- New Patch - cleans up the code duplication in
	  ima_init_policy(), adds new function add_rules()
* ima: add support for arch specific policies
	- modified ima_init_arch_policy() and ima_init_policy() to
	  use add_rules() from previous patch.
* ima: add support for external setting of ima_appraise
	- sets ima_appraise flag explicitly for arch_specific setting
* ima: add support for KEXEC_ORIG_KERNEL_CHECK
	- deleted the patch based on Seth's feedback
* x86/ima: define arch_get_ima_policy() for x86
	- removes the policy KEXEC_ORIG_KERNEL_CHECK based on
	  Seth's feedback.

Eric Richter (1):
  x86/ima: define arch_get_ima_policy() for x86

Nayna Jain (5):
  x86/ima: define arch_ima_get_secureboot
  ima: prevent kexec_load syscall based on runtime secureboot flag
  ima: refactor ima_init_policy()
  ima: add support for arch specific policies
  ima: add support for external setting of ima_appraise

 arch/x86/kernel/Makefile              |   2 +
 arch/x86/kernel/ima_arch.c            |  35 +++++++
 include/linux/ima.h                   |  18 ++++
 security/integrity/ima/Kconfig        |   8 ++
 security/integrity/ima/ima.h          |   5 +
 security/integrity/ima/ima_appraise.c |  11 ++-
 security/integrity/ima/ima_main.c     |  17 ++--
 security/integrity/ima/ima_policy.c   | 167 +++++++++++++++++++++++++---------
 8 files changed, 214 insertions(+), 49 deletions(-)
 create mode 100644 arch/x86/kernel/ima_arch.c

-- 
2.13.6
