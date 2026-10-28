Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793202064;
	b=T9KL/KiqB7Sw+uRPcsLS8uLv1KPRaQnEvqlxUc50kImzLXYHpOHgeVsHHWTFhSmXRMCB
	 EnIhJOfCcIT3MBSZiket/poX+nOYtU+xXJ0ER5KzTusQr2HuznMsfWT6iY2vDIpfLsBEN
	 5CH3IXgw7ixsC/ShtF2YZUDJLAECUFqSB5D1Ec3E/qSYc1ztpxnuWe66bFC/csmjswMm1
	 f0oTo1h9ftP7jlHvZUIFRTwD3KnGMXiIoCdMohgNaM40czvPJym1wA9riL8ORI1UwifK2
	 IdKGMR4RluKuVWbhluN24V8ZqvjoVWH5zf2Phk1hgtFDOj++kJeswHYMhM8jm8ryDDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
	b=uEjwTbYEnv7vhLd8xSQJGD5Kmg2bP/oziPEX+oOU9nWJL2wf2mzNmquWrMNEZXPuYsD5
	 nCw8G2pm5q0WAbYNH+LqBKlJK6w37XnmrBQWmg4Xq45dqNB3BpbwBu445yByLNCk+mj2n
	 nS6HtgLMUcflqiu1jEuqDhcmie74MtG6Sb9ynCEtZpZGHXRI7P7XmlYbgcyO2oND3xD1M
	 8XHVSim4PREbDoSeFpv9WwSZ2/c/wjayMSTL7rPDsWoX9VNyTZugL+Cg8Q3nWIKwSc8D/
	 WutGZz9p2ZL5JymBUSAWbi5AezPNFvQ3hK5GQat5nxy2BCp6ofPahN/1+XDpqi+X1jA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=loLkuUzK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF74606A33A
	for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 15:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEF74606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=loLkuUzK
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso172804966b.3
        for <linux-efi@vger.kernel.org>; Wed, 28 Oct 2026 08:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793202062; cv=none;
        d=google.com; s=arc-20260327;
        b=IOwOZPNkZ+p3WyNhiSXYb19M9Hc6nQKaMi1qOIZ+A5MDnomVTAmK7KwRhYzInHzAJV
         bP+mranTA8ukhSBSEVB06lsto04NFgJyLLG7VuEzdOUdB1x5p1HmBHwBb02c9dGVy9bo
         qygPdnAipdH5FkmntxHUeyoldvG3bZnHPZd/yjfug+vhjn9dbnzdeW1D9za5QKt1HhjV
         bUwz8l8BXkmAfnJI75RGEOf2PiX7UHroCrcx4GmNLYwwkag+UT0dLOV2oGy8DNOiQpYw
         Vtei1UZ76cPvSxlINxdx1IVqceyAmpnQd5PpYagsoVgouT4kPC0UOQ6bfjoq89ca/+xN
         8TNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
        fh=1opDD6BmEpZOEkLTGncsCGMSiDlZZSenkzwvyOs43SA=;
        b=j6tTej9PgBUGM5Akl15fT7WP/r7O+Bynq06iX7N+BzI4uxJMV0FrdLcJuGkHmjqeat
         MvTDyzYbl21OqJQWeJH6vZQ53i9dpdIQEnN2xUCG1mZJ7iRyjvllJnhD7KszC071Ztsn
         y4uI+7+zzRbiyGQLmEtWUL8ZWDvRIVR5+aeFfy8xwvq5kYjEcfKKzjpn+YiA0hPWPcLM
         b3QB41TBAB6fnmfMWXVLhWMdj7IC8P0zqjMLbd8PrgegZsPF/f/PZaFkjc8L0gtfaMTV
         mG8o6XLM9saQQFHptWLgWdYjI4Kr7utiPb1t+Bf2L2v6ACxJuGQDw/PKZgcHU8HK4SVR
         W+hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793202062; x=1793806862; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
        b=loLkuUzK6mJYRXElK62aWp5gE8MHI5y//xAl3m1lExP8hPa0npVF+gK5wAx6GSnsGn
         nOu/daaiDCVGWOCD4/iJCPNWeMTUggM8m1InAEXtj4UtX/8+tWHacgQS+KCl5y1qwn0P
         Uftasvn3UXWQeIa/TVdK6Ce6RDZRbzTQ2g3d8x1a9ZFwMCUQ4QBiuJ6Hwh9x4kKQFvlf
         U0WV6ZrItYQLvTfRQOYunMbvwMZQZ2LU5P4R/HQOSIcP8bFHS8yCHle21AZNQ8La9DB0
         uJGbUuk1cpSvqXuGVCGzbEKGomMOI/gGaBZGgCOzOD8P6Y3LBa6QdQg9IP18qON1Nn8W
         knOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202062; x=1793806862;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
        b=CugdtSosSFkoUQKOakVl8HPe5BUWczx3GxqPLZvTxeCIvjQ9gzNGXeteLdTa0NybNJ
         jbs0yhzv6mde1Np7AP3W5AoZJsA+85HdcJvD7BUQeWzKifzP7Q0jn1ZSVe1xo5pKra8k
         PRLc/sMadzxDMX1x+f3mRphvOOApwfXveFK2JsNMO6UP5VugErBsnBXHWbePCepX7h6v
         ocIYnfUZUDcxHQDUecClJWrB7EAoJzw0ruaqd6j9KtkStFO01jIQjxC9uAN34lF2YEJQ
         xtRzBVsbik3a62Xn44cqKx+JoDU4gWg3FAh95VJVgjlZuYfVqYpUOJUL/8STknRBRzUF
         MUPg==
X-Forwarded-Encrypted: i=1; AKwUvByy9UAIDEhZpE5xLXsB7uTLic1MHL1ja8d94p7qX3osMIbXmlY+0e5E23+bCI+TVQmhcykOJrCXl/w=@vger.kernel.org
X-Gm-Message-State: AFq9FYLkv/sWyD84UVcoLJQgqgpap8XzaBbyM5t5W1KX0Cg4hsD6DMjy
	71QnocjXTp7yP2bNA+5u6ankR5/uclq1Akp+5PrYGaTqdgWHgEtc32TNUNXNc4rvqYN6/PcMzNj
	cMXxXGZb1w9C8bf800vE64jnf0TlFnE+TiP7v13bC
X-Gm-Gg: AYBFou0bycLXioOcz/siJoQhYT5FWQC4O3NsGby7S/qpS+ozQ4BCpJzRuiE3Jemaz7A
	r/wY/dJ/8I0bCZZM9whEwDg+xhbsBZuJA3MIwWwwmkMD1R1Q19KnePToa02iJEqHvjpI/c78yeO
	m+e1rNW2wgj/+iObCUj57SnQq4I1xhwXzfcYIH6nn9cPdGLb6axTV1GUEr8pMdFFhmlxyeIls71
	R9A87yzcdqlMtxWoGbUIxj5Uv+MVCj4vr4uNeb5ZjpaJgCrdV01UiAYC6NDp/F8A1Gsv/QSz9ny
	fzgKV7f4KXWKtfpt0sXP/he8i4VvAsL8iWLPFFeNfFXRAXYJs0Fvt/L7W/gDyRmz8qrR/TAN0fy
	0fvkma7aNPVzKttSCQc3N3feGAuRjhCEzpUrWmDVWi43y9DjAEHDu3uxAuDA9M8KG0A==
X-Received: by 2002:a17:907:3ccb:b0:c41:30be:4f82 with SMTP id
 a640c23a62f3a-c49bdf82147mr200595566b.39.1793202061724; Wed, 28 Oct 2026
 08:41:01 -0700 (PDT)
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
 <20261027025616.1632690-11-kevinloughlin@google.com> <2976bc2d-2642-4448-9c1f-ec13e67e45d5@kernel.org>
In-Reply-To: <2976bc2d-2642-4448-9c1f-ec13e67e45d5@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 08:40:47 -0700
X-Gm-Features: AclHuK9oWsApJE-SwbWIqUTDRpRi_a-FG1r_BRCTB7JJ3QabTlKp_kjVIFg_bKo
Message-ID: <CAGdbjmLXhPkutP3yCNYghP_tkvHm2Sa+6aBHF1+9abaai-4bAw@mail.gmail.com>
Subject: Re: [PATCH 10/13] virtio_balloon: add higher-order page inflation
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

On Wed, Oct 28, 2026 at 1:59=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 03:56, Kevin Loughlin wrote:
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
> Sorry, not happening. There is no migration support for these (large) thi=
ngs,
> and there likely won't be any time soon.
>
> NAK

Yeah, you're right. Another great reason to abandon the
inflate/deflate aspect of this series beyond what Michael pointed out.
I will follow up on the cover letter RE: how doing so might provide a
path forward for the CoCo free page reporting by simplifying things.
