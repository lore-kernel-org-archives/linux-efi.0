Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E603B3898;
	Mon, 30 Mar 2026 09:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774861248; cv=none; b=es/t8zhjVGlE4SPBodY/rgIBnPSJZgeT2qXqbEG74R+HfN4rVVUNZLzQAG9K4a8Xj5wnXBJmoDGMOw3BNRHKrOtivpGwYqhjrUSbOxifj7SJwjxnYgsIZoC4bYeIUxxhYWTyeFyecbRD7+/l6tCDaGlW7C6/MH2CwJ29/BF/HSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774861248; c=relaxed/simple;
	bh=kryiSL0c5gWoP5Xn33RlQGuB1fDy2r29C8AZwGGNizM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMmMq3bqTtmK1jmbVL+FDFpZYD4SJWE+ZBHLq/jqvQ0Uf5NtxhKMCYw+lPwr09pXzIoD5tFWwNvxFpSBGQLewvOh2mPjj6TWG6LIb0kA6lpG0D7Hwidm+cl+O9JisKVSLGebcZN4kYticFyp4I2krGhikjHrcvJ6oM3KDujHlRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyVV6yho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyVV6yho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BC8C4CEF7;
	Mon, 30 Mar 2026 09:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774861247;
	bh=kryiSL0c5gWoP5Xn33RlQGuB1fDy2r29C8AZwGGNizM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WyVV6yhoGLHl2DGlMtLNk2PLvv1LoFNZHT4upzyLknoqI3XroAjHB9I1ha+vU4mPX
	 jqLByu7cdkfcSBvwjAbgeSA7t1FnsQjdZlrHnf9SNnPEyV8aXCVfzuhI/9ayog85j2
	 ZCfecMUhBhB9NayIQbTF+29vTra1H0L8yHpOy9Fwzj1WruGul10WlXsrznGUH8EUO4
	 yAVoSQA1pK/w43OyYruiDlv+uPCsaxYtmh6p3C7asR9EeKI1wjuzkpsIcL4izJJluW
	 H7vlwohlhoQLLz7U0ZJ9f5WNsHXklzmi3Z/jx+6T/BWbr7v0B1OnwuC2GYBfZcweMT
	 Fa1JpYbf/eG2w==
Message-ID: <b1c93301-c12a-46a6-ba92-53e8f9a28022@kernel.org>
Date: Mon, 30 Mar 2026 11:00:37 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm: move free_reserved_area() to mm/memblock.c
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andreas Larsson <andreas@gaisler.com>, Ard Biesheuvel <ardb@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Brauner <brauner@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Saravana Kannan <saravanak@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Zi Yan <ziy@nvidia.com>,
 devicetree@vger.kernel.org, iommu@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, x86@kernel.org
References: <20260323074836.3653702-1-rppt@kernel.org>
 <20260323074836.3653702-5-rppt@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260323074836.3653702-5-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/23/26 08:48, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> free_reserved_area() is related to memblock as it frees reserved memory
> back to the buddy allocator, similar to what memblock_free_late() does.
> 
> Move free_reserved_area() to mm/memblock.c to prepare for further
> consolidation of the functions that free reserved memory.
> 
> No functional changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

