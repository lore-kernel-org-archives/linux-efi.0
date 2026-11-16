Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794857495;
	b=31PE3TujDrEVthFWW0PByzUv7vAmeM22fDbggo2tFAqrMapqieGWGmMUyPvcTILglJ9j
	 Umf7Jac/3Rbo02Vi/0ghIe62fDDBGsr0nb+m1U4Oxi6vllfqOne+CgShMorgqL4KdYYS1
	 rSIMwS7AJRg9BOqk1Gh7zGu+w0ezOKTbTG6M8chsizk4GGykMJ9MXpWxvMDt7TwaEzH3E
	 DVqZojT/V5dF9q031FGST+TH6t321zdL6ABEBsVka9KH8kR4cJI8pwWiRmyegGDOqoVqa
	 KqtzHfV+lO/SDAe8jHc8q3RN4WdDMzVtEv2HQ5PsiNWQuOsYLonqfUnzlxleZ1vM5Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794857495;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=lwgT/KrjrpKLxweIoceB8B3882no6dAeURpV4XCqn7g=;
	b=UmufqeatFTTht/TQFYW+D6zYU3ZlutjBVqO6pVnnYr9ieruuGS/Y2e0Ys/vyFZdAgwsX
	 OKy4XPki0XdN9z46WAoVAKCq1TnMBWRujVx+BJqRHiQ6W4PQNGoakQfX7lavwR68TnRc9
	 UlvchAtc6Sl33ctjiv8rNZznEqCxENhVZLHLUgXw+AcLapxVDx/0JQEmeq8D0rVssZySs
	 2WJ3vdnOvnsqXpA1cDAfm1lz0k4GiUayZk6mqrZJ1s9LD72zmMAsg9utxgxLNbFlKMLZN
	 xk2Yszzr24uSQ3IuQeKiyyhr5bj2heMWuB4wIomT/UO9sXCz5+hrbIx5xBWWVVcVbIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iscJSfUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69090606A323;
	Mon, 16 Nov 2026 19:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iscJSfUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092EB1F000C5;
	Mon, 16 Nov 2026 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794857495;
	bh=lwgT/KrjrpKLxweIoceB8B3882no6dAeURpV4XCqn7g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iscJSfUzNMLwCr0GmHc8B1KIlz3tTIkklr8dCTK5HESbKqYa4EcY8O8EfrDHY6Iim
	 rWSwtV8w1osMdTYLAZKmr/Bjjn9rvishPiHuF8CRBa57cvIgsUIwl+S2XGTK6T5wjx
	 cXP01dqhGiszXgEhZ7JdCeRK4quQk71XmBq7YzQVMIFpscH2+JXqW3wAbk53uCRxvr
	 5uNoxHdQFiM8vS3OYbPnXHoB5uahVO4d6oa3kclUED6z6ClhF7cfu8DOZ0rPCUBQwq
	 Rb64e/37mdbzyPH16DA1ssspAllyedtGlVjFnPDANs/E6O6yAeoqkZ7Nma8EC1sQlG
	 OAKVXYK17PMHQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 39357198003A;
	Mon, 16 Nov 2026 14:31:32 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 16 Nov 2026 14:31:32 -0500
X-ME-Sender: <xms:EVr7avBdQVFoEfowz_bCbI5AdAT0mX5c34086tEkESODrdbqV9IQEg>
    <xme:EVr7agVzCehMdtLffyQbJHnXG8DSh4qEPdQYRsxUAX5ou_gjacQCb6W9LKGt6MAzt
    5hRd_pOWxQMaEgqmGscM5MyX7mslg8LAfmZyYh3wplu2GDnvTE7t3me>
X-ME-Proxy-Cause: dmFkZTFvCSGQHIu2yMjqWjpgcdZz154dIWM3uIczS4ecJ9T1Ot9xsnK1FzpDfU7202u8Ud
    q7tiI18YF8mpIMH06FRZlmiB1jFalJ5440vUqFqxj/gg2qhCC5NZSZ62XdMx+f7jVnynWL
    HTCM5imh7D+AWkoosndmN5k7FtUBeF0Eo4Ddl5Lq/Q21QofGB/Ye9ZIwuw6xmRjLOVNytf
    jxQqfomoBdZDQkDoVs2fNuaxqhr9eqOTZtFb9C42AT+UgmAq7VeuYKVKVUp24WCxXrCZCA
    xqhAY3v1ng6ccB6zLwefGZC6yZx3mZXc9BInfEFSzH8SY31iDHCIcio1OKHUDFpq7b6PVD
    g8pNSAMFmuIJkbemCn1MkIDL/LJhxk7hRG0JmMA46RM+wnmhSx0OZe5ZNy89a6qE132frM
    7I1MOm2OdvuVNKL05fA7AA33M7ProFlTF+G/qPfop9/Ac93XU/h9PDXnKxc2GOYRkc6F/+
    DSE9g2XIaog3F0ybFwotpVuxuivvTeiHNikqlFA4IvnBs03FRTvyJ9gmd699qSny7pPIhh
    id3qZPScO+40bcQOTg1c4bkHcEIE4cr3pBQVW7lm9bqkOoko+bVKfXD/GX6E+Gu7jML8Nw
    LvZn4IE9GrQ6FzU6xIDNyhWknd+pRIXDAWiRsMf2OdAP+IT+SGTxTV7gJLxg
X-ME-Proxy: <xmx:FFr7aslYsOJph0XSW_kFMQQ36WrX3X2k7xR0Cdvtcy63Y400LuLnNA>
    <xmx:FFr7ans2CxP6SXmGsHQgLCGmqziYBKMMa7kPqLrYYTX6s9QXCCxL8Q>
    <xmx:FFr7anrP5-GXyz7S3dl4xB-7Ze-tIxT_tkTdoqnv0kXuhhv7cIyI3A>
    <xmx:FFr7atddxEE9RgQaekTFHf2s51GF1m1I7ZVqLOxYIz28nzsmqZ3PMA>
    <xmx:FFr7avlXcCklzkuiFbGTbCcVudYgjHjYNqy-jhU5MzgrKYzv5QaHu0oK>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5EF9FF80093; Mon, 16 Nov 2026 14:31:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 16 Nov 2026 20:31:09 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Message-Id: <3aca714b-9296-4a87-b5e9-636f9f3f7bc8@app.fastmail.com>
In-Reply-To: <179485513561.2274641.9183102461241695856.b4-review@b4>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-24-ardb+git@google.com>
 <179485513561.2274641.9183102461241695856.b4-review@b4>
Subject: Re: [PATCH v3 07/15] efi/libstub: Pass kernel entrypoint down to
 efi_enter_kernel()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 16 Nov 2026, at 19:52, Jason Gunthorpe wrote:
>> Update the EFI stub code shared by arm64 and RISC-V so that the kernel
>> entry point is taken from struct efi_image_info rather than from opaque
>> arithmetic performed on linker symbols.
>> 
>> Notably, this results in EFI zboot to enter via the actual kernel
>> entrypoint rather than byte 0x0 of the loaded image on these
>> architectures. Beyond that, it is mostly a cleanup that will allow
>> special linker exports for global symbols to be dropped in subsequent
>> patches.
>> 
>> ARM is a special case here, as it combines the EFI stub with its legacy
>> decompressor, and so the generic image_info carrying direct references
>> to vmlinux symbols cannot be used there. Instead, it provides an empty
>> struct efi_image_info, which is passed directly to its implementation of
>> efi_enter_kernel(). So on ARM, populate this efi_image_info with the
>> base address that the callee expects.
>
> Does this mean that the EFI stub never sees a decompressed image on
> ARM and jumps into the legacy decompressor?
>

Exactly. x86 used to do the same, but I fixed that a while ago for
other reasons, so there this efi_image_info approach is still feasible
as well.

> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>

Thanks.
