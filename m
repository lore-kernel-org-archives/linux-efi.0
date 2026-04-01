Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45206402443
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 12:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046253; cv=none; b=LWkbQ2chmcHwCkzDnGn/gVL1Pi4dRdgj7E6uZzKQDBBB/FA/ArhGIeSkMmq2guH2dTDTrKp1VAAwsn0+yaMOi3SQebOVQt0AGhggLSY5RDOImMWrQ6tApzO5Y55+4tyKZgWOG17akEJDVqBY3P9i09ghZeJp0kQ7jzCuYdLYlao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046253; c=relaxed/simple;
	bh=Vq83sHeQM3lKtjJXQLWNxKXaNZHPY9RfSEtNN9UDHGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G/Bh0cSmtlNVin1QmoqK5PghecZ0MuBcYEjdvwnwbL/1aZ8PEtOyXjNkZFW5MkIrJaof7SGAar5XuYinyltQTgOZiSMORD6VZv3GD2rkP+4bzLKZkAMSsvDbzKBkH+jJOVd3btAcvNUzYBGliM2RehKHVOAGHdcpgqlDwHrOcCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DMn1k7Zy; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DMn1k7Zy"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4887fbb4dc8so10366885e9.2
        for <linux-efi@vger.kernel.org>; Wed, 01 Apr 2026 05:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046251; x=1775651051; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=raTovvIuA8BXu/kgHuJxIxG7+Jya4C5OKP0v/N62tFM=;
        b=DMn1k7ZyijjLvbnyFiOhY66i7T87IdBZTVz8zbmf/THtwhl7NYQBbGe1HAdvr7cPYx
         Yulf8e4X0rkTgPw/C1YHpQAG6t4j59Jcj9WTISY8FgQ6FbbsHeoSUgL3933eZ4ynwPMA
         xjPytr8eFhvNB3MTNtIf65tIdyfJYiEafr6RC7h6mm7ScULZsNrmgX1UxsmKjfbPA+fA
         owPq8wmDxqq7FxJ0Oy2rFfiGFwmPFsVaXfodbeXoEqE4O2IOhu1oXTAsh/bebeuZXYQM
         3sgVpJmznMDwPpMb8CbsdolZ9BO8U1vlQRnyHEFsygO/Z9D6PVJ/03sfP10G3oY+TIYA
         hXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046251; x=1775651051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raTovvIuA8BXu/kgHuJxIxG7+Jya4C5OKP0v/N62tFM=;
        b=S1MqDjSU8EZZn/5rNzfsJmlzT+/BeiCYVez5fUt28k/FAHCNVcsw8ELv9POxS7ZHbo
         N3T7ogYJbSqMLUA2gDvGyMfAbMAgD8XBL8foi5ycKGQ6E3w0Lwc5trFNXg3ltlVHuhXM
         PdA5lrGGAOJXB0BA/Bw1sbTh1NmKCoTrzEVw1NDWqSk/DLK1MDclicUw9QhpjmAX8pUS
         9EpL0d5MmHwxju/j97hNkdAzoafPVZC2tGTntQwdVDL6Pp9Nke4fp4Ktigy+IPYwRunZ
         zXp81787SJxpEVIb4GmOO/NmerSg4BB5WweLeDYm4Ro8vZxZzfOSUntRgUxnXhiz5JKl
         OUEg==
X-Gm-Message-State: AOJu0YxK8KObnRtFdsHDXtkMk5wOtNZ7OyE6l8JPhX8bYwHaTQ5WzmlY
	9n8xAqmdmXNFHUh9f+bM3GUtdIDofE+MDp2zzWVZZ5K6xyj8ClAz2Mb9d1/wCewOYRTE4rlqXSe
	IZm2xbfXQXw0uMWitb8jd2RK9hhl11HkgOrHxEGYKKfldkRh3qv5v9wv8tPwikPnnb9M+Q5gf6W
	z7qVjeMb7vqu/7a4z4aauiLw/mY6zsiA==
X-Received: from wmok18.prod.google.com ([2002:a05:600c:4792:b0:488:7891:d1bf])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f95:b0:477:a1a2:d829
 with SMTP id 5b1f17b1804b1-4888356754dmr55980545e9.13.1775046250319; Wed, 01
 Apr 2026 05:24:10 -0700 (PDT)
Date: Wed,  1 Apr 2026 14:23:57 +0200
In-Reply-To: <20260401122351.2058145-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260401122351.2058145-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1261; i=ardb@kernel.org;
 h=from:subject; bh=NDK6hD2ARL8meteiG5vAQnRk28SciK+OGjeHBR0xY18=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMsX/zxj3LaXd+2iK3b45EVEv5lX85yfff0dy1TtjQ4f
 EqX89buKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPprWP475lWaBXEZMr8enVb
 3vu9a7P2zd1W+T2KZ0n14WqbsJ9HFRj+6Rk3ps3Kq9qqxsbBxJpQ+eHjaf5TdvuqV7L8f1zv9Oo VKwA=
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260401122351.2058145-12-ardb+git@google.com>
Subject: [PATCH v2 5/5] x86/efi: Drop kexec quirk for the EFI memory
 attributes table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that the EFI memory attributes table is preserved properly, and the
quirk to detect corrupted tables has been updated not to result in false
positives when the number of EFI memory map entries is low compared to
the number of EFI memory attributes table entries, there is no longer a
need to ignore the latter when doing a kexec boot. So drop the
workaround.

This reverts commit

  64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 79f0818131e8..98641c621e6c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -611,10 +611,6 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
 			((efi_config_table_64_t *)p)->table = data->smbios;
 
-		/* Do not bother to play with mem attr table across kexec */
-		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
-			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
-
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);
-- 
2.53.0.1118.gaef5881109-goog

