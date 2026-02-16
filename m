Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469CA32694C
	for <linux-efi@vger.kernel.org>; Mon, 16 Feb 2026 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255998; cv=none; b=Xobyx02/yqtY5VZ7NQJMj4EKFf8pFhA0po/hiclGWJsc/7vs61lfW6ZkeF+6PXk2tE9tIJE5asYc0mY7JRF8/cCfgvHFJKz+Kmtu46m2oyeyZTmAJaPMAX0LteCwx677WKSyzFJ9vsXyrLtEAZI03MqtbNIUUI7vH31V5Sjuxz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255998; c=relaxed/simple;
	bh=B/smNXNw4Eq3KyVVAhvZJb6xNJh9+uHMcx2/WDqg4cU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRjnNcIIt04vI66sRqiFpalHJ/1u6egwSCsSzKLpdjWCn+tgiL2uDPBpkuB/VAZMvJTUmQKXZJeNJnHano4RMM07VPZqw2kOodKHa4DVephJEtgUu4wQ03GNgu84mXQv1JtlAJ4kyOqZQzK3f+Bv44UKCKGRCqReFF68wnAfNdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiHc5c5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiHc5c5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B6BC19423;
	Mon, 16 Feb 2026 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771255997;
	bh=B/smNXNw4Eq3KyVVAhvZJb6xNJh9+uHMcx2/WDqg4cU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tiHc5c5UzYvP4Afd3mNQvDVeGkRHIRwpNvmVOits7L0jLKOGrN8EBwCK9j4kzpusL
	 G9UDAkoiCs6xQMp09NU6Fks7ZW5w9wSmYYDleIM4H28GQwPCYCQZjs5IYI030NgPRn
	 XMXwg5Kqn5pHMZK613d9xelr7fz1Jbl0vAbrgvt9jysDChCtyVvvloytszftUWdUyg
	 bGtw4eYyeNuhZrV0Zi/yqqs696IF+84SqelEz/Edt4oWIMraMRS4/EmLfr8XI+qeZG
	 MBYWIfv5MxIbQfgpV+zOBuIc30BJ4RgxEoLRu/twqsC+a/95nlqQLblgfzXVmu+sYP
	 m2k8oqDWh27tg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 976E5F4006A;
	Mon, 16 Feb 2026 10:33:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 16 Feb 2026 10:33:16 -0500
X-ME-Sender: <xms:vDiTacDSAOIBjjq_ukEMG__0o6a66lzpJD8v61xqxu17uQq7GCjcZA>
    <xme:vDiTaQJDe9Z26vK3U6F42wm3anYYwUQwZptbMHgJ_7Y8yC2jHfvLuj8La44MPnVts
    1IAG8ghrmpz7OH_rfxJa2cIIhakAIgfJ13bx6C8R71C-jTN1uPdIdr9>
X-ME-Received: <xmr:vDiTaTo5SfnyISE-jaO-yLWPCQJirTd5fPIvp-0jdmQyXdrckrlJaSs5nxdxhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtoheprg
    hruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtohepsg
    hpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnheslhhinhhu
    gidrihhnthgvlhdrtghomhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:vDiTaZMgIcEVnBpvG7yVREE8T4oE-WKD7zo-QhzrhSobf_ljajXhvg>
    <xmx:vDiTaQON3U3yuVrmO1ymreGtfhECvGTJvAHk0ICMAN309MZKfB9eWA>
    <xmx:vDiTab2vGs-FRXwAt0FeUFFufILsPjU-s4nzWnS2Pdq5-sVvqcb4bw>
    <xmx:vDiTaU2yqGh7bfH3c79I7qxpvI93z6rHtARiS2qmmno87060RqlDcg>
    <xmx:vDiTaazoo1EY_uuNPJwnKTniiHC3EncdC3ckKtec1TMiCRjmj_VwqL2k>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 10:33:16 -0500 (EST)
Date: Mon, 16 Feb 2026 15:33:15 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 2/2] efi: Align unaccepted memory range to page boundary
Message-ID: <aZM4fYf1bam_mo9V@thinkstation>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-3-kas@kernel.org>
 <86c040be-e91a-4d1d-a365-a3bf3772374f@amd.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c040be-e91a-4d1d-a365-a3bf3772374f@amd.com>

On Mon, Feb 16, 2026 at 08:51:17AM -0600, Tom Lendacky wrote:
> On 2/13/26 09:48, Kiryl Shutsemau (Meta) wrote:
> > The accept_memory() and range_contains_unaccepted_memory() functions
> > employ a "guard page" logic to prevent crashes with load_unaligned_zeropad().
> > This logic extends the range to be accepted (or checked) by one unit_size
> > if the end of the range is aligned to a unit_size boundary.
> > 
> > However, if the caller passes a range that is not page-aligned, the
> > 'end' of the range might not be numerically aligned to unit_size, even
> > if it covers the last page of a unit. This causes the "if (!(end % unit_size))"
> > check to fail, skipping the necessary extension and leaving the next
> > unit unaccepted, which can lead to a kernel panic when accessed by
> > load_unaligned_zeropad().
> > 
> > Align the start address down and the size up to the nearest page
> > boundary before performing the unit_size alignment check. This ensures
> > that the guard unit is correctly added when the range effectively ends
> > on a unit boundary.
> > 
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  drivers/firmware/efi/unaccepted_memory.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> > index c2c067eff634..9ddf3dedd514 100644
> > --- a/drivers/firmware/efi/unaccepted_memory.c
> > +++ b/drivers/firmware/efi/unaccepted_memory.c
> > @@ -35,14 +35,18 @@ void accept_memory(phys_addr_t start, unsigned long size)
> >  	struct efi_unaccepted_memory *unaccepted;
> >  	unsigned long range_start, range_end;
> >  	struct accept_range range, *entry;
> > -	phys_addr_t end = start + size;
> >  	unsigned long flags;
> > +	phys_addr_t end;
> >  	u64 unit_size;
> >  
> >  	unaccepted = efi_get_unaccepted_table();
> >  	if (!unaccepted)
> >  		return;
> >  
> > +	start = PAGE_ALIGN_DOWN(start);
> > +	size = PAGE_ALIGN(size);
> > +	end = start + size;
> 
> Should this really be:
> 
> 	end = PAGE_ALIGN(start + size);
> 	start = PAGE_ALIGN_DOWN(start);
> 
> ?

Doh! Yes, you are right.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
