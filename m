Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535800;
	b=vPLE31GoZEwX/67gvbU574ciZh/6JiPBbmWIc30qFp3kNMwx78IGdXS6i2XWriQvps73
	 cOndpVWqOswgYQEpmPoVyzMRnJTcqZZRc4i1N46MmxBhCEBTMomrkWA5vacSIYADCW7Qy
	 +6PzHgz1bUkFdhzAmd/USSMCnbMWP4jni90hTuU7ofncR/sCYFeMX7+Wo3zxpsxirXxOs
	 qSrJfgmbb8omks4+oD4FUlJtyOU0M8JSxyAkL/5eosgIjS4VNvJU81V1yaeOmkUe9cWwP
	 mGj6l71o2skk5X3LuecP5a0yy2qvlyWcChqcn/iMa47fgpkzrILBZkOLi2YIYLW6JvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535800;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DBmlD09t+us4vgRnqALAcW6AgVgBCrAuHVb46ePvY5A=;
	b=oKZ8lPtvCkFQVb3iXrgyWrjlOUsMBRCZJUMF+wX4dgIcS9OhWaSRZkWhoPw1Jo8NsXG2
	 QmLAweuT8w4DI+Y/xcn5IESFHkY0TyeHHpBGRXs6Db+pOezTcOTaV4d3frLyupF5c6jWu
	 +XYTG+ASCcl/NGi9dsD9OoA6s0i7KymZpPArqqpLgpSq5vaH6NXxjbqwWcNhpoJXGQicb
	 awg64883Y6qBtxrmecgm0KCBRJm3JD6IC0YdJjmdS6WRSTFPEUsymaQAkh85tK9rVSPLv
	 XHBTQLY/4Gd+doOGkw7T8ebc6O8XKa6VoM+4K3WMO/gfyB9r4C4i7fkOx22pMr1kG/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KydYkcJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF13606A32A;
	Tue, 24 Nov 2026 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KydYkcJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27B61F000D3;
	Tue, 24 Nov 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535799;
	bh=DBmlD09t+us4vgRnqALAcW6AgVgBCrAuHVb46ePvY5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KydYkcJZ7NV60VrGLHtYGZOrlFrD4nCIdia+Fr9/pP1mLBU55VVlIzRvquAwV4rSu
	 EBRaq55zMQJ3CoTg6DdOXF9OPxB8TmgqfGCXmS+Txpvoh7YIh5AuPub0oN15hgv8W0
	 04s1h4Lkc8nJlZvGzSyTseInrPdvQaQVfuiNKZFIUF32y6qqP8zBqNJ9WjdtgasYPQ
	 0NElvY00Vo4eoG4mTsyyslCse1pFUct/egcqU4Md+Acv6Xc5XKktszMpsFgoiZA4VU
	 aMHIoSbhXZXOvNNMAaTTACBBQKdxxvfjkp5EYxVdCvCzOVSxc4gbFWfHAakprOcBR0
	 r5uVcrehSUTGQ==
Date: Tue, 24 Nov 2026 17:56:30 +0200
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
Message-ID: <awWzrkLxfQ2_ODKe@kernel.org>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>

On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
> On 11/24/26 05:32, Pankaj Gupta wrote:
> > In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
> > memory bitmap before the command line is parsed. memmap= and mem= edit
> > e820_table only afterwards.
> 
> memmap= and mem= are debugging tools, right? 

I wish they were :)
But AFAIU they are used to carve out "pmem" or PFN-mapped memory.

> If you use them, you get to keep the pieces. Why add complexity for this?

-- 
Sincerely yours,
Mike.
