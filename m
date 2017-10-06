From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi/efi_test: Prevent an Oops in
 efi_runtime_query_capsulecaps()
Date: Fri, 6 Oct 2017 13:19:39 +0100
Message-ID: <20171006121939.GC3314@codeblueprint.co.uk>
References: <20170930081732.x6g4b2mwxwt5xzql@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930081732.x6g4b2mwxwt5xzql@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ivan Hu <ivan.hu@canonical.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 30 Sep, at 11:17:32AM, Dan Carpenter wrote:
> If "qcaps.capsule_count" is ULONG_MAX then "qcaps.capsule_count + 1"
> will overflow to zero and kcalloc() will return the ZERO_SIZE_PTR.  We
> try to dereference it inside the loop and crash.
> 
> Fixes: ff6301dabc3c ("efi: Add efi_test driver for exporting UEFI runtime service interfaces")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
> index 08129b7b80ab..41c48a1e8baa 100644
> --- a/drivers/firmware/efi/test/efi_test.c
> +++ b/drivers/firmware/efi/test/efi_test.c
> @@ -593,6 +593,9 @@ static long efi_runtime_query_capsulecaps(unsigned long arg)
>  	if (copy_from_user(&qcaps, qcaps_user, sizeof(qcaps)))
>  		return -EFAULT;
>  
> +	if (qcaps.capsule_count == ULONG_MAX)
> +		return -EINVAL;
> +
>  	capsules = kcalloc(qcaps.capsule_count + 1,
>  			   sizeof(efi_capsule_header_t), GFP_KERNEL);
>  	if (!capsules)

This looks OK to me. Ivan?
