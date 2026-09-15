Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D9B4A2073
	for <linux-efi@vger.kernel.org>; Tue, 15 Sep 2026 11:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471809; cv=none; b=aRHCSHDCaQCYv4+lDcvbv2/5eFyEJkw86wU2WgSqcLGtu9vvDTZx/dtPPTtBS4n+TLehaxiq1jsR9vzjbjLz8RHVnWplepqX3G1sWWuymkM4FPwi0ZNuqdJMQzbK7wM5c5APEpb2MU4z/NhIfYNbiM9l/eTqrXPOa5zHu0yUIJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471809; c=relaxed/simple;
	bh=APKTuDGLjMsk92bnnkXJ0rRlkzi8IPJqTj2KURSVBU4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n94HIPuo4ghCTADM/sHpcZ7hkd5+kZ4gHet0ZHSXUUjGMkjvOYp7T/EkcviLmLH/a2xnYhx7+HfNQsVegGZrlbbehet6g53o/Z5GS9KVUzsCXVZY+fT9JTuDZsZYRgCkDz4UqHTFZWQ6DdfvMrSCu8vEvP/e623+33BcGlSScNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QfmW0HZG; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QfmW0HZG"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49e73e541d7so1646205e9.0
        for <linux-efi@vger.kernel.org>; Tue, 15 Sep 2026 04:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789471803; x=1790076603; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dGOErKOPioTgO3v0/s/JdPfHHqPEsYrQAaTIvwRdmxw=;
        b=QfmW0HZGIofUmjnkWGL2TIVkFUxUuxZhOFjQCkuHPy/WVprMzaImb5IXvjMXS/wCGL
         uT++ASkA8Nzq8SsnOaIO0UueO+47EwRvo5F5Q2iv3015O88zbQeDLcIPKzLSIcrifmLG
         RVNd4ny1+Cy+QmrUym6h9ZUTtl8MXydeYJyp4q1FqUlyFJQXlfCStv7fqRBhRq+m6drU
         2MOKbXWfrGw4Cn3wFCJXObY+cq2LnTd2bB/lN0FlToSkrHYz2p1ue1fBhw1OzHr5z4oA
         4tpDK1zE80uk+drClpQQOLiuwshUO/kVmbzbC0pFA/whcZ8lOZHZwDWrcDKDnhhs+UpU
         /o/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789471803; x=1790076603;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dGOErKOPioTgO3v0/s/JdPfHHqPEsYrQAaTIvwRdmxw=;
        b=h8eM28D9cN4g6pjdwjcHvmwCC5rZh3U1AdEN/cnJX9APHUD7GQ9ok0TK7dpGFmJf9p
         HyJPgRKaczV72C4mzKCRMtg/I2AuVEqn1v9ow9gtzFVz2s3kYmMiD9E6bL0PuXn9ilh+
         iEgPVA+xHZ+JQKgodHGJJ7AAqAnf6+5NrHh+0PGh/G+N0dlVmnN/d6rUNiaFsZFEX9zg
         x6a5N7CpleMaCkeB3Bi9x6qOOhGnPneqpMiiZngL/UKPJmZk5CypVg+WYge0P52KEyPZ
         EdXR0hXiQDzGXRugxu2luBtN1E5rMaMsmblE0yD1O41XoqWmU6x/lgVOjdJazT30A4Ks
         spSQ==
X-Forwarded-Encrypted: i=1; AKwUvBxvJeSlCx7/ehPvkQON8ZDms72c2bPEcCGFe3RCMBainTvsl/paRKNfKzSNxryy7QFWHuZsenJglmY=@vger.kernel.org
X-Gm-Message-State: AFuF++nZ7e03FARZnvVEAjgT0Qxk3S4tk8P3FafNnpfXjJXY0CfeEo6y
	n6GFxRvoq0nzubkJF+PcYl816ttCxKahMFH79MuMk0z4eHaTFmPCZK0R
X-Gm-Gg: AYBFou2Tz709LKC4FCjD+RfjXthxK2Je7OxHCJ2uRQs1ALXmOs9tTNsfet2IZVqBzId
	QliLmLJMOaWOYBtU8IVVgzpORiBCLC9MXIT6sk4lD+A27irWhxqLsVezAeTpPRF/+Jjhd/KK7Sa
	AeFKtPj9mpNqoG5CV9F6TcEBEc5xC6OYYENNSYUd50bZgzkqzFEkpX/M5E5dnrmFDpID86JcT4n
	6kWA4gDD9maEpNP4j5cRJrHBRBcn2FI+i6PsMeeB/slRLDs1l9hR/BJZJJ4DhHHinRMA6o2pA9N
	SAYv1nzrpqPkBf37Y21ED0S7woLlvp2X5BVci5hiduqEJB9qq+9bKmpkAr+9B9z8A4m+V8fV40d
	j0mCaSPmNJnv9ua80i+SuxZQRUE89GAZx0f11XBHxoi1lGf1LjyVhKcrakL83ygZejQXZDRTdFd
	pBISZDeVoEjWnHMBNXnjTurYD9Timll0MaLbPv2pq9w6Q/g2SgUXWFvHB7Irpx3WuPd63xOLRU9
	xzAj89d+Kk8QY1nIUMFiexIoE+CfR6xWEDl
X-Received: by 2002:a05:600c:33a1:b0:49d:28b1:260d with SMTP id 5b1f17b1804b1-49e7d74ce16mr30558965e9.12.1789471802734;
        Tue, 15 Sep 2026 04:30:02 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32d3c7sm31448164f8f.10.2026.09.15.04.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 04:30:02 -0700 (PDT)
Date: Tue, 15 Sep 2026 12:29:59 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, Alexey
 Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti
 <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?UTF-8?B?QmrDtnJu?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?UTF-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Jonathan Corbet
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 17/21] objtool: decode instructions and resolve
 branch targets in parallel
Message-ID: <20260915122959.2348bf90@pumpkin>
In-Reply-To: <aqkR9Xqu-0Tem1zm@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
	<20260914-build-speedup-v2-17-39817ec5db23@kernel.org>
	<202609141112.F8983EE9C@keescook>
	<aqkR9Xqu-0Tem1zm@gremlin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Sep 2026 11:09:25 +0100
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> > > +static unsigned int decode_threads(unsigned long text_size)
> > > +{
> > > +	const long nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> > > +
> > > +	if (text_size < DECODE_THREADED_MIN_TEXT || nr_cpus < 2)
> > > +		return 1;

The text_size check ought to be before the sysconf() call.

> > > +
> > > +	return min_t(unsigned int, nr_cpus, DECODE_MAX_THREADS);

Why min_t() -  you might as well make nr_cpus 'unsigned int'.

> > > +}  
> >
> > No, anything using _SC_NPROCESSORS_ONLN internally is wrong, whether its
> > pigz or objtool.  
> 
> Why? We shouldn't cap a 4 CPU box to 4 CPUs?

You almost certainly don't want to use more...
(Unless they end up waiting for disk)

> 
> The idea is that the empirically obtained 16 core limit should naturally be
> capped to the number of CPUs.

The 'empirical' limit is very likely to be system dependant.
There might also be situations where you don't want the build to run as fast
as possible because the system is performing other workloads.
(Not to mention if you have had to add tracing to find a bug.)

> 
> I guess in a world where make hands jobs off this could be dropped, though,
> if the complexity there seems worthwhile.

You need to pull tokens out of the make pipe :-)

David

