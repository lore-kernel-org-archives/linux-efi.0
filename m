Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F122F8E8E
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570055; cv=none; b=CP2VUa71ob1KWJeCU7nd8jG8X3H4PM3qe0GSfgms0+xuYAtKWdgDfNJxclDe+FPtQ8lpC3UlnBJt/ySZ3LvpCWd8HwnS5bVTerxbSvxWjJq8TEhsyPDLFW1IDpkgx+Jw2YpHJOF/i2GTIL+auDzyazwv1T8Df/U8hvJzOBMQfwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570055; c=relaxed/simple;
	bh=4M3XeYI8lfZyQ0kdxVKYo99uiVCoJeAAy1bxt0mFJPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O+e7qN3Q8YpkTCu8DsWQs3WVC0LY1NwAPlXAMjp4emihe+fw4XTGj6n+jirIE3cXA8jH5fQB32XDyW+PxB+cnFLJAjvZaA5S+UXJhzJqGhElvWZTuj82wJQV0s/BPudvvWl5BhTzVwcJUOVmkp7pNqeIbxSkfetYLonMo4HFmsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hBJF3vjR; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hBJF3vjR"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49cd55ee2f7so51462295e9.0
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570052; x=1790174852; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X5xo/Tmz0T7aPKmXCPKRwoNwYrD0vFb3mWe6uQZFyqY=;
        b=hBJF3vjRNOcUWlJm44CO/ai4feMv7qKg25RwbyrxAa4TpdmOSUY+umQuTrCWCe5H6X
         FcMwT36yPADKtcfJYODnL2o2mqvKbzNTKsvDj0fLCUbuNbPnQai3tr37eIBXynORIyuW
         oPsVmdJr2LshAIcDX3YoEhhXBXnQ8k/otC0NfvM98IMdAvzSX2O/qGhAZF/mx6iOlrEs
         Rfj03lWk24yAM3eLpec5Ryi+GhSPbGJ25Kyliy3gz4KY/zPrViapwhP9ugFwG2PZi833
         3OFtRJZb9byuYv5Eb4xw3uPc1q0nkx5ZlHRQn9BWuLsbokOSScUUV2NVygyq65yXiEd/
         Zhqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570052; x=1790174852;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X5xo/Tmz0T7aPKmXCPKRwoNwYrD0vFb3mWe6uQZFyqY=;
        b=mwkaaZlBvKXoKytVjnjH9+o3t/mFda0oMirLlpCCo1zGsYmQQtWXt9U1CATN/F3yTL
         nyDrJS5D8R9C9j2sQQXxfvZBr1/LdsaC8yFIzMHtElCgWP2ajJDbeYdc+KWTPuWOwolO
         vfweEMr1UW3T139CE70y2ye4Ga7tczNXh8U3NwGGatjIFYiJDzJnWR61zuWSvdm40eaM
         GFj4xjtl9Zc3TrGJmmh93jOR2MFQU5WX/ay+BDgQQww7awDLweG9jrMD0uiFJZ04UTbR
         17A+a3ywN//yHXx1jqdmEv4IrvrtbvVIOgEOiM98PxAYsSULCZ5vARsfTIXoQM5jmX6c
         OPZQ==
X-Gm-Message-State: AFuF++kAL06I6R4xBBfhKUZpquFKNuWjF/r36Uz4O8v2a4zdW3gGT3sj
	hFzjmw9atsJP/5UDSJHOJsIMnBKLinVoexSPu2kwim3Ih9rHs4mTeC/GAQrbiSre4aFhU9GJSyv
	rLoGl503KB0CltITu00g848RXH14tcU+ykB+KpR3iky9tlE15rErc/IuTZ/w26rLW9gm/IlJoBn
	RCs05JILrB4FdZOLKsey+Myc8CjwtQ4A==
X-Received: from wmbhi10.prod.google.com ([2002:a05:600c:534a:b0:49e:661c:77f4])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b87:b0:49e:6c9b:4e94
 with SMTP id 5b1f17b1804b1-49eb73308bemr44031795e9.28.1789570051918; Wed, 16
 Sep 2026 07:47:31 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:53 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2274; i=ardb@kernel.org;
 h=from:subject; bh=dlXdLd0hhW7NlWGwnSX6SvP8+eAGOum46CB1gc4SNxc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6nuhlcpndC5+UPqwZpVFuYsFq30/27SrRmt/2V4+o
 Z185rxSRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIUg1GhnV7TZZtXR50v5TT
 qEym9q6KdwqP0d6HAe3Jv31WlU6Res3IMKH07bnb09Tm6257Mdmf5+qXGF/+R+btt/e99gqvr3s azQAA
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-16-ardb+git@google.com>
Subject: [PATCH v3 5/9] efi/libstub: Avoid efi_puts() for compile time
 constant strings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_puts() performs a UTF-8 to UTF-16 conversion on its input, as the
EFI console's native character set is UTF-16.

This is pointless for compile time constant strings, since we can
simply define those as UTF-16 to begin with. This takes slightly more
space, but removes any runtime handling of those strings, simplifying
the code.

Note that efi_puts() also performs LF to CR-LF conversion, so this needs
to be taken into account as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c    | 6 +++---
 drivers/firmware/efi/libstub/printk.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 80dc8cfeb33e..6919e28ba92b 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -309,12 +309,12 @@ static u32 choose_mode_list(efi_graphics_output_protocol_t *gop)
 	efi_status_t status;
 
 	efi_printk("Available graphics modes are 0-%u\n", max_mode-1);
-	efi_puts("  * = current mode\n"
-		 "  - = unusable mode\n");
+	efi_char16_puts(L"  * = current mode\r\n"
+			 "  - = unusable mode\r\n");
 
 	choose_mode(gop, match_list, (void *)cur_mode);
 
-	efi_puts("\nPress any key to continue (or wait 10 seconds)\n");
+	efi_char16_puts(L"\r\nPress any key to continue (or wait 10 seconds)\r\n");
 	status = efi_wait_for_key(10 * EFI_USEC_PER_SEC, &key);
 	if (status != EFI_SUCCESS && status != EFI_TIMEOUT) {
 		efi_err("Unable to read key, continuing in 10 seconds\n");
diff --git a/drivers/firmware/efi/libstub/printk.c b/drivers/firmware/efi/libstub/printk.c
index bc599212c05d..f36639886d00 100644
--- a/drivers/firmware/efi/libstub/printk.c
+++ b/drivers/firmware/efi/libstub/printk.c
@@ -136,7 +136,7 @@ int efi_printk(const char *fmt, ...)
 		return 0;
 
 	if (loglevel >= 0)
-		efi_puts("EFI stub: ");
+		efi_char16_puts(L"EFI stub: ");
 
 	fmt = printk_skip_level(fmt);
 
@@ -146,7 +146,7 @@ int efi_printk(const char *fmt, ...)
 
 	efi_puts(printf_buf);
 	if (printed >= sizeof(printf_buf)) {
-		efi_puts("[Message truncated]\n");
+		efi_char16_puts(L"[Message truncated]\r\n");
 		return -1;
 	}
 
-- 
2.55.0.1032.g73a4cd73de-goog

