Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793201944;
	b=ooKnwMobrVYtgcaHDXMNKc1+P8dPTGFUgrgqptrwYpOo7U1W9YZdJrmaDUP4kB18ok0r
	 OQZa3y63OiJhsTR1Y5qLs658HBqOkpxbf/7ybmFDbTO1GoGTq/c22po//dEg2fx4uaA5L
	 rCXfJ5lZbUtRsmo7gafov3d4Gd1yr7cjaU6eMX4kjbccvK6e8Vf4Xw1GmSe0lPqXP1uAh
	 IroT0hawGTozFUHuELhoZYfthrGRxzaUJpQoNrwQF9dOMEwo1s2xd/vwFbdZqauQrl5Fs
	 0qVwpRr9qpx9DxQl8NA36tdRI4mWvvBnwqnEHOJtPefMHnnhhOh0DfCKU5HrjI7CiPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201944;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
	b=bC3yamsq8T/zN1EbPRRwQlz47PI7qWIiGOHFfdMg7qIOScjggDQmv9msDtKzqcEwoQZv
	 1KBcbm2WMA67F7mxHPrqixCoL/i0BLPCTtt17NhoQyq5J+DgBdxCsIT3joxj6YBpwrqEf
	 KqcYcC3ET7ZTTAJTALJzaR6dCJ//nfXvYxhNeQ6cyijWwBU2cqdlcC/Cnd+frgNQadGWZ
	 Oqj/qyneBAvQFnPeiuBj1bBHjRSVpLGWOX1gzuHQqlS/R1LHMyGWrtoZq7slexqBR43v9
	 OU3FF22ZN3VAeNfoX9RyTG8NWz1tojlI+yHOCpmS1S45x181AYN4Up1a695uZEN54Kw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Jo/hfhVR";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F61606A31D
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 15:39:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65F61606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Jo/hfhVR
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c423b145922so156941266b.3
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 08:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201942; cv=none;
        d=google.com; s=arc-20260327;
        b=eN8IdW8lsqp5Y1aEiFYdqIw4AV7GPcP6LRyFyES8nskTYn8iQCDafLZ0vc7u30Jiem
         /dJf0c3NmRiXP70QnyJSGUeCpyVZjzZXpqJ2INRyKTBQ1H5EUb9qKCJiOFhkKxZagcGd
         PlhvE0KLGekAuf+IKcnF2yunHui5cCJ+qZKmv+gD2JUORDDiHcbf8mrGQfikVALbh5HX
         ghQW1OeiRZczWonPrjsylmVilHHH1IAFWy7+lwZO8Ikx8X+98R4M33odSf0pSTCrAkua
         fjFBcz9EyPNy+aqolAXU+dyxXaw07GeSFZlODcyVZLaofHfNmdHHvAOdp+c5YeTDeq8o
         KhKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
        fh=hkj/UcDNledWTLL+5RDG2BGKkpbwTJY2TK3Zi4TH2ws=;
        b=ByLS7mDpdwVSb+7c1mEn0qQDpvoin5/vXPGLGwxvDiJJo4RsDIiL1t5SiJzbBvpRVo
         UZvwR7t7SsKCXsvb/0FMEy47VbFFds9GwP12/yKfTKcZCQDjcJCoCntsxtY8qjtAxNur
         qA1eJQQgH3iGRYkDfTuEe73g0bNr2S12c+yZGWpFu++JMpTRxobo8SAGLrN6R0utUBfI
         pWYZj0GQypu1tvYrtCIUjgabLeUcyTbUTg4W8hG02juKRIlyyAcmoPc+X5FY2krvKehC
         9s7gxbD/tnNIbDVXoSxvr3FMMSbe/3j1ak6agnSggrXgtLVbTgfRh5y5R8gukJMqg+xZ
         CR3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793201942; x=1793806742; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
        b=Jo/hfhVRv+oZjqTkmJ4+dL24FIaKzcvsi3pdmy3HAlGeHEIfzZHjqlPLUyOGXe4+CW
         wsuVi1Utas9P0WXG7bx1cnkNHsHu/klbTZtjQWHIr0gxVjwzCPPzuBGrqvAordXXNadI
         OKdm3dGndlPEzpukVWLfFzGLXlrjvSxK+70XEYUozWgQy7wPa1gAK8FtfZ5f8iqrzuNZ
         dfZLFNf+mKjskkbpSgi/qIpHqqRNbqzXAhA6LhPTDB36MNu9Fgg3wfujeERwjNlPWwwE
         /KZJ00iqzA7S1HHj3jqFAOSCjJyC+Lj6ef2AIsczC7rTqBfJsZuEbWzJpxmsK8s5UTpe
         i4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201942; x=1793806742;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
        b=CWOXMV/We26vID3mMBh4/XdufGvEmWh+IBwSulbKljSotJcd93B97hwpUYPKKE3eBO
         SeiAw3CC4tm8z0otSRLPW7Zm6iRBYBwydqqNTkZs9m5y9puwqxfNXIm03cQh2r3EiL5T
         bblakKUvz4D9OUSFjIhOqyjSLd76yn++QGMeGYEuFwez3hSgVvTQaqlIZjADNddaTaU5
         b7F6esyE8iIy58BL72ugzAQWEqnS7fGp4rehY4tqYP0Sh218NHyhkquflULme+s+uPmQ
         GcL+iTBMLsA2tc+kXAYmxfBa5yTUfbheIQHVu2bDOsiP2U6PcBI6Ir3M16mJPtr40/qG
         KP9A==
X-Forwarded-Encrypted: i=1; AKwUvByC9Rk6dkeaA5Sankuoo0WjWbadbh/7FnncgxA20IRNJ7xoA04oaCV6Qa8sF8EwX3kEbNb+QStBhbM=@vger.kernel.org
X-Gm-Message-State: AFq9FYLqBx4SrXUNVSaUuGHLcXRORaZesZikudAoyYfgT+ruz3hiWdB0
	gb/9I6Vk74349QcE3YHvHroA0LXjjpyPOlKXtNx6Yx31edXpQD13Lv8f12boOUfC8HYHblXvzWY
	pjbip2GODky8Xp6ruGsfxUeTGqDjZueMbI9Dzc+fa
X-Gm-Gg: AYBFou2X4/6Xa9m7EIyiz7fUy0NJyi2FbADIA4vlWBvHovVj0/BRPkcbOE8FQ2OvjwP
	JcUvtkAqgN14vdBG6cPkd0A6oKuyatEITLffUb6x0vbN84svcwIyAYd1Nxv5Apg0RGFW8/JpYN1
	jqnkc4Co+h1GQH9hGLfv/oPQB1og34nauGAHTkpBBJvsh9NolYUqTavETRTaBCpLCRU/oaemCYN
	V90RguuK5qNxBD03J79vwGUESmxrjZjNxv0z8TpHV32go763ieXgLAxyvV5ApvRvD0NvOkJbdrz
	7ofIi4TOThhAazirGq9XcjeZUe9ilTkspkGqcC0A1xYmkj1ZYNQ4wJkZdbczre2XwKxknrKzZoe
	gdhfTyKhUd+B19qgnHF90DypbO7fHJnh/eIPi7PNpO+phOlvYuBh9r8O9KpmqUg7PP0ZAOLiXYx
	HGNUEUbmpLvFY=
X-Received: by 2002:a17:907:d308:b0:c3f:7ab8:bef1 with SMTP id
 a640c23a62f3a-c49bdf2f80cmr259829766b.34.1793201941132; Wed, 28 Oct 2026
 08:39:01 -0700 (PDT)
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
 <20261027025616.1632690-2-kevinloughlin@google.com> <20261027053843-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261027053843-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 08:38:46 -0700
X-Gm-Features: AclHuK-vBr-9NFy3pcmA7HqGTQSybdCjlTCvxPcN7DJFBT-excWUi_DEsSkfHKE
Message-ID: <CAGdbjmK_vbmxX5Dti9+RwEiWkxQDHz+Dg9ToNnyEd_z-2ncdPQ@mail.gmail.com>
Subject: Re: [PATCH 01/13] virtio_ring: support per-virtqueue DMA mapping ops
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

On Tue, Oct 27, 2026 at 2:42=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Oct 27, 2026 at 02:56:04AM +0000, Kevin Loughlin wrote:
> > Allow individual virtqueues to override the device-wide DMA mapping
> > operations via virtqueue_set_map_ops(). When custom per-virtqueue
> > mapping operations are configured, vring_map_one_sg(), vring_unmap_one(=
),
> > vring_mapping_error(), and the DMA sync helpers dispatch through
> > vq->map_ops instead of the parent virtio_device DMA API path.
> >
> > Replace vring_map_single() with vring_map_indirect() and
> > vring_unmap_indirect() using the device-level mapping path (vdev->map
> > or dma_map_page_attrs()) so that indirect descriptor tables continue to
> > be DMA-mapped for host VMM access even when a virtqueue overrides buffe=
r
> > mapping via vq->map_ops.
> >
> > Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
>
> Please, don't. The automatic mappings inside virtio core are there
> to keep simple things, simple.
>
> Everyone doing something funky with mappings should use the premapped API=
.

Thanks for suggesting. I will use the premapped API if I end up sending a v=
2.
