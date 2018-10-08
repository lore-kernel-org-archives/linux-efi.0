From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v5 0/6] Add support for architecture specific IMA
 policies
Date: Mon, 08 Oct 2018 07:20:25 -0400
Message-ID: <1538997625.15382.87.camel@linux.ibm.com>
References: <20181005174015.21939-1-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005174015.21939-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>, linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 2018-10-05 at 23:10 +0530, Nayna Jain wrote:
> From: Nayna Jain <nayna@linux.ibm.com>
> 
> The architecture specific policy, introduced in this patch set, permits
> different architectures to define IMA policy rules based on kernel
> configuration and system runtime information.
> 
> For example, on x86, there are two methods of verifying the kexec'ed kernel
> image signature - CONFIG_KEXEC_VERIFY_SIG and IMA appraisal policy
> KEXEC_KERNEL_CHECK. CONFIG_KEXEC_VERIFY_SIG enforces the kexec_file_load
> syscall to verify file signatures, but does not prevent the kexec_load
> syscall. The IMA KEXEC_KERNEL_CHECK policy rule verifies the kexec'ed
> kernel image, loaded via the kexec_file_load syscall, is validly signed and
> prevents loading a kernel image via the kexec_load syscall. When secure
> boot is enabled, the kexec'ed kernel image needs to be signed and the
> signature verified. In this environment, either method of verifying the
> kexec'ed kernel image is acceptable, as long as the kexec_load syscall is
> disabled.
> 
> The previous version of this patchset introduced a new IMA policy rule to
> disable the kexec_load syscall, when CONFIG_KEXEC_VERIFY_SIG was enabled,
> however that is removed from this version by introducing a different
> mechanism, as described below.
> 
> The patchset defines an arch_ima_get_secureboot() function to retrieve the
> secureboot state of the system. If secureboot is enabled and
> CONFIG_KEXEC_VERIFY_SIG is configured, it denies permission to kexec_load
> syscall.
> 
> To support architecture specific policies, a new function
> arch_get_ima_policy() is defined. This patch set defines IMA
> KERNEL_KEXEC_POLICY rules for x86 *only* if CONFIG_KEXEC_VERIFY_SIG is
> disabled and secure boot is enabled.
> 
> This patch set includes a patch, which refactors ima_init_policy() to
> remove code duplication.

Other than a couple of #ifdef's in .c files, which should be converted
to use IS_ENABLED(<config-option>), the patch set is looking really
good.

thanks!

Mimi
