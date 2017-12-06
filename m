From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/3] efi/esrt: use memunmap rather kfree to free the remapping
Date: Wed,  6 Dec 2017 09:50:09 +0000
Message-ID: <20171206095010.24170-3-ard.biesheuvel@linaro.org>
References: <20171206095010.24170-1-ard.biesheuvel@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171206095010.24170-1-ard.biesheuvel@linaro.org>
Sender: stable-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Pan Bian <bianpan2016@163.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

The remapping result of memremap should be freed with memunmap, not
kfree.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/esrt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 7aae2483fcb9..c47e0c6ec00f 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -428,7 +428,7 @@ static int __init esrt_sysfs_init(void)
 err_remove_esrt:
 	kobject_put(esrt_kobj);
 err:
-	kfree(esrt);
+	memunmap(esrt);
 	esrt = NULL;
 	return error;
 }
-- 
2.11.0
