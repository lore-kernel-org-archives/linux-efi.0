Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026126;
	b=rACTG0utZwfs1BPqj60OvnWzEw24Hbw8x35PylwBImzaoARvhADu64LjkGSLXP5RKyuO
	 gYKPx7tr7fd5yDMFBInind1q1LK7a/2OrwRA3l9Bqva3rur8tunqlyNtld97A74z1vhfu
	 vMQsOjMbzdtd/Rn+cC0bUVpbUKPlFWw1fm1yUPZCW1BdoNGEaMz7MykcV7Kn4yqJtsaK7
	 QrM2P7jSkefhVZpJ5cX7eeuqI1CL5cCIZ4z58fECtfxdEratvPFuPwL7OWmobx4WsW1+i
	 PrAgWAb3/PIeiSRKuQWYKzOz4o1PfeUTP02BBcit+vjX1otxN/p4T47PeG93iIsg/WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=X2HAR1/QIm7cbi9gzcaeZomwRblEdyJ34MRcnIFpfbg=;
	b=3a04EH3rSi/TUV73I6jb7RK30qoxZ9GnIWmx8W0DC44NFXOaXxBhCcN+Yw4yF754CvyS
	 MdeLaL0NWNiSYFloMbe12CO/W48Pepvo88hbDepVaqRKTCVKBK5vn4DH6WM1KMDkfZOQS
	 0EjKS3HxpY7RR/YnQwOaq4ryRs20lLUTLK1NE0bL++stnd21SFX0dPnX4DJgrvnPTMbGv
	 sbwKTdEh6YEgI6RlKstI/uM0sgnDZKJt5lEB+pisBXykXDOPbWzVszAsmKAj7vZq2lYFH
	 lRFnb/mzjsiUk8T/PDwDrPiQUi1/VBYbmuXfJWhmlG6Y9R1tF2QtNzJ556g9GglGqZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="oAm5aA/n";
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE45606A336
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CE45606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oAm5aA/n
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c37b2763f1bso132814766b.1
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026124; x=1795630924; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X2HAR1/QIm7cbi9gzcaeZomwRblEdyJ34MRcnIFpfbg=;
        b=oAm5aA/nvoTOrGSAHiHqPJlnJyPHb6Iw+ETRscjH+cT8dF5jwsIbHainiT35XDLFRv
         Alxq/tvPs0iPKKb17fVvkLJVQ1XprYZzb0EbjgUQ7sa4tAhadMRsIhS3n9GNh0gHaExB
         mZq6oXsRR7xHfta0X3yyy1vMDMxg/Qc9LemUYQwMCksRVCrnhNm5JfD92ch5a6RVw4ez
         U86n9ahZb73LPn81BG1iL+u040kVyMtQ8C795s8r9xDVfZ0UtQBU6JXCTZ1SRAhdT73+
         lFvnmyjUIQ3EaqTkwnfpi7xfLJ4mRLKYvwCvwENe+ezWtiC5+V8O1qTmQPJE8VMZY91L
         cEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026124; x=1795630924;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X2HAR1/QIm7cbi9gzcaeZomwRblEdyJ34MRcnIFpfbg=;
        b=LT7wiHOoFBQb2ruAdxjZUzmH+tD6cpUb4mDauWTP1F3Hb2TW+XkKHeBrn3rE/gS3Oh
         wq4s0FRTaMwfQUwjVQqAPK02LYncgIrkd3VErJCuksOY9u/ZOe3Toia30hmfKTh1SD9a
         nt48IBMf9dvjAM1sqKakMGWJSCxKqvHTlCpa4gvasPi3K5f91LpF9kq2aWN2R7zRqr17
         mVxa1ePTwuqd4Id6VUbx0GPr/doWP+6dhIs8g00DVpjhEJXTfKKBsd1hZUMrJeIMA45f
         zvxybXRbahQd4eX8OBWhWeMa6VmYUmvtDfUWr9opBTD+JJHGdTdchnrSewXT7vS6ldIE
         fK5Q==
X-Gm-Message-State: APuU4Z9gKmcsq5+p54F98+Jg1FOKAvpeMOIMH4hJzg2PnPMykdruBdOg
	wMvSYU7ExXAvKMcF63f4Z1asw6kOdZvSolD1K22ZNS7F+BuV44qbPcpAhEq1fMdD7AS+yBCDJST
	0TDyXGgcwvVeQF6y2l0MwVU71t/smO3+3KFtl5QruMl9+rMvoWjiXFAp3uCAFZfwrJODQStIWII
	aW2avW0Ko62hUyjj2KltDyJHIo58KIGw==
X-Received: from ejsj16.prod.google.com ([2002:a17:906:4750:b0:c50:9014:5739])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9490:b0:c31:c767:ae0b
 with SMTP id a640c23a62f3a-c510dc46093mr335886766b.0.1795026123628; Wed, 18
 Nov 2026 10:22:03 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:16 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1913; i=ardb@kernel.org;
 h=from:subject; bh=VIsLiroKmQWhjV/hmhsESRfVSQ8Kw0tSPcHO14prx9s=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvmwWvvm95e17E9K2NDbPkg+j/ukJRfPtiH+Q4JSYcv
 PmxdH9kRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIZgWG/2E7fT4eu39zRh1f
 83dNmbx5TW5zrrkcP5aX7OzzbWmoeCLD/wDLYM3ApSk3e8R+/VvhvkTocrniAeuGitNi00ISZ1g WsgAA
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-31-ardb+git@google.com>
Subject: [PATCH v4 10/19] efi/libstub: arm: Simplify handle_kernel_image()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that ARM moved to efi_image_info for obtaining the base of the
decompressed kernel image in efi_enter_kernel(), it no longer needs to
distinguish between the image address (which might point into an
unrelated allocation below the decompressed image) and the reservation
address (which is what can be freed upon an error).

So use image_addr/image_size rather than reserve_addr/reserve_size in
handle_kernel_image() to return the base and size of the allocated
region to the caller. This will allow those parameters to be dropped
entirely from the prototype in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm32-stub.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 798b2ae3bb03..55d4fa3177a9 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -128,18 +128,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	efistub_image_info._text_offset =
 		kernel_base + TEXT_OFFSET - (u32)&efistub_image_info;
 
-	*reserve_addr = kernel_base + slack;
-	*reserve_size = alloc_size;
+	kernel_base += slack;
 
 	/* now free the parts that we will not use */
-	efi_free(*reserve_addr - alloc_base, alloc_base);	/* no-op if 0 */
-	efi_free(alloc_base + margin - *reserve_addr, *reserve_addr + alloc_size);
+	efi_free(kernel_base - alloc_base, alloc_base);	/* no-op if 0 */
+	efi_free(alloc_base + margin - kernel_base, kernel_base + alloc_size);
 
-	*image_addr = kernel_base + TEXT_OFFSET;
-	*image_size = 0;
-
-	efi_debug("image addr == 0x%lx, reserve_addr == 0x%lx\n",
-		  *image_addr, *reserve_addr);
+	*image_addr = kernel_base;
+	*image_size = alloc_size;
 
 	return EFI_SUCCESS;
 }
-- 
2.56.1.708.g77570a6a1d-goog

