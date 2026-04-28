Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF38235358;
	Tue, 28 Apr 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365529; cv=none; b=WCkxDU6yV9MKRyi2VOxy7JPzHQ9dfKz4oZHuImdwYMqnDIXgZQwmtd+eIuGSzKLPYuMZ5D3W31+fe86tsAlj7KZhGHBR+Urfdec6kRMvCRKGXEfs06hOGfJOcVjA5BiEDYCFJN9wOGmzZlm5iq6UELJ5kX5fVV1S7oWL+9xYDPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365529; c=relaxed/simple;
	bh=X5eMF31oadZAWte1lSQ1P2nca5U2gXu9zv+E7ukQozc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bv0tvxe3R/HC6oYYGHLUDq6DQXEYOxJHd/8Mu0btqdyvXswCPlZJDbcdVJPRxGa82xFtCnUbQrzOsTtHn8zDpyZ0NXu8HFG/RJ3uPG4UNSMYO3G5prWqX4fLzdVXUTPONi3nv4sq+G2toCinnxE6VX3o0ftiuO8DU7Fg92LsDQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byhatB1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byhatB1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE46C2BCAF;
	Tue, 28 Apr 2026 08:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365528;
	bh=X5eMF31oadZAWte1lSQ1P2nca5U2gXu9zv+E7ukQozc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=byhatB1o3vl4KeJ+Ey1qbjkPl1ZKfjxJkTA7Rsqf/exRpm3LTcpn5wZ9noTpt6IoN
	 GjzPqPQKms75c1cCXZ4rx3sRUFd0CJmZVgclOhZpFxYmObziag9Z3CGS7gZYKbHm+D
	 0KxVDGgXzbfx2cc7KVvC363/hx68yAai+x8bMtpRnnaq7zdvLdKaQe1Vuip63TkMiG
	 IGMwV56kviDfTrRQMO032NJ17oQKs5Np9FgYooWolBCSz5jqW6BnREIKNCY3mpOKVB
	 nF3e8UUfpvCdITdyVOAg+PL6Em0Q7MGoINz9YpRERv4dByz9T6N9xN+e4yUnD7PAlx
	 4WRvD0KZQ3wTQ==
Date: Tue, 28 Apr 2026 10:38:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v3 08/17] x86/efi: Allow ranges_to_free array to grow
 beyond initial size
Message-ID: <afByEd6D1FusY7bW@kernel.org>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-27-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-27-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:33PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> In order to avoid the need to mangle the EFI memory map, which is being
> done to keep track of which boot services data regions are really reallyo

                                                       typo: really reallyo

> reserved, and which ones are only reserved temporarily, this information
> needs to be recorded in a different manner.
> 
> The temporary ranges_to_free array is a suitable candidate, as it is
> specifically intended to capture which boot services data regions should
> be handed back to the page allocator once deferred struct page
> initialization is done.
> 
> This requires that boot services data regions are intersected with the
> memblock reserved list, and this may result in more ranges_to_free
> elements than the current upper bound of the number of EFI memory map
> entries.
> 
> So reallocate the array when running out of slots.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/platform/efi/quirks.c | 40 ++++++++++++++++----
>  1 file changed, 32 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.
