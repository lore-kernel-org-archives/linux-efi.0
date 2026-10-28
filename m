Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213671;
	b=C0fqYj7/y/LWRakYDuklNQSnTU7/V334x8qZ3JMZ8PeXO/ePAGv17vNIHYhoe2LysFt9
	 j7/XiiBn5ekM/II+rXA9XcJmFYr+qxoYA7PyGIlGG+nBzwpD9Csz4g0GjbNqYbYZwOg9h
	 nOWFyzgppK/2mBt3ufwVZT+VxdPlwguW+jBxETK81aW4v/pXyDTqwbDTQz/mS3YN/yyXa
	 Dbamupexul25w9hdcYvRmc7on5CvItzKRdk9mLEWWPIUG+F4KqAnQloNcKTeLS6WWSlm3
	 XhUqp5EXoYjX1TSoUI+nRIrEAcrMcHi3CTFKCZFOIKZjYsbMovlLC7DvJnzk6gUai1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213671;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
	b=P1HtY/R9Wr6H712jBLu6nXLsUqZyIC1uc4reOfrsbTWIW0Zwy+Rf4+gFNiMGEXY4+Vqz
	 lBPqc+nKFZ4ngvabyhrZSv0eI5cnEhz7Ijxik3RnvvEAiI/gPVjL4AX7X2rg6M7w+5nzl
	 cozggVFssvlqzP68Q58G7Vf83vvpKQawqRUaooI9R4qTL52BUAf0Cc1sUcy2nhje8jLLx
	 rF1CfEUXxBuuimLftkXVaMiZ1/8yoc+hh8z9SAb4NJ1mtu/MZP4VXLCEMvloC65SjZSf0
	 BQSHVuwsi79K72yfL597BLmaGc+dylg5yZhXExuU5koIyoRI1jqFk9pjc6SNx//Kh7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S6UPL3Lu;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=c9fjvsd9;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA18606A31C
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 18:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CA18606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S6UPL3Lu;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=c9fjvsd9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793213669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
	b=S6UPL3LuEu3t4EP+SqZsdOo3Pvkl0B6g2qFejBlIJUviQ/xF46QtqLiXZOEaMcknm8SSZ2
	Yn9WB/zFQRiZO32+5GgxOvtqT4BIgd3INuM8tiPcg9+F4vLN9FS6D/TyZlp5exbqUndJ9s
	gvcf8oGoZvkCw+mCjARc7irlZEq9zYY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-Smmw3aQmMX-S5558yreHLg-1; Wed, 28 Oct 2026 14:54:28 -0400
X-MC-Unique: Smmw3aQmMX-S5558yreHLg-1
X-Mimecast-MFC-AGG-ID: Smmw3aQmMX-S5558yreHLg_1793213667
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so10239435e9.3
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 11:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793213667; x=1793818467; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
        b=c9fjvsd9b+OBbDCvEHn6EYsSMMeKxHxDwrYIf8VIBw++7QDXBC1I/5UeXjwqYjmWqp
         +tIJsFOLMSXqbxLSZQiE/9Se8/X6KEhsqNgtE3NwQUTnrs2SVKMqIuO6tLAzH2T2zvoU
         Wkbt1QT1vlPGs31QUbtwTmU+f5caR80TrmYU2WaREVPB9wgSGcUf/O94a8hQyalXAUIv
         krPZGY2l8la2hueLlutRt6EO+FQRDjkKrKMv+UnJgagwUM4x0/iDeCA+hsAfuji0r7Yg
         SY7ACyleHpO36jEYkUqAi3H/oIcpvMJ7P4R4gwgu4jwZhFGTW/FZhTSqHE0fHb1gIMFY
         fghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213667; x=1793818467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
        b=KFSdHUGCYxQl+mFSjtAxPiY3J9og0JGoFsT599+vZYdrvThb6g5vKKnwurnHFoEv/R
         9rTPQs2C7EiSDMMjBUHiwIwa5i+hqsdqIbO4xZsULvpYkc138kmyE9bENgxfeXcBDGt6
         aEwdeEhxaaTCjdOeOa5B7inb6V4Gz48HXeChThq6LDfEmUg4LdWjASdHOIHtfGZoD8rl
         CfKUMXxuzyU6xRi8B7u2TZ1lJhC1Cxrt7D/Np2sdV2G1xwUfts2NGegRWtOeJlsIhgBY
         fP8Mk+3m6TOVrmvHetL3CsehH5SjISERBZenZi2He4mT5VMz1e52yw/qixsts7u0a1Zv
         xXWA==
X-Forwarded-Encrypted: i=1; AKwUvBypzG+5i43OH6PQNj13SIyfHWbngdomU1uolafe+0QK7+rWQGNEbwmXCYw7hjcbaRMaUqpyDl13vgk=@vger.kernel.org
X-Gm-Message-State: AFq9FYKJVqjF8rlZPHmg9GDV5rskSZcy6KDpWGIrd0z3zh/oPxENurvg
	2WIoFes1a+ouLVootPPkFNP195tkgq8xwZaSGvR5EmOze6YFU6JpFSXaul9PWTlkQR9pyV7Z5TJ
	H6j9lXQfBIFT/7dK/Ym0CTKi7JBGNvVdj8nNtB4FHdbtt7Q2wwf+S576tS+F3nQ==
X-Gm-Gg: AYBFou2Ql1vMsr7V1mACwTD4fq56/QAtXNv7prPLUG0WcxP7sz73fQXoaZphKExEUUe
	t3igNYSiIgPtYCEOQ53gtOzD0F8vADnLh5nfQ6xR7g1LaNHHG2A76DmJ1/N+fcQuSV3yCtGLf1G
	nE+CZkNKVNkTcoDicQaYQM0yeTsxZD8xK3hgzdnZOvpW4e8MOd1RsRltjAZFE9yKl+IkNExkSrx
	y3gNKCanx/oYS4twmEwfvhSXXDJaKfac0j2sCMyEcVbbziPvvaoc3PpQGag//sImO/Q5Id4rjdD
	qQOgvwOWjBUej7wXvULNnMOIoiE8gJ+pL8wX71/YUBRTiB9X8sd3JlOiiLwb8zar0+3nRwBBkhF
	R9xaCA1rIr4cePCyXYFnqJBIh4kATdwIGJN3woWgO
X-Received: by 2002:a05:600c:524a:b0:4a1:efba:511 with SMTP id 5b1f17b1804b1-4a9674e6bf7mr73578465e9.35.1793213667411;
        Wed, 28 Oct 2026 11:54:27 -0700 (PDT)
X-Received: by 2002:a05:600c:524a:b0:4a1:efba:511 with SMTP id 5b1f17b1804b1-4a9674e6bf7mr73577935e9.35.1793213666877;
        Wed, 28 Oct 2026 11:54:26 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04785sm10398775e9.4.2026.10.28.11.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 11:54:26 -0700 (PDT)
Date: Wed, 28 Oct 2026 14:54:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowangio@gmail.com>,
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
Message-ID: <20261028145316-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
 <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
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
In-Reply-To: <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>

On Wed, Oct 28, 2026 at 11:12:47AM -0700, Kevin Loughlin wrote:
> On Wed, Oct 28, 2026 at 2:01 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/27/26 03:56, Kevin Loughlin wrote:
> > >
> > [...]
> >
> > >  mm/page_alloc.c                               | 248 ++++++++++++-----
> >
> > This diff stat should give you a good indication why this series is not acceptable.
> 
> Got it. I will keep that in mind going forward, especially if I end up
> attempting a v2 that simplifies things.
> 
> On that note, I believe the majority of the bloat in mm/page_alloc.c
> comes from...
> 1. supporting the legacy inflate/deflate option
> 2. introducing support for various page sizes to be unaccepted
> 
> (1) I can get rid of by dropping the inflate/deflate option, which I
> think makes sense given free page reporting should be sufficient to
> enable dynamic guest downsizing in cooperative scenarios.
> 
> (2) becomes simpler in part just by doing (1). For further
> simplification, we could potentially restrict free page reporting for
> CoCo guests to the current 4 MB MAX_PAGE_ORDER instead of supporting
> any order 2 MB and up. There's a trade-off here for reporting
> effectiveness under fragmentation, but perhaps support for 4 MB only
> (and its relative simplicity) could be acceptable? Especially since we
> would then maintain the invariant that all pages on the unaccepted
> list are MAX_PAGE_ORDER?

I'm not sure what is meant here.
But if a lot of memory is free and it gets merged beyond MAX_PAGE_ORDER
and then it's not reported, that's counterintuitive.

> If I can sufficiently simplify the changes (especially in mm/), do you
> potentially see a path forward purely for the free page reporting
> aspect of this (dropping inflate/deflate)?
> 
> Thank you for taking the time to review, David!

