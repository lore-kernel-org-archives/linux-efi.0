Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C748C8BB
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535911; cv=none; b=SC4kXK9YrqID2kh/qmia8iPnLwQivBLZF2WX1MXnlVMM4zlG2BVh/JIY556+p7zDQ6DgXMWHwltj2+udATfC8Hst7AhMtWawOVImTj4BxUFR5LaCYqom/ZJBhedp+sETtYViIwP9YSyHOqZlhWV/M79FeYORkUcBQrOFRuh9AKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535911; c=relaxed/simple;
	bh=ocI4dQsxB8t5prCDfeqVv/27rqEw33aRyRMZvwh2m9w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c+hhhkwIgoAyB+RB7P9gqBAC+09yJgIAYE6GPtjRLFyTZFrvQahSevV3zcuz7dfUONYDjZl3eIIyIN7E0+Ml+ROlylKCCkEu/rnWo0WgeMy7Z6UuxuR7brlz+DHFhvialx4RDA8aD7tXjkQ2ik6xYi1ADb+EJDwMEw/mXrvAw8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LE/QfN82; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LE/QfN82"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-446f87b6de1so1372024fac.3
        for <linux-efi@vger.kernel.org>; Fri, 04 Sep 2026 08:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788535908; x=1789140708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AA+yqbwYZteLCNaSIMYbow92ZoGZzXWDMvvS4HzPIJ0=;
        b=LE/QfN829mV4sNEcQNrgIRW8sFqdBKPl0zVlsuF8xvraJCXjmg8D0R7fRuIIM2yg+r
         BcPNmmBDZvvabeRFJuFpbxSMBtPZGu1wJ/3YDnQMWNemiCcF5rJRMexBQ/TBVKVLJM8U
         aWTCiqhkmziJPC/qr7LuNgG1r7gVzOcWUYvR7BNFc+NKllcID4x0sPyD2eSbeuYi/VNG
         VkVYDDT/d0Lvx6o/HamOON167zQV2wm9bwVs9l3tl5xAUMIaWzmM2NcaRq06ebMPA3I4
         EkIBt4C1ZdU6Dx7FF2nFHvxdtpwUc+4FX/gdAf50IeQa5eWrjmLQOklC+WIYgaJ1iToP
         cx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788535908; x=1789140708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AA+yqbwYZteLCNaSIMYbow92ZoGZzXWDMvvS4HzPIJ0=;
        b=SJ6Tly6xgmtM74ep15KECVi8pZrft5ts8FcGpk88/7EwC5yQwCJKFdT0ibxxoYBRg1
         vdyb2DX4aO/sgnxO5DsLkFs1pf0TIddVvHbIgcTFcpiCbcH7I6uhqxz0X/wepoUJznXo
         F/QOlAUE34ohEIw5azlRYfTWlxilhK70TCuprRuF3AXTAwJ4s7BxkTJhd9c+bouud5JG
         Qbu6O31pVrwWpKBGot3dDoMGfvmaVsmgT2mQsrrtggJI0ue4TSoBinRvZP3h4FrUyQ7g
         fidM8ma/JSNGR8tBWTf/1GZH072VDFzhRmYdNBlokpG1oqXQF8XH7AVKo5jn78ZRACKz
         1Lxw==
X-Forwarded-Encrypted: i=1; AKwUvBxn1VmBpDNUQqj1b7h5Xh4K3c9X5TbEvFimO+0qKhjrWBP4CE0WKDDu9DDA11QMPL7GeIb0DtPZrNg=@vger.kernel.org
X-Gm-Message-State: AFuF++kEL0M5l12l+niuW9N83V762VrEGdCSStJdYoxbwy18beNE9ZUP
	R5hpa6SV/DSzfhjrmCWPJlIVXpSaGPUvwH+ZlnoObEQTTYLcPI4psooI
X-Gm-Gg: AYBFou0mMqvDTsq4qsa8b3+hl/rIJliOAWdIaCgFdLKO1ggYqejTz7wamjZjfyEXqO7
	GBohhKYY2rrS64kYR/uolIg7V4mQhXDcw2VHDX6reJIo0WucKWrg0Feykc5j+168ASGQl7+ZLmF
	9j+i3SIvJYBheU8vKfhDRzvtYMz2qqSmpfZ3u/iSxACxovDQv5/gbclSnMbbuVe4131n14LnXOZ
	EGzLKPqq0SGO3opay9BPFOIjmZRDelFO20g8YecLwFKy+Prnmx9eNr55387QZSgBeMd7drk3Med
	kLvv9x8Yd6AMGB2Ps7XrLDaO7orPviF2wxo5r1obsg6BwldIWpNwLcdR9S4T0YVlWOvufJqx3Lj
	5G4kfxVsqpxs/ujxTXKO/9MXel1GMTkv6riTQRsprcGMeyuLdAWiKeJPprwDrksocS8u9Uu3C4U
	ZwrJfXPEn+jTnRQe7uzo0zftRGGvEVz/fzkDjEtOVedVtF2U9zRGxQQjUFg3N5zn2WYnOwMEtyr
	93s2kDcBXyG11MZhmiIzChHlGVVghQ=
X-Received: by 2002:a05:6870:c10c:b0:448:71f4:a28 with SMTP id 586e51a60fabf-4754f7c25c0mr6819282fac.2.1788535908255;
        Fri, 04 Sep 2026 08:31:48 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-47554b60b21sm2371315fac.14.2026.09.04.08.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:31:47 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH] efi/capsule-loader: Replace kmap() with kmap_local_page()
Date: Fri,  4 Sep 2026 10:31:31 -0500
Message-ID: <20260904153131.134383-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmap() is deprecated in favour of kmap_local_page(), as described in
Documentation/mm/highmem.rst.

The conversion is safe here. efi_capsule_write() maps the page and
releases it within the same call, on both the success and the fail_unmap
error path, so the mapping never escapes the thread that created it and
the stack-based unmap ordering is preserved. No atomic context is
involved: the page is allocated with alloc_page(GFP_KERNEL) just above,
and the copy_from_user() performed while the page is mapped is fine
because faults are permitted in a local kmap region.
efi_capsule_setup_info() also runs while the mapping is live, but only
reads through the pointer.

kunmap_local() is handed a pointer that has been advanced into the page,
which is fine as it masks the address back down to the page boundary.

Build-tested only, on i386 with CONFIG_HIGHMEM=y -- where
kmap_local_page() actually establishes a mapping rather than returning
the direct-map address -- and on x86_64. No new gcc or sparse warnings.

Assisted-by: LLM sparse
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---
 drivers/firmware/efi/capsule-loader.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 8e8f81f0a5a0..e423df3438da 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -197,7 +197,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 		page = cap_info->pages[cap_info->index - 1];
 	}
 
-	kbuff = kmap(page);
+	kbuff = kmap_local_page(page);
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
 
 	/* Copy capsule binary data from user space to kernel space buffer */
@@ -217,7 +217,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	}
 
 	cap_info->count += write_byte;
-	kunmap(page);
+	kunmap_local(kbuff);
 
 	/* Submit the full binary to efi_capsule_update() API */
 	if (cap_info->header.headersize > 0 &&
@@ -236,7 +236,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	return write_byte;
 
 fail_unmap:
-	kunmap(page);
+	kunmap_local(kbuff);
 failed:
 	efi_free_all_buff_pages(cap_info);
 	return ret;
-- 
2.55.0

