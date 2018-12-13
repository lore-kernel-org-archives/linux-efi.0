From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [PATCH v2 1/7] integrity: Define a trusted platform keyring
Date: Wed, 12 Dec 2018 22:15:56 -0200
Message-ID: <871s6mffib.fsf@morokweng.localdomain>
References: <20181208202705.18673-2-nayna@linux.ibm.com> <20181209044849.825-1-nayna@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20181209044849.825-1-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au
List-Id: linux-efi@vger.kernel.org


Nayna Jain <nayna@linux.ibm.com> writes:

> On secure boot enabled systems, a verified kernel may need to kexec
> additional kernels. For example, it may be used as a bootloader needing
> to kexec a target kernel or it may need to kexec a crashdump kernel. In
> such cases, it may want to verify the signature of the next kernel
> image.
>
> It is further possible that the kernel image is signed with third party
> keys which are stored as platform or firmware keys in the 'db' variable.
> The kernel, however, can not directly verify these platform keys, and an
> administrator may therefore not want to trust them for arbitrary usage.
> In order to differentiate platform keys from other keys and provide the
> necessary separation of trust, the kernel needs an additional keyring to
> store platform keys.
>
> This patch creates the new keyring called ".platform" to isolate keys
> provided by platform from keys by kernel. These keys are used to
> facilitate signature verification during kexec. Since the scope of this
> keyring is only the platform/firmware keys, it cannot be updated from
> userspace.
>
> This keyring can be enabled by setting CONFIG_INTEGRITY_PLATFORM_KEYRING.
>
> Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  security/integrity/Kconfig                         | 11 +++++
>  security/integrity/Makefile                        |  1 +
>  security/integrity/digsig.c                        | 48 +++++++++++++++-------
>  security/integrity/integrity.h                     |  3 +-
>  .../integrity/platform_certs/platform_keyring.c    | 35 ++++++++++++++++
>  5 files changed, 83 insertions(+), 15 deletions(-)
>  create mode 100644 security/integrity/platform_certs/platform_keyring.c

Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
