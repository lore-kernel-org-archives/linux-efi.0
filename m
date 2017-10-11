From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: ACK: [PATCH] efi/efi_test: Prevent an Oops in
 efi_runtime_query_capsulecaps()
Date: Wed, 11 Oct 2017 10:34:39 +0100
Message-ID: <20171011093439.GA3062@codeblueprint.co.uk>
References: <20170930081732.x6g4b2mwxwt5xzql@mwanda>
 <20171006121939.GC3314@codeblueprint.co.uk>
 <449b17c1-2c97-fd7c-3073-5cb20e1c3672@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <449b17c1-2c97-fd7c-3073-5cb20e1c3672@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: ivanhu <ivan.hu@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 11 Oct, at 02:26:57PM, Ivan Hu wrote:
> 
> 
> On 10/06/2017 08:19 PM, Matt Fleming wrote:
> >On Sat, 30 Sep, at 11:17:32AM, Dan Carpenter wrote:
> >>If "qcaps.capsule_count" is ULONG_MAX then "qcaps.capsule_count + 1"
> >>will overflow to zero and kcalloc() will return the ZERO_SIZE_PTR.  We
> >>try to dereference it inside the loop and crash.
> >>
> >>Fixes: ff6301dabc3c ("efi: Add efi_test driver for exporting UEFI runtime service interfaces")
> >>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >>
> >>diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
> >>index 08129b7b80ab..41c48a1e8baa 100644
> >>--- a/drivers/firmware/efi/test/efi_test.c
> >>+++ b/drivers/firmware/efi/test/efi_test.c
> >>@@ -593,6 +593,9 @@ static long efi_runtime_query_capsulecaps(unsigned long arg)
> >>  	if (copy_from_user(&qcaps, qcaps_user, sizeof(qcaps)))
> >>  		return -EFAULT;
> >>+	if (qcaps.capsule_count == ULONG_MAX)
> >>+		return -EINVAL;
> >>+
> >>  	capsules = kcalloc(qcaps.capsule_count + 1,
> >>  			   sizeof(efi_capsule_header_t), GFP_KERNEL);
> >>  	if (!capsules)
> >
> >This looks OK to me. Ivan?
> >
> 
> 
> Acked-by: Ivan Hu <ivan.hu@canonical.com>

Thanks, applied.
