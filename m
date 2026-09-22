Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C113CE4BE;
	Tue, 22 Sep 2026 04:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050760; cv=none; b=OrFWBWPK6+yfFhg1wlz+qG3+K3k4f9GTyG67Kx0qbIkQlws7kN3EOL2DGTgWA95sLAACenhPkoajx7L/lU861x1wTt7YVeaKZ8a/9R0zFysK1wkmq71uyuZnHU/hkjunkHV6Eu6X1Rb8af0x1/VAmlHt4d/Fd7nb/fEroEOxnW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050760; c=relaxed/simple;
	bh=CFUjfWW/pDRAB45ZPOTLMOkYRqsV9MvW8Ya0iftlsh4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jMzt7CXjjF2qMrNSYsOuJE7TKkMuwi4v1ueG8vkgG7bUIFpxl0lD7wTfr8amHE+4jkjiRuIBuXvFjTdkynv2sXWJQULhYDa+LcAbz1TmclAWjLPXUmE20BMUtnkVO+Ni4dkCm6hL3/yI1vq/INIwLVfJzAgTORdY4SIB4fXWdYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9TK1a5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9TK1a5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84161F00893;
	Tue, 22 Sep 2026 04:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050758;
	bh=CFUjfWW/pDRAB45ZPOTLMOkYRqsV9MvW8Ya0iftlsh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A9TK1a5YzUWGYSTQvvf9KGUghwtbj8wOjMaM5Bl+fLvfFzQ4EFM6CaBOIX6Rg0RY4
	 66qmp6KLIm5DZQMTJPO21zraA7UaHca1Akg1SaA6LE+1BK44hKzNTHQtZZUghCC9gP
	 FwBsVMznVAAlfYMkK5IFKOa6DqP7/01hmIQGLORaOfrpaL45aKC/cN1IFNnE4uwR+r
	 cuFRlPBNfZzVNCpdrFpLMFOBBkWiLwq67Q3BSP5xnp96qcGbZCAspgdUWFququqvnF
	 uC5Aj8sb5cT1L05VCKITCqYzkx1e3NfbY72JS8j0tNO0GNBeB600clVwoJXtIprtxc
	 a5n4vjOQintkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] memblock: rename KHO_SCRATCH to KHO_NOPRSRV
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jonathan Corbet" <corbet@lwn.net>, "Rob Herring" <robh@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Borislav
 Petkov" <bp@alien8.de>, "Suren Baghdasaryan" <surenb@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Saravana Kannan" <saravanak@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, "David Hildenbrand" <david@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan
 He" <baoquan.he@linux.dev>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: robh@kernel.org, kexec@lists.infradead.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, x86@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260922041321.233986-3-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-3-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:19:16 +0000
Message-Id: <20260922041916.A84161F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> The term "KHO scratch" is vague. It does not accurately describe what
> the memory is for. Generally, scratch is for things that don't contain
> anything useful. This is not true.
>=20
> For memblock, KHO_SCRATCH is the _only_ useful memory during a KHO boot.
> It is memory passed by the previous kernel that is guaranteed to have no
> preserved pages, and so is the only thing safe to allocate from early in
> boot.
>=20
> In addition, KHO now has the ability to discover other "scratch" areas.
> These aren't directly passed by the previous kernel. Instead, they are
> found by searching the KHO preserved memory map.
>=20
> Memblock does not care about the difference between the two. From
> memblock's perspective, both are memory areas with no preservations and
> so they are safe to allocate from before KHO fully initializes.
>=20
> Rename MEMBLOCK_KHO_SCRATCH to MEMBLOCK_KHO_NOPRSRV. This name clearly
> shows what the memory is for from memblock's perspective. Update
> memblock functions and comments that refer to scratch to use noprsrv.
>=20
> There are no functional changes apart from the flag name change in
> debugfs.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D2

