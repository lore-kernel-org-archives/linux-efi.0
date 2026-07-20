Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873AE38B14D
	for <linux-efi@vger.kernel.org>; Mon, 20 Jul 2026 19:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574315; cv=none; b=lR2IMhH6u2Gkab8f47dkrFwWBwdv5w7J43DWGN5AzXhV10OHFT2U7FfVKFs6dpwQkKde0MZ5f8BKfReL1wDkHkVjViaBX73jfTksQBKQpSp8/RhTLSqn2d3TP+QzFudwcyUcT3GIHJfyRaZqqpZIHZw4KE9fx1dc4zVGo1B2Rhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574315; c=relaxed/simple;
	bh=fnW288skhTtWEbrTN/fD9Nt9dtFSRpG2InOVP3xSzZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrxR19dspSbdjHkf07luPj6KoUC6O/DFOufgcnA/t1afPsgQSLmKYUUCvHlvQyQ/AFhigpAkRJGTzUTxwQL9QAJgRbxgP0LLR6xScPIW9yJ1HbtzNCMapC7tD2ILJDCmdK2NTxcfDhUmO5XDpkAvjPiTn2ueixGcBZMIL43+P/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NbyExw7C; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NbyExw7C"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso77530715ad.2
        for <linux-efi@vger.kernel.org>; Mon, 20 Jul 2026 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784574313; x=1785179113; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kPMaiKQm/Lrn2+15jJw1Tz84+egEdnjBHflNkHpDaxg=;
        b=NbyExw7CLFk71hAnpCJNUiZedvi+eDrJI9mqRpI89yk+kTVspS/t7ax2vHPuApaQI4
         WjEB3dlDf7AbdioL0MPE36Jh2OhFkDOOWSQrFN49T1hqj3zWED3bPmdmyadRGmnbJo1E
         ca0paUja8vJl0Px2IaJ+jvDFtjbxKlFU5vZxK8Q3vOdXClzC4n6Czf1r4b6kVgsZv1yX
         29P/R/8UZqC4oL081tJMc1zmK3K/Isg2hL9sbZjEOLbVukDq5XC/fATt/bIrIzRkK0rO
         TQ1jiAAqfSRYsE5Vtkbln/d/nZy4Gh4zYiqUXLwpTtl2Myfh1ggjrRZH6EwGYJPKSxwC
         jAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784574313; x=1785179113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kPMaiKQm/Lrn2+15jJw1Tz84+egEdnjBHflNkHpDaxg=;
        b=awxhxsFmhJciYW1asYiXDc5iWctaYJUZGLx/j6+gUTS943+SnnyCQ968xjSquO0Bag
         EUsd+036nc4Yyq6oYWo0F/7tPN2lfcG60nBAxkvxWbrl/lXsYus90yIZcH/h0p4kt5kJ
         5hC3/4kExUm2fCrp6dqk3h8tdahi74b7wM65QF5jz48KhCkqrOk+6DPSvy8rwi/NrQHB
         DdUM7vaKgdTltTLldI1HcA34qS6CU0nWY3+qmEgcBJTJjDjiSCSyIolcGrtyQnHWtNd+
         DasKXfOTXjjGhmuIC2oXrn729dhhiQEkc6VJ+4KLlugq7dthrSS1CE7Z8OlZotXPaf3R
         8u6g==
X-Forwarded-Encrypted: i=1; AHgh+RqO3BReYa8hvIuj3mRcAADstk2AyWCtMxw6njnF8icgHTzLbyso9h8/6HLlU+RS53bgL9p2XsmArnc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsfajeT/FqmOobY1+l3Xx/c1/InKOjpi4Wh5Jb6fbZrJwWIB7e
	kjAgvjXssH1PToTCfscw+xhDd6dGKksxzmFsXTShTnCCU5gzkzTO+Xg9
X-Gm-Gg: AR+sD13A0oBmF66FdnyXitZdImttKtrygKKsbylt66LfQ429bmg/5hVYOisVpnElc5T
	UOo4wJnKu+StdO/Icvj/8HliZ0PVY1j3J45s9QSCgSv9dxwlOoouYra5pP+o/tdtXPNXGiuYouA
	JfsTBEYb/ZdhcZb5Tuu1jGGNelndSehwgwuuQB0HNcKoTnIoTvHkwa19flo/2TcjYsKYWQNnx9N
	r9KSZheWBzpd+fUUePK12JVb9hEqgWKs8LkzjL/evNBDAcl8PpHdd0bpGL41kUAXy4oye+B3QOx
	Jh+WqKgVid04zbZRvOdE9IKVdt8tZhodDdnX0RpevtJdFju8fSm8/xwls0J9OYvSHd4QV8Y8Bv2
	90b2X11m+u6QejEVOuHaFPaGS0RC5HVwooPtbQ3BaHeDyxtNa+eZKcT7MsvOTODBvberguixhjI
	zaBqEF1tPpzTzuH93URoXfmiQqNKFyo12AzQ==
X-Received: by 2002:a17:902:f681:b0:2ca:3e3f:4956 with SMTP id d9443c01a7336-2cf34a35445mr164591015ad.44.1784574312756;
        Mon, 20 Jul 2026 12:05:12 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448f73esm60735085ad.16.2026.07.20.12.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:05:11 -0700 (PDT)
Date: Mon, 20 Jul 2026 12:05:08 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ning Sun <ning.sun@intel.com>, x86@kernel.org,
	tboot-devel@lists.sourceforge.net, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 14/22] mm: set page table page type when allocated
Message-ID: <al5xZHiFwatn518I@fedora>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com>
 <alZSwAM4pwmMOeaD@fedora>
 <f3afa5df-73f3-49da-87a6-d75eb5f3610f@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3afa5df-73f3-49da-87a6-d75eb5f3610f@arm.com>

On Thu, Jul 16, 2026 at 11:49:31AM +0200, Kevin Brodsky wrote:
> On 14/07/2026 17:16, Vishal Moola wrote:
> > On Tue, Jul 14, 2026 at 03:04:03PM +0100, Kevin Brodsky wrote:
> >> As a step towards removing pagetable ctor/dtor calls for kernel
> >> mm's, move the page type updates from the ctor/dtor to
> >> pagetable_{alloc,free}.
> > Thanks for doing this patchset.
> 
> Thanks for suggesting it :) It's turning out to be quite a bit more
> involved than I expected though! (There are multiple cases where we call
> the ctor/dtor without using pagetable_{alloc,free}, see my reply to the
> cover letter.)
> 
> > We should switch over from __folio_set_pgtable() to __SetPagePgtable()
> > in this patch. Ptdescs and folios should be treated as distinctly
> > independent of each other.
> 
> I sure remember the previous discussion, but my reading of your comments
> [1] is that we cannot really change this as long as pagetable_alloc()
> can be called with order > 0, right? Multiple archs still rely on that.

Kinda...

The concern was about callers accessing tail pages directly for that
information. Using the folio API ensures that we always look into the
head page.

Since we're now doing it at allocation time, we know we always have the
head page, so it's fine.

The dtor/free should be more questionable because the underlying api
uses virt_to_page() which could look at a tail page... oopsie. I
haven't seen any reports tied to it so its probably fine (the
setting/clearing has been using the folio API since ptdescs).

We can say thats a happy accident that makes distinguishing ptdescs
and folios easier :)

> > Eventually, we want to replace the memcg accounting as well, but
> > there's no existing API for that right now. Lets leave that as is for
> > now; this patchset is big enough already ;)
> 
> Yep, looks like there was an attempt to improve this but it had to be
> reverted [2].
> 
> - Kevin
> 
> [1] https://lore.kernel.org/all/aha321ndGSdReBJR@fedora/
> [2]
> https://lore.kernel.org/all/20260225002434.2953895-1-axelrasmussen@google.com/
> 
