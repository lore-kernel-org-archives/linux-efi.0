From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2 7/7] ima: Support platform keyring for kernel
 appraisal
Date: Wed, 12 Dec 2018 05:53:30 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1812120553170.11653@namei.org>
References: <20181208202705.18673-1-nayna@linux.ibm.com> <20181208202705.18673-8-nayna@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181208202705.18673-8-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au
List-Id: linux-efi@vger.kernel.org

On Sun, 9 Dec 2018, Nayna Jain wrote:

> On secure boot enabled systems, the bootloader verifies the kernel
> image and possibly the initramfs signatures based on a set of keys. A
> soft reboot(kexec) of the system, with the same kernel image and
> initramfs, requires access to the original keys to verify the
> signatures.
> 
> This patch allows IMA-appraisal access to those original keys, now
> loaded on the platform keyring, needed for verifying the kernel image
> and initramfs signatures.
> 
> Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> - replace 'rc' with 'xattr_len' when calling integrity_digsig_verify()
> with INTEGRITY_KEYRING_IMA for readability
> Suggested-by: Serge Hallyn <serge@hallyn.com>


Reviewed-by: James Morris <james.morris@microsoft.com>

-- 
James Morris
<jmorris@namei.org>
