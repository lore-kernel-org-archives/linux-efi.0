Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654980;
	b=HhgJTz35xPqkGcZ8Ex3m1H0T9y65NGn/khjfz9yfL92elw6BTsbsm8+UdYZ3XF84akvT
	 lLaNwwt9I1IVJ7CmHMYrDrj36b98waGPGBtsCsWDs0D76xHSCWSqZQfpWXqFNByYPaByq
	 HrMZmNJmvAXZPHnBlYQtkidwOGdbx8GIIu6TjlNsrHgl7yD26Oy7A5lNnrAsVU6v0y81f
	 U/DLD9kXw89tB/Nqcvug4CG4c1JfALl0nzL9GUQID7nFyrSvgFXrXvTqenGLs5g3L2rhI
	 +RiHw05kghxrCffa1SWFEQO/cP8y2H5Vq022d8nXKNdzrcSHQDu2EgXiShPy4n2Wi3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654980;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=F7jeJVayQGD0xvnj3CFF1raguTs7sNVnruKGMRKHPBE=;
	b=mP7NPEN0Dkv5wbwQTEKexvMAm77vh8KO+qa6iuWfymwNRBdDdy9greEk07wsQFqUtb9V
	 BiaUGHfEahc5O/N/KyKafbLbQQT5Zk/IwEo8DKvdBI/BYO5R5ZKjgRSnQo6D+C/cKLi+8
	 A2Ca+pIawRkFbfml6J4CIKXqrhrPMkfiMM0WGds7W4udlHmUiDWuEYjwX0N7Mmu15dXd6
	 y+g5A9f00pGQ80fL3DTtGY96E2rbNcATOQat83zQOYMUJwi2EpiwElcCbDfOlsJlh/Zro
	 NXOyOU+kKlJGMvKD2KbGw6+q7JUm7yx57SJwlLR0crjJKstHs6M+y0xXDfS5lpYpULQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd9UCmMo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C298E606D801;
	Mon,  2 Nov 2026 21:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd9UCmMo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FDA1F00A1D;
	Mon,  2 Nov 2026 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654979;
	bh=F7jeJVayQGD0xvnj3CFF1raguTs7sNVnruKGMRKHPBE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dd9UCmMosHXv3BK00YuI82okISUdsjtbKw8/aio/ffEh/bqs6v1ivmm2d/yAlk2e3
	 A+aJWUs4C/8touGwdefs870nlSZzkL9JmZ3vk/C5zdKCMlPiNx52xzri449Cmuxw6G
	 wZP70MdljYfFsCGB0J9MNspLJZG7E4XuoKxPkp//stkmEBld6S9Qvn7EtSfGr8KPdJ
	 V0vYqBpARW1flECh39//LrWXXnN7UWZP2DvyR33AaR59EgQDrPKZJAdDpLCO9TP/Yd
	 I6c8ddv1X/Cg4iNhaji27l82bTaxNt1JzLfPlih5VnpjA10X57GpsTmmM91zn001vL
	 InGC9/lO0zxHw==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:10 +0100
Subject: [PATCH v3 3/7] init: factor out root device lookup into
 lookup_root_device()
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-discoverable-root_partitions-v3-3-27f04b69b7ab@kernel.org>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
In-Reply-To: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2044; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=Vb/E7pKpfUmfAWscJFJRCfaYaFbl2S5D4ehB3Hkx6hs=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTYGi/65Nb/kx47HdcFPGyWc4ryPGmuYz3h6OET45
 zylj4kLOiawMIhxMViKKbIsK+fkVugo9A479NcSZg4rE8gQaZEGBiBgYeDLTcwrNdIx0jPVNtQz
 BDJ0jBi4OAVgqtvsGL5nGrOt7LKV5/c4UNO5+suawHcuwkdObm9dkbKF4+mm28mMDDf/qj6fsn+
 dabTTicBYTxaGhrjIdk+ui2lsif+eS56U5wAA
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS root detection will also need to work if root_wait is set, meaning
that wait_for_root() needs to handle the DPS logic.

Move the early_lookup_bdev() calls and the rootwait error handling into
the new lookup_root_device() so later changes can extend the lookup
policy without duplicating the rootwait retry logic.

While at it, reword the error message to add the "VFS: " prefix.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 init/do_mounts.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index b088021b1546..b0dccad20971 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -402,6 +402,18 @@ void __init mount_root(char *root_device_name)
 	}
 }
 
+static int __init lookup_root_device(const char *root_device_name, dev_t *dev)
+{
+	int err;
+
+	err = early_lookup_bdev(root_device_name, dev);
+	if (err == -EINVAL && root_wait) {
+		pr_err("VFS: root= is invalid; disabling rootwait.\n");
+		root_wait = 0;
+	}
+	return err;
+}
+
 /* wait for any asynchronous scanning to complete */
 static void __init wait_for_root(char *root_device_name)
 {
@@ -415,7 +427,7 @@ static void __init wait_for_root(char *root_device_name)
 	end = ktime_add_ms(ktime_get_raw(), root_wait);
 
 	while (!driver_probe_done() ||
-	       early_lookup_bdev(root_device_name, &ROOT_DEV) < 0) {
+	       lookup_root_device(root_device_name, &ROOT_DEV) < 0) {
 		msleep(5);
 		if (root_wait > 0 && ktime_after(ktime_get_raw(), end))
 			break;
@@ -440,14 +452,9 @@ static dev_t __init parse_root_device(char *root_device_name)
 	if (strcmp(root_device_name, "/dev/ram") == 0)
 		return Root_RAM0;
 
-	error = early_lookup_bdev(root_device_name, &dev);
-	if (error) {
-		if (error == -EINVAL && root_wait) {
-			pr_err("Disabling rootwait; root= is invalid.\n");
-			root_wait = 0;
-		}
+	error = lookup_root_device(root_device_name, &dev);
+	if (error)
 		return 0;
-	}
 	return dev;
 }
 

-- 
2.56.0

