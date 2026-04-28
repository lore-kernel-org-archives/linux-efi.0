Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2056D3D412D;
	Tue, 28 Apr 2026 08:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364732; cv=none; b=ExXW8HYl8RuBtSlK6ZTTEfj5L7TacYQRshCcq/80PZsOGEQtmSjKn8VZTmt++j2/z1IgtcZfFj0KQ+66ATA+kWuf8F73Pdoybvn/4TcM2UYBYaeQxKLa5s+3JU1yPH+8LTm2aSeXTv16O7R7M8aTiU/pAMKUaAkoBeUlFhGz+SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364732; c=relaxed/simple;
	bh=b0Ns9dA6trQW98sLl1ge42dM0FW0V1lctGFoJtyAB5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4Luehak72+p3tab2n7Rzq80ZBwlXEsVR38YwAePXaD3luzi5737g4Gm7iYKHovXfodFs9tBc6KFkj61allpCly7+id0N6XZquJ4bHwoHmxU82kXjlEn6FhFTAO5NyG6pcdfh5o9a/T4Q01CyrExNTJSZoCs91NquDAYHpBqOrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFpjhuL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFpjhuL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E0FC2BCF4;
	Tue, 28 Apr 2026 08:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777364731;
	bh=b0Ns9dA6trQW98sLl1ge42dM0FW0V1lctGFoJtyAB5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QFpjhuL2TGTGcJsMNnJoYy9bQsLZC5BJ5CEsa/PALhl3KjFuYMVt2aKnqq7Smy3lw
	 IMF3+41CZicHcV2QBlPUSz1uyBj9BBGue/Zi9rmyoxkOF28eeTH0JSIrZmBXEqA+nM
	 m6VvdiQ43+znQ5E6X8IDRxJNUAQewGuBnAVLSVljErM7LE5GvbrJSl3kOmJ3ptNZUL
	 8nA0LVTlgLxLz7ol68WWZjJyJirafRmy8ADHxBIWx955pIpnDFvEqEeBGk7EKiT52S
	 vEync9C1eSzyriFsLi0H5M08t8BXSDWgbu+6GKNbEWxGtSNZVH/BZF32sK3ayPvwlJ
	 Jic3xFMryZXqw==
Date: Tue, 28 Apr 2026 10:25:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v3 04/17] x86/efi: Defer sub-1M check from unmap to free
 stage
Message-ID: <afBu9J_NCsYB4SgA@kernel.org>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-23-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:29PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> As a first step towards moving the free logic to a later stage
> altogether, and only keeping the unmap and the realmode trampoline hack
> during the early stage of freeing the boot service code and data
> regions, move the logic that avoids freeing memory below 1M to the later
> stage.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/platform/efi/quirks.c | 28 +++++++++-----------
>  1 file changed, 12 insertions(+), 16 deletions(-)

-- 
Sincerely yours,
Mike.
