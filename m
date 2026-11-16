Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839629;
	b=sHffb3ogqUn77jkpKVr/ZjxEZekeoQBJQRA323q/2KfTIqUy5bZGTe1TsZ+HdZ7jKsin
	 Khc5V6cJKA1oaDSdCPE/g/zKcjv0HIp9MmGPbqLeh3PkuPU8xKw4E9QdwUYO6TXDqM3MJ
	 vJ6YykeY9ceS9VkuC3pBgFZYCxRBNcQJaf+JkCBlx//+m8xrBKyDanQOuoOiBajkyeWvb
	 UBhYDGEk1y1DwTAGOOVJftFu1wDDbSbIiloQdKZRFuRm9Nk7ylSyBiZYeO8Q6CRthFHaV
	 giHom8GtAZDQwti75biLQe40D1Jh1uMWJ99C9IKieA+p9VfaiqokqFdcpOKaScfkiCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839629;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z0CHo3OgZpSOH78GpElRuXnPAH7Bfx9AyeGxFJOb2UI=;
	b=fs62Eu3f7+c6tSrzSj3yLygLShSqPjBhEnCvOC1DCCg1uISsfy5wnX6c9G5/GmKX5HnH
	 ArGaERp8x7Qho89vMRCBlKkQWhqQSBWRKh/bmxLIK4pVNDiH/mOI97KnFKTX1S+96Fx+o
	 oDf359Dn0aCI5HM+KsORjnErhK/8aRASNEBuPxx59S5EBe9qZ1oz0Q/QmwvmPqNtgwen4
	 7NkD73eM/v5QOyjC4RVz3CnNw5Eqfq1sbFuz8mzcAae4WArYnVCr+lKHsnJw4e4SFstCF
	 BcXCrVJRMHcmhB9PW9/30UQNQySgKZ5xLAp8xt/J38XuQNWH+X9jJfpqwPxkaE62UTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kAQQ0d3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC368606A32F
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAQQ0d3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666361F000D2;
	Mon, 16 Nov 2026 14:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794839628;
	bh=Z0CHo3OgZpSOH78GpElRuXnPAH7Bfx9AyeGxFJOb2UI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kAQQ0d3/GyV5mOsDD5sosUyOXg3KZXRciYUKaGNDIwRJGiNRFE2xjnIxiT652pcfM
	 HsOzR6P33pvxFSjTdBBaXlp3SDi5Fsax529ESj2m/B2b97/4nA9WkPpg6IDg+tdEHv
	 x2es5p8DkZf61XgYfQExzpFquKNs9Tgm+kCNezGdKc7VpSuqbnj2sCePc0XbA0iIlv
	 yoSCuL/P7xXTm82Q691HJg/pWrgdSNHaz8BMt3/QB1JgJdx4/TaRyaZlOXy2wSzmw8
	 b9BwPczasCzlrTyXMKT5X5MMAyEm5o9ztw0vEg8ZrtFM3KYlY5Pawu7ihVhmssVius
	 hNtR0qf5qLeHQ==
Message-ID: <sashiko-outbox-217173@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/15] efi/zboot: arm64: Add missing barrier after
 cache maintenance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261116142618.1687025-18-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-18-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:33:47 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] efi/zboot: arm64: missing Fixes trailer on
  efi_cache_sync_image() fix
--

commit 05b2747c96f7a33b4d57118d40c0532c9c8babee
Author: Ard Biesheuvel <ardb@kernel.org>

> efi/zboot: arm64: Add missing barrier after cache maintenance
>=20
> Prevent the I-cache from fetching stale data by issuing a barrier after
> the data cache maintenance completes but before performing the I-cache
> maintenance.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

[Severity: Low]
efi_cache_sync_image() was introduced without this barrier in commit
d9ffe524a538 ("efi/arm64: libstub: Split off kernel image relocation for
builtin stub").  Should this include a Fixes: tag such as:

  Fixes: d9ffe524a538 ("efi/arm64: libstub: Split off kernel image relocati=
on for builtin stub")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116142618.1687=
025-17-ardb+git@google.com?part=3D1
