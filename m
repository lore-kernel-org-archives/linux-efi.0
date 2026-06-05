Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DB385506;
	Fri,  5 Jun 2026 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780677793; cv=none; b=LuHLk2kInyMOlAaxnKyQOanWRcvnZG0rGa3ptrPEL/75QoouF32jfTDMAhLqcn+TvLnqudRXF1k4ZHdgQ8C3InldJYHvTMMC874GZGewRT24Ij9NNTwqsEjrINXSRCC9c2sjFL3TSlGWedZghWONfWgDGGquFjUUAKLcrth37WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780677793; c=relaxed/simple;
	bh=RVUY7GdG7fcRwxQmpzciZiBkVfFvyx8FPSUAuSB6G8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f02vPs8Ym3PLzAumcRqYMXRfqDbJkKjMT6Vum7o3wzPdqmChq1XmFWZwMe54i/ZyV9hvBrLNxOB4VpA834CCC9Hou88AsUsi3vZXpYNKZdkNg+Sy5nvqoqP8dIIARfXoDN+FFLEj8IPvbxNJ8mS/UvMYnnqwtjYYEkMDPOsNeHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyD8D3Vp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyD8D3Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAB91F00893;
	Fri,  5 Jun 2026 16:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780677792;
	bh=X8VbWPhTuC20viLwsnteWZWpqNUIF1WOp0iFWzHYFfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyD8D3VpY5qB8VFGRKknfJ05yppizL8k5Fq5UiMe3uBE7G+Ole500RMzCM4MvWfIm
	 WhFJ4HE8As1C/O3VKy2eLCRFqEjk7Y85TFhRf6XtHLFoi0vWkGqq3C0yJMO8NWOiSK
	 D4yb710jjPlPlSUco8GHZMa2a87QSYaes8s/NZ44Om47YaZ6ev8qB6/74FLHP34PCj
	 bzX+vfkC0x7saWV+xZw7wK/MX9Re1VYD/vo0hsgt72QcGmUmW3DvtbQt4E0FGoJYHt
	 r7yfPVy49AC+dnB8mwHZ994ib84G7HOprQlA+w5rHCGdYDAAQE3GzpJDwqvMv0dnhf
	 u5ROj8RBbDGBA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] arm64/mm: Rename ptdesc_t
Date: Fri,  5 Jun 2026 17:43:02 +0100
Message-ID: <178065627722.2113653.5493772948773143201.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520063417.2363417-1-anshuman.khandual@arm.com>
References: <20260520063417.2363417-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 20 May 2026 07:34:17 +0100, Anshuman Khandual wrote:
> ptdesc_t sounds very similar to the core MM struct ptdesc which is actually
> the memory descriptor for page table allocations. Hence rename this typedef
> element as ptval_t instead for better clarity and separation.
> 
> 

Applied to arm64 (for-next/mm), thanks!

[1/1] arm64/mm: Rename ptdesc_t
      https://git.kernel.org/arm64/c/c34d4d48c4a1

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
