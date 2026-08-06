Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA9F352C52;
	Thu,  6 Aug 2026 07:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003131; cv=none; b=NW90P+OH07fcjWZXEi459qTECa/BcuGbIO4z1LI1wo3pl/Fz4niBM45ulI4JuSC2euCJLulHOhurf1NXKeV9+kxokpbXD2F4ggPIc+QALUCMcaoZ6AuwH2eIsnVnjgjaDiZoH7XB8iAZ0lgqpYTek1Jr59mvZoeD9Ir4Xx6wloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003131; c=relaxed/simple;
	bh=6Qdw3rPKOE/bqfzieoBLsN+JJCKDj8Yo0JXPMaKeuak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+6OjvjM/2+Th73YXjaE38QMUAUezNRhcYZ7mkQ5FVerWXhIHpN8nF3zOY8A4laU48lAKQSpnLGVzktcJWz62E8jJTJGgewAFXzyXlW+xZ0U0pcZgxmMqO5MxAWlg9rI4/SW6/OqnfKJXwbqU3ZPhDp8ak0FA4toNPHniHycyvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8YD+Krb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8YD+Krb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0881F000E9;
	Thu,  6 Aug 2026 07:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786003130;
	bh=6Qdw3rPKOE/bqfzieoBLsN+JJCKDj8Yo0JXPMaKeuak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J8YD+KrbFok+1fwrI0iVh4vH26ewld4lv4yE4DFBk81pY0lZdIVyTtOduja1KQ1L3
	 BV958JiLuPY/ayW+tVLF8iavvaLcHpcaNd+5HKEnzG/wxP5fw0xcGz5ZrCF96Ga3rQ
	 ckARtxPyCWzm/OG4zer/hsYuw61JO3TxKyA3pb1bv+sVmLiolZQc9VE6T8be16/0Lj
	 pxPY2tkmJr0KqCi8N0/leBGXsiRewNbRPX/Jt8LHaJlHqqSX8Ocp0sZRGKAA/snYwu
	 kWb5phclr88l1FQHh0l1AcAt9lBb+HtlHoWI3czYHgwuZFMhavmOxmga44ZQ7ZyAHq
	 m/0hJeUVeZY+Q==
Date: Thu, 6 Aug 2026 08:58:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v2 00/15] riscv: add Svnapot PTE folding support
Message-ID: <anQ-GfzFl-thu3q8@lucifer>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>

I already commented on you failing to cc- anybody here (!)

I am guessing you did the core bits in response to David's request ([0]), but in
general - if you're changing core mm to suit an arch change, you really need to
send it as an RFC and then it'd make sense to send the core mm changes
separately as an RFC with an explanation as to why you need them.

[0]:https://lore.kernel.org/all/62c418bc-082b-4ae2-a889-f63dd2b7f503@kernel.org/

Thanks, Lorenzo
