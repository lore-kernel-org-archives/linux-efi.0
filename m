Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026491;
	b=k8GRVkHDXGyLLSmUwQFDCIrr9TJDeh9oPpgoBW3d0WiIMynUcNYNjrp53GIlqS+dZSTY
	 HdEQWbGNVb1QJjtUEkHkjjDJlOPohfSnNT67khWLVKmkzqHmaTjU0zqfowejqj+JumegX
	 U2zudPOvRihXQteYwJ0GwLAQ+dFQMMHOV41n2/lqEUb/dEiXcg326/1+PH22DJMhemVeQ
	 T6pJ+5AZjc4HV8r6EBbvGR8jtTnUfcdcMJsxNIU2GzBDZbZKLd3Ctc5cZ6xQ8iNQxZ0Is
	 HKyYfnMyDiPeJcogpEKJyX85O7AfhzD3qwM5+q5uSQ/MwfgmuDtBjXth4U2RARtWtsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026491;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=trYM+OOlr3uGMfOICLielFnO5HEgmfmWcIIpBYh+vqk=;
	b=OR1RMtNxbOTHUf+Dg+1gb/QZE9qc2YNlloNwo8n2NFUzBBSpFh/5x0RZ7lv+0X0eMWs1
	 gucO3z6NGrwTD/xUjK5xx5bTM4urDEfUqiSoBpvAY76TQc5g+NXO6FOqMsDUhl7lM7p0B
	 qzR1f02YMxSNPnA3qjTuouhk9HeAVMgzZAuz2zqd0APlgkaGSFu9+MTYCw6XWyG7epEFi
	 NNfFJE+gllglWlJM2jj78/lDhd0HiyQ809SQWxkP3S3VtnieJCQoP1KlA/0EKJmU4rCm2
	 v9aeYvvwyEnNODjLzuf9a1c9mgKz27hNzfgpoRch3x/HS1b73+dk6rmWKqiuxGgaeXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GkWQ5uGp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA29606A32C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GkWQ5uGp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0781F000C4;
	Wed, 18 Nov 2026 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795026491;
	bh=trYM+OOlr3uGMfOICLielFnO5HEgmfmWcIIpBYh+vqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GkWQ5uGpiLMJJPmampCqWtbsmDEaijTv18wmVJ5dQIJmkRQVa5bqw2VWmyLYL+mLp
	 Rlljh8/ErSvZHTXf33Jk9cZm0rq+0ATvZMMIqg7o0TdM71QhkVWLmZm8E14W191CDR
	 HZyZWUVvrbqcHFO/ndHOAASfJOZhWkC3DQHooiWgInqLm6a2mWOmHp40cpeONF5jTo
	 GQqhOPxKlpzg5bgPCH+auElCig3g8oz44CUOJn2HKVDa2FJDHHRXwObv3IPyfGKn1X
	 iagt/+AQHA+NYUzS7EtjGCitUUAbG/BLs1mwo9kdJ5EI+fLfnkCi7K3iRa7y2+wAuW
	 GAyPK/KXrL+kg==
Message-ID: <sashiko-outbox-221757@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/19] efi/zboot: arm64: Add missing barrier after
 cache maintenance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261118182105.1633603-22-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
 <20261118182105.1633603-22-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 18:28:10 +0000
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

commit 67b9c92c21821b6c29157da1899e6b84aef3ebfa
Author: Ard Biesheuvel <ardb@kernel.org>

> efi/zboot: arm64: Add missing barrier after cache maintenance
>
> Prevent the I-cache from fetching stale data by issuing a barrier after
> the data cache maintenance completes but before performing the I-cache
> maintenance.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

[Severity: Low]
efi_cache_sync_image() was introduced without this barrier in
d9ffe524a538 ("efi/arm64: libstub: Split off kernel image relocation for
builtin stub").  Should this include:

  Fixes: d9ffe524a538 ("efi/arm64: libstub: Split off kernel image relocati=
on for builtin stub")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118182105.1633=
603-21-ardb+git@google.com?part=3D1
