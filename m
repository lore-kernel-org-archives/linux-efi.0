Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933454;
	b=kwfX4Y4KwGAgo7eF7anAY0DCR8LMbAjWOIdUiOOUN/xDaVSSwn066oqec6TSnArNkom+
	 CukiovOErv6yPW+6VghVue93Z2tFhGceBbORwA5YsZqbSe3Sm+PNjtHgOusDyFTv3Fmho
	 xJk2ORKJt5EV2P+8qeW+g2dA41y5RMWpY9vtmkl0y1GpQB+CkltNgTMBLGGouKKVZdVgo
	 aD9dqXjYrN+npO3iLo++FySoqcdtBv9dxNMJ2QjoC3/huzZsIr/V3J0M2+whFHgK04Xu/
	 HOEaVTxyn0t1zEzv8hM0miqct01XwY4D1HZJJKQyLv/xAJ985NSiZWexDIKGuPzri+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933454;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=+qezTJDPIXOUc1wTjo+jFgclNE5St9qwmSMRv2XTur8=;
	b=bv/5tJIMIanSeXajj+bhn4rH3CBgL4KFPW7rAoqiadNyHYUS4AgDQaPul2C7q3nHDEvV
	 eaBebyas6O9nasWzxSZUA1JElA5I9irMw428emjYbOXiuttGNzlnEm0+gkOz0fgMLmKUl
	 02HDeSg5gk8ft25i0DSSIV76IXQ1sLE4nUSUjEBxZjKb6uU9Z9Fc2htSbo1+UbVkhlfRd
	 f6QsDwg4pwsTh/PsNls2pmpRZmyyJmfLTZ67HHOogn7yVUXxwAmHhk3RQIlf4oveVnWZD
	 6KOTc45Vkxv00MJwUajy31B4T8E+P8iiTGEPEdoTJcu33kUjAciFUNXYoL4UFBgwNhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JdaZVaHj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72F60A2612;
	Sun, 25 Oct 2026 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JdaZVaHj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7442B1F031E5;
	Sun, 25 Oct 2026 13:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792933454;
	bh=+qezTJDPIXOUc1wTjo+jFgclNE5St9qwmSMRv2XTur8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JdaZVaHjGJlOW3LvxtLLrHVqiQ60G2OM6YEog6rnrotkGxQvvdMLcpZIZx2qv/hqJ
	 At15BbOrfacnanXtp09ixhk0PA2UV+TN+esEkX958oYBFy1arhWqQX0Wfp6KnBlXp2
	 q2PBJQNISFvf3yCdoR6hb2hSxrZ4d90nVxK+nxTs5KT6+lJzmIa3vU+Ip+VPUKroLv
	 1VeiK2HL3u0y8lnC7l/3yjbhpTZjNOxwQ9f9TiI7ROlg1d8kzC2vTFTpwIxuRxTb+f
	 nSYeTkgL9tQ9gaGFFhIo23qMZAzlnCVh14grVpZ/onSI2fZEOxCxLQ/ohjE6Y7nHda
	 7Bht7xk5bkCvQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 25 Oct 2026 14:03:13 +0100
Subject: [PATCH v2 3/7] init: factor out root device lookup into
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
Message-Id: <20261025-discoverable-root_partitions-v2-3-fb77d0821fab@kernel.org>
References: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
In-Reply-To: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
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
 h=from:subject:message-id; bh=q8zY4QXQ0Hl/5uPA2J2rzGtPPR5tDQYh7QQcqUm1vcQ=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFl3/9nM+j6p5cP5z7cbl/6vi5ROSpIsN1zwTpdPTaM6f
 /nc7V6VHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1T9EGf5n8KiVvHRJ7Vgk/HOLTfiDrfPr87tfmP9tWDXD54yJQ346I8Pa6ps5qb5
 895tZp9YEFO5Y4vKXbcHRZW+a6gtUJ+pNE+UCAA==
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
index 95e0b3a0f711..b9814d0cc5a6 100644
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
2.55.0

