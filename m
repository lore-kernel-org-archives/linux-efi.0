Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AF12580F2;
	Tue, 28 Apr 2026 08:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365655; cv=none; b=nhYO78MlDeVe/LK+L9s5jgWYXG2v5rfIUZA9ok+UhdyTm77I7buPqm8i6icnkizILEb4Fmg6KYadJwv7aNgVT96SX9I9fKSgLXQpUy+jityw5EAKYtMzMH2xdAV64MO1L2uaqOezwJJpOAUfNM3C90l1hQop9n8YZE4nFLa9xiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365655; c=relaxed/simple;
	bh=l15v9GwBq6Tgk+jx/U5WdIZ+E6LJQvJWYPZzgUb+W5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWVEIuytpsXVdeRBpejqvE2xrsFm9WgACa++H1ELGS0sTsk8DyBTMNW80USOr9aWvlfn7OgltnhQ2rQZfID2FPK3Ul7mSufLcQZVY2JtDDq9zIL7djpDBTjmBv7m9iTFOprYF80wG/jXT7w3VYRv854P/RY9yxVhCTTigqGicys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oM+zuqaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oM+zuqaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E27C2BCAF;
	Tue, 28 Apr 2026 08:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365655;
	bh=l15v9GwBq6Tgk+jx/U5WdIZ+E6LJQvJWYPZzgUb+W5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oM+zuqaFj7aPMIAaQRlml7kSQe+lb4++pGnshxKVSoC3bcoI21h3rzRP/ZIvNZeqF
	 Ick7oAIHjaC7/CuTBdcwDCG2ljiHd8Nb/HEVaKAjFKVe9ucDa8z2n6q2XVGa/gSgo7
	 RGh8CqYuvf6EG0oPCgi0fxqj5yMbk83rG0LgmZiSdM9KDmJkDh0BlijdLEmO8LtWDc
	 GkkmT97JMFmbbz8AukaHSFmLOX5z6KUS3HBSZW36eGrwIziKcCpLClQ5Bq1qPvfwJ/
	 axVTCTY33sQfFTZZ1bC+lJy/uVN7SX1061aXmi/Hnv27eTi+mNslFESYLX1nl70DJB
	 Ja6z51S/Tl1fA==
Date: Tue, 28 Apr 2026 10:40:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v3 09/17] x86/efi: Intersect ranges_to_free with
 MEMBLOCK_RSRV_KERN regions
Message-ID: <afBykC-IZngftJoH@kernel.org>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-28-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-28-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:34PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> efi_mem_reserve() will mark reservations in memblock with the
> MEMBLOCK_RSRV_KERN attribute, so take this into account when building
> the ranges_to_free array. This removes the need to split EFI memory map
> entries and tag them with the EFI_MEMORY_RUNTIME attribute.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/platform/efi/quirks.c | 44 +++++++++++++++-----
>  1 file changed, 33 insertions(+), 11 deletions(-)

-- 
Sincerely yours,
Mike.
