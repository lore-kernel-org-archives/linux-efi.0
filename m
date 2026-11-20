Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795162551;
	b=5NxnxwMi9pXZI5sJ4LgQcE/SeDqXEV5bT6GDgDn8YoCHFXTQvDdB5grdzeXyPK5nhlON
	 31gj+PXw4IOW+FwxLPNLcewaKaSShDBT/iKDkUcvoS5MychHUK4uiDV5V8nS//KmKszaW
	 BpEuUFI2CeQnwRwntKTsSnANnhwSSbBRHhcW5Z3VGqHzSo0k3PlCPMfJF+cjZEhS0KAkZ
	 8xyZHXA4Cfco77pZmynPamJvwgHGo0DggJ6WHoZ4Gaskw/PkxlSuEwza9ls/Vs7+BbEgt
	 sf1OYYWV/qeWQnDjo1ayTPWJwlS1LBGPX6SxUAZ4ixYz/hCQkt5a/q2bZjSsXhpngpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162551;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cdMIn3d++fXbCyR18l4vxstb3vbUjNZ9OLHJAK0SFoU=;
	b=jmYa5ADU7QdAY/5HClg81s8C06jUEemSxcCEG3FeIjoQMed5RR/EK8yIFsxMyJLiqyIK
	 w+WP+MuGjMM24742+1kNuou5i94rJsw4h0ShySbReiHbUrOeYc39tbFcWvzO8/XQ3xnXA
	 OrAuVbunTIhu5yrPp6MJ7K/McTPm+8wxtdNOdPACDUq2l/0/sBfMzED41SQpBn4xdZYCm
	 EBfZJocOfYIAAr3Hfrs6jMPh9NElWN7nnlvTBrzQ44K9cEmZ2HcM0hTbxyJlX7Yo+oYQT
	 0OgibDpecH/3GJzVbeBteQ0HaTV8CZup1nh3nEf09d7+IpNr3+6tQDkMN1gM7belWLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=TS6htP1O;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78804606A320;
	Fri, 20 Nov 2026 08:15:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78804606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=TS6htP1O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=TS6htP1O+h6H4bGmlR9b1Azg3kn6oP/NH9vinjx85xFFlL83ElYD7duGtpmiaRezh9rh63uujSB+M
	 fCIgKX55E4uTo5uKQi/VMyf8KSZ4NSaTLmgle/LExQDBTqlb89AwQnbDfXIVLMd/UipeIrhcatb6lH
	 4JiD8R8/bTOJKOQY=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96b0001af7cd-2c214;
	Fri, 20 Nov 2026 16:15:46 +0800 (CST)
X-RM-TRANSID:2ee96b0001af7cd-2c214
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16b0001b0515-1d423;
	Fri, 20 Nov 2026 16:15:46 +0800 (CST)
X-RM-TRANSID:2ee16b0001b0515-1d423
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	Jeremy Kerr <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kohei Enju <kohei@enjuk.jp>,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] efivarfs: fix off-by-one in efivar_validate() variable name matching
Date: Fri, 20 Nov 2026 16:15:40 +0800
Message-ID: <20261120081540.1870-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: zhangchujun <zhangchujun@cmss.chinamobile.com>

efivar_validate() passes utf8_size + 1 to variable_matches(),
including the terminating NUL in the name length. However,
variable_matches() expects the number of non-NUL characters.

As a result, exact-name entries in variable_validate[] fail to
match, causing some variables to use the wrong validator or
bypass their intended validation.

Fixes: 630ba0cc7a6d ("efi: Fix out-of-bounds read in variable_matches()")
Cc: stable@vger.kernel.org
Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
index 6833c3d24b54..9f18bf48615c 100644
--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -274,7 +274,7 @@ efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
 		if (efi_guidcmp(vendor, variable_validate[i].vendor))
 			continue;
 
-		if (variable_matches(utf8_name, utf8_size+1, name, &match)) {
+		if (variable_matches(utf8_name, utf8_size, name, &match)) {
 			if (variable_validate[i].validate == NULL)
 				break;
 			kfree(utf8_name);
-- 
2.50.1.windows.1



