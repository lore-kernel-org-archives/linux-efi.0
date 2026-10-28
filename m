Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793202008;
	b=eDW355eLR3dT2NK7wZ9Q++LUoGXDG1Szu7Opg0/efPYV/2cmxp6kUL6y5e+SqkBqRNJZ
	 DV2KZMWpf3/5F64E1JHuoVmj3EtBsoQcGXA+UbaCTj4vip9VPj3ZtqtWSjjZffpSgcQvV
	 HMkR//aZDWLbwbQpM1jwal6yaQJBJnTfCCG1H3R+f4/yVQVJ7FqQakq5G4vhlrOvxOjyC
	 UrQfnCG9Cfs/J6XwIXC78Ip3zm5AQvH73BCTBtKJGhiyKl5tCRDOQ5ocYz0b3D0IfmQuJ
	 lGZ9VhaUzb/n11uxfN1r2AENZmgu5/E9qQ2ggRievTuQEOZJdY9abS0ujUwf3Q7YYdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202008;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
	b=PWkCY6EXomGVKUeXo6nTkFp0cuHuEaXSYX25QvUyxNYWEcnU70/5H/EfhArXhRJKZqy8
	 6CoxxyK9D80ylk+f+azdkoJfsPvbKc1n6CXsQTlqdknCzstRZXs20bYMC1HXOV8wMMzzz
	 m7mQQ6U3j1J4iQkUsWxotmsiGavn48k3ksWTCQiESjWk/k357P7U1jmS82BZe99nsPT3x
	 8/gEVAJ1EwFdeuTVZovedbBKBH8z39Ewjw6p4Pw6L1mJYkujfRJaRionU403Qq9knoebO
	 1TA9em6YLwH9h4Ze/ZIC9tbGYJxQbOaK80VgeoXzzlAYhYfL+k1EgeD0RWxGaMUb3rA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lzrv5baS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7263606A31D
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 15:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7263606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lzrv5baS
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c46d41f6af3so165820166b.1
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 08:40:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793202006; cv=none;
        d=google.com; s=arc-20260327;
        b=aj+aX83WTU9eiGoZXqK6C8IKvYcDQVSYpuTZJVrpdsIcqGOVCQgPmQpDl5PU4LSlrv
         88f0ttc4hlSQcs+l75hNoE+iM6hwEBccUt84ry3qhJrCEh4aec3InkURTDQ3KRYcXhjE
         Z9pYLp2XW4EX3Ja4jQBzOd/KHTIigc+R9VlgjN0gu3cbtcQDWp4+kZ5mzN6Vr6gY235g
         IujokTAVZTnj7LlA/ZaDf6MFKpxDVnsa8MBaLgcRMMFqIVesHSbadStuxwUlAcU1VtS1
         an/1/jr7yK53xn5d2ciQIiOKrQEUzdqc1k9FBeU6FnewxyHw07RF/DZB3DtOyGWBJxKA
         69zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
        fh=JqctlGlX52h/vekLmd809xbQlKuSW+FuaiEIZ98GM9Q=;
        b=WwBKYOL2TTpkWZ6UIu3thKQplKnFwYOdLnMPWToFjG6Dnh82nxigr9Rfd2N7LcZ8MN
         Gzr55WdaBuVh2R/V+uTQgbOQRse4S31DgV+nQwpFXlDeqlmaJyWIG0wn8H3OF1E+JOvA
         7O0OUfxzoIH3OqsUZSuLpqpfREj4R+JYZykpBzayJafOM88P5UgKcuPfNtrAhsgSbvj5
         rRBRko4d7nrgZyr8XLeGCcsmACyD91H9RaS/zR/ehaTtp0OyYFSBrwPPYrz6SRULZhMI
         r8hPcxBElF2bJEZHTAL+3eS/DwkGT9D53qpY3gVLbC7/YKKt62pPPpLUuA4h+EL8eCn3
         udJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793202006; x=1793806806; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
        b=Lzrv5baS7hZO56ak+j11CZOpo9nSwSzqR++f9YLzcEmSTxWwZQFwBFUDMJCR2ak458
         4zMWtmZpd7fl6+iHDAzFDsltCruFoM9m3rKAF1nbPQ38QQ97sY2Oupi3jTQRUS0z07kY
         /4Z189+g74DrIJpLSPIaqW0Bv5NK/A9ybyIm4LoLz8S2Dg6JPDCBW/twsdfd/BstNY1X
         F0WE1g9ZDMJ4pA1yfDaNgvWXRaX4rRhgbH2DVsxdAtmw362z1jqaE4q9w2rVRSV1bYNz
         pdw0GNIfu1bkawf3pNYOq8fyug2JYA/oXfjTKXh6bb7aKySduRXo4Bb5IJ2R/4FiPFli
         vAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202006; x=1793806806;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
        b=0uqKqDjCc0KBs1ydkxnKKFKTnzEH4id6hP7NFk/SZb0g9Ysh8rPAOWK7H1JyzHjELh
         pkaKnCP0voAbG7f77zmsflZZAb4hujjyRzNp1L7DWUA0HABWX0oJPrizQydQqi2OrFFp
         JQKmH9qx8ZKgfXtWQYc8djMU3no/CyDmBh5/z58FZ+ApBkY2xkDBYikZqVCA2kes1+oC
         iax/86TdnDZtz11xw7FfNzJCZc8tX28b5wbsaa9UgSKeuksTYRxaTgSWyB8VDQ+3nXPq
         cuyxZM9K07aofBzxS+/u7Xs49qrXXntKwujsfvbeMdZKR+G9LBGyVY2aubaGafsRsx/W
         vPQw==
X-Forwarded-Encrypted: i=1; AKwUvByMBC+RaphX6w0LaU+dR+OMqeH3o2Pk+6tOhwKjadrYutsADI5rsVEiR0uQWt4L++RSRN5Kejifmmc=@vger.kernel.org
X-Gm-Message-State: AFq9FYL+xC+21Grto+5Hk4XZVqTpaLGZWFL2XhB+JcYi/yMtjDU0yljh
	pyzIw4oKjmGBWeALQe883mSItFsiXF8+Cj1M9SuI3zU+mP9BPa/lvJ6MTcr8U7sBhKU3E2JTfSF
	TW01buRqr5A+aUuSHYDQdqi9OU/yip8v/l61oLRza
X-Gm-Gg: AYBFou1/li+/jCskoVurpCZnck5bBBQzz1iWS1ssPWY+gj1H6Xb8mz2exIOfEsciGhD
	NTcF52jhT0dj6wFepFQAYTAkkVvWl8x/MO69B3vZqB6h5LX2YYiadWzluUS9ZuRh7oix2PmCs3J
	JyCnyXMwQOjr8iheqvucrG48UGe6alV7mKg48BZnSqmd9sEsCXeGmrB8wJf77LkTo6EdJifgjCV
	UdIuu4iqDlGM5mLrur8mygUubzSaMuNxBhEVfPI63NOoMi5nDk9h0yhfF4LDJGhfDfCc9kA58eM
	9Qpy4c1mZIMzDge8OnTXChn3uyzuNYFrMe6OzUSmgYAUTeixtbPE6Si/QsMdxTm/bD3RVtCGjE3
	o86q94GrKUA0gtRanaOOaBZGfCfoVmH+od1MMseW/Zcpm9mTcZP4IlPWe9TgscvVQ3g==
X-Received: by 2002:a17:906:9f86:b0:c41:960c:8c62 with SMTP id
 a640c23a62f3a-c49bdfecbf3mr243566066b.30.1793202005586; Wed, 28 Oct 2026
 08:40:05 -0700 (PDT)
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
 <20261027025616.1632690-11-kevinloughlin@google.com> <20261027052057-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261027052057-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 08:39:50 -0700
X-Gm-Features: AclHuK_MLzRdQo76ylDi6PC5wwAQyJcXzBectQ_iPw892kOlvxApU7OSZmy7jAE
Message-ID: <CAGdbjmJjBp4WPqkWs0KNLpH2ve+Q+y26yOg1PO4TJHwKfu1uZw@mail.gmail.com>
Subject: Re: [PATCH 10/13] virtio_balloon: add higher-order page inflation
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
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

On Tue, Oct 27, 2026 at 2:35=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Oct 27, 2026 at 02:56:13AM +0000, Kevin Loughlin wrote:
> > In confidential computing guests requiring page state transitions,
> > unaccepted memory tracking operates at the EFI unaccepted memory unit
> > granularity (typically 2MB / order 9 on x86). Inflating the balloon
> > with 4KB pages would prevent unaccepting the backing 2MB unit.
> >
> > Inflate balloon pages at unaccepted_memory_order() when
> > virtballoon_cc_needs_state_transition() is true, while retaining
> > order-0 allocations for non-CoCo guests and CoCo guests that do not
> > use unaccepted memory transitions. When a higher-order balloon page
> > spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
> > transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.
> >
> > Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
>
> I'm not too happy that this rides on the legacy PFN thing
> which is after all limited to 44 bit addresses.
>
> And given it is passing around 2MB chunks, then one 16 byte descriptor
> covering all of 2MB would actually be more efficient than 512 4-byte
> PFNs.

Agreed. I debated initially doing this in a single descriptor but was
trying to avoid also needing VMM changes.

Regardless, after reading yours and David's comments, I honestly think
it's better to just drop the legacy inflate/deflate and only include
the free page reporting functionality if we end up adding some form of
CoCo ballooning support. Beyond being inefficient-at-best here and
potentially making fragmentation worse as you noted in another
comment, the legacy inflate/deflate path is the biggest source of
bloat in the mm/ side of changes for this series.

> > ---
> >  drivers/virtio/virtio_balloon.c | 87 ++++++++++++++++++++++++++-------
> >  include/linux/balloon.h         |  1 +
> >  mm/balloon.c                    | 67 +++++++++++++++++++------
> >  3 files changed, 121 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_ba=
lloon.c
> > index 11f74848fdc4..d162c162b496 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -182,6 +182,13 @@ static void balloon_ack(struct virtqueue *vq)
> >       wake_up(&vb->acked);
> >  }
> >
> > +static inline bool virtballoon_cc_needs_state_transition(void)
> > +{
> > +     return IS_ENABLED(CONFIG_UNACCEPTED_MEMORY) &&
> > +            cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
> > +            has_unaccepted_memory();
> > +}
> > +
> >  static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >  {
> >       struct scatterlist sg;
>
>
> Put all this, and preferred order, etc etc in kernel core somewhere,
> and expose some sensible APIs that devices can use.

Good call, will do.
