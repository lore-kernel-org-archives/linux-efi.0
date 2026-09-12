Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348C41A51B
	for <linux-efi@vger.kernel.org>; Sat, 12 Sep 2026 10:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207404; cv=none; b=QjRoowUtXVWaohvBFtgP4LY8y6n6K2+js2X5nfI2PEZ+EYVeVFRx693UUD/4zel+JPAI8wM/kMuNhlYJtPNCt0rt6XSHeUg/gr0DmNxvazx715OoZJSvK9MtY4p0koRlJ90x0NCl0WY7JGyhiDxh0qW1PMqqOwwUkaV0seNxuzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207404; c=relaxed/simple;
	bh=8sojs+se8QPBJyJ3S7gUk1OtieiG2IMnEQyGHnpeALo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+6QAbwH4QZzuQqnTHntITk1+JhuM3UoS0etas8biKP8eyQlD0ibOBHIQEDuyl2BLYDObGOVzivDZix695inDQelpMldp+KQx8RTH1wds9e28/a+Glwx/5cpND9z+mdDsKKna+IIDbDDGnrLIA5q1QaMdjipuPv1B04gAKXtcgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fe+AZyiP; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fe+AZyiP"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485984ebf5cso300920f8f.0
        for <linux-efi@vger.kernel.org>; Sat, 12 Sep 2026 03:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789207400; x=1789812200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=78QJrighesf7VQwGx1w3HgeMelr4wZOukxrUbALylpM=;
        b=Fe+AZyiPJOfMvfVWNuDtyAcWTVKbBm96f/FC3Afm6JLZBHlBx4RDyqfVRdhFrVnLcu
         n4w48wdDXiNehawYgSXj6RD10qznhIwlXp2oOKq81tWWQcrvxbZzbDpLoCKjGmThvW5n
         kuCdUk/zDHrjp2P8fcKrJCIIptcNIR9aAVXgQITG7+l0EDdMQJzK1hv9Fhm1dzDDpJjr
         sX/pIp21teXMpdb2inVRL30AHaleM1Yuo4FVYGmeaLlbXvYBIVwd30kdVsV6ZMYtdNk5
         RJUK/36fQ0Yjypq3Y2OzYHXDnBliRbq6ba9NaXMK89x1NGAILWj+/oOeA3oS/cZnbvOW
         QfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789207400; x=1789812200;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=78QJrighesf7VQwGx1w3HgeMelr4wZOukxrUbALylpM=;
        b=qnyJV6eYfKZjcg5NqIgYBWraXEZM5LPh3r2jVX7upSeVMANpKo6Ikpq3qUnHCKgX57
         Kx/eRj9JIbALWVw/T8Vn+9szn7/PuFEHaiWNDZyzjul58gcYxNVYXD1TKOby0KdRkKjK
         OYCdjWwBTOy+zmOT86FBJAHT6iUorFZl9ZsPVVy9dE76tvENLv3ive+RIIIcZu2psagp
         ambFW0vdmnxL9uQc4LTFueG7AFVevfz7YSLD7vyxVkyaa3djcT8xfEEywlNzonujir6O
         0VInBgXSPYH/X85fXBPma3z7rCmH4+vBiL9YkF7zZnpyosho+6QZJeqBomXDRAb0Bwp3
         AjtQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKtmLh2gkKoP5F9S1BPxtcb2TupeolV1FrsuU8hM7+o2eiw9ugj0c8ufNI0nw0VsfcRdJgokHxFi8=@vger.kernel.org
X-Gm-Message-State: AFuF++mtRKTyYAtWgBgS466V4QAhIS4RAiC64giDTxSTTDMAhMTRjVLn
	7tDw9ivgmvaWVvLJPoKbiJp5hrQYTbmA3jFMr9P3ahmAZHLmWeccZ3Ii
X-Gm-Gg: AYBFou0G4ojQpqy1WfA53noyngTQWNmCsvJgr8gFX9lkPlPxYoEJ4Q5kLSYwE0D7Ojr
	4Rko1kzLd7KNnCW/mN0ZOyy/XOfIkICc6r+Yog6XOXPGj9xBZWNCC9yurO0ZV2lO5f+dAKodWDP
	eoI2HtfpxMFDzw2CbFPQpwTzulSDvTS2/pMr5DlO1bbZJURRsBlkDKIPRtaLXLs1vq2UBaRtwuM
	M78FPPDprH4kaIYUqc1dJDBSJOb13DQ+2aBGaCQypOJyGK0eypjvQfeMvnL75OlRWRXVW/IjqZv
	hz+rI6tsTn1epppiPHaZiXW8royNW2M/UWWWN7qLQ/h6A0ZtAwkmSfL9iFWrNCZyoT/H7IwWRoB
	dyApRs24DoxeWHMUr9dY7M8xrqz1TDYiqSSKfM7kz1HpIXIWAtJJSCUC72jTc8UtPWs394AMtSa
	pRjftTgE3+1T1KetyL+4lrX6II9T/lprIEmD/HHJPqaRaD+KTICtRN2upqDbb4hor4Vb0rSUmW/
	5Xuw3YJCzXsq4leh77gF8amn60H2A9La9LFQKFNymAtzX8=
X-Received: by 2002:a5d:5848:0:b0:481:512b:f0e7 with SMTP id ffacd0b85a97d-486f6c0a974mr2053384f8f.17.1789207400506;
        Sat, 12 Sep 2026 03:03:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486f301121asm7428212f8f.0.2026.09.12.03.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 03:03:20 -0700 (PDT)
Date: Sat, 12 Sep 2026 11:03:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Nicolas Schier <nsc@kernel.org>, Nick
 Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas
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
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker
 probes
Message-ID: <20260912110318.23bb6619@pumpkin>
In-Reply-To: <178901395292.3971858.13236774094648272066.b4-review@b4>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
	<20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
	<178901395292.3971858.13236774094648272066.b4-review@b4>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 09 Sep 2026 21:19:12 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> > diff --git a/init/Kconfig b/init/Kconfig
> > index 8583d9f06c52..3c92c87254a3 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -144,6 +144,44 @@ config CC_HAS_ASSUME
> >  config CC_HAS_NO_PROFILE_FN_ATTR
> >  	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
> >  
> > +config CC_HAS_ZERO_INIT_PADDING_BITS
> > +	def_bool $(cc-option,-fzero-init-padding-bits=all)
> > +
> > +config CC_HAS_NO_STACK_CLASH_PROTECTION
> > +	def_bool $(cc-option,-fno-stack-clash-protection)
> > +
> > +config CC_HAS_NO_ADDRSIG
> > +	def_bool $(cc-option,-fno-addrsig)  
> 
> I am generally in favor of this proposal since I think these checks
> should be cached by Kconfig where possible to clear up running them
> twice. That said, I wonder if we should pick a better dumping ground for
> these checks other than init/Kconfig. Maybe init/Kconfig.tools or
> scripts/Kconfig.tools or something?
> 
> I also worry about backsliding and growing cc-option checks. Should we
> update the documentation to state that it is preferrable for these
> checks to live in Kconfig so that they can be properly cached?
> 

Thought...
Can some/all of the checks be done by running 'cc --help=xxx' once and
parsing the result?

Although I'm not really sure that shaving off 0.2 seconds really matters.
(I know the little bits add up, but there are much bigger delays.)

One thing that does annoy me is the delay before the first compile when
you do a -j1 build. I've not looked at what is being run.
This is all made worse because gmake doesn't stop on errors very well.
I fixed that in NetBSD's make about 25 years ago.
(IIRC it mostly required always getting a new token from the pipe.)

David
