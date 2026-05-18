Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5711340855;
	Mon, 18 May 2026 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779087755; cv=none; b=aqlEsmhltC7mbl8HbakNN/2Ob+sqeSsYGx4xLYGOrguTKJ2KsW0n+OAh+Vvh0yvaBMV2GrK3wI3WOOK6Jb1878Wu2sAwXxgJUS35GRyeTOxvxrv5SXwfJx6pRtOgpwaiOXSmpSlijBygVv4JzcNTT7Ly3g9YQfoCnxN0+S90Wwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779087755; c=relaxed/simple;
	bh=+KMO1sA3pMW/EElsjNhraa+tU4RqOJMs6BaPkXfMvGo=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=fsADxO7H+InZDYU8yEStuT2w4eGLgM9ffRzZhCchiZyjAOCLxE0foFrwuhmOY7vT7L+0j697sjWV/z6rn7LrucXUcTSk+UNYZxzCF43skP/hJYlsx05MLwHe0g9rKr08FYvE1sOu/YNICW9VBRJ8j/o7RLL+T7VlazOvWgsVhns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=jIHOF79i; arc=none smtp.client-ip=203.205.221.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="jIHOF79i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1779087741;
	bh=OGseklYBHMignp5Du1Fid7Y3Tj3Py9np2qy08x2NInI=;
	h=From:To:Cc:Subject:Date;
	b=jIHOF79iXNKO7lW9QlW+WASVCn6dMf453a0t4yj7kdtW3vbQ/R8MeuMaZNzg9Da3V
	 iK5nMZoPi02F3g13NRwdmFsFGCppE25W4eBKMP/yc1qP3dBGv0Ck5zFpmOpAniFUf0
	 65dy7XjaeKLMQvuWLoAEBgh7qcENcqoSMUwMoVwA=
Received: from NUC10 ([39.156.73.10])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 92BC068; Mon, 18 May 2026 15:02:18 +0800
X-QQ-mid: xmsmtpt1779087738thbmrmk29
Message-ID: <tencent_270AE22BC7E81D6281019A105796C8E5AE06@qq.com>
X-QQ-XMAILINFO: Od8VqZhFMB3NauYW+4DxYZzS148YTEKk8PgWCUirDRargu7hcvAUp75tA63ao/
	 DuSu3fUjqF7wHkyUVQ4svBOFCUav80fwwh0ChcG4uonn2biNnTIJ8B3fJHP096mdIMWFWf46q2go
	 vWfdQxxSaWYUwsk02izPumJ/RuGgCLDi+ouZqe6cnyAVlsvcepFAFTYxK0CsPXMiJvOijPUDtUSc
	 1asbdn7Rp2LN6Qky7ShCKAemfjPHhFOTH/ooIqN6ip5WgZ34jCEZixbR3mk9209x1rlx25B3LZCO
	 ME0XjY+l039dahHu0m1bxYTfgUNyHdq1m7x74PaEn58eJ8zwEmS2nAhK8NXZiZPK+7V1M4CxDKSy
	 fkSM7plAAl6gDw8syVtqdw6zBYahYvjqOSMxyYO0Zk1MkR8Q0feKbWC+0gwH+xf8Z0a6WZ7QvS5K
	 0q10EGaYk72nhPonI6vau1AspWVBM4xM3vWMcekxs/9wU/hv6B+Ik+04lDAlw05FJvwm2kcOzm8p
	 cjVFebP+JRA+JIu+LKkFogYv5B3OHbW8AKfsSAtZbpoRI0Xn5TsjyNEO7BUvOoaAXiZPFh3OJcn1
	 wBp3/uieH+XF3PvYD/O8L+2B8r+oe2JEf5AmIxZU9KlfEZP7yxouTIq8G29ppBs7PJW175TozGQB
	 aWuoK2tvvT8NRDGjG2+5FM85EYOcRpBBRBX9yc2cBDsX4459NE6DplLY1gx4x1F1xGvOVuezDdma
	 0P3IT3lWlwszsxHtGN84IluwPS8qDLgAMGo+N4263uUNxo+R56DyRzZ0TOingGui5o7nGnzQhDgY
	 j9hOsOf6gsBlu8tqziDSuJH+1nrdh9YjEqa1EEWmoXh9drp24VyF4nEWHdzGtW9eTUr0V4OF99qc
	 jEQ4Twn2FzPP5qhCEei/Uebrgz3w6RUOpJ1gP7PV398rKedtcJ6iSfheujxsBzsM7SeIqMALABnN
	 RtKWAjrQpkSznwdnAhX6bLPmVkgEkAdOdlZVLq22fz9piY3Eo7Ut9voPehnR30OtWHy4ucyz0+Go
	 ZAAUPuGcPHRno+MnyHVnpOY6zZdlYzl6KpjyLo4A==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Rong Tao <rtoax@foxmail.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org (open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)),
	linux-kernel@vger.kernel.org (open list)
Cc: rongtao@cestc.cn,
	rtoax@foxmail.com
Subject: [PATCH] efi: efi.h: Remove extra semicolon
Date: Mon, 18 May 2026 15:02:08 +0800
X-OQ-MSGID: <20260518070209.445733-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rong Tao <rongtao@cestc.cn>

Remove extra semicolons from comments.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 72e76ec54641..ccbc35479684 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -61,7 +61,7 @@ typedef void *efi_handle_t;
 
 /*
  * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
- * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
+ * struct { u32 a; u16 b; u16 c; u8 d[8]; }; and so the implied alignment
  * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
  * this means that firmware services invoked by the kernel may assume that
  * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
-- 
2.54.0

