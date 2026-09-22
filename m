Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244C3BCD01;
	Tue, 22 Sep 2026 04:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050916; cv=none; b=FTSPs3FFJe++lYVl8H1q65pioxm6T36DL+PSG8zxQD991qRWs0CmXtJHLVMIHnlxcIFqz6fS7N5jyAF02fMU4E2fotqc4PvGMkQaJiTjS8HrKjMHK0LnL3MnM5jJ/qzqBaPitUbvjQ1vVE5SXmcMDtxVGAs5OvkRZvWW3RKp21Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050916; c=relaxed/simple;
	bh=syaZVYvUtgFnasCG/seUwWXzYWSqGpbsEDVlFQfkXQ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UjNh9JdMwRZS97dbiF6RdrZDbqJzWed+FAjZCsRQlwMoIuHkcIkZaQjYYCVjyO2mIwHFhlGVHO4vU0YaHnzmVssh/NpnaIJ4A1wXFH1/E4VGEETImLXT7x+qwLBWacAxohCu6hWOrXuLzk3F20znW40OjbMNulWXXbvAB+Rf02U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Me/fCZ3M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Me/fCZ3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D851F000FF;
	Tue, 22 Sep 2026 04:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050914;
	bh=syaZVYvUtgFnasCG/seUwWXzYWSqGpbsEDVlFQfkXQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Me/fCZ3MkA+e5U5b7deNmL46lRZBivAbchui33mecbxteRUKkj+jf8wzRvO04cu9i
	 EZ8xCRpw3vgbZyON30v6aXiQRUdJiKxepri33w/E2eFJyEVGZfPB16OW2r0qNWWblq
	 Oaa5LwQbUzjU7/+shPeIpqLzgVyqXVy4zfH/Bhfx74HHNvfWT8OI558TpMVhWeik3H
	 SQAzsnkOufbKRZcUm/Dpibq6u6z6g35XOq6hzs8/pEt5uIJpT9s1nytWeUKhBWI94a
	 EmBttiqJC4CSt9N2V7WgO0Jd1pPIbayqwCbuGkFIKACCA11pRoVLg9AGPG6UABCkRv
	 vQrJ/mGlQJu1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] kho: rename KHO scratch to KHO bootmem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Alexander
 Graf" <graf@amazon.com>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Rob Herring" <robh@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Ingo Molnar" <mingo@redhat.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "H.
 Peter Anvin" <hpa@zytor.com>, "Baoquan He" <baoquan.he@linux.dev>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Saravana Kannan" <saravanak@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Borislav Petkov" <bp@alien8.de>
Cc: x86@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-kernel@vger.kernel.org, robh@kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260922041321.233986-4-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-4-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:21:52 +0000
Message-Id: <20260922042152.D1D851F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> The term "KHO scratch" is vague and overloaded.
>=20
> For one, it does not accurately describe what the memory is for. From
> KHO's perspective, it is memory passed by the previous kernel that is
> guaranteed to have no allocations and hence it is safe to allocate from.
>=20
> For another, the term is overloaded. KHO also knows to discover other
> ranges of memory that don't have any preservations and are safe to
> allocate from. This is done by kho_extend_scratch(). These areas, while
> called "scratch", are completely different from the chunk of memory
> passed by the previous kernel for early boot allocations.
>=20
> Rename "KHO scratch" to "KHO boot memory", or "KHO bootmem" in short.
> Update all function names, variable names, comments, and documentation
> to use this.
>=20
> Call the discovered areas "noprsrv", matching what memblock would see
> them as. Rename kho_extend_scratch() to reflect this.
>=20
> This patch largely has no functional changes. The only functional
> changes are renames of debugfs files from "scratch_phys" and
> "scratch_len" to "bootmem_phys" and "bootmem_len" respectively.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D3

