Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211180;
	b=lEBF16k0PBsJZ73PRC9ObmYQ7wY4j8p0q7ajBLrMd9O72Ds3HguPLdbpEb3qXrbz6FNC
	 vaiJzFOm/38FnB3LEoeZnJE5xRVBAWMjF2Ar8UNQt7cYlvNm/QBggNvYki/UizRmyeNYM
	 8cFD0Ss3HEq+kl2vLkTafA4schL/IRGYZOFLoL+nd2rQNdXeSZIaI5FmQi9g2Yjcx0U4z
	 R2P3vTeaEOahA+Y3kIA4HD/OUMXZgQWbagzil75bzIkTPvY1YNH9iLw9cyok6yTrmtEb0
	 d8QWhRUfqtivqSnLgG0biNq3SbTcPRopEzTPx9qV99JLghxqaG50eY8n4zqCr1rlzCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211180;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
	b=joj8Gwz7wdqhd5ajR11cqlAyN27cR/SceeGAibHXJysnRNXa4pXm8ZsVXkdNNKVdscKn
	 CfBVeH4FtX0vNHq6iFsljSoBsHN43X7WHpxbEs4414rMNCCjTW5tKdXk/oIzREMthgl2h
	 e4sj/w4wvqhiFBb6/D6Hwc6FHBzM2jSc56SHYLysG3rwc5SG4TErszNp3Hr+uO72VJxKj
	 iNYFhmah92TxK+sF/Fl6QkqUPbiYW093IJtD/DvfTP5aarj4GJVzXPBpKVVgt+k5ol+xc
	 an2VWGykQEovcT1vAPsnWNUM+4r9FcILCVbbjKPrNqK6HYTRhf9yiCPr/kh2Onddjig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HIBoTpnA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C354760A3826
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 18:12:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C354760A3826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HIBoTpnA
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8565d77c277so12062277b3.0
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 11:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793211179; cv=none;
        d=google.com; s=arc-20260327;
        b=A/OIo+PhhAqK75OP/xStCmNEmKD8XSJU8/ZuDqghZEKuuLHW3RtgiYdjkBtbtJw4dC
         ZijEVNCqx8Nczvwme0dJDz9w3pQ9XUsteWOt9Me8h9v8tEaYnH2Mv8iwfVSq8BPn5v+p
         9PTqE8QWI/0plC+fcoSx3bcBAfmEKsw6SXQ23Az+1n+FfxesRm5m/76cpBOdRGnh23iz
         arsZUMtWBfIws+i6DCutVU5QIj0qnw266so8VrUgx+3MaNMmpKjQMHU+l4pSkt3jT3QX
         oiYdR5pSWx6Cr3phUMzyxDoz27Q6l8t/+7UVsoINHwBsUYlHRzKP/tsvHxYAE0pF1Lwd
         1lSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
        fh=JmvDQrNM5IntMNHXXR2nz53BKG/sLvUfbulur+AVNMo=;
        b=cHGbcFtQtA0P9+yEDSg5gMr3JtTnLcBrtrsXcqLOODOWVtsKnY2ThP284nIquP9krv
         K6NFBhojW4Tlv9/UVd+3YAPnd3dTs8aVQXKYKZNbCfkKzy1gY+G23uYdzTClu8hpDIac
         isdNj4cB0+O/9cTPDVRA/UVuSrQ2VKrSqaRTnGEYd0QOVNOAwwGKK3kSkAFePh0YXL4V
         R86DTup5Ff+TKhvuaolBe6nIgh1AonXgc6xCu58X9gWbqqYQ8DUUPMVsXIcn0rYZMiDc
         qWjIxpXVQKAe3rHAYtBJWxgw+wZSnw+Zxc+qfLdmUdEU+D1TOmuZFuVMpToDy48cTS77
         34hA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793211179; x=1793815979; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
        b=HIBoTpnAvU9mMFCmmSFVKRCFAd659KMsW7tTEnDrrCYuk9Kk2KrpYcvGJMXBp5yYJ3
         FG32/WC1xU0d8/1XEk3ICK8C+q5UqKQoqN5wi38+6NCQdz3qVZN5PjVRED3lJIE2PLg9
         OwAdptAebOFSdCg6RQF/8JpmdTTGs522Iy3kLNSc4QblZphhsOVaQzZABe9BbMr3O7Dg
         hgoALtjUth0N9I/4QptPdUJtpEPLTLEEREzfobo0x76M2nuTycjZfBg3tq0V7bu5Dwz3
         cIxP31Rg81WI0ALjRpZyg2iz6jlWK/028Hh8lNFFQjtnaSPPJ9u92lFtc3c7swQaDpJc
         fbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211179; x=1793815979;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
        b=is/UHlTvTVbmdjiB9Pb1ZsdOiquPO9/DRMVDCyDCPB2TTYRZt/hXSmGhsB7EnYmvCB
         zQ8wgE75B+MLyoDHXAmxy7GXSazJJgGsV/Du5IFoD/oC2A/iUCeb6Xj34aWOI8QLN/jM
         phyBGPBwu6bEm6uTHFp/b6t/h2qzBx0kdU7E/brjpllHGFAXxkTbaaZppXVNX8Qd2sHp
         PYGrYT7C+2q6FoQwbwQ7FJMqP75xDiAtZNKw0GXL+nYz5wC8UMh75jINDTjo6Vmc0u98
         QRm5VYkQ5r6CXRnDzfIfI3eqxNz3t1wL3soHOnGC+fXe0Ekn0+NkKJRlKTDSvLCZZMeC
         AIvA==
X-Forwarded-Encrypted: i=1; AKwUvBz7sCj0pT2dMs7WfbX8UfrATUdqQcPcGAdO6mghLVnHcQfwTDKWFZkbY8IQRoISe5yl0Nb98PqTjUg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKhbeG+ojr77cJd9txS6Qy5bTbCIz1QbKBsfAnJWCWMZoTw9vPN
	h/VUwZ/7A+go5ew3LUkHiiY6eVHAlQ8EyDaeeV9qihEJ5UFw7JfTvtUNgY7vj54+S69fFZhF01U
	U5kmqJppL84KgBqmmYIXjMnD61V+Sw/yZ2l49jgZm
X-Gm-Gg: AYBFou1GFY9wqTlaH8f+93JPUTLzLQYKUWuSCweS0hYW8BtGCDgU1ZRnQ90CvF/oLzc
	YbiaFPmBPxRdE/HiMLscyJP1W5Smj6FD4qAKXMzCpIv1mIIvFG6FNwEb3+Vv8Pc7NuBic3aTria
	2l756SYJbOENZMhjiJ9YAp1yBufga/iJfTRTOyNv/LI0NwjThvORKdjWlShL8Cy+/Pl2btmx99y
	f5ZnSQVpCjIm3dMBj7H8TfpzTGBILYerZWi8JtWnLbBvW2eH+mR8Xj7oO/m0xTQrMd97mfSqLVc
	srH5z9fdEq2gcLT2pAZ1GKRxT6hAw/AuuKYpNtRJfgaRKgyVZijVkKfhW1Ll25Si2EWYZH97bHe
	ZuOHmwBRfsZAg1qS+j3GvFo93fpXva9UT2C6WFsxFx3AkmxKE8R9hmcT8C9vZDa1sTF4=
X-Received: by 2002:a05:690c:f86:b0:8ab:436f:6e7b with SMTP id
 00721157ae682-8b1b5e93e9amr21228787b3.63.1793211178194; Wed, 28 Oct 2026
 11:12:58 -0700 (PDT)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com> <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
In-Reply-To: <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 11:12:47 -0700
X-Gm-Features: AclHuK87kmeri51i0i8SscXVJiPFVq3oTJZMZ4FP6A_jqbPgcyRklPs7gnicX7s
Message-ID: <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
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

On Wed, Oct 28, 2026 at 2:01=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 03:56, Kevin Loughlin wrote:
> >
> [...]
>
> >  mm/page_alloc.c                               | 248 ++++++++++++-----
>
> This diff stat should give you a good indication why this series is not a=
cceptable.

Got it. I will keep that in mind going forward, especially if I end up
attempting a v2 that simplifies things.

On that note, I believe the majority of the bloat in mm/page_alloc.c
comes from...
1. supporting the legacy inflate/deflate option
2. introducing support for various page sizes to be unaccepted

(1) I can get rid of by dropping the inflate/deflate option, which I
think makes sense given free page reporting should be sufficient to
enable dynamic guest downsizing in cooperative scenarios.

(2) becomes simpler in part just by doing (1). For further
simplification, we could potentially restrict free page reporting for
CoCo guests to the current 4 MB MAX_PAGE_ORDER instead of supporting
any order 2 MB and up. There's a trade-off here for reporting
effectiveness under fragmentation, but perhaps support for 4 MB only
(and its relative simplicity) could be acceptable? Especially since we
would then maintain the invariant that all pages on the unaccepted
list are MAX_PAGE_ORDER?

If I can sufficiently simplify the changes (especially in mm/), do you
potentially see a path forward purely for the free page reporting
aspect of this (dropping inflate/deflate)?

Thank you for taking the time to review, David!
