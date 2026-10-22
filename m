Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792683597;
	b=ikwcCwsH4W+Lb0vJMdehUeWAMyxsuEdVFqqiVP2LO17Q2ffkeb8V7AdkhTcPyo8s5Bmq
	 CjPGzOfgDYztNkzvaPYCBB1KGITNKx+hColeTdpmLygTtFxUKjLHgcB/ufxDv6/qxHCkn
	 uHoqu6dAOULqkzJPNycYMyHmepG7kwKcpk4g8ESaTrEIFtQYUVFnoAGiz8EjJvxH+k+cs
	 5B0z/tV7t5NHYhyWK9H0hB2cKi1gxvMSgW97YwUeJhaJDKxm09z7myJNvxzxYr++xVbnU
	 QgqNt2z9HsgTYkpHuwnZ/m9i7qOgzOsIEqOCjNKju5zDmPtLgVPSufJfBe1ScLUoDjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9PRBt6CU99Tgp/PmrNNizxfLM+x8gsCayxEXcNPrw6c=;
	b=iSNwq2znmibj5+kwL87RjPuENijOS+T6WwG4SQXiRyCWdjGfFK2mYBR0F936gxfxBgWa
	 ToKStqw3mTCb3SXGj853hRHog5E9UtAz6McHXFkDBcJELJh+nSosrsXa9F3s1Q4hNvOrU
	 sNK+LkDcSGnDvccuE02QcEEaLVRoUaQWW2RXzySadhmv3vWZc06P4FDyUGbugfm7v8Jy+
	 KEcbU4sVCt5rWpgzMh3VYNLhaleg6dbVlyDVRQtaWWR8LM4BnA5biS5BOmbfFV7TmclcT
	 7TWVKCwE7R2A/W9ZXvKNRmzAmvF215JFBtYLpJCOeyEGCVYXtQE7+Uyz4VHbSyCl48A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gwNC7e+7;
	arc=none smtp.remote-ip=209.85.219.49
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448F2606A319
	for <linux-efi@vger.kernel.org>; Thu, 22 Oct 2026 15:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 448F2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gwNC7e+7
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91b83459526so34096d6.2
        for <linux-efi@vger.kernel.org>; Thu, 22 Oct 2026 08:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792683596; x=1793288396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9PRBt6CU99Tgp/PmrNNizxfLM+x8gsCayxEXcNPrw6c=;
        b=gwNC7e+7NzQRg4fHDHwXLCiShQBYZmOKhlIS7e0HLIepHhNxJdOA4thrdVz6MrzsJb
         ubP0mnqUVpjbxahUPKbPu5mWivtODl82Os3sJhxS5TdQJzUExA4JD1LjR0c9R9TcQjNA
         ZY0FiG9yx55iuQMIQgkGgwj06/FvXMeAoycMe8+Sq+sZePzu2EAxuo9IsgtfHd903hvf
         i9r1GOyrmtOTHIi32tUHbCKUjUk5xWwdEfSovVvx5RpokY7W/CBTpC3vK/InhpI44+Ov
         9pSC2g3pbZGGyz4147yvSEdzHc9LyL4r7p4oJZ7wPMreHRlLrp8jLL82oneJYMKIjDUD
         aKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792683596; x=1793288396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9PRBt6CU99Tgp/PmrNNizxfLM+x8gsCayxEXcNPrw6c=;
        b=GTBoIg5fE69RvKv36JrIs4ul5GFGnNUGS4Uf9TAZzOqSQRFiekxWVxsh+BcCeGa0BX
         NiT4aBSv59oDnlrKzDiUHYEQG9/qkFEmyfhByK/0KssMQUDwPlXb2TOWF7zjL2tq4GjV
         k9DYcsoAKkJbTGkZfkeSZMES/wUkTMyMMbNuZC0oEpfb0clsuobOwy98v9wAN6F05XaJ
         s91VIq5HdPIqI2fEnRhF1qhVpY8lQo7lrG+5NpVtdULZ068SwipRiVQD0N070mILNY2f
         0sFe9m78kjAZIayl87fyJL8TGKfJHFi+onb64St9vhZdfbGrWHg7sHgSixv8xnXDbf/J
         WI9Q==
X-Forwarded-Encrypted: i=1; AKwUvBw3QdQ5d6+Pk0o3ZuVgTPMQCWxwTtVrC9H5kUnIhF12ynV+cwYBebrXsOuHISvuHmMDXFdbjASvvks=@vger.kernel.org
X-Gm-Message-State: AFq9FYIxVKG8atgUTseMKwoxIx+90c4eIxmriMiqXqoqkE2p2RHFT+rl
	QoaipBAsFiaXD6e4xYGupBfzRxle9IXO3lrP+0zF+R0tWHYMXp2tdfG8
X-Gm-Gg: AYBFou2rJ5vcdyc23NOv21X7LpPPSkjc/Thl5ysVLIYk23FLenzNgw4tVArbrH1QK4Z
	21Rsn5d/uF+tkWxF4UfqzexdYFhJwggPHGG5vNCl287zWjEVyeuPm9PZljsya5NCyAhA7uNTn91
	26xax7GE4ruu9pFogCPs4Nd/SEQn8lRSYK3MUr9rpVi7OnP6VVi0sq2lG1oO40BMEvvkcQwIZkO
	CTZyZ+V61VPUeLqLfpWKf0Xk1KMtw9G3RAdHrbu8iddVGmNKVanuVOiOxySbUtI8CkxQ5TxQdiz
	hk9LFcqxeWsniRd25jubWytIwj8CEHbPmeRwpsLg3e5nfGxKd+J+y8FbKyBtyR/Bm1gxCoNwvnZ
	oOHnKvNaZ3+Kfc/EPdX8jctn+Em2EpKUQnZhVOVld/+40h5NSwTTnYsAl3g7lmk+tRucodM12xO
	tCfXzE9hG7VkLO4jhnXQNJSrWYikFt7xzDXNYYazbrx/J0FqcHlT/mUDrOyUIgYQmXFOk4WunLk
	xcJBMq265pVCGfJzORqtnqAf392NqN2O7IvCa9iqrv79oxvYIXGrhbngHgNvJ4nhps38Ehr0xV7
	gepnYvXaVR7hMDvwTAu0nJAynTUYmL6SpPRMdF68SRJvXBBEztbHi2uJxMA=
X-Received: by 2002:a05:620a:170e:b0:93e:a8c5:132f with SMTP id af79cd13be357-93f57f70346mr956171785a.29.1792683596172;
        Thu, 22 Oct 2026 08:39:56 -0700 (PDT)
Received: from CW-KDG4DXVLYF-L.hsd1.mi.comcast.net ([2601:400:8100:2e40:55f:d026:b9b8:679d])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56c6f15asm538665685a.6.2026.10.22.08.39.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 08:39:55 -0700 (PDT)
From: Jaehee Park <jaehee3park@gmail.com>
To: ardb@kernel.org
Cc: sebastien@wenske.fr,
	ilias.apalodimas@linaro.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/efi: Drop stale INITRD table entry on kexec boot
Date: Thu, 22 Oct 2026 11:39:54 -0400
Message-ID: <20261022153954.51577-1-jaehee3park@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261012133712.618913-1-sebastien@wenske.fr>
References: <20261012133712.618913-1-sebastien@wenske.fr>
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

From: Jaehee Park <jpark@coreweave.com>

The EFI stub allocates the INITRD configuration table in EFI_LOADER_DATA
memory. That memory can be reused after boot, but the configuration table
entry pointing to it survives kexec.

When a kexec'd kernel consumes the stale entry, efi_config_parse_tables()
clears the base and size fields at the old table address. If the new
initramfs occupies that memory, this overwrites 16 bytes of compressed
data and prevents the capture kernel from unpacking its initramfs.

Invalidate the INITRD entry when reusing the EFI configuration tables on
x86. Kexec supplies the new initrd through boot_params, so the capture
kernel does not need the old table.

Fixes: 6e62d1c6f2c7 ("efi: Wipe INITRD config table from memory after consumption")
Cc: stable@vger.kernel.org
Signed-off-by: Jaehee Park <jpark@coreweave.com>
---
Hi Ard, Sebastien,

I independently diagnosed and locally fixed this issue on October 6
while debugging kdump on an x86_64 L40S system. I was preparing to submit
my fix after internal review and found your October 12 proposal.

In my case, the stale INITRD table address overlapped the capture
initramfs. The capture kernel reported:

  Initramfs unpacking failed: ZSTD-compressed data is corrupt
  Failed to execute /init (error -2)
  Kernel panic - not syncing: No working init found.

My local fix invalidates the inherited INITRD entry in efi_reuse_config()
instead of changing the stub allocation. With that fix, the capture
initramfs checksum remained unchanged through successful unpacking and
kdump saved a crash dump.

The tested version also removed the data->smbios early return. I have
left that change out of this submission to keep the initial patch small.
This reduced version has not been boot-tested separately. It retains
the existing SMBIOS guard, so it does not cover SMBIOS3-only systems.
Would you prefer handling that guard as part of this fix?

Would invalidating the inherited entry also be useful when kexec boots
from a kernel whose stub allocated the table in EFI_LOADER_DATA? The
allocation change appears to address the lifetime at its source, while
this change prevents the incoming x86 kernel from consuming a stale
entry created by an older kernel.

I have not tested the ACPI reclaim patch, so I am not offering a
Tested-by for that patch.

Thanks,
Jaehee

 arch/x86/platform/efi/quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -615,6 +615,13 @@
 		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
 			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
 
+		/*
+		 * The EFI stub allocated this table in loader data, which may
+		 * have been reused. Kexec passes its initrd in boot_params.
+		 */
+		if (!efi_guidcmp(guid, LINUX_EFI_INITRD_MEDIA_GUID))
+			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
+
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);

base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
-- 
2.54.0
