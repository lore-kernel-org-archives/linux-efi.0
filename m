Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2488E41B374;
	Mon, 15 Jun 2026 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539869; cv=none; b=enKQu9rxhEyO264Xz2kD85BNw2UnV7lGaQxjE7tkzSyQlBwIgzlsUlRmk/5Tt83DJvECcTZIQZi9QZjqUwFc3SvWLO9yCGk4EGC6VOvx0MDYfcV0mBixK08RUmpwcGnaLMz85RoJkQXEfwK16Pxmpi2YctgHUB/YQJcp5UT1QGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539869; c=relaxed/simple;
	bh=bdh0KjiIvSsGMoHzE2tou/IZPOUU7lq/OpcbV848WpM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dHFdJuRoz1GCIFWDcno6tSUS1s/EwPdddsRKeqFDPch81ZSE2SdQow1/tlCUEBZWEBWU7cIURF3nz3MnmpRaVAD97LDWRg9R8gxxdHKrjmhWD5qc4XTWbz9DN0JXD/zRHJM9q1rHZ3qPBlC0EI+ER/a42/drDAreh4et+sD9cQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIR8rRpm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIR8rRpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD001F00A3D;
	Mon, 15 Jun 2026 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539868;
	bh=rGXlwl/xxJit/WeNCIYfh+HcaGWl7b2l55kHocoZXu4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FIR8rRpm7neycjkE9Iz2VaaqLHwVYMvUycGyr7VvM8ZiiD22Ic+jZuvRCVF9W2jmi
	 pgrlyytE/MfxgFu9l16FXuZYJJf9nxOEuEZrYsQ47I6Y9uDfp5lysL/gBnD6LcTCxj
	 Wi08mgN4/UCP299glw7hg87SztiyFqSS6D2lnYixn5uoedgV0OCMpC7J1tdqORE4RM
	 lTDSxAF3I4bzQtjFF1VmeqSNyPz2Oh4pSSTE2X9TSF0WGlZz8OZWRRZ8NUpsys6uVM
	 xVg82mkkxy7c4dPl4eHVsMRILx+S0BOBYN1NCyrfda7Rct709MopYQJuyux/YAsihm
	 7eqd/t6r60TtA==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:13 +0200
Subject: [PATCH 17/19] init: factor out root device lookup into
 lookup_root_device()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-17-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=bdh0KjiIvSsGMoHzE2tou/IZPOUU7lq/OpcbV848WpM=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylc57fNLP2Y1rDg+7848n5mHrt9WWi9+qru3ldu47
 Zeou5x+x0QWBjEuBksxRZZl5ZzcCh2F3mGH/lrCzGFlAhkiLdLAAAQsDHy5iXmlRjpGeqbahnqG
 QIaOEQMXpwBMtZwGwy+m536pnN/cZSq/VKi/CahZpiu4tGwv49ZNzXPlmc/oSd5jZHgj82G6j9u
 sl+0TkhIvrrl/6Jqa2/WXAiFKtzpfPLe9HssDAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS root detection will also need to work if root_wait is set, meaning
that wait_for_root() needs to handle the DPS logic.

Move early_lookup_bdev() out of wait_for_root() into the new
lookup_root_device() so later changes can extend the lookup policy
without duplicating the retry logic.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 init/do_mounts.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 95e0b3a0f711..5fb5aeb88da9 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -402,6 +402,11 @@ void __init mount_root(char *root_device_name)
 	}
 }
 
+static int __init lookup_root_device(char *root_device_name)
+{
+	return early_lookup_bdev(root_device_name, &ROOT_DEV);
+}
+
 /* wait for any asynchronous scanning to complete */
 static void __init wait_for_root(char *root_device_name)
 {
@@ -415,7 +420,7 @@ static void __init wait_for_root(char *root_device_name)
 	end = ktime_add_ms(ktime_get_raw(), root_wait);
 
 	while (!driver_probe_done() ||
-	       early_lookup_bdev(root_device_name, &ROOT_DEV) < 0) {
+	       lookup_root_device(root_device_name) < 0) {
 		msleep(5);
 		if (root_wait > 0 && ktime_after(ktime_get_raw(), end))
 			break;

-- 
2.53.0

