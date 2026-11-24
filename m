Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795536862;
	b=5F75VlIUASjGWtFojxSDY9cy9/6iwIsMcTq0VU25pJ9SlBvPM5eBpvBuXVZDPq6AdF21
	 ytAn4Vy8zKjWHdK7iuaSeIVu4JB7zK84VS7l1XMq3kbj+quMR1d92owaSEXtHKcHfBGwq
	 sofboHpYIgBM+yrDL5MwPfa5aG6i6/ceEjcbnPoYOcUDHNd09qCYX3LiQDonfpM3UjWPt
	 GRIh7YU9hRPO4AmnpgMr8QWnPU7bI+E2lbk0/bTSgwkWOFxQYxYJ5GOAmwNUIKDKL6C2f
	 aeJTlLqHz8GiBSPGwgPEqesPdGkaSCuMqMCCaKar3FN364foFMXpylr+EJkFlIutIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536862;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=WrZPcXpujul/0lHKoTpqeKk2rEN77o0/xsCu0c+kPzk=;
	b=Ky5GDjvbokDWlb+kUJ2wfXZVoFb24wjeJep3zOW9GXEdcU0iJY+7dGeXEwXfWNrl+e6q
	 GGJ2mzor7EpQRIeJeAwSi70K7CddSVFXnFBpq/jTiY3Abq4z0zdLlVFbBqvQuTGHqKZNd
	 HG+FX36mKB12rX+HzzB+wypFAt0YdzH4iuXI72TXayPdZ4frIqHNOBjDZxh0lbAahJ4Bz
	 1UvtID7PH3TB1VDzdYE9rP4d4y35aWbKiKB6QrmPdIEadWf6KLRdZsyyxjpOEsJFvCE1C
	 sn38HftIWBsCkqvaptNSooqgUakEEphYKQEaNehJCT2Bv+GdxykVSR3hJgZhXNKCkLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9S5gsaK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30847606A31E;
	Tue, 24 Nov 2026 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9S5gsaK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAAB1F000C0;
	Tue, 24 Nov 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536861;
	bh=WrZPcXpujul/0lHKoTpqeKk2rEN77o0/xsCu0c+kPzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b9S5gsaKM1pEhc09ZRSKqeE5LzsmM0Rch2EIYoXBLn5hFQCbGTZXqgnLIgSaDPnEl
	 IBxlX6mGcjSAZFKw3M6SOnF5FfngeYDJXOVqHmZ7aJofIs5BCqipkg2MsGRPiTSVeO
	 fOVKyc07oysD6nmQwarUXsAa0y1b1GnJ+OSa6MkE8DMz5fMbzHbWBLxuQA8UICjsww
	 oWnFVSuSd2RDBPhlfT26bwiGLnTXw7hqn2wqaJ0zqP3VsXeiRgM75pGp7tcRdF2+Fb
	 KcadwoDHLT/mzbfbkZOigg6GrPHPGBAtVVMTG8X0JFTMG+Ce+oRGj/NbqZWFqpjH7z
	 u5LArjSylbEDA==
Date: Tue, 24 Nov 2026 18:14:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in
 confidential guests
Message-ID: <awW31hUpXuujSAXA@kernel.org>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>

On Tue, Nov 24, 2026 at 07:58:31AM -0800, Dave Hansen wrote:
> On 11/24/26 07:56, Mike Rapoport wrote:
> > On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
> >> On 11/24/26 05:32, Pankaj Gupta wrote:
> >>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
> >>> memory bitmap before the command line is parsed. memmap= and mem= edit
> >>> e820_table only afterwards.
> >> memmap= and mem= are debugging tools, right? 
> > I wish they were 🙂
> > But AFAIU they are used to carve out "pmem" or PFN-mapped memory.
> 
> I've used them that way for development, but production pmem systems
> always had persistent memory in their BIOS-provided memory maps.
> 
> How are folks depending on these in production in confidential guests?

They shouldn't but you can't guarantee that.

But I don't mind letting them crash if they do :)

-- 
Sincerely yours,
Mike.
