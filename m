From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [PATCH v2 7/7] ima: Support platform keyring for kernel appraisal
Date: Wed, 12 Dec 2018 16:14:47 -0200
Message-ID: <8736r2fw88.fsf@morokweng.localdomain>
References: <20181208202705.18673-1-nayna@linux.ibm.com> <20181208202705.18673-8-nayna@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20181208202705.18673-8-nayna@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au
List-Id: linux-efi@vger.kernel.org


Hello,

Nayna Jain <nayna@linux.ibm.com> writes:

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
> ---
> Changelog:
>
> v2:
> - replace 'rc' with 'xattr_len' when calling integrity_digsig_verify()
> with INTEGRITY_KEYRING_IMA for readability
>
>  security/integrity/ima/ima_appraise.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index deec1804a00a..e8f520450895 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -289,12 +289,21 @@ int ima_appraise_measurement(enum ima_hooks func,
>  	case EVM_IMA_XATTR_DIGSIG:
>  		set_bit(IMA_DIGSIG, &iint->atomic_flags);
>  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> -					     (const char *)xattr_value, rc,
> +					     (const char *)xattr_value,
> +					     xattr_len,
>  					     iint->ima_hash->digest,
>  					     iint->ima_hash->length);
>  		if (rc == -EOPNOTSUPP) {
>  			status = INTEGRITY_UNKNOWN;
> -		} else if (rc) {
> +			break;
> +		}
> +		if (rc && func == KEXEC_KERNEL_CHECK)
> +			rc = integrity_digsig_verify(INTEGRITY_KEYRING_PLATFORM,
> +						     (const char *)xattr_value,
> +						     xattr_len,
> +						     iint->ima_hash->digest,
> +						     iint->ima_hash->length);

If CONFIG_INTEGRITY_PLATFORM_KEYRING=n the second call to
integrity_digsig_verify() above will always fail, and the audit message
of failed signature verifications for KEXEC_KERNEL will always log the
same rc value, which is whatever request_key() returns when asked to
look for an inexistent keyring.

Here is a patch which only performs the second try if the platform
keyring is enabled.


>From d5fb94ab9eb13f6294f8dc44d1344cb85dfa41b8 Mon Sep 17 00:00:00 2001
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Date: Wed, 12 Dec 2018 16:02:09 -0200
Subject: [PATCH] ima: Only use the platform keyring if it's enabled

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index e8f520450895..f6ac405daabb 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -297,7 +297,8 @@ int ima_appraise_measurement(enum ima_hooks func,
 			status = INTEGRITY_UNKNOWN;
 			break;
 		}
-		if (rc && func == KEXEC_KERNEL_CHECK)
+		if (IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING) && rc &&
+		    func == KEXEC_KERNEL_CHECK)
 			rc = integrity_digsig_verify(INTEGRITY_KEYRING_PLATFORM,
 						     (const char *)xattr_value,
 						     xattr_len,
