Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4663FDC06;
	Thu, 24 Sep 2026 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790238959; cv=none; b=k6JOU6V3H6SGM3x8tQ57qwrGerkD0THm8MBknXRPtCc4gupKN80m1kw4nkm7Gtw98QCg66XaW7h9R6AKiYrGq7HEF2YglHhNU2zmymgDeYKKXHFI8LI4kwFNjQX+F8d3ywtanUTDsrQrlTi97GWHHd7CVnMUKx2l36jDJZZiyF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790238959; c=relaxed/simple;
	bh=uw9cNkdef0lPGsFEHEF2awnHRfypbOgHkzi82BYqksA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KcOlTQwczkbRDUrogfER2/ZGlv1jPdFIP2GgthdDb1wTVEXNpzNphwJD1REXKD7nCGgR1r+31VlmU677eaKeGj1Vs1YvWeZuQsWTDOlQx7Bz2J12ywcsffL+YXJnx/KTAyF7d5NYVOo9/NenHZSMRnxY6ov7jQE5iz4akszO8RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X31XwyZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X31XwyZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F21F00893;
	Thu, 24 Sep 2026 08:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790238958;
	bh=e7EM2scO1Xc78BwoAUHajjylw+akcDb4zR59+Q7scyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=X31XwyZEWdHBJJBkwh+YGKGtWaKuIhss1ceDmg2QfxyV2X31Pppi40vmjCTILvnnb
	 HrfOnU7BMetUV7eps82Hyhcz7Z0liQ4ND+29yycijKUs4CZQB4q7y069slEnJOnd8/
	 CNZxGl7NAAmR5lcDhHKyx+vtzOdaYixVosaL6aolLXTam1ZOC7Wi9CPWo3p13yFB36
	 QDY3Og6jLZBEgLDp3bl8akP6miMDKR6EeR6ukVYgP8FK6UN+EQDsJUalySXr1qxVB+
	 FO0idQCoegSt9g7eEZu4yfAViCkCg77UcAr0T9ZdcsDk5GkU62SNwQ42iqhj/PxDvR
	 aGQcdycbSPiQw==
From: Mike Rapoport <rppt@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20260922041321.233986-1-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
Subject: Re: [PATCH v3 0/4] kho: rename "scratch" to "bootmem"
Message-Id: <179023894799.508379.10846192044961348704.b4-ty@b4>
Date: Thu, 24 Sep 2026 11:35:47 +0300
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.1-dev

On Tue, 22 Sep 2026 06:13:12 +0200, Pratyush Yadav wrote:
> kho: rename "scratch" to "bootmem"
> 
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The term "KHO scratch" is vague and overloaded. It does not accurately
> describe what the memory is for. This was discussed previously at [0].
> The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
> is memory passed by the previous kernel for early boot allocations.
> 
> [...]

Applied to kho-bootmem branch of liveupdate/linux.git tree, thanks!

[1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
      commit: 5e309f53050f33faf74f55332f359099d7346464
[2/4] memblock: rename KHO_SCRATCH to KHO_NOPRSRV
      commit: 05a84ceadf7024be320e2ba82fe709db4a4180bd
[3/4] kho: rename KHO scratch to KHO bootmem
      commit: 85d3615cea17968788aa6581fd242e34d8953e58
[4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
      commit: 8fe64603a47506c3b357002460c3a9c0d8d4d321

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: kho-bootmem

--
Sincerely yours,
Mike.


