Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E74827E056
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 21:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777327053; cv=none; b=Bzo/MyG9RjrsXOK3gFUvYUnUQT2kJdnjkdSv+Kvcjm3Q83tisJNk7hMVg9fRBYoi8wtNLL+Z91q03bT965WvnlgMIz7LVpFf787S+qXzG8L3rnim/GI4+n+ImwD0pzE6tEPebk7z98kFYlnHgtdhI/ox3T2Tkxwy+0MuC11RvxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777327053; c=relaxed/simple;
	bh=7P7VU36hQu4iMsGekLZKiPL3rBFQOW0TOaXA+fXfycA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6Fmovt5wG+3VaNLVpapnRn0TSZ2zVtZt0xE8g4PzX5lGOfSkPySnQOdWdqTsmuxLIJ76C0smr3yiY0bE7qXfjxaO8lv844AIh8my7DD92QunCVLpsXL5wz63pGBhW0+9IqM+KOzvvwcAutvK95OzjLR6IVsTmAdZ78DKuGPut8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vus3K/Ko; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vus3K/Ko"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-676e62faf2bso10758513a12.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 14:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777327050; x=1777931850; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
        b=Vus3K/Ko+TtG9US3RHvWXgbDNG0uxEsn5kag+aVyCiLOgaQ4jftTjH36HLu/nU+vMF
         DgG7bxOpeFCJ/VVePXCkQijEnGIL6ANVPx1wmgvec2Oxu1CdqMZtBXJH2NDhyXWb1PKk
         l56FteUVfQrLn5OJ4plg5kAsKgfsGpDco+guE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777327050; x=1777931850;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
        b=Rph0UIZX4jyqiBm0nL+KnJTDGDKX7inLN4ZUtOpQ1YhMQeov1y+Rx3NfvMohfBvh+6
         PAU1pJoadSvYiOzmYpVR6GsWmtO1gOJx6vg3AMbfGY7QLd1j2x7TCLJiDPmmwgmyVVft
         3yDsQdUHtGL2uqwY6anDIa+KsEaAgIAHKpuQiorPU5CiKtBkfdC7NZgGSzVEs3bA+nTA
         9vSn99HLTxALXvolJi6Y/icxY5jMxWNiZQ1bcffPSRbd6jjgDQYZUsuvuWyyOgvq30k4
         reJM77NkzuS41iosEs7J6IPz+FehNAFli1Dc7OB8Uf1+fMgDgqPl6Cikc52OujWTNyQn
         Hpaw==
X-Forwarded-Encrypted: i=1; AFNElJ+nVuvL0k1pqwEwueQLKQiSnLFjj6R78KAwY/0GIamv/83f6BDPKxOvSnb40GohHSLkrdhpvAD7fbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YygGZklXzg0UdWrwvMMkXmE4rP3jEB/V8QXIT73IOCq9PLRiQAC
	EQhHXAFdQZkf4YW6SPe4a9Mkox5lLHdWB6RKQ+AXiw2QOurdG19cFjUKMfi2bLk9m3R1MKZRWCj
	aBRb5Dw0Gvg==
X-Gm-Gg: AeBDievhJpCMSM9+JlIRvx2RXeubGld84eej0YJ6EV3J4uiBkp1K1t0p4SD41As5WQo
	XF5CUnFCWjoc6Mwsum0FcmCL7RpU0Bd9PmbwN9XxxxNldI0AhT9VuK1QYi9jZlEIji8IgLm0AtH
	RTocPjhA1zKCUEkjvgxRKULOGeYWA5ovRIIKor59fwdkCCOpScYhTxr61hFlKn5NCbLHYbwxmTt
	5e8PiiSjW1+mHfiMwC46F/DOf46+LCzXoh0igjIB5yv7K1tWmPpxLFzzdyWGiRoKwVKeY6Rsj8i
	3wpDwOfTqy+Onvu6E3oNmcEvRbv52AZKNMM8DeAMD7x7KLS7DRJfF00zFOZ3T7AA3wIYBSX3pt9
	AJBAnechkNf89HuhzUV0MXnUTLS/3O3vbfMHCPpANLJFF7QZCai8kN8ebq7XlWF0iYxT8pHNHbC
	anj471O9LrT4uPsz0BsiYYNZeKOqqBYfAE6LVOj5abK+mjI35XLERlVqIMOEHzdMvD/g0qhSad3
	QgGCEAsirg=
X-Received: by 2002:a17:906:6a1e:b0:bab:8238:63ba with SMTP id a640c23a62f3a-bb7fe36a2e5mr36681866b.0.1777327049661;
        Mon, 27 Apr 2026 14:57:29 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb809023ecesm10796466b.26.2026.04.27.14.57.29
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 14:57:29 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-676e62faf2bso10758499a12.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 14:57:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+PKMZd0Z56FJHtRmAZGeSgM7G/wMK4N4qf2tr8gBksqwbkLUw7ke3MtCad/8tjCgz/C6jZ2WZWEUg=@vger.kernel.org
X-Received: by 2002:a05:6402:35c2:b0:677:270f:6f4b with SMTP id
 4fb4d7f45d1cf-679bb04a8a7mr185115a12.1.1777326742385; Mon, 27 Apr 2026
 14:52:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury> <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org> <ae-2yLWSGnfeTvh1@yury>
In-Reply-To: <ae-2yLWSGnfeTvh1@yury>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 14:52:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
X-Gm-Features: AVHnY4LQUFWo9ODz4M3q2vZC9Gn8nsdYr95Nd4ky5ERVHHxIyN_9ZXY5zjebfdc
Message-ID: <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
To: Yury Norov <ynorov@nvidia.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Laight <david.laight.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, Yury Norov <yury.norov@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 12:19, Yury Norov <ynorov@nvidia.com> wrote:
>
> This is what Linus said when added x86 implementation for copy_from_user()
> in c512c69187197:

Note that some things have happily changed in the six+ years since...

>   That's partly because we have no current users of it, but also partly
>   because the copy_from_user() case is slightly different and cannot
>   efficiently be implemented in terms of a unsafe_get_user() loop (because
>   gcc can't do asm goto with outputs).

now everybody can do asm goto with outputs.

Yes, it's disabled on older versions, so it's not *always* available,
but all modern versions do it. And if you care about performance, you
won't be using an old compiler.

             Linus
