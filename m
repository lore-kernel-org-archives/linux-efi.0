From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 6/6] efi/fdt: Fix handling error value in fdt_find_uefi_params
Date: Fri, 19 Aug 2016 21:35:04 +0100
Message-ID: <1471638904-3494-7-git-send-email-matt@codeblueprint.co.uk>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Andrzej Hajda <a.hajda@samsung.com>

of_get_flat_dt_subnode_by_name can return negative value in case of error.

The problem has been detected using semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5a2631af7410..7dd2e2d37231 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -657,9 +657,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 		}
 
 		if (subnode) {
-			node = of_get_flat_dt_subnode_by_name(node, subnode);
-			if (node < 0)
+			int err = of_get_flat_dt_subnode_by_name(node, subnode);
+
+			if (err < 0)
 				return 0;
+
+			node = err;
 		}
 
 		return __find_uefi_params(node, info, dt_params[i].params);
-- 
2.7.3
