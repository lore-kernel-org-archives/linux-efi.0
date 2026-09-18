Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AADD2EEE8A;
	Fri, 18 Sep 2026 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746835; cv=none; b=DHSWBHU2lCublLHbjrpNT4TXoUTqfl7Qc1F+NPZXdxHEx+UqoSOPitAghU3qPWjbKUGX5g2dP93jj8i0xBSEmcM6Xxdf/YQOM3PQlM4ZldvXNxSLrL51K5MMRqI9Ygxe3iONFAOxD+9fm7QjkkKMf+7dvnLBCZ04SCMRdbgyl1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746835; c=relaxed/simple;
	bh=Zz0HowFz1DRXJxqvbviPYdYtj5Lq4iMssj0Vb4eQCqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTeUfzXJbnpRh3g9wpPpK8yQEu/6c0dUIu62puuaijCVb/tSzACWU6UFH4AykWuWdGrxRuEMk+pudyXIjFS3YktPI1SDn1+BWeTtqSEWrxlOM4Sffqpk9Gx/FKjG3PISSs5MAfZm05N/7+8hh3OBWyg+HdY4ygcb/nYcILmrvwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIEriSXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIEriSXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5BA1F000FF;
	Fri, 18 Sep 2026 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746834;
	bh=lbVpbtgdB6gGZcR4lzgAB3myFCTkj71uHlYAh1fjtFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IIEriSXVzQQIbmH/FW5DBcrqsy76Yaczc0C0Ik4WHYjVQnzytaQllHxVnCbSmc/wf
	 3ip1FhCfubcWvgEFGaFqhoSBjDlBrbvhIHU25A/1RM1nk2BmIm70/Hxw8/S+DydAV0
	 3SGFaiA3XRt4FWTK9+c0V8lv5q/l4wftpnHooY14rs1ubyLM6hw2/hfF2VKKSwVh1e
	 FhOV+8MyczBeZB8UNCkeyseDoJ5Ct12tMLHGuGVDnY5b3vFJgGhlAZihGM0UyCgXsG
	 35aKDXN/yNndhmB4yIr2PssE15X1XCIQ3h0rbbmm3vNlaIAaUfJsNDydr5HXuEh6Xe
	 SOp7bD+QGVffA==
Date: Fri, 18 Sep 2026 16:53:52 +0100
From: Harry Yoo <harry@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	sashiko-reviews@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.or, 
	Borislav Petkov <bp@alien8.de>, Danilo Krummrich <dakr@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, x86@kernel.org, kas@kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, "Rafael J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev, 
	Johannes Weiner <hannes@cmpxchg.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rmikey@meta.com, kernel-team@meta.com, driver-core@lists.linux.dev, 
	riel@surriel.com
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
Message-ID: <aq1eWgGenthqMNd7@thinkstation>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
 <20260915134535.C3FC91F00899@smtp.kernel.org>
 <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
 <aq1Xr4b7BXZForCe@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1Xr4b7BXZForCe@gmail.com>

On Fri, Sep 18, 2026 at 08:27:40AM -0700, Breno Leitao wrote:
> On Wed, Sep 16, 2026 at 08:44:30AM +0200, David Hildenbrand (Arm) wrote:
> > On 9/15/26 15:45, sashiko-bot@kernel.org wrote:
> > >> The bitmap an earlier kernel filled in gets in this one through EFI,
> > >> but nothing reads it back yet.
> > >>
> > >> Introduce range_contains_poisoned_memory(), which the page allocator
> > >> will use to ask about a block before handing it out.
> > >>
> > >> Signed-off-by: Breno Leitao <leitao@debian.org>
> > >
> > > Sashiko has reviewed this patch and found no issues. It looks great!
> > >
> >
> > David has reviewed this mail and it annoyed him.
> 
> Breno is curious what annoyed David here.

Harry assumed David was annoyed by Sashiko replying with
every 'LGTM' email :-)

-- 
Cheers,
Harry / Hyeonggon
