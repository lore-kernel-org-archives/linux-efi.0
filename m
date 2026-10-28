Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793217008;
	b=X/LMcAiJo9W99gSJThFi2o4YYnsp9trtfTV5tZIvghINcNJ4Bx32VgXdAn5PcGMoecFF
	 5C6ifnxK+FmV5pgzoYzcoDLvXXtr84iaNOugSQoGEGPdOaNrG0hAti+fIiBGnX3d4PRt5
	 qJSEHlk4DhIbH5YWYxByviiK7mDHzd6PdAXuLIe0+xtu/if7Lz4/clb+lkjNzkoPeCbFp
	 ZuvLOKhZ9MpJA64tIdEFG7XIz121ITH7+KGjQ8nNtZ8kyiTbqFcwAWz1ADcv7ictmU2tI
	 nGm+f2xl36boUW9LHuJzH5/xtfmJkUeLwLh2p3f90YOWAiPn03n2LseUSRZcyZWWtkw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217008;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
	b=pB/XbbzkXmqIqh9qqix17xk6X608pllKn56wi8aytWP5bxq1CVvFB1WH/GlAw/azQaZq
	 g1v9UC2QX6dDQ/kXLtsTFK1lGLN/Sf0VGYiQqOLlV5+abRz5IeZNllne9rR5UPQRwQAaC
	 tzaYpl1NtaShzC6HotroXqeQVbYAsPhKdwdcbFeEOYY1vasepaGXwKfMkNistnU6gplHl
	 JGOZCDehkVKz8QxAXYg/XD3gNzW43QIn8V0IJRWkxoxqgBHUiziQL7q/3lqZ0bgDif1gZ
	 MliCR3RFXkEyYhKROyT2gh0swrAIVjt3v1xYZCJsP0vVL3NwJpq88Waqpd8hw81/Yeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WBm+UY56;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9172D60A260D
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 19:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9172D60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WBm+UY56
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ae8607e8afso11331557b3.3
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 12:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793217007; cv=none;
        d=google.com; s=arc-20260327;
        b=ZQWJg8beahiCfynXjRnNbKwrefVeVz3g8oqCJXVWV0io2zRZnLpbmFW3rQcUIyZLXL
         nlebOQiUxGw7jjHzybPVwnYnXGrAKSdoRichhJYM0GwBBnt/+srghDW6OkOpTY1LgCwK
         tZlgHzz/0REWtW72qvDKhT9SSUnC01juz9toh6TsSOHaXVYtZeiCmYqQjrGMAQogN3qb
         AW1N684TeXuDA0i/yvzcnFqaTxc+XbDCzaOm61rglGrjjC6T4AZ+8EnyEf1ZW7eZ2mXm
         AUav0KyVl0V6IyP6yYwEaqTP/zYPh4qS+v3kgBReOPssZTouNaYwcjXU2qkCDn5FRewy
         /1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
        fh=qUdjd4LpEiJwotCeN6q9WQFybOzqeAn6YrHT4wVDviM=;
        b=C5fFrjJgcU6MIBO+qMEK84kXSUfdNxfjyhap3PqdSVgiIvJRMiAxbrQhmxSUGSDftp
         gHNMwWaqMy9vkfHl1acwX6yu8o4WSvcnU2rgjiF4JZ+K8R4m+Ua6GtKfAf+LrKTe66k9
         7KHrNsKxaob6XcpKR3tVJmxSeOi1aePcYnpgiqU4CaUlzRhg7LMo7eCN9CIvDY3ioF8o
         WFr5oTSLzk8Ly+dWUHihndT/a5fdU3V+x1ynRgNC4oOo5QOvytaDK276E0wav5Ztf3Nr
         L5/4n0nrS49FsnHM/AVYMdIsi0m+LeG3v4jryjx419o2bLd37scFP1RNwlEOWol6hwqB
         VoGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793217007; x=1793821807; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
        b=WBm+UY56vIEkNtDy915I1PF0XsgX/IQCI+LijgVrlKpAuMGNBzyNsWakaYIOIyP8+H
         JIdzuyY0VKHP+X03mBLYr6j/erNyIWp35QmCYRHAWoKirv73G9haV+CnZbWSzzkzEC8L
         zizmh8WZw3bUNJbsUee7INy9gZNdKAvewIjtN8JL3UWYcA/kS+Y5UvQeXWwmUCTTB1xY
         xI0HUDruSC/K9DYlIz2qOCZjfyzObgFJIY2r9DNQcFUWaw7HqRy9RAQJruTwlrE/9AYU
         HS5TDiwdIXtRseXeWisufkzEc/lo+bBdD9DeBbIbAzulGNuRK2Zl9PpdtK7aItatOrlj
         KQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793217007; x=1793821807;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x6V0ut3kqKgQIto1YCEH+vR5sKEvkw9wBhgLEXh9NNo=;
        b=qljLU+aZCsNQLVNuYMdLKFEPr3S3TvGRsym5tOrF94OuC5k+HtPNGaavEWWCVwNy9D
         a0iw8LSQTQESbJZRkrl3dtwm16Pz3z3gN/ax3qbeTN/LrWh9N8RWeI1p6KBg8a83vu51
         kRXiq5n6mTUS0Q6rRWttWSNohBmaZf1Q/ZguCvPoeLr1DmZT2sRHRXLjBt9qgbwcDBl0
         REzVwl1APwXzKgyt1sHoUlYhIcvsbirbvnkzbZWkRmq5npUEyiObvsSaw0/X636Wi47+
         VsCTGSwr1DIYVOAM2OmCIhzutkMUs8Zx71y3uVHr/j0eNgqAXq8vQL4L7Fyep+g6Oi7x
         hOFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMVwZ9LeUHbQiMcrLDvxONAj6R4th8Oe5xv3qhuTRx/Ytr5W8lEeD7oyJpLt8nUEXW+47L8mxEUzo=@vger.kernel.org
X-Gm-Message-State: AFq9FYKbKcMHzfawKhyKgOaQjaSbit/cJkH+V6wzx23b5226Rs6tmsnn
	j3kWaRoMUsCyk2pvW3CsJZEO8/ohVcsERQoPzZFQM+ovfOCQoO0OC7F/SIPSsJ/PFrgzMqTVWc8
	fciSeO2IL7HUPXgEBSBFQHzT8dryOnkQ1XIPFhvDF
X-Gm-Gg: AYBFou3Gg+gAh81N48hht7+x9KNprzPr8CZ9qF9RExrFbPc9WECKcJf27s1UU9FQvnd
	o+ljjSKge4iQM+hC7oWf0JX49yU+34/+ukZwTxwc2CFXwel6CmHsYG67zn/zvRM5uggXOVEyrPA
	mAc/pa0y73k1mha+CTrR/ry1x8XcplaRI78hmWPQtQ5LAH9vZkBupkhrpNrQEUCKWCRhAh+vlCn
	i6ccfE9G9320lGZW5rFUGIixodo6QaUT9sRMxLsja0jk2jJ4rr8E4EmfHvBvJ+5BA55Y5rUejXU
	9HHI4otMPdNsCyfJxMe0aHwv7LlvAlUThZaVKfRWiXyqpJWFaOPIuk06mLVFUvoAa5pHAG1DnjB
	g4rCDxHmSqU9BA+RPMHZ6Asi1Em7r7gHQoP7qkWd99yfXKfcGTn11Y/qz4VVd31rqxg==
X-Received: by 2002:a05:690c:498f:b0:8b1:a485:dee1 with SMTP id
 00721157ae682-8b1b5e870f8mr20662047b3.62.1793217005584; Wed, 28 Oct 2026
 12:50:05 -0700 (PDT)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <279a92da-772c-422b-8047-ad37dbae211f@kernel.org> <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
 <20261028145316-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261028145316-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 12:49:53 -0700
X-Gm-Features: AclHuK-xGxvCvL4otBtvefj81uI5MhPmhwclIN6rdpDM6CRLGOUQBZrCbVhrSfI
Message-ID: <CAGdbjm+4Jqx8Xv3uvhgaaiThYuVT0vF6UGx83XUku04Q_PN+OA@mail.gmail.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, virtualization@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidharth Telang <sidtelang@google.com>, 
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jacky Li <jackyli@google.com>, 
	Steve Rutherford <srutherford@google.com>, David Skidmore <davidskidmore@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 11:54=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Wed, Oct 28, 2026 at 11:12:47AM -0700, Kevin Loughlin wrote:
> > On Wed, Oct 28, 2026 at 2:01=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/27/26 03:56, Kevin Loughlin wrote:
> > > >
> > > [...]
> > >
> > > >  mm/page_alloc.c                               | 248 ++++++++++++--=
---
> > >
> > > This diff stat should give you a good indication why this series is n=
ot acceptable.
> >
> > Got it. I will keep that in mind going forward, especially if I end up
> > attempting a v2 that simplifies things.
> >
> > On that note, I believe the majority of the bloat in mm/page_alloc.c
> > comes from...
> > 1. supporting the legacy inflate/deflate option
> > 2. introducing support for various page sizes to be unaccepted
> >
> > (1) I can get rid of by dropping the inflate/deflate option, which I
> > think makes sense given free page reporting should be sufficient to
> > enable dynamic guest downsizing in cooperative scenarios.
> >
> > (2) becomes simpler in part just by doing (1). For further
> > simplification, we could potentially restrict free page reporting for
> > CoCo guests to the current 4 MB MAX_PAGE_ORDER instead of supporting
> > any order 2 MB and up. There's a trade-off here for reporting
> > effectiveness under fragmentation, but perhaps support for 4 MB only
> > (and its relative simplicity) could be acceptable? Especially since we
> > would then maintain the invariant that all pages on the unaccepted
> > list are MAX_PAGE_ORDER?
>
> I'm not sure what is meant here.
> But if a lot of memory is free and it gets merged beyond MAX_PAGE_ORDER
> and then it's not reported, that's counterintuitive.

Sorry for the confusing phrasing on my part ("2 MB and up" vs. "4 MB only")=
.

MAX_PAGE_ORDER (order 10, 4 MB on x86_64) is the maximum order in the
buddy allocator, so free pages never merge beyond MAX_PAGE_ORDER.
Today, page reporting logic scans from page_reporting_order up though
MAX_PAGE_ORDER.

Accordingly, what I meant is:
- Currently, upstream mm/page_alloc.c assumes every block on
zone->unaccepted_pages is MAX_PAGE_ORDER (4 MB on x86_64).
- In v1, I set page_reporting_order to unaccepted_memory_order()
(order 9, 2 MB on x86_64) for CoCo guests, such that free page
reporting processes orders 9 and 10 (2 MB and 4 MB). However,
supporting 2 MB blocks on zone->unaccepted_pages required generalizing
mm/page_alloc.c to track variable-order unaccepted blocks (Patch 7),
not just MAX_PAGE_ORDER.
- If we instead set the CoCo reporting order to MAX_PAGE_ORDER, all
MAX_PAGE_ORDER free blocks are still reported, and we keep the
existing mm/page_alloc.c invariant that every entry on
zone->unaccepted_pages is MAX_PAGE_ORDER. The trade-off for this
simplified logic is that a standalone 2 MB free block whose buddy is
in use wouldn't be reported until its buddy is also freed, such that
they merge into a 4 MB block.
