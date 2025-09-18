Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE0713D521;
	Thu, 18 Sep 2025 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758196952; cv=none; b=LKqTeEW3E5sc/OB08ip5Sf81D1ci5g8g7/7Q3/Alxat2v/CUJJdBbRGkCwT+q7wG44X4WCStK7oQoG5C9p7YlflArtzkEGtzjwAZgHisjM83ThCM/SNIn0RkuZevQnwHughn8MdPtoLXp3lIcoQwQricTHiTD9fcgSln7sLMxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758196952; c=relaxed/simple;
	bh=bVeWEJiNP54v9HHCnkHFZfXnvx/rOcUNSBvMjkgyhS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbHUAXW2nwc7LPgl/FBtd8uv7KI9ZgonJ86ABxmVOVSGXWgTc+I2V6fP0obh2loyJ/yvY9SqxDiUuX/s0QzvjxlzAIqHI21Y1JFGS/FmDAuOSeHzmVGaRn2HqvWkXQrQRT9eooq15NhPMHqapLmpxrS2lIr7wAOeF3ipxoE2RCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHdXLWTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHdXLWTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D759C4CEE7;
	Thu, 18 Sep 2025 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758196952;
	bh=bVeWEJiNP54v9HHCnkHFZfXnvx/rOcUNSBvMjkgyhS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EHdXLWTWe81Hr7D8UJ9M7UtdDmsICuUafn2rMYUdF1XX2O1yxvz5e5XyKC/vf8zbM
	 yS+ZDjw1BtgLZJIJXD+e72eMQRISDM5jfWfRakC0NEM8krBbcPMghbkaLfrIxlc+c4
	 MI2BrA3SjJfAyj7CjYvDpubznZn+dwvziJyckuVsXDS3/xp8z51+kWA1PAzk6ySS2+
	 lzDWNr2jCFkrGSxsKuNRRPlDp7UX6LPhzGg9DAMs/zU7GMMVKDkvNjmWkOemRQLAJl
	 /9lVJf/0ki5FYhPdYx270ogPF8/+Zj7lnnYfe9XodLrQTEWCI5MBbUjNzguU9ReVgj
	 etxcHmehnhnWg==
Date: Thu, 18 Sep 2025 13:02:26 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 0/3] arm64/ptdump: Add cmdline 'early_ptdump'
Message-ID: <aMv00p44PyZZv7cH@willie-the-truck>
References: <20250910094623.2356282-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910094623.2356282-1-anshuman.khandual@arm.com>

On Wed, Sep 10, 2025 at 03:16:20PM +0530, Anshuman Khandual wrote:
> Enable early kernel page table dump for debug purpose when required through
> a new kernel command line option 'early_ptdump'. But first this reorganizes
> ptdump_init() separating out the debugfs creation, so that it can be called
> early on in setup_arch(). This also adds kernel dmesg console print support
> for existing pt_dump_seq_[printf|puts]() helpers.
> 
> This series applies on v6.17-rc5
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-efi@vger.kernel.org

I'm really not convinced this is particularly useful and I've certainly
never felt the need to have something like it. If you're debugging really
early page-table issues, why you want to rely on all the ptdump
infrastructure to get logs out?

On the other hand, if people do find this useful, then I think it should
be implemented in the core code rather than done behind its back in the
arch code.

Will
