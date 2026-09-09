Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE9E3E1228;
	Wed,  9 Sep 2026 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959614; cv=none; b=tQg+4DGDLmF1NlqxlFvRpIOAzx5esb1Zu7MhAtfvPqTtk4uin4QvPCC4nNImYnNX688MRir9Ohi7R+DGZVxv2wzG+30xiDBtYBZ392KTQKYWue4ToiTvn35FeOz5FUxJM2V/HpsZ/qno7lgin/FkQOIQ+RGOrwYzy1WLDbMJnF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959614; c=relaxed/simple;
	bh=IZj7gcoR1BSM5qRU6zyoL1d1abYxfkHpfCAN9EDmS1M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lMVoML4xVFhr5+uW6tILwHOiHht6BXEyQO1Xe8TjRMZgvn1nQWoQ67vmv9Z2YnGS6sbgW3VCTrn/UPrpswI0NHfLGkDgQNvSndnZLHYbpsZNhGsVXwI+fZcNS6/rKEWKd/ssLBhcC6nn0HCDHS8go09QJhx4JuO5nWakLD7G1Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1/4Stf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1/4Stf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BECD1F00A3A;
	Wed,  9 Sep 2026 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959613;
	bh=IZj7gcoR1BSM5qRU6zyoL1d1abYxfkHpfCAN9EDmS1M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m1/4Stf0ONAeUDQwpGd2ObDI4Y1eUAi/bIJeo3Kg/A3Q4m++iPAtNGiq119atWnZi
	 /1Qj8UCIt68EW/K8SkdnNb2muOzmu8IfBBZL4/DN4hb53pE4PI0oomqX+wm/Mt8q+M
	 UYBAkF2jGPLZCEGNzHB5LJxRE7hwUQ4jmmtfEqQ8Wt28UK4W6myJBSi6sfNOPWWx6Q
	 /iTvGzpidk91r6b78Ipmjhxg3nx52Y2hBdHDVR3sAA9sFUCqHA8PAM6LOKRQ6JBB8z
	 Pi2OrAlsfgMSBia74jxXsVq2C4ZLCvRj8Vr0VhyJILFcI6NHxdYTmrmeiisqi5Xe0F
	 +LS5tDzC2tsjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Michal Hocko" <mhocko@suse.com>, "Zi Yan" <ziy@nvidia.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Mike
 Rapoport" <rppt@kernel.org>, kas@kernel.org, "Suren Baghdasaryan" <surenb@google.com>, x86@kernel.org, "Vlastimil
 Babka" <vbabka@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Breno Leitao" <leitao@debian.org>
Cc: rmikey@meta.com, linux-kernel@vger.kernel.org, riel@surriel.com, harry@kernel.org, linux-efi@vger.kernel.org, kernel-team@meta.com, kexec@lists.infradead.org, linux-mm@kvack.org
In-Reply-To: <20260909-hwpoison-kho-v4-1-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-1-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:13:30 +0000
Message-Id: <20260909131331.1BECD1F00A3A@smtp.kernel.org>
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
> The Kconfig symbol has no prompt. There is nothing for a user to decide,
> so it is on wherever it can be, and it only costs 64K per TiB of RAM on
> a kernel that already has the EFI stub and MEMORY_FAILURE. It is
> restricted to 64BIT because the unit arithmetic would need div_u64() on
> 32-bit, and there is no 32-bit EFI configuration with MEMORY_FAILURE to
> test that on.
>=20
> This is a similar approach as used as unaccepted memory.
>=20
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D1

