Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5AB47D462;
	Tue, 15 Sep 2026 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789479940; cv=none; b=Hp/GpAB9xhqAoznkM4bsImnRu9XcAACB6i0geah8MEtwoCsxnmVQLoxZJBI36XRa4I2tFBrOqVonUZ4Uw0IWZqVy9IwKYXP+QOIbVDlkReeP6vW/4EmYLYtBHWmxE+w9h/GMsJjWBYEXZuyF81EVZcu08mfjM96U4dh2sSa4ql0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789479940; c=relaxed/simple;
	bh=OiVbNpqvcTpST0O0QqLXW+ZXyZ4rqHD9AsZUlFhTaN8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sJhgQbLLhf07wFAFV2bVB06SCCnXZS16PSAa6LQcXCQGFvwhTUVoWqMgzbDQ9ede2uwDIwvUCOAIibwyeTLc9Kac/JYkznD/u3TnpOMzuvum4o7guGK50VjBo93VyeYpZt2SoY4LpuywRrDgcaYlVwqxqxU0/g1RO8RyJwRIvRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hi5BOtIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hi5BOtIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FC91F00899;
	Tue, 15 Sep 2026 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479937;
	bh=OiVbNpqvcTpST0O0QqLXW+ZXyZ4rqHD9AsZUlFhTaN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hi5BOtIEVU4s+3yGSkPz0/SAa3xuZHvLVpvUfNAH5splg6V68ueCIPFYP3/mpMulN
	 u8P69p91iUJ0DvXufSdZIKn2jcj8/nL90UaX8qWkXmwhffYxBPcX8v6xabJdCHM9uS
	 z0APFIvOBx9ALorAcSTdPK39S6JJt/J+ryBC6YOeWFlhtPrN383awNLaA4SMyFizpA
	 wG92L0Er3GzqiyFFLxmr4DbvFLuVKocAtwi+g/N7XmJ66fdv9ER3gV7xBJROmIeGXh
	 yELnMJVm02pPNLmgfAN6ykp/nJhDspGneThMYtTcbY6FFghJT0/8X1s3mAGVJErlu4
	 R0Rnq9hJzvg2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range
 is poisoned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, hannes@cmpxchg.or, "Borislav
 Petkov" <bp@alien8.de>, "Danilo Krummrich" <dakr@kernel.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, x86@kernel.org, kas@kernel.org, "Suren
 Baghdasaryan" <surenb@google.com>, "Zi Yan" <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Rafael
 J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev, "Johannes Weiner" <hannes@cmpxchg.org>, "David
 Hildenbrand" <david@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Breno
 Leitao" <leitao@debian.org>, "Michal Hocko" <mhocko@suse.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ingo
 Molnar" <mingo@redhat.com>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, harry@kernel.org, rmikey@meta.com, kernel-team@meta.com, driver-core@lists.linux.dev, riel@surriel.com
In-Reply-To: <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:45:35 +0000
Message-Id: <20260915134535.C3FC91F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> The bitmap an earlier kernel filled in gets in this one through EFI,
> but nothing reads it back yet.
>=20
> Introduce range_contains_poisoned_memory(), which the page allocator
> will use to ask about a block before handing it out.
>=20
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D6

