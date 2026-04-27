Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B8D21CC59
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 15:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305400; cv=none; b=EzkXNxvIEJ6HxjK0oMR6fFeobMZRYtdX5Z0YGzZ+5/Qwkrx4MGSHV2dgRUxyTUcT0ynOO5ZF9fITKU8GMCNp8i/wrXhvq7YE57hZ1freHzIGOs/+rNVgDzZia7Iq6XXIfj9rdVEC7BRfffWqBfU5/pVmyF4gqJXnjhGMcL7ZGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305400; c=relaxed/simple;
	bh=9AZoKn3Mmd7YFHCvD6UJBvrZLBycKGUTenx7s57wVxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NN+RRCqEfNKiDU6P7+XYKrVPurhLUvCyHb8cYoPXkPm8PLxNpoW+ozhPYy5wbhEwjWXzAkMBu1pc6kWY/xyn2GO9YDT+dtUL1uWj2Acc/qEYpX4vO7Q5sYhkuauIzpQIdqZz0yFJ6QUyiLwdUEd+VLc+r/k57k3ZIQv3QQzaMVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYWY78Px; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYWY78Px"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777305398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DBoGTpnCziaMe4ETleb7tyo0dqz90igD9vfAMDx0ca0=;
	b=JYWY78PxOF6vLeGY5TKkST3zpqoLQV/IV15axLtZo0o84KY+9wmzKa3qwFBnwuGUx4yeuC
	+jJ+umg0SP8i2NdLIAwcw9XHvTZqvVZJ2LK3mGYIFXIIcH4RsYyUyR8eaBJTxcgaFaKLcS
	pHkY4oyfnRq0vSN1BDov2qNVcaZ13Xg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321--aX6Vh1DOa-AMEVzXiqxMg-1; Mon,
 27 Apr 2026 11:56:37 -0400
X-MC-Unique: -aX6Vh1DOa-AMEVzXiqxMg-1
X-Mimecast-MFC-AGG-ID: -aX6Vh1DOa-AMEVzXiqxMg_1777305395
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AF8619560B4;
	Mon, 27 Apr 2026 15:56:35 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B3F9195608E;
	Mon, 27 Apr 2026 15:56:31 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Kees Cook <kees@kernel.org>,
	ony Luck <tony.luck@intel.com>,
	linux-efi@vger.kernel.org
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efi: pstore: Drop efivar lock when efi_pstore_open() returns with an error
Date: Mon, 27 Apr 2026 17:56:30 +0200
Message-ID: <20260427155630.1966791-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Thomas Huth <thuth@redhat.com>

If kzalloc fails, the function returns -ENOMEM without calling
efivar_unlock(). Since open() returned  an error, the calling site
in pstore_get_backend_records() won't call the close() function, so
the lock is never released. Thus drop the lock in case of errors here.

Fixes: 859748255b434 ("efi: pstore: Omit efivars caching EFI varstore access layer")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/firmware/efi/efi-pstore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index a253b61449459..a5db3534f0a63 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -60,8 +60,10 @@ static int efi_pstore_open(struct pstore_info *psi)
 		return err;
 
 	psi->data = kzalloc(record_size, GFP_KERNEL);
-	if (!psi->data)
+	if (!psi->data) {
+		efivar_unlock();
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.53.0

