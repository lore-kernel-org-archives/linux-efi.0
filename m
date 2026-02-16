Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DA524337B;
	Mon, 16 Feb 2026 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771253524; cv=none; b=UweAdYtJ3uxAHXPy6mBb6XavrhGsgM9ysEd7H9jXLPHSPvTWDyoY7tEe6z7yTfY1nj582nNbSIPwmpaPY7MGlAHdW0a/bBUU6VE+cfAlZ/zO8mLARC0NW4kgvQDxC/a9jVVySi7cALIiuGLcuUSLP3s530xXcTy2ADcAzY6MUaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771253524; c=relaxed/simple;
	bh=hG0c8Mrja1+MSA9V9tgUeaCss6j9bWCBInleHisLE24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+JH6Me2n6V05NjP2U+FIzMnpmOxGRfUlViALk+A6McQ7i9recc2fk9q88CFxB7fhHUC/uK7VLdMuBSqFJVLj4nImRexXKvgAICkfd9bKux6ifu9zgyqUh877MOhYdLID9oD1It55n9eNskMCjtdC17LZmXIo3cPENNWAgxVKWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEO3gqdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEO3gqdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A23AC116C6;
	Mon, 16 Feb 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771253523;
	bh=hG0c8Mrja1+MSA9V9tgUeaCss6j9bWCBInleHisLE24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VEO3gqdv2/aaC7oikECT6XmGucBKzsdhSGRKRVN3DU4bjvZlLsYUQUKwZlXUWw7EY
	 oqLOiQ/wZaDYQQE4e86li+3IgXzBAjMuPHx6/1mnpnenOrU9J2w0gyrQ0ZJX5vDezK
	 TJ4NLVTrwMOliNLilhZ9Z0lR0/6qYwWDKWpybq39z3kZ7nRUtEgy6UzgwnvK9Jxhui
	 4k83pbBb41va3ZBXuxxcBZ3K+4RPLtBseBGq9MWLvYqDxaoq60/d9So3sC0qYfbvQg
	 CIPEnrNPlzU66q0E/tdHOHyjxMqorOiqQwSXAUbg+OvOBsYZCXQLfPqctwlMNwBdoe
	 +4RyNazHhNk/Q==
Date: Mon, 16 Feb 2026 16:51:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aZMvCxV45Uw8YPhT@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation>
 <aZCaE04vDpf2hDEc@kernel.org>
 <aZMn5_uLLH61Fr6o@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZMn5_uLLH61Fr6o@thinkstation>

On Mon, Feb 16, 2026 at 02:22:49PM +0000, Kiryl Shutsemau wrote:
> On Sat, Feb 14, 2026 at 05:51:47PM +0200, Mike Rapoport wrote:
> > > My guess that multiple memblock_add() calls might add up to the full
> > > page size.
> > 
> > I'm not following here. Can you explain what do you mean?
> > 
> > Multiple memblock_add() calls to adjacent ranges will coalesce into one
> > larger range. But I don't see how is that related.
> 
> I tried to find justification for the byte-level tracking by memblock.
> Not in relation to this case, but in general.

Probably somewhere deep in git archaeology :)

I presume to not waste a page for every small allocation.
 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.
