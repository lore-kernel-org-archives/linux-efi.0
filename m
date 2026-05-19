Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5DC369D6B;
	Tue, 19 May 2026 10:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779187495; cv=none; b=UFkoJL3jcHXGcPcIlEguPhzmkj8h0VHctkALiHm/Jg7ueJMBUlG2t10UuOEuQ12IZCXHETx8UYvcB26SS06OqtDRFKP39CftEv4HnOC+cSu9NKiro8Kp9+zEz0uR8P69rveIc0yTDxhMlvX6SIwCTEk+2To7/noXX9rP5ozHduM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779187495; c=relaxed/simple;
	bh=bweqqNVEQlCxrPPMlPmHCilEJnXZTQrMsH9ukPx3AOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZkE3ei2uJQW8LXo+OEIN5wo8Y+Yi/HXTUc/hfhNK1Gkca7dxlCfqRXIgeab5J3F6pyE3XR7AxF/TxhBbwzt+QWApfJCfzf+ROe7qOv5Wj9CK6GsaN44/AoN5eVB+IskG14uD4W1bCQovgqk4sfOSV4Zgqli2sChFf24ZegRNQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhGWnkIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhGWnkIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95182C2BCB3;
	Tue, 19 May 2026 10:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779187495;
	bh=bweqqNVEQlCxrPPMlPmHCilEJnXZTQrMsH9ukPx3AOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VhGWnkIJe4A//Uour88grVAKECdhf5mTokRs0OQgbpOPID+Lck+YdsR96hqzAyC6s
	 GIxDBO0lUsXWeJk1mh7sVQY36lxcgOjEBpRbEVXawXNTYKFZDZ7KQaSlxgvQ12pLsz
	 xxvTjQq7jTA/SIonWf6CBn6Lx7s9xd3YoLSRVFdJxP+Nt3Fh+RthGFbdak6IvZtv+U
	 IytnifPxpQcABQWUGhnWT2PsQxxIeuNihFR6NdKjHGiQnY6cCqG1huJyu6AdYmGIoE
	 42/C54Ah4sR/VBjlpcDdA8Zvg22FBEtZyIJ8YaPF8od8bxGn480iO1rFT7FOzTdmfW
	 k9fgOkOla/T1w==
Date: Tue, 19 May 2026 11:44:50 +0100
From: Will Deacon <will@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@kernel.org>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64/mm: Rename ptdesc_t
Message-ID: <agw_Ih69WYh7NDWZ@willie-the-truck>
References: <20260430034933.541634-1-anshuman.khandual@arm.com>
 <afMKEgJGWZpZjZub@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afMKEgJGWZpZjZub@kernel.org>

On Thu, Apr 30, 2026 at 09:51:46AM +0200, Mike Rapoport wrote:
> Hi Anshuman,
> 
> On Thu, Apr 30, 2026 at 04:49:33AM +0100, Anshuman Khandual wrote:
> > ptdesc_t sounds very similar to the core MM struct ptdesc which is actually
> > the memory descriptor for page table allocations. Hence rename this typedef
> > element as pxxval_t instead for better clarity and separation.
> 
> Maybe we should keep the "pt" prefix and make it "ptval_t"?

Yeah, the 'pxx' prefix really hurts my eyes. Please use something else!

Will
