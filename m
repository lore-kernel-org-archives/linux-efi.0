Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2C939CCE6
	for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425041; cv=none; b=qu+15bH7Hgm5ExVKfkagjO/rb8kmVSGUThizllPuH3pEpJknn4dFB7otYCqxW/cMcnzKA6STIRhZM2eNlHeG8AoKDJA4vjNmEtRUauljysBdJeC4/TSOgz1DW9wCi9maFTY/TyqALNME0SxFoGjpe492tiup3OHxB4whUoWYbZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425041; c=relaxed/simple;
	bh=3pbB/cdA2n+mw9ojxn7xAJ0JjyYJsv3yomOKFEBUOog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mo2jw/Zz8YjoKniX4OsnMdDBxdMXBou60Qv2YF5mscZNYUOS4Fj/JrnrGNryiyrckvZxCzqhjaq5ehERAhRR3hQHGmQwE6GAkk8gARtNZLAI+n711eANRSHfImUAmhOsnCi9UPV37UVK7aSKFMUS0KCUWbQ8Xbu5qE91aCR0G4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OM7iJ+C+; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OM7iJ+C+"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so618785866b.1
        for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 15:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789425037; x=1790029837; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=doHeCbdvroV7mGBSmqv1XRXXxfYTXe+sNzLZzLwqdyM=;
        b=OM7iJ+C+X/LJiSsDl6hOMoj3jD0HLGsHWTib5rqzUJrV8UbcCJEgVXIYEYJajHD1fo
         l7JthwRj5zbRxURMofPq/XBNgjyA7XTFIoCHdjFzMaUxSw+xlvSLBZlgJttBudnIfbsV
         3YeMaV4TGPVeeFCb/iehSgN1TA+iGGxrJD2M4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425037; x=1790029837;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=doHeCbdvroV7mGBSmqv1XRXXxfYTXe+sNzLZzLwqdyM=;
        b=YDQi7OOY/EJBPRQM7IakrEjIpKzRvfQZFtfFfnexr+P0fCl4vomcBXw4ngiTVqc50n
         NOkgw9c4XlH4JQsjcvhvSoQuIak2NpDs9X5oB6TzoNMYCE3Ul5/GUq4ADK+dDKHIzn1H
         zGeV3FNZ07fmrgkprNo0m9izGmzgn+1qCjr+IpSe3e8DAPEA+Fo3RB6K+gLigFBAOzMT
         jQkBBlf8ym8+VrNThc5NwyBO8bpAkFIkZRcVbuawKVw1i+1641HEYpcnZntsvcsCj5BP
         jQsLB/LNIFpM6xU05DDClzEGriAtBfNKS7MsrbdCzzOVMsYXw4OOWbjWmcL/peK0PICO
         nqQA==
X-Forwarded-Encrypted: i=1; AKwUvBzjq7W3o/zXKSA6yoFFZF2ZtU99vZ8M42K4ztAm80PFk2tOtgZlERCBftIUhC8RHhlm/WuU1MDrjyY=@vger.kernel.org
X-Gm-Message-State: AFuF++kWfllAJL+DpdIMZfOxIQJ6jfA1kk3fIzej1keyCbiomFG6P9Ve
	I8kZGksX3nc5e//OdxlglXedK4WYAAo3bJxSdaWLAWnBpXh4AOCFFGO4WHfMApTjP/Orf+IVFrx
	27gHpcd5UPA==
X-Gm-Gg: AYBFou0N78gqCLeMSj6fomPoSSI0ARF9dLTBXSxoEJ8xCH9//dIZ0OY8I7FRzrP3eA3
	klLavsfaq3S+x9PGTsEaXk68ZyRJbkq+ayP+EBv+TlKmntea0g6ftE/166Adbya0Bo3aMICGG3g
	Ruqr1TKMg1FydLEnupXQxLxNxzTXKwIw+jnwHn4WpvgUIguU6v+X8hRtgcJiEeKVtCeF4KZ+J4+
	MJz+RINAM4ApZWExlfl0ocQaInvjfU2Bkr5tJiw6CZ0Noy84vF9H4I/JfhAK8GOYsQzBYAYNv3X
	ZsSHSX9TvlaH6pXG+OhXqwk8JNll0VgjsnuvWJzgnEZx482TpZ61gXrc2b1nNl1XwmdUmgFJT1l
	wFwdfq3H9WrziIA1jhi/hWtDRy5PPEpYDMdHIpU9IphjKBeGYrAA7NqesZfjI0+77gUnvhm5dvm
	OibGClBOx83B0c2L0YxByd0iHdUHga8ZApwK8ACWg6/7CQhK9BPGUyHLJiOYAo0TAOHiDQgOBDp
	qpOMlC+xurUvpp45GgKKvlosxt7QQRXOVQpECKH0VhOQI/zrm78Qlrl5EGh
X-Received: by 2002:a17:907:9619:b0:c26:1648:a074 with SMTP id a640c23a62f3a-c29b87d8a8fmr301678166b.47.1789425037466;
        Mon, 14 Sep 2026 15:30:37 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2965c4e248sm516578166b.2.2026.09.14.15.30.36
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 15:30:37 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so618779266b.1
        for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 15:30:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwx/aO5i8khE3ExHJPKfFC60v5wq0/8rwPGtpn8VONXSmDwwPk3zTcLVbGKVDCi/YtmavNbf7xqxf8=@vger.kernel.org
X-Received: by 2002:a17:907:97c9:b0:c29:4415:2ebb with SMTP id
 a640c23a62f3a-c29b860109bmr315536666b.8.1789425035842; Mon, 14 Sep 2026
 15:30:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-15-39817ec5db23@kernel.org> <aqhLhVMkNzf_4oJw@jpoimboe>
 <CAHk-=wiB9MX7vBDQ+WHTUVfSYubLhR-PbABewscqTsxRhg-LbQ@mail.gmail.com> <aqhmhmgrnN3Mw8yG@jpoimboe>
In-Reply-To: <aqhmhmgrnN3Mw8yG@jpoimboe>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2026 15:30:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj3BKkCYtmfs5sORF_+Oumv2Gc8D+YxkMp9W2-mvLS=Ug@mail.gmail.com>
X-Gm-Features: AcwNN1UnWAKTndckmaJ94decAtfrWRGA6P58dk0oXtHcS9ajgGc6O7ZKSXjYJOY
Message-ID: <CAHk-=wj3BKkCYtmfs5sORF_+Oumv2Gc8D+YxkMp9W2-mvLS=Ug@mail.gmail.com>
Subject: Re: [PATCH v2 15/21] objtool: cache relocations, do less work
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Sept 2026 at 15:23, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> There might be more efficient ways to structure the considerable amount
> of data, like replacing "struct instruction" with "struct basic_block"
> or so, but it's hard to know whether that would be a net positive.

Yeah, I was thinking that you'd only hash instructions as you find
them if they are obvious "I need this instruction", and then try to
hash them *again* if they are branch targets (and just have a "already
hashed" flag).

That way random number instructions would not be on the hash - unless
they become branch targets.

And you wouldn't ever really have to track any complicated decisions
(like that whole "basic block" thing - I agree that it's painful,
because the shape of a basic block will change over time as you find
branch targets).

But not a big deal. More an idle thought brought on by that other
patch that changed the hash table size, and this discussion that was
talking about the hashing - or not hashing - of sections.

So more of a "if it is easy and straightforward" kind of thing.

             Linus
