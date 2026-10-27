Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793096980;
	b=l577b0U026lgPZD+ThSYvzAsvGR33EPOQiUC6NAtg8ARhtukVjKGqSu4g4/P3BEYkqOR
	 iX7cEf6txb038/OK/Sm/8yckYfya9lm9idXUbt4R08Jr+r/Pk7A3q2NZHgAw2eum8dftO
	 6/k5Ixgtuc2qI4czZZoXthvxXKMmbvU1RYnoHp5d5R0gjs8Jdq3AyTHthiXgmlAALl3RQ
	 6bXsXNdmfKbG0cWy8C40ZAq8GWDJoDfvcmNkWr6pfWaKkLHVC/g3T7SBcnRBv8a0ZoyUu
	 TNQZf2zhZJpKBS63pgvpDOJ+ngwa1QO8Jgim9Jx1eizgbB+gWM83QydM8QAjAjQMxDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096980;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
	b=Ai89nZKeTqrBzVKN6g+CPZH+QBxOIWIXoh9qT8qJsaEndn91WqWd/4ebfF86PGjjrydF
	 U8WEHpdQyhCUFIszfGsObSTc4jsZayC0haaVJiXQMhZy/i3xrrk8uhVNMwcDqUM25eb2M
	 dV/EsAILHHVk349pk8o9O/2j3QrJ03TZWiIliTJj+5UDgbZ+z6qR64kB7xIt0Anx7VnvM
	 oNnkW7sZHfHRgMFhofuCgiBElGROHRd+8Z/wyEA/6pT6a2TCfUOxRhsHd3fGYRir+abNN
	 4bsOajVXXnfCXtYqH9KKLnmosAnLEjViyeHhdZy+Wa7a378qRdaRHJ2ayhxWG3MgSxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gLb9YpG7;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dxwtWssD;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0C9606A330
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 10:29:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC0C9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gLb9YpG7;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dxwtWssD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793096978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
	b=gLb9YpG7t7aAG5zdrtnhvrwl+EWJbl8BAas3vnSQvE7RZFC1to4hrFJ2HzYEXlEd7BUFNl
	AQp/dEfFDJW0EhBTKWGntzjWOoRNCmTG3CAPNCoGP2WFDppFPrRHTHwVg7Povykn7MS4Hz
	YOoQJy/9sO9n4UL2QB3b4MknMrzEpLQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-eNEoHW89PGWNb2cuULtBsA-1; Tue, 27 Oct 2026 06:29:37 -0400
X-MC-Unique: eNEoHW89PGWNb2cuULtBsA-1
X-Mimecast-MFC-AGG-ID: eNEoHW89PGWNb2cuULtBsA_1793096976
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48b02d63407so2796473f8f.0
        for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 03:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793096976; x=1793701776; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
        b=dxwtWssDZKqDcfUvjOBCsmn0PcucQRYRIbAt8Wh1fV0QMQTdpZuGgq4/Tf/GVO68QO
         +nb/aEHWy2Jv9Cq+BAQgGSjMbTy9MJ1BrZi9pJc3ned/kdRxSOKYCBQgsRjLeSCS3pRI
         XH9AJ+MhN7jtNLIFE3M+3qVXbtEe7pA4Y6h1NrZw+N5jb4dA0U90FDMPwdLB7ZhM5Mpe
         hWiYyXArw2EnYHSKTAF8uHBuON9H7RuUkia7CHHLiT2Yqiut9Czp1De8zlWXqxt6JESf
         ybrDwW9lNmLFKD7OlH/MdIGTbJnBEzRS1EwaeCdRl8m2ifxUoLbRC9IENL0jPkq+/aBC
         Q6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793096976; x=1793701776;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
        b=SA64xu1W6pao3yTrNpAh71lCdUG9s0fw9h+9ta8gfyS2dGRyoXjSr45mUOw9Etb6Le
         xSqcQhb+nm3oMoKR+4VuD6JXmuGjv/seSocMddvB0E0d4ycIU/X+FvUoDjn9yxa9f+AU
         ZGhLVimLafY8Kq63ApxFgy5U04CMZPqyom2Ew4/QVEJsiUp/INLOgCoBipWDiE3luH4B
         77VPmSyuboEfIfsCVzYF1HdDyAjgx9IXnX1GVorYvQmbxepaD8bR6gVtoCgVfhGQWpM7
         d8mVqkCtz3JIViJVZK1rK7l1WFy2s2Df0wP7unNFOXBMw1XpT36fekQj+Ab9lzWP7uDT
         qltQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPjC34Y0j/ToT9qfSSYSlkFGQ6/uCsjrtwCUQcltyXlTp/I1r5zncoUAtNg2n0w2U+wsyu2pNDeM8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJsIMziDBRdvfowx+XgZgqHGT68cDNGiTxDpC8/RlRMVDE0dvYC
	9xnwkSsqpX/u8vymVlX2t+l2Dbvqyy0tqdft26leviapBQTIjiPSy4mTsDifYeGpXlQS2u57ZS4
	2goJQtvjYICkI3gdf0XRukV0qZNAh02ddu3exAwmzbLlxgDb0lmeHx1fKl4TIQw==
X-Gm-Gg: AYBFou0V/I16XDuxlk60cm6/kWGTZA0OFR3vn97YNMl8CL1+Vau7xYmrae3xJSqJjSq
	ECin350fr5LQEOxRZbXq4e4eli+YPCFRwpckp8EAWjWyMD2YQ/7VfjZ4Nu5FmiRIv6QvltUZc4z
	PJjs2o/11WcIa3rVQMaeOWkoeDrHOHNsINu7uDYeBAEH5YeVvSNTaVUITYjxG4LSPGnXggNz+28
	jEjz6euyyQrsENwgFUCOd/t/UpfivwK5fqW9VN5e1CEd3AcQZ185sd5xYo/y0iW8Dvu6ij+Wcih
	3EAodLjrT9Am5+sJtieubeQvGO9sz9E5DKSWuAmGrZlEA9Cdrkn8r/cIxZZkRd6E7UM=
X-Received: by 2002:a05:600c:8b86:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4a35acb17bfmr175618305e9.22.1793096975868;
        Tue, 27 Oct 2026 03:29:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8b86:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4a35acb17bfmr175617615e9.22.1793096975354;
        Tue, 27 Oct 2026 03:29:35 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2d9280sm254068375e9.13.2026.10.27.03.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 03:29:34 -0700 (PDT)
Date: Tue, 27 Oct 2026 06:29:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
Message-ID: <20261027051245-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
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
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>

On Tue, Oct 27, 2026 at 02:56:03AM +0000, Kevin Loughlin wrote:
> This series enables virtio-balloon free page reporting and memory balloon
> inflation/deflation in Confidential Computing (CoCo) guests, starting
> with architectural hooks implemented for AMD SEV variants, in order to
> support dynamic CoCo guest resizing.
> 
> Today, memory ballooning and free page reporting are essentially unusable
> in CoCo guests due to three main roadblocks:


For me, the bigger question is not whether we can, but whether we
should. Considerations I would like to see addressed:

Security, e.g.: does knowing which memory is free leak information from
the guest? If no, why not?
Consider CONFIG_SHUFFLE_PAGE_ALLOCATOR, RANDSTRUCT, etc.

correctness, e.g.:  Linux has init on free (and default on windows), if
initialized pages are dropped and host can not be trusted, they have to be
re-initialized. Is this handled? I don't see it in code.

Also, performance, e.g.: How much does this re-initialization cost?

Management: it was simple with balloon off unconditionally.
Now we are in murkier waters with various features offering
various performance/security tradeoffs.
What if some guests want the tradeoffs but others don't?

Documentation: for all of the above.

-- 
MST

