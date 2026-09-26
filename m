Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BB04248BB
	for <linux-efi@vger.kernel.org>; Sat, 26 Sep 2026 10:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790419901; cv=none; b=JTeNgVwCFPanu9SLvLVwJBhYnB2bx3NhIW9zQjiFso1mJRdl3BvtjUzrUvwClZY/QoL/5AI9C+yijXKB5CD8wLEEZ6eQPvSz94qpapCsu1cNeaYCcdGeaB7uCTfgH8qR0IbPgxNi5goS30Xr2ZNHL8PvzKU63y3/Bb+M8dyOXeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790419901; c=relaxed/simple;
	bh=jW735kAcsD/2b21ceEtLlnICfYOZRCFHJbsmuxuCW2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E518ehBpXQ7tlaEwgbFTGE4u2VMnMQAxjYBQIFmTM1QMj0QoPD9KTuO1MFx8pSzNjSMN2dtLx/3ppqRBkhUDj7SUzgDqiLUicb+hN91zguk3gOYgKDmQ4x+/OV1OgHXJU++U+8r/JyloNg3RdJii61hkROkHF2zcGMxIhB8udDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TiFCA0e0; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TiFCA0e0"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-3437a48f386so222768eec.3
        for <linux-efi@vger.kernel.org>; Sat, 26 Sep 2026 03:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790419898; x=1791024698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kyhzvPKJ7yjFZH8EyKop+R4jPDKS3cxEfo32yPynS28=;
        b=TiFCA0e0tnsRFaq+PNr5M7G8AO3ztY/pJewjNBhIdOX8ATWL6Dza4o9I/mvmESi+Yu
         XFkVgc32KA7BUWDc/uExN3esp+jbyWcGTt6IN3d4QOOAdO+3OobJT+7lJOkR0bTsTiZo
         Ns7p8DukFxDbABveBInc12L5cf5n6n1LSVWkLnnBKl5jTaFhpaTPenxea50SDojTjZrl
         HkmMErPcw+WgsqzkibqqddV2FyGTy/QstqGLe64h5QSgOJpw3PzwS0PmgJ+dr14qHalp
         L+my3WUSPfqn3Qj7IdQDvXpj7BO4xtvCJu2auil6yE/PHrzyUGzwJ1+22TI5lFxNlJuJ
         +tmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790419898; x=1791024698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kyhzvPKJ7yjFZH8EyKop+R4jPDKS3cxEfo32yPynS28=;
        b=i88UidYYJoqxe+xZEY3y39zh4bzWFgLRnQhuvOC+MtIMR62ZVxQVNO64R5TyZekYT2
         dcRRmfBzkCEDvflNp8IoToBkjjPgwreFkge7CgrethpyzHL9aaXDKWY5hzzs2/9+N3U+
         CgYK0AR3OyD8ixE4U//Jm0qSShdt+sUVzIBVx+lI+hhaAY2Hz8xAI3kpvQZtfrMGZoV6
         3LgWCdujgJwspUkKJFQExqYN3ZaFMQS/uGQJ9HfxFm8BNg7n/87nUjAQu0dvCNUwKBsC
         nTjJwwcmJ7kRiIcaimPVcCkm374d29FOilyU3vxMuQAOmjEYlTu5yXm253ohcn+FPcJ6
         8hqg==
X-Gm-Message-State: AFq9FYKMzl91mDfGCNOq5sCv+S37V5HwIXhRfBWDbTKgm1RTNZ92CFLO
	L63JWdY390H5ssyDUoqNS+HtfrljkMEoXnWDkR9CFVSBqSVE+LrfXYJ931ci5Fui
X-Gm-Gg: AYBFou1++K0RESKHlbWZaDmjuywZoaI13RssRiOAI61gwXkQPdqOJudaiGAzf9/N5w0
	bEcZ+4FRzjVSna1EjY2GmGjh079wV3lzoid5ZmttKwmAFoIMpwMt1n8e/p2h/wlnUqwZPP/T2cu
	HOjr19NlPzls/3VO+eQiYIAQmlmpcCgzywa9WgQahdbH3dMY9V3pMMXKvDwRxLiXNvh/mwI7/tK
	hF+8qsDT6qqsxafZ4LfyWuSFcoh4lnVSAcUDOcIcRfx8+6lthPRVxd+MQ0L/SdcBGGQ/R2bg3Lm
	PrCdHscySehBDZiCphHK3av0feUHzwY8H2LtK+YBHXXxEZgfOtnEKoqUogkOERFBPXuzkz1qMXo
	OkNZapUxs4BCA2IxK5cP8vOn8n87JmDAvFZPeQCFEZj1XEz642UVkJZsZSu+g5Kyqv5BHZNmM5r
	Jo311jbUpMRkHS/ljxFFeY+P0moncRWskDfUSQgiVCXD81VrsxTw2MDNTvADut48+MKVG1mT1Si
	jRpbhGmO7ptwSgZ/gXSJKg=
X-Received: by 2002:a05:7300:2728:b0:33b:f206:845 with SMTP id 5a478bee46e88-3427304f495mr2392858eec.32.1790419897292;
        Sat, 26 Sep 2026 03:51:37 -0700 (PDT)
Received: from DESKTOP-7QP7L26 ([45.190.211.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3414504fae2sm13834603eec.20.2026.09.26.03.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 03:51:36 -0700 (PDT)
From: dev12124 <joaoanandalima@gmail.com>
To: linux-efi@vger.kernel.org
Cc: ardb@kernel.org,
	dev12124 <joaoanandalima@gmail.com>
Subject: [PATCH] security: Fix the Capsule-Loader with Lock Mutex, Verifications, factory default initialization and return
Date: Sat, 26 Sep 2026 07:51:28 -0300
Message-ID: <20260926105128.1113-1-joaoanandalima@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 drivers/firmware/efi/capsule-loader.c | 67 +++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 8e8f81f0a..6d4d9fec5 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -18,6 +18,59 @@
 #include <linux/vmalloc.h>
 
 #define NO_FURTHER_WRITE_ACTION -1
+#define CAPSULE_HELP_SUCCESS 0
+
+/** 
+ * A Structure for Mutex. 
+ **/
+static DEFINE_MUTEX(capsule_mutex);
+
+/** 
+  * capsule_help_open - A Helper under the Functions,
+  * with Lock Mutex, Variables Protected, Security in the Memory.
+  **/
+static int capsule_help_open(struct capsule_info *cap_info, struct mutex *mtxPointer) 
+{
+
+	// Lock the Pointer
+	mutex_lock(mtxPointer);
+
+    /** Fixing the weak allocation issue that carried a risk 
+	 of the driver writing out of bounds.
+	   A Initial Secure Space (e.g 1024 pointers) */
+	cap_info->pages = kcalloc(1024, sizeof(void *), GFP_KERNEL);
+
+	/** Check if the allocation failed for
+	  Memory Loss */
+	if (!cap_info->pages) {
+       mutex_unlock(mtxPointer);
+	   return -ENOMEM;
+	}
+
+	/**
+	   Now, the Logic of the Physhics Address 
+	**/
+	cap_info->phys = kcalloc(1024, sizeof(phys_addr_t), GFP_KERNEL);
+
+	/** Check if the Allocation failed for
+	  Memory Loss */
+    if (!cap_info->phys) {
+		kfree(cap_info->pages);
+		cap_info->pages = NULL;
+		mutex_unlock(mtxPointer);
+		return -ENOMEM;
+	}
+
+	/** Initializes the rest 
+	     to factory defaults  */
+    cap_info->index = 0;
+	cap_info->page_bytes_remain = 0;
+	cap_info->count = 0;
+
+	/** Return the Success */
+	return CAPSULE_HELP_SUCCESS;
+}
+
 
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
@@ -281,22 +334,18 @@ static int efi_capsule_release(struct inode *inode, struct file *file)
 static int efi_capsule_open(struct inode *inode, struct file *file)
 {
 	struct capsule_info *cap_info;
+    
+	int ret;
 
 	cap_info = kzalloc_obj(*cap_info);
 	if (!cap_info)
 		return -ENOMEM;
 
-	cap_info->pages = kzalloc(sizeof(void *), GFP_KERNEL);
-	if (!cap_info->pages) {
-		kfree(cap_info);
-		return -ENOMEM;
-	}
 
-	cap_info->phys = kzalloc_obj(phys_addr_t);
-	if (!cap_info->phys) {
-		kfree(cap_info->pages);
+	ret = capsule_help_open(cap_info, &capsule_mutex);
+	if (ret != CAPSULE_HELP_SUCCESS) {
 		kfree(cap_info);
-		return -ENOMEM;
+		return ret;
 	}
 
 	file->private_data = cap_info;
-- 
2.55.0.windows.3

