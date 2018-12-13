From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 7/7] ima: Support platform keyring for kernel
 appraisal
Date: Wed, 12 Dec 2018 19:18:21 -0500
Message-ID: <1544660301.3956.3.camel@linux.ibm.com>
References: <20181208202705.18673-1-nayna@linux.ibm.com>
         <20181208202705.18673-8-nayna@linux.ibm.com>
         <8736r2fw88.fsf@morokweng.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8736r2fw88.fsf@morokweng.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiago Jung Bauermann <bauerman@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au
List-Id: linux-efi@vger.kernel.org

On Wed, 2018-12-12 at 16:14 -0200, Thiago Jung Bauermann wrote:
[snip]

> Subject: [PATCH] ima: Only use the platform keyring if it's enabled
> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

Good catch!  Thanks.

Mimi

> ---
>  security/integrity/ima/ima_appraise.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index e8f520450895..f6ac405daabb 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -297,7 +297,8 @@ int ima_appraise_measurement(enum ima_hooks func,
>  			status = INTEGRITY_UNKNOWN;
>  			break;
>  		}
> -		if (rc && func == KEXEC_KERNEL_CHECK)
> +		if (IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING) && rc &&
> +		    func == KEXEC_KERNEL_CHECK)
>  			rc = integrity_digsig_verify(INTEGRITY_KEYRING_PLATFORM,
>  						     (const char *)xattr_value,
>  						     xattr_len,
