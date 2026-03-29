Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90795264A97
	for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774806927; cv=none; b=n1fLyN6CDkL9vF3Y/76m58E/T1QhA2BNX+vNtMbddzWH4fItUAzp1Ga/LEhYEQFPyvTLPqE/67XgYcEtfph/xGq8u1asJbFAv12ZOV1piUckxTnwYtxWs/wwfcX65Z5cwBvlq4dRmrd8aZUcRhAf6TINudzRaEl5ChYZSVtwDt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774806927; c=relaxed/simple;
	bh=UBWQH1pqb31aIAq/6OcggWSs3frKEtuJ3nEvyubtDyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhC8nT6/fISk/QKBJ1sqVqHTv8D8h5u/SAzzfy2r71Cwi4ilohVveVWAi7Tahvj3P3QWa4Cj1PQlH1PB9G8D7GOtD5NgPEHjhn5zImx5/6gLr/7LR2gwl8SOBgzTk32YJbShy8gWiasKU2OfzB24H6oyHys6UOJ+XzXBacWEKYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=p38bPscG; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="p38bPscG"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cfc497a604so521868585a.3
        for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 10:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774806925; x=1775411725; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ap9dPuw0mQr3chOD7n0lkw4KTbjyl1V2xyuJ5AjqmVI=;
        b=p38bPscGV28eQkbHfQC0f8liYNAaLiou80JaQsBxLD2xtFvQ6Jh2ARwpK9VcE4xrQu
         2IUWs0eDYbXC7shN+Ho9CydZLvc7MXxOSNwEjuwqr45Noa6r9+HpmDtgZTjk5o6GZ7wZ
         ls3LXhSlXYNIBBak3J6ODbC33gI3fM/KUuYM6KUsTqEQZ56mP4C9oIamBYaTAC0dfCY0
         V+rIh4Of00ZZO19wK28MR5mO35BmR0zgq8uXQWgbqXJRZLOBhUCFaw3u4TVozfrJYO7l
         fmEP9DvpA5vncWw/40WeQvMgNnEuwoMgz6CjVdW5GiGMvty4orhHFCv0/vZvEP+yJTtj
         1jYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774806925; x=1775411725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ap9dPuw0mQr3chOD7n0lkw4KTbjyl1V2xyuJ5AjqmVI=;
        b=hlBUuqeE5Dk7AJvvC3sc/8PIoHeZeAk7H7X5yZSg0egH4eLZs7ZJes9OLhQYZkH9LI
         YKrGLQx8Kyx41zmtCKUwmvAi1QlzVLMLw3GSdYL5KV51VxjJqCFP2kRwNFN1Bm3aShzw
         gWEYq1RaKxPYkblbHo7pXDAgn1vCBkvMtSgoZY3UwDajlgR+VRx9K2W1cTgY/tQdilqv
         VVyC43MOU3JXrHA4EoQA70YtvRfIwMFn1a5RVpi53/UDx0vsPPP0R2/ohydJfdSET/7R
         Miiqif23NpwWtBefcts3mOY2eelfpr6zHTuzHMNx6Rv3jA8FVsv0ElgDR/MgrVZ/7VY2
         6e8g==
X-Gm-Message-State: AOJu0Yw+D+5xlpUIA4wVy/DnjvpRyiFHMHLrIVYzlazugmUra9k2xCCM
	Bk4+xoXamSXN6xKLsqiM9BjMMhBf95yz5dV8btJdM+rxJcakjJMfdXlAb3uvkSwF398=
X-Gm-Gg: ATEYQzxoKuJXPK8Hs6Lt9ZawrAIJ/AAU186Ai2oSjbxjxnMn7WNvot1ljTwQ3zATHJQ
	9s48TYWcGfdyW6Z3qjln0i2wM85hP82ppgfJN6Er2MdXCHJWQX11pNedTHhi2IdB7GzAy+/EdAa
	eD80Jv8A/ii81W1K3gPrBNGVF47FRvrIsGftvfUIqbQutFxrOv5q4mR4fAOVjH0z0tGEUJCMlp4
	V+TaMF3XWFwTr8VlMABGNorexNzy9TCrGBmLj5gfA7D9CuYyhj5qnBCU44c1W5Mt4xgPOkg/C/s
	8803lSYcdcKXc0G0cL1pqm/8zy38gxd/3BUR8Dn5wydht7naKo1zoHyIYGPcfuaZFTOMvveuq7O
	7O8GoDnN+JZzWitKXyeF7DmqkC3uIOBJuiaUZSE+HKSitz0hlAcmmRg89uITj6J5ML0M2hAGG/a
	Nd5y3xPiN/0ahX2MQqiiLfkQLBWi2kUEPXIvYBTrQEf299clwYaRHukvSdQHthEf6EZ+OaPCuas
	+O7a87rZs94KyDaDA==
X-Received: by 2002:a05:620a:29cb:b0:8cd:b90f:fc14 with SMTP id af79cd13be357-8d01c7e4b6dmr1256165885a.61.1774806925541;
        Sun, 29 Mar 2026 10:55:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-68-72.washdc.fios.verizon.net. [173.79.68.72])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d027f0e687sm470620385a.18.2026.03.29.10.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 10:55:24 -0700 (PDT)
Date: Sun, 29 Mar 2026 13:55:22 -0400
From: Gregory Price <gourry@gourry.net>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH 0/5] x86/efi: Re-enable memory attributes table for kexec
Message-ID: <aclnisM4_DGNS2U0@gourry-fedora-PF4VCD3F>
References: <20260326132655.1733873-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>

On Thu, Mar 26, 2026 at 02:26:56PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The EFI memory attributes table augments the EFI memory map, and
> provides permission attributes for all runtime code and data regions
> that are otherwise mapped read-write-execute in their entirety.
> 
> Currently, this table is disregarded when doing kexec boot on x86, for
> two reasons:
> - the boot services data region that holds the table is not reserved
>   correctly, and may contain garbage at kexec time
> - a misguided sanity check on the size of the table is likely to trigger
>   on kexec, as the EFI memory map has been trimmed down by that time.
> 
> Fix both issues, so that the EFI memory attributes table can be taken
> into account again at kexec time. Note that this requires that the call
> to efi_memattr_init() is moved to a later point for x86.
> 

I appreciate this fixup, I'll try to give it a test in some known host
configuration switch scenarios I know don't work across multiple kexecs
and see if it is an improvement.

~Gregory

> Cc: Dave Young <dyoung@redhat.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Jiri Slaby <jirislaby@kernel.org>
> Cc: Breno Leitao <leitao@debian.org>
> 
> Ard Biesheuvel (5):
>   efi/memattr: Fix thinko in table size sanity check
>   x86/efi: Gather initial memory reservation and table handling logic
>   x86/efi: Defer the call to efi_memattr_init()
>   efi: Use efi_mem_reserve() to reserve the memory attribute table
>   x86/efi: Drop kexec quirk for the EFI memory attributes table
> 
>  arch/x86/include/asm/efi.h     |  5 ++---
>  arch/x86/kernel/setup.c        | 11 ++---------
>  arch/x86/platform/efi/efi.c    | 15 +++++++++++++++
>  arch/x86/platform/efi/quirks.c |  4 ----
>  drivers/firmware/efi/efi.c     |  2 +-
>  drivers/firmware/efi/memattr.c | 17 ++++++++++-------
>  6 files changed, 30 insertions(+), 24 deletions(-)
> 
> 
> base-commit: 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 
