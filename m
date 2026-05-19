Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA53E1204
	for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179032; cv=none; b=qH3dLqGkadgmEQcymQXMSXW1rcRuBKZw4q/0YHpMKXkjLAXqRv1VEZkJePWuWm9HZSnDG1DBzzHuV7nFxyT/pO+7rBRqRCLMugFPJcqyPxSSgFZuSOi2+vVpjUfRw+TkznZraBYxY0IUCrhSegeaA869m1EP/yt1LTQa4NwSw1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179032; c=relaxed/simple;
	bh=GStzyvmJTsmaUk42AwEA1uzb6RbBK33xsAsBGyLzXEY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M/S/KgemnkCyBufbL8FSp8jOV/neaTZPTkFo8+zJXc3psUu16wdCd4H1lXtTOrMMueqhTmKC6Rff7q3AtkNHYB0a0eb9SDQV6Qa71POyibaopd0F0mB34WkmzjYZHkZYvy9H1A3jLVAD4YhOXxw75JHTh4rwna86XbQ+PN+2ysU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KVpzrkDX; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KVpzrkDX"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44cc3c9b2feso3401251f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 01:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779179030; x=1779783830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EDtVf7GoC0ETuGDABfZDTcKjJk2cW1lLQk994emXYy8=;
        b=KVpzrkDXEZl6cnLO7r2x/LTqkR/zDGzaCnnUeJb3nk2n2d0VbGSbmDdi6wjYzf89Uq
         6yzZRQocaFCzxWJgAk+Zl715ZtAMlXKZbkGZrd0xLLALuks/dSh9GbSAvepL8rjfeeg+
         R+wCEhokeR4Agm3GnrUWD9BWsiRINtkDpeEdFBWx3+WUgkESv+NUIMkmAW6b/Pi+hVf8
         wd0+zmr/h5X1E0RokWlgJtjiLvCPXqBAL8NmzqU3UJxAPPdM/hGQ9MSLbu6AdeTwvvOl
         R4EDP4hsRyKY0mS7nUeSx4chNNsL8Dds9DbRXSqEohWYe0HZcLtbn4+O0Z0ktNitxQKN
         4mwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779179030; x=1779783830;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EDtVf7GoC0ETuGDABfZDTcKjJk2cW1lLQk994emXYy8=;
        b=nN6YCUn27q6Rs4A9Aks4ljdR5p5Cf8xfLELc2AzwwBZU0UrCEO0olCClFnQqOso6ha
         H4t3Al6cw/u/mh1zzsul1Dbd5PRdELIgS7F1doNqdv5j+RRLy3yvSE3tAaUyemlQhbuC
         rA7Z/YLgkJ7NmW5ByNBYD5EU03J+kfT7LpVmiYLEUpzRpjNUDEYZ/DDRocU6HXz7jcwg
         jdzezqmJYrHhqGy22UkUzN2sdGUdyhgom0PQD5uFkjuwRBN8PfpiCCKTsnspn5jUHIXu
         sCWYT/n9uY8zN1xcdiphW2HiUBRJHflQiWHGh6A3dkstRsnVkRvU67qsmp8B5JYmg3It
         B4ug==
X-Gm-Message-State: AOJu0YyZ8tQKJyTrjEaWKGwDg6K51vnNl8bS88RdPwyF6kZ+Irj352Un
	xHdO+c7DCLFkWQuLmTOSu8NYhSSrKcHAhGJyuBtqSNMzdiXtRK30dL+eSKSd7mOcdwpGtG1CVy/
	j7fBl1lN8P/YYQoW/RnKOVuMY3uKAmq7VTqDGYLZE/DQqs3fTiQuvNiuvXDt3wghGFVBXphS5qP
	wX9tFzRpYgR7Dfavw+MM1EY2U3SYiHjA==
X-Received: from wraj9.prod.google.com ([2002:a5d:4529:0:b0:44c:b43d:e7eb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f96:0:b0:45e:878b:6c36
 with SMTP id ffacd0b85a97d-45e878b6e10mr5631188f8f.35.1779179029577; Tue, 19
 May 2026 01:23:49 -0700 (PDT)
Date: Tue, 19 May 2026 10:23:17 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2815; i=ardb@kernel.org;
 h=from:subject; bh=Zy8MdDJ1w6zl6CODa7NOZmbOZ38EWfM9KtofDeDfF5U=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYtH9utc27aU04Gz5nK+/uh8dbe/nsGy4BIZR4aO+arvL
 O7HvNjbUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZiaMLwh+/59Ge20t9+TCyv
 PGuWbNnPdXRdohZXZe/FHWd2cN77ocPI8ITj2pWm10c/b2esEY6z2P3XMV3HpvZmQH7oVV+zf0F zGAA=
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519082316.1959158-2-ardb+git@google.com>
Subject: [PATCH] efi: Allocate runtime workqueue before ACPI init
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Since commit

  5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM handlers")

ACPI PRM calls are delegated to a workqueue which runs in a kernel
thread, making it easier to detect and mitigate faulting memory accesses
performed by the firmware.

Rafael reports that such PRM accesses may occur before efisubsys_init()
executes, which is where the workqueue is allocated, leading to NULL
pointer dereferences. Since acpi_init() [which triggers the early PRM
accesses] executes as a subsys_initcall() as well, and has its own
dependencies that may be sensitive to initcall ordering, deferring
acpi_init() is not an option.

So instead, split off the workqueue allocation into its own postcore
initcall, as this is the only missing piece to allow EFI runtime calls
to be made. This ensures that EFI runtime call (including PRM calls) are
accessible to all code running at subsys_initcall() level.

Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM handlers")
Reported-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d04be38f1750..318d1cc9a066 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -402,21 +402,11 @@ static void __init efi_debugfs_init(void)
 static inline void efi_debugfs_init(void) {}
 #endif
 
-/*
- * We register the efi subsystem with the firmware subsystem and the
- * efivars subsystem with the efi subsystem, if the system was booted with
- * EFI.
- */
-static int __init efisubsys_init(void)
+static int __init efipostcore_init(void)
 {
-	int error;
-
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		efi.runtime_supported_mask = 0;
 
-	if (!efi_enabled(EFI_BOOT))
-		return 0;
-
 	if (efi.runtime_supported_mask) {
 		/*
 		 * Since we process only one efi_runtime_service() at a time, an
@@ -428,9 +418,23 @@ static int __init efisubsys_init(void)
 			pr_err("Creating efi_rts_wq failed, EFI runtime services disabled.\n");
 			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 			efi.runtime_supported_mask = 0;
-			return 0;
 		}
 	}
+	return 0;
+}
+postcore_initcall(efipostcore_init);
+
+/*
+ * We register the efi subsystem with the firmware subsystem and the
+ * efivars subsystem with the efi subsystem, if the system was booted with
+ * EFI.
+ */
+static int __init efisubsys_init(void)
+{
+	int error;
+
+	if (!efi_enabled(EFI_BOOT))
+		return 0;
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_TIME_SERVICES))
 		platform_device_register_simple("rtc-efi", 0, NULL, 0);
-- 
2.54.0.563.g4f69b47b94-goog

