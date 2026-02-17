Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F13382DF;
	Tue, 17 Feb 2026 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771330192; cv=none; b=Nz7koxaMAtuAX75/K8HCuI1SjgsWm0pOaIsehij0rIgE4ZwsWzmtlFb+fg3MazHY+f6MiDpXUKGFZqZz4my+tFjlYT7PScS4xatEc/AExI2WsHdCk/8C9zyIKNhgnb9RjbElb1SgelH3QIPc1rZBK+VoqAOPxdapMXWFehZRUKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771330192; c=relaxed/simple;
	bh=+dDmsgNTxJ4xXTywjhKRtMBQjRXfDi/GXnhG2R1uzpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrR1FTfG5TREybtIJT3yzoVeh9shuMX/SYMz+bn3PtdM6pW3Ge76/LRYzoIuxtYQ2aG4UEzdGNZqELVn+mKih8A1uWIqxX5ypBAlY+ze5M4XbGCW+MXEOgifwarDiPyHGaLC8yIaHvfB+Hg63KDUZg57VJhOXo0GysIa2DwBrZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4u74F0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4u74F0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4440C19424;
	Tue, 17 Feb 2026 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771330191;
	bh=+dDmsgNTxJ4xXTywjhKRtMBQjRXfDi/GXnhG2R1uzpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4u74F0P/z9HalXrm+ZixCxZNji6V6YooDDD5uK35jvkP46JJtGnvBx4yaiI6EHMk
	 md3+r4ms/xzWet1PaiK6q991NEZYvXNaBfObeUDUwPfFu3Lsda2xnpwOp1pUthOIKd
	 9OLHmc60NI36GALylCAAaXFHhYdbI07CrlLwVeSGM56eSNDPPawPkoNqHEaWk7qL4W
	 +/xyEviB4zlY16qq1mWwYnFoo2aFY5mIoiCcjHoGamILeQXpfwoEL+waJRQKUBlls+
	 fR6ORgECOWZxyAa5dM0CC8h7WErlFPiHmZS59GHgz75MGoXJFq6kpPGg3ZpC807dks
	 l1bTGgNJjKbmg==
Date: Tue, 17 Feb 2026 14:09:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory
 code
Message-ID: <aZRaiCidlfNtPG17@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>

On Tue, Feb 17, 2026 at 10:49:55AM +0000, Kiryl Shutsemau (Meta) wrote:
> This series addresses two issues related to unaligned physical addresses
> and sizes when handling EFI unaccepted memory. These issues were
> identified as potential sources of kernel panics in Intel TDX
> environments due to incomplete memory reservation or missing "guard page"
> extensions.
> 
> The first patch fixes the reservation of the unaccepted memory table
> itself in efi_config_parse_tables(). It ensures the entire page range
> covering the table is reserved even if the table doesn't start on a
> page boundary.
> 
> The second patch ensures that memory acceptance requests in
> accept_memory() and range_contains_unaccepted_memory() are page-aligned
> before performing the unit_size alignment check. This prevents skipping
> the necessary "guard page" extension for unaligned ranges, which is
> required to avoid crashes with load_unaligned_zeropad().
> 
> v2:
>  - Fix 'end' calculation in the second patch (Tom)
> 
> Kiryl Shutsemau (Meta) (2):
>   efi: Fix reservation of unaccepted memory table
>   efi: Align unaccepted memory range to page boundary

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 
>  drivers/firmware/efi/efi.c               |  8 ++++----
>  drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> -- 
> 2.51.2
> 

-- 
Sincerely yours,
Mike.
