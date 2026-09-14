Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7E7496D4F
	for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 20:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416759; cv=none; b=J54gBRYdKoojNDXv/SELl/tzCMffhwdy2SlobHapDKjm4rDa6lTQw8P1jxnLbsb+YS2WPuBhYdx5L2gJcGDUzR8ILi6BMovgv5vUyS4dHgd90OFGpQGhQIkYEadcVHkGUjHvY9XYq//pKlm+8VQqKxI4J/XJXC1fKxtyL+2nkaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416759; c=relaxed/simple;
	bh=g8JbSv2uB9OVHPX6mK0/xKaLA1R5JXVM4OnU1gOEgUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzKImQvhULAKckKwi2d9kEGoSX1EVk9FeAh+nftyvIbOtgNcynJof4tkfjAnN7BwD1LsQJ2/ZNXSk4yfwHXCsnjBhLQMxcVR+C7d75TQSef9ow5B3Is/5d/UFIwKUh3HePlZUX37MLkiPGxHSWQRX9EF3RULXP2EGxWdQ2jzmzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VbJ5+dK9; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VbJ5+dK9"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55efe7so343717666b.3
        for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 13:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789416753; x=1790021553; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FhpCYoKplrM1IaRlncQiHxwpj03BaeP0oenEDpXOAEg=;
        b=VbJ5+dK97ZE0IKbBRPXHpVIqgOHf9QfaYVBJno3slRC/FaxtmszESKZ0ygl19eCghy
         ZuICBpORJNutfyd6ReRwDeiqw1nqlRSXXEY0YZu2Sot8eV2g7b2wLlhureOUO/Vkgij0
         OyXS/yWYHvdiZycH/6cfE1fkT+XDW3gJjGI2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416753; x=1790021553;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FhpCYoKplrM1IaRlncQiHxwpj03BaeP0oenEDpXOAEg=;
        b=O5BVYLqlziJswrrkhwSqUfA+UNHioWTOQLXZKhcOLfK2FocPM5pzuVzvm96cUfjnPy
         GNJ18StqcLKv5tby6k0FO6K2Qmv8P+PUyksh7BmsXhnzw2NV7HBIMlvKbqUfEcHRWxKQ
         UOpbt2elQvw2RB7JZw9QSvBH0C0ExOOqefx9IBM0PpSYQb6niDnH6FrxR3/Z3SIE+nMu
         GYlAJijNmvAbYFYyVrOuPz7wMmwSCsfo/2Xl/FWjSXFIyB2IY2xwTrh/Z7koY1rhSDXe
         NZ3xYiqmCZgvKtDsesGh8WcTpYNuWiDkFZyqSvs/hWa6tHa699u3oEclE40Z26hZ4CaI
         ZvGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwbSAq4OEjzbDc+8KnEhbxflq4xTqV/iH0wmu5CI0Yus7rC15rayp/rlL8yI9AvrOCtvXCVPIbWJWY=@vger.kernel.org
X-Gm-Message-State: AFuF++klXWh0I3EEMs/u7n095qh/0iUpbdPoAVddD7fR3fAg+pmPTHlU
	uyN8hUPzDWYRI5kMd1mQY1iP/cxl8dcI5BJnj7Un+I452Oe17ZCe06I9BXuwbAyeSYgNZ5koQDW
	tEHz67UL9QA==
X-Gm-Gg: AYBFou2kVsIgAVgDVb5kB5itiqrootf8vyg/d7f9OUZzCqN2c0wK7AYcsVP0PFqIWOi
	VeIUgRA8tvGxSN5beypwhEHXnBxFOploBnrz/9ecI4noKTxi2sq5R0ymNUMq6qaq81eLZOV8Psu
	Hasn9GqJjV/Xv2k/Vx2bfJgprnhAnBKIWILF7jV3xcyLlOyyWMTg7NvnCIJvQywjdS6Fkv89EL5
	4RCjhihLvltrheOkBRHVERFTOOuxRCT79lb8wISGalzbBie5yuxbrxa+BhSBfUV2u+46pzBIREk
	A9+138lIzeI5RtibHX1vx22OdgyVyxEaVy5bIdY+eQq6qc36dJn7lC7MAFDftDxwS3mA1d2LZ+m
	Hokc7/sbCg+5VdSv+wr+8mtNMg3jCFhVRkdsRyQTsAZqFEXbKs9AoPkbt9aKrnOUHwl96kUE+vP
	Ubcty0aSXVmTd9yeannA8/XU8rywtxrTuDaNmeoFR0ypJJvU2gcJlBONmHfhN/V+3c3JOJelx6R
	zl5Rax16zniIl9osf8v+6whcDACDfecEwaW7x2/KWW/smur
X-Received: by 2002:a17:907:7ba5:b0:c29:62d8:68af with SMTP id a640c23a62f3a-c29b8762c2dmr310349566b.47.1789416752760;
        Mon, 14 Sep 2026 13:12:32 -0700 (PDT)
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com. [74.125.228.76])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296613c3ebsm471270466b.57.2026.09.14.13.12.32
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:12:32 -0700 (PDT)
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a98505364aso3748548a12.3
        for <linux-efi@vger.kernel.org>; Mon, 14 Sep 2026 13:12:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByCfS92K7HkBgIB6YB0jpirt/DDZhz3R50XjdAgkmmghgjiRoDv+NVt6PMbb3CDFhfVqlRmQtOtSnY=@vger.kernel.org
X-Received: by 2002:a17:907:6d1f:b0:c25:5faf:b207 with SMTP id
 a640c23a62f3a-c29b84c9a48mr280688866b.3.1789416413732; Mon, 14 Sep 2026
 13:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-15-39817ec5db23@kernel.org> <aqhLhVMkNzf_4oJw@jpoimboe>
In-Reply-To: <aqhLhVMkNzf_4oJw@jpoimboe>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2026 13:06:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiB9MX7vBDQ+WHTUVfSYubLhR-PbABewscqTsxRhg-LbQ@mail.gmail.com>
X-Gm-Features: AcwNN1XwkDuRyfqGBvPSv1hGEYJIl2TPFZFoOf2g9mdtKKeoU1aAJmlE5veL8PE
Message-ID: <CAHk-=wiB9MX7vBDQ+WHTUVfSYubLhR-PbABewscqTsxRhg-LbQ@mail.gmail.com>
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

On Mon, 14 Sept 2026 at 12:44, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> BTW, I found another initialization bug: klp-post-link.c uses
> elf_create_section() to create a reloc section, so it missing the
> initialization of rsec->hashed in elf_create_rela_section().  But that's
> moot if we just get rid of the hashing.

Talking about "getting rid of the hashing": the instruction hashing is
obviously a big deal judging by the hash size expansion in that other
patch.

Do we actually look up all instructions by hash in the first place?
From a quick glance, it looks like almost every user of "find_insn()"
is looking for just certain *kinds* of instructions: calls, branches,
returns, endbr.  And branch targets.

Maybe stack updates? I didn't check.

Yet we seem to hash them all - even if they are just some random
ALU-only instruction that is in the middle of a function and never a
target of anything and has no impact on any code flow.

So the question becomes: do we actually need to hash those
instructions at all? Are they ever actually looked up?

I don't know this codebase at all, so maybe that's just a really
stupid question. Feel free to look at me condescendinly, shake your
head and say "Poor Linus has lost the plot".

[ And yes, I see that whole "next_insn_same_sec()" thing, which
obviously *does* look up all the instructions when you iterate over
that function, but it strikes me that using a hash table for that is a
bit strange when the natural way to do it would be with juyst a
"struct instruction *next" field instead.. ]

So if hashing was such a big deal that it showed up clearly on
profiles, maybe the answer isn't just a "make the hash table larger".
If a "next" field were to not only make the hash table much smaller,
but also mean that next_insn_same_{func,sec}() would become a "follow
one pointer", mayeb hashing would become rather cheaper?

Stupid? Or maybe "not completely stupid, but too painful to change"?

         Linus
