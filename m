From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] efi/efi_test: Prevent an Oops in efi_runtime_query_capsulecaps()
Date: Wed, 25 Oct 2017 11:04:47 +0100
Message-ID: <20171025100448.26056-2-ard.biesheuvel@linaro.org>
References: <20171025100448.26056-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100448.26056-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

If "qcaps.capsule_count" is ULONG_MAX then "qcaps.capsule_count + 1"
will overflow to zero and kcalloc() will return the ZERO_SIZE_PTR.  We
try to dereference it inside the loop and crash.

Fixes: ff6301dabc3c ("efi: Add efi_test driver for exporting UEFI runtime service interfaces")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ivan Hu <ivan.hu@canonical.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/test/efi_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 08129b7b80ab..41c48a1e8baa 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -593,6 +593,9 @@ static long efi_runtime_query_capsulecaps(unsigned long arg)
 	if (copy_from_user(&qcaps, qcaps_user, sizeof(qcaps)))
 		return -EFAULT;
 
+	if (qcaps.capsule_count == ULONG_MAX)
+		return -EINVAL;
+
 	capsules = kcalloc(qcaps.capsule_count + 1,
 			   sizeof(efi_capsule_header_t), GFP_KERNEL);
 	if (!capsules)
-- 
2.11.0
