Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EF1372EC0
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957672; cv=none; b=Y76AMpDg7f09bES0gqd2aEjRp02cM+hqowJEjygQiBeoXkP3XKihtmYWGoMgQ1kESRnRh/IcF45Oww59Z/GJxWq0FP7T6I5ZTmRiBzbQgrXF5FIcTI3iD+Zyw2egQoKJUIo8TfSudOO/YsTloUUFYwib5OiAN5XkI1UsT6QAnp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957672; c=relaxed/simple;
	bh=tnB6iuZ6E5vbcxeFaPRRMPwzhcy4pO9KyeduoWMF7rE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=poO+Va3sWhxSGSuHkJMOCLiThazut4kn7fV4vBXS45bQbazLz8L8JI+GkgzaL2PhqvqdxxpkPx6bifHulZEAj5gnJMCPeo341R15659YCdF4h20H6ph8A8j7DYe1l+aO56qGkWNwSI29QMs94yGm0XRgAJTbxvQlb60n+p1U8VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SHDd7lWz; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SHDd7lWz"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso75257015e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957670; x=1777562470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RFFa0eyeL35xeyu45ExmOZX3U0AnLJJNTndQMnU6Phc=;
        b=SHDd7lWzZi3z/3436vI0/dPhQr8kp5ZIW8ZzWCEcKo0EwK+EHHTEZCxwUV0+SNQ1kO
         0yTcdy0u6HsMglM0LkYRa/pXJBJ5ump+FMvwz0iyYkQ4h4bb06ul5IrCruaiTwStCdU1
         1bhMYyjleGg0imiACvkdi8wgvxcS3VIZE7P+LNK5oU3UO6gZhs277org7rjBixZYiwMN
         GI14S1u+O9tXR7uHsO9fwajqMtKpCEj9s06W605nJN63U09hSP6sSBiKHe9KmY5zBHS1
         NpwisSxcDDHH0AQ7gne0u3sTtoTGaFhmYu3DTA7CP7Har1AC7O/S89VqQ6N1P6CL3lCs
         sixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957670; x=1777562470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFFa0eyeL35xeyu45ExmOZX3U0AnLJJNTndQMnU6Phc=;
        b=hWowKl12nob0LUQei5jHsKn5C+zts0kpmFn6RmTOiNuFushL5bHnW7oYqoZL+Paknx
         RSdvszZvvA/lnRDDKI6o8QiYJhVZUGHgLe/0MBtpiQr/+Y9b3ncSIt36qV3Jhf7ObrM+
         CZK243C8ZllM9nDPEfUSnW4fZYyjkFyCr3BeUgBVIjS/PkmeeCBO+5fk6uh9O+HQn9DH
         YpVJo6T+TfY6VYRDmArerPlY9U//LysGQsM6zyZOWOc4bbDxiDmFMW+zzNvqAsxvjzlH
         Acy53EXpi3SOwmt7XCZtF8fo31zFVOGxmcksShaRlDWQc7m9zDN93Fmrqayj3syc/zO3
         D1kg==
X-Gm-Message-State: AOJu0YwKl0EgQcYlHJBhW/KhvTAnQQBXJ7B9xOXuCxy9zbHkHf6hFFxr
	xxd1tZIpga1hskkjynP6clUWY2sWiHq2nIoLHDmDsC+6qrVhSC8gsvm+Cpn0xcc8k5BSWeUvhw=
	=
X-Received: from wmbgz9-n2.prod.google.com ([2002:a05:600c:8889:20b0:483:27fd:cf2b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ec8:b0:485:7f02:afd5
 with SMTP id 5b1f17b1804b1-488fb755caamr407991925e9.13.1776957669759; Thu, 23
 Apr 2026 08:21:09 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:34 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2056; i=ardb@kernel.org;
 h=from:subject; bh=jc52JwSM1lqsY0b8j2g3nRYFPgUE93s/+qfuH/7VRek=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxbGysBDho4vj7f/fasxW4QxWD1e52xv61MdFUOj3Q
 wPjV6UdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCJ7/jH8d9vyLcv7Li/3Jraf
 AiKppit1Nf5FdWow+Ns8kpNSzF2WzsjwK7vot4Jk6ia9ivuGC7fuW9sX/IFf6tIkJ7Yryg563KV 8AA==
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-28-ardb+git@google.com>
Subject: [PATCH v3 09/17] x86/efi: Intersect ranges_to_free with
 MEMBLOCK_RSRV_KERN regions
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_mem_reserve() will mark reservations in memblock with the
MEMBLOCK_RSRV_KERN attribute, so take this into account when building
the ranges_to_free array. This removes the need to split EFI memory map
entries and tag them with the EFI_MEMORY_RUNTIME attribute.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 44 +++++++++++++++-----
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index ce452e5c2f0a..ce06a388fc11 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -406,19 +406,41 @@ static int num_to_free __initdata;
 
 static int __init efi_add_range_to_free(u64 range_start, u64 range_end)
 {
+	struct memblock_region *region;
 	static int idx __initdata;
 
-	ranges_to_free[idx].start = range_start;
-	ranges_to_free[idx].end = range_end;
-
-	if (++idx >= num_to_free) {
-		num_to_free *= 2;
-		ranges_to_free = krealloc_array(ranges_to_free,
-						num_to_free,
-						sizeof(ranges_to_free[0]),
-						GFP_KERNEL);
-		if (!ranges_to_free)
-			return -ENOMEM;
+	for_each_reserved_mem_region(region) {
+		u64 region_end = region->base + region->size;
+		u64 start, end;
+
+		/* memblock tables are sorted so no need to carry on */
+		if (region->base >= range_end)
+			break;
+
+		if (region_end < range_start)
+			continue;
+
+		if (region->flags & MEMBLOCK_RSRV_KERN)
+			continue;
+
+		start = PAGE_ALIGN(max(range_start, region->base));
+		end = PAGE_ALIGN_DOWN(min(range_end, region_end));
+
+		if (start >= end)
+			continue;
+
+		ranges_to_free[idx].start = start;
+		ranges_to_free[idx].end = end;
+
+		if (++idx >= num_to_free) {
+			num_to_free *= 2;
+			ranges_to_free = krealloc_array(ranges_to_free,
+							num_to_free,
+							sizeof(ranges_to_free[0]),
+							GFP_KERNEL);
+			if (!ranges_to_free)
+				return -ENOMEM;
+		}
 	}
 
 	/* add a terminating entry at the end */
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

