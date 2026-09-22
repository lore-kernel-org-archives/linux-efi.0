Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F58A3C8737;
	Tue, 22 Sep 2026 04:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050878; cv=none; b=BjP6Dws+TGez8li8MElQZL2AwqEtjT6Og6sA+vh6LcJeqE2BR5iX/ISh/UfEULlGGKR18jx6bG3EvbWIZVfmswifh9jGUkfAq8MSSunTi9CAwNEjtqSGCi2hF08ye93C6s7i4FeWoIIQiqBFVV7M4lN5k/eSTitdkTKoKpnhp24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050878; c=relaxed/simple;
	bh=Q1W9xFoCuwZUjrX1fXkCIP7Uhyo9jgTjhsWMFg7PkY0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DMdDqNqBL5CseoBZ26jvdDiZn0i36mZ2EUfBiae1y6HGn/VcplIJO9wQX1hrkCAvgTPpuL11zT8lTB/CdCo8/jENpiSqmS0SSbPjUNdzsoB9GDHKxgyy0QTeLBQc/gw0drUrRnv/5VlbPQ3grYSlvVMUdlhcUQkxRftfiUHDzGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEuQS0Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEuQS0Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F10C1F000FF;
	Tue, 22 Sep 2026 04:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050877;
	bh=Q1W9xFoCuwZUjrX1fXkCIP7Uhyo9jgTjhsWMFg7PkY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CEuQS0Q7o4ut1GNVSswUL2EiY8XWOZD7AYtoTdLN6QalDPwf1r3kp+JPhzDMHV1Ca
	 +1grgSCuJ3ouBvTHSvpgQRe9kShQ8HW4agMTW8J2kQWFybDH5qhBgBGVqFFW8ZHLLJ
	 ZQIqhJcQshc/Ty+POHhm13ldPisTnzR508Evf5pCTNeCdIvlwrVO+2RPjnOp0VRrz6
	 EB/vuxDHTkLyDTLxx43k09cZltZYpYYyLjmYkjX/TbMfleM3Yky/sXsYDPhPL+Vbvm
	 LfbXEi3Cu//m2sRWOH9JkwJkKmsl/SEjRQeGxXkYdYcIBWihbFAvgUr5pERL3PzU9J
	 CtAsdd61WMFpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
Reply-To: sashiko-reviews@lists.linux.dev
To: "H. Peter Anvin" <hpa@zytor.com>, "Saravana Kannan" <saravanak@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Arnd Bergmann" <arnd@arndb.de>, "Baoquan
 He" <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Rob Herring" <robh@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Alexander Graf" <graf@amazon.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Borislav
 Petkov" <bp@alien8.de>
Cc: kexec@lists.infradead.org, devicetree@vger.kernel.org, linux-arch@vger.kernel.org, conor+dt@kernel.org, linux-doc@vger.kernel.org, robh@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260922041321.233986-2-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-2-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:21:15 +0000
Message-Id: <20260922042115.8F10C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> This config is only a proxy for CONFIG_KEXEC_HANDOVER. It is only
> enabled by KHO. No point in the indirection. Use CONFIG_KEXEC_HANDOVER
> directly.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D1

