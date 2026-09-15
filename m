Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878A3B14B2;
	Tue, 15 Sep 2026 13:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477543; cv=none; b=Fth+0EDn79KU1Vw5nHOt3cu/RygMQvg838t1aTq98uEFcUbH0TTfbh8dUJAApxA70jsEkM/C5xxEQH7oqM5hm3LzWlrHia481xowBgmh/rDJQVV6fvAd6Dm1LSbqFGGzmT9faet/ltKgNFKbOdH4pusp99GEIA7iJp/24CYj1MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477543; c=relaxed/simple;
	bh=ordUloR4tkzjSO9c8EIpA4VajsXZhXheq1XH0wJbAg8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SCAkvMWaAbIW7BGCBnOQzYHYhGxTXCKZ3iO0UncVertDeSTwA3sqhW5Q7kduKKErsTsmORNxAC3iX1UO0cWy13hAwjzgBDD1xs3rllwU3Vv2rEC8THjgy6f8npU6GDlc026BlmmejXarQT6IG9ut47KuX5KRUOt1KrtanGtFToc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AaWwXhlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaWwXhlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C919E1F000FF;
	Tue, 15 Sep 2026 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789477542;
	bh=ordUloR4tkzjSO9c8EIpA4VajsXZhXheq1XH0wJbAg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AaWwXhlqxLtAa5qlsWLkRg/bwK7yuKnIL0MYjZ90S+6rgQdy2v7lDv6HG6lkhZtYY
	 23zmI+aO1DaJfwR21QNJYZjFaow5wDJ2UDYtmR+AB7oWsO+95ZAfx5htQPznuHY1Br
	 +8gWOaVLSq3ydNSGBSGAM4yCUoQynNoap33dmuxf97RTtGGFTRGMHtsBgX9xLyDC+n
	 1w02AyhfbIKLqA5b3fN0dTiDi6z7pCjNmRiX8xTSK86Al8POq9LjCHnnF98mSL0jLr
	 8q8VIkJ0yl7nt3TuB7KsNJMkaLxaV94rNmYWVvFE+QcKKO5ZDiZ7hvmzNgS2eBKrGi
	 RvLz2STvXrYeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/9] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Danilo Krummrich" <dakr@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Borislav Petkov" <bp@alien8.de>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Breno
 Leitao" <leitao@debian.org>, kas@kernel.org, "Liam R. Howlett" <liam@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, x86@kernel.org, "Zi Yan" <ziy@nvidia.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "H. Peter Anvin" <hpa@zytor.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Andrew Morton" <akpm@linux-foundation.org>, hannes@cmpxchg.or, shakeel.butt@linux.dev, "Miaohe
 Lin" <linmiaohe@huawei.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, riel@surriel.com, linux-cxl@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, harry@kernel.org, kexec@lists.infradead.org, linux-efi@vger.kernel.org
In-Reply-To: <20260915-hwpoison-kho-v5-2-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-2-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:05:40 +0000
Message-Id: <20260915130540.C919E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> Hardware-poisoned page frames are tracked only in the running kernel's
> data structures, so a kexec loses them and the next kernel doesn't have
> this information, thus, tripping into them again.
>=20
> Add an EFI configuration table to carry that information across kexec.
>=20
> It is a bitmap with one bit per EFI_POISON_UNIT_SIZE (2MiB) of physical
> memory starting at phys_base, modeled on the LINUX_EFI_UNACCEPTED_MEMORY
> table, and it rides the EFI system table to every kernel in the chain.
> Basing the bitmap keeps a machine whose RAM starts high from paying for
> the hole below it.
>=20
> List the table in the x86 efi_tables[] too, so an SME host maps it
> unencrypted like every other EFI table.
>=20
> [ ... ]
>=20
> This is a similar approach as used as unaccepted memory.
>=20
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D2

