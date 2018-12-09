From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 0/7] add platform/firmware keys support for kernel
 verification by IMA
Date: Sun, 09 Dec 2018 13:39:56 -0500
Message-ID: <1544380796.3794.6.camel@linux.ibm.com>
References: <20181208202705.18673-1-nayna@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181208202705.18673-1-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au
List-Id: linux-efi@vger.kernel.org

Hi Nayna,

On Sun, 2018-12-09 at 01:56 +0530, Nayna Jain wrote:
> On secure boot enabled systems, a verified kernel may need to kexec
> additional kernels. For example, it may be used as a bootloader needing
> to kexec a target kernel or it may need to kexec a crashdump kernel.
> In such cases, it may want to verify the signature of the next kernel
> image.
> 
> It is possible that the new kernel image is signed with third party keys
> which are stored as platform or firmware keys in the 'db' variable. The
> kernel, however, can not directly verify these platform keys, and an
> administrator may therefore not want to trust them for arbitrary usage.
> In order to differentiate platform keys from other keys and provide the
> necessary separation of trust the kernel needs an additional keyring to
> store platform/firmware keys.
> 
> The secure boot key database is expected to store the keys as EFI
> Signature List(ESL). The patch set uses David Howells and Josh Boyer's
> patch to access and parse the ESL to extract the certificates and load
> them onto the platform keyring.
> 
> The last patch in this patch set adds support for IMA-appraisal to
> verify the kexec'ed kernel image based on keys stored in the platform
> keyring.

Thanks!  This patch set is now in the #next-integrity branch.

https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git/

Mimi
