Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12A548B396;
	Tue, 14 Jul 2026 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784041515; cv=none; b=pXzzau+MLf/NOykCbyQr/K4p+dPmSRA11zUqqfO/8iNc9pGfmHuyh7heKdVDeOIARNN1fsJ8vc46xxfZe8yQk6SALK+NfjXegqP+/6Qt+bydyJWtp0ltCGgsKCXch4111m4A3nSCz7OiYoM7COU/pwdb/l4QvtyehWlCC/gS4kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784041515; c=relaxed/simple;
	bh=HHJkedvqLGkWxIj2Z1wggFPycBLi0/kdB+Mtl8peKIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oC99ID8sKe64/ifHZF+r07edSI+ihzpyesiEZNaBMOYHtFSp13yNLODGB6KJUVg/p19OfDrIdCGGttJsfnkPTARVWzlicm3mmURRT8SFO+6XBSMIl7oHOc6lVpCP1QixBCSSKcR08SjL/Kt2szIKrq4wkzrYkJ5nmHLkKncwsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crOD2NmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crOD2NmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA51F000E9;
	Tue, 14 Jul 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784041514;
	bh=AYjyETDBZwm0j/cPjjIgSYujcuHtX92Lh9M1By4BrMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=crOD2NmJDWob7tNH4b0nB1FiZnokFnKZDkP0Ght7V6I9Wl8zmC+0pmKCW+kuXLlLH
	 OdZHmkh/T/9BB42ZvoZwp60T/mYLQwb+uOSlwDUb+jGK/rXpggWk3voCs1+1oCHlIy
	 LXTlYETzj3M++Bh5NzIk2buDSGg3fmS7KG1J0rfl/O/1fHossnuwmJ7LiswfHs+0P0
	 ffWQo61tvdjoVoC7hXSzokGWOo+sPo7j+/6Jfs2msT1jdScy1yBzSMh3QvyUVNtNcz
	 99aBb5YGUL9jfl1vNkXPGp7NC4uErRwi1ismiMLOqmhMcboruizzYkE3vXwJGQsEgm
	 RUE53xPNgB+iQ==
Date: Tue, 14 Jul 2026 16:04:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-arm-kernel@lists.infradead.org, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	sparclinux@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-um@lists.infradead.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ning Sun <ning.sun@intel.com>, x86@kernel.org, tboot-devel@lists.sourceforge.net, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-efi@vger.kernel.org, Vishal Moola <vishal.moola@gmail.com>, 
	Alistair Popple <apopple@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
Message-ID: <alZOs30ziqa7l_Lq@lucifer>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
 <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com>

On Tue, Jul 14, 2026 at 07:47:43AM -0700, Dave Hansen wrote:
> On 7/14/26 07:03, Kevin Brodsky wrote:
> > +static inline bool mm_is_kernel(const struct mm_struct *mm)
> > +{
> > +	return mm && mm_flags_test(MMF_KERNEL, mm);
> > +}
>
> Could we give this some nice comments explaining what a kernel mm is,
> please? Part of the problem with the init_mm checks is that they're
> magic and it's not always clear what's special about init_mm.
>
> Maybe start with this list?
>
> 1. There's only one of them.
> 2. All kernel threads share it. tsk->mm is the same for all kernel
>    threads.
> 3. It holds the reference copy of the kernel page tables
> 4. Userspace can't be entered when it is the current mm
> 5. It has different TLB flushing rules than userspace mms
>
> I _think_ those are universal across all architectures.

Well point 1 isn't true of efimm or tboot_mm so we possibly need a better
name :)

"Special" is overloaded too much already. I quite like "eternal" so:

	static inline bool mm_is_eternal(const struct mm_struct *mm)
	{
		return mm && mm_flags_test(MMF_ETERNAL, mm);
	}

:)

Cheers, Lorenzo
