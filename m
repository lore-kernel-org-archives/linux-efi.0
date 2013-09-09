From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 02/12] Enforce module signatures when securelevel is greater than 0
Date: Mon,  9 Sep 2013 11:49:36 -0400
Message-ID: <1378741786-18430-3-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

If securelevel has been set to 1 or greater, require that all modules have
valid signatures.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index dc58274..ab126d7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2487,7 +2487,7 @@ static int module_sig_check(struct load_info *info)
 	if (err < 0 && fips_enabled)
 		panic("Module verification failed with error %d in FIPS mode\n",
 		      err);
-	if (err == -ENOKEY && !sig_enforce)
+	if ((err == -ENOKEY && !sig_enforce) && (get_securelevel() <= 0))
 		err = 0;
 
 	return err;
-- 
1.8.3.1
