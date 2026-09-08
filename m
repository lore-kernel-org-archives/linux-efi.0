Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16A63ABD96
	for <linux-efi@vger.kernel.org>; Tue,  8 Sep 2026 21:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901594; cv=pass; b=ZUx9s2UBfe9NZNTRnzB4Xa8pn0W2TauZbADn38sUpAXLGVG9166w8d8+y3gCr5xG0M/ORYBPWVYYxZ9av7L3U00yM/xD+SJ3MtZB3rl7YdJuSzCUFlyW+mvs/QUdCkfyjlpMFBQclI6IfUtWdzOi9gJqhEDobp+0DtXuhR8ly8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901594; c=relaxed/simple;
	bh=cIOFXtCuNna/zYNDEeDAmAkgX9xNg/vNmHFdct8PtpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EFSegT/Ain9dDyTT4wp58r2qUpaVdetS2aSVANoWknECyWyxrjmZAdNtyTXhW9FK9TFOaL5Oxbt6R0PdP7mf11YRfGKnPRK4VKDhyeM39CmKnsFk8tjiFIbZhz4AvDxorsiSvBIT8Gx9wv5TX+Joe01XOB2y4igCJCHJLDk0bWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=otsf6b66; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="otsf6b66"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so71998895e9.3
        for <linux-efi@vger.kernel.org>; Tue, 08 Sep 2026 14:06:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788901590; cv=none;
        d=google.com; s=arc-20260327;
        b=oFOGsDFUxBR809tQ/GIb/me8t9gaDCF0XMH9mjrsU+ocQRTzfYNS3TlBzABgy7VQPJ
         q0N7yEU+rOQYZcQZIYlFf+yoijTcLYiS32+NQLqnWKLmEJu930OeB5Mz5D1vjws8U7XV
         43k19m0nyYypahe76uyopl89x2KKRQou2/GMZShTBLZajqAqYo2EgBzHT0VviVKSlhvh
         EwnCm6lwrnh2HG45Qi7ea+JQWBsg21Sic6vlNeaJAnGjF9axK9AK67Ulw1KPF5fOt7Ov
         v/8HC1EUJo3iArzpGb9R3ByQxhzubI5VOT2IxmbOM+MugZmxdddMCrWUPigh2pRUVCPU
         jT3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/CB3Vtp7eYFgiX1lhWfAP6WjiIrj8nFLFrnLp7SXQSY=;
        fh=pAW3MHol3pL21tWFJ8VyH8tKnODQvbHCZUaGcCTRL1o=;
        b=aIgdAwdNud3WgUJ3sll33CvBJxYwiHlHDs+beSrJvexhzWjAXWoWt4pA2/lmc2Qf1p
         KaLmFwnE3gmgHbq12HRhTCrLeOXxdxC2ZdpUt9EsK7EeUGxGsMhVJnP8Xz2p0VJs9uAJ
         FQ58qZy5NcIwfwnAhG9TD8/+cM6bJ5WUPkGSSVc8S3h/6UoM8/n+LnXFCGR0ehFfNoug
         PVTS1HhTaCS4GCeLFDMRSNrK2pswUzSkPr5d2rU9xBCXaBBOXJMK6GBf9s46BFnrd1Y+
         FxGHlqgAg8jSgoQX9YJvbkFS9JdQVcUYURDRM2pOj+PFnWG4hkUOcuhqwuUvxMC4RzjD
         aR9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788901590; x=1789506390; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/CB3Vtp7eYFgiX1lhWfAP6WjiIrj8nFLFrnLp7SXQSY=;
        b=otsf6b66eLyN+62lzguVV+VBMlATv6z+svgDrA31hnA5b3fBV3bwYCqshPtnmsyGmv
         QDNDZwx7N31zA+x89VYITcROT5ZRN8TP4ggK6R9uMannUm/MUJSMRZGWkbAMzCuOqlSY
         H6biXYN3dL5DiY2yXed6Ky4yh4BVxXR56j5VYoNJgh5pu6nlbLx8ul8LTxw6ojhP81mJ
         6JTXwtflQYVkO/SfV7yVBVRWnh5SQfasm8wlbFkY625Bkt4jmQ2QbNf1ssWLfzh6NMk7
         l1RjM2KYlCGn6nKE0yFuTlHEHgKavdGE6I5+Sqelz5oi5Z+IpMaKNlUCqzRnSjeVC5x7
         BuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788901590; x=1789506390;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/CB3Vtp7eYFgiX1lhWfAP6WjiIrj8nFLFrnLp7SXQSY=;
        b=Ah+dtyI7m9rH+IedszFAW1Gr3TQczABztPZiRz6hcnTOW9tR40bi/E3teNEjrvehqa
         qquFhR5P2mtWJEYl7Kg9NqGSGwNmVAtyE1hr+B9dJnVZOF8jbs4th8CiuuXovjd72wnN
         6eo7Hz2u9jirZixEJbEvzQ/V422k3QFnlGQPhjKxrIhrF/c4tIPNZiAyU9zVPN89IaUB
         r5B/B2ewq3dn9e6FIisl0sEPyBmKSKuKDkSkZN4X9ZIFJeVtRiFvM8SAwRIWBR2fZtwX
         +vyQtUwf5mNiUCmYpgW11gAFkzVvb5Ksh983SSTsvyAEcoQJgbs3dhJ/REfVmSVI9Dnx
         38HA==
X-Forwarded-Encrypted: i=1; AKwUvBzigkGC6OW2LKfSwGB7Gh0ocrUgB6+TCTxDyIfKDlofXHFd+FvDKvdaWtEwyQYcCqmEiMtyruXiR7E=@vger.kernel.org
X-Gm-Message-State: AFuF++n45OGQq9siO9sycHqTiJCoHY5/QmzKP9rSyueka7OU7pMZfMF/
	0Du4GrLMEUVjPchmyLt75pP3mwnQN7AR3l/VV4wcqizelZ9kzzqfqbinTq/t/Q3N4obutDCWz/a
	W2iIDDE6X1tV1fEIyBH6M5GinwqYbxpu6WWRD3ltE
X-Gm-Gg: AYBFou2PkTSnQzJEmL1wcF9PVA0zF0vHVODkzpNZXUHV818q7+QNRp5JAYXUpJVrYmH
	sRRgKzu4ejxA/M2QToLoLBC6IRESxqjbgRO2vUYeZQBF2O9G4JU4G5IVaPhA8WABXxmMYd/Qfvc
	uiGjMV6fqtuVVECaj35MGmlpXr+iYrIiei4AhK4OkvEiPBFT/60kaycSO3tAsFANS/ThRJTxjOO
	SfdDHEMmUyt5MmWD9F7P1QV5ZstOELSWKiYPNf2x5w9L98s+h3h1cNEfTb3gK3h5HXQ42LJwXvW
	WjKEVE1oRFJxAP9uz4/cyUXU3NOHAXJ62Ayx/8WnhT9gCMzo1Z0hUwTlTvL4YMydGnEKD6YqoE9
	+PS2pDLXFfSi58J3nw6Aqt+aVjKnUsnwpqWubAwK5ECw+QKOUGhdv5FXO
X-Received: by 2002:a05:600c:6091:b0:49c:eb17:cf3b with SMTP id
 5b1f17b1804b1-49cf8252497mr286154405e9.8.1788901589479; Tue, 08 Sep 2026
 14:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 8 Sep 2026 14:06:18 -0700
X-Gm-Features: AcwNN1Vne6n6eJi0vjoX52mygVY2Bf7Bhttyek2fKXqRHQxDJ8Lg5WpFcLyZtjc
Message-ID: <CAKwvOdmdFdW8=y+s5NLoNeKz4LVbmW8tr+JqJ26wqYFJDdARFQ@mail.gmail.com>
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Schier <nsc@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 1:55=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> A typical kernel build consists of a frustratingly large amount of time
> spent stuck in single-threaded bottlenecks.
>
> It turns out that there's a lot we can do about this and doing so
> significantly impacts kernel build times.


> Fundamentally the series improves build times by parallelising
> single-threaded tasks as much as possible and improving the efficiency of
> code used in the build process.

Cool!  I have not reviewed this patch series, but am supportive of
solving the problem, since I do recall this being an issue;

i.e. it always annoyed me that despite have a 128 core machine, much
of the build is sequential!  Having all those cores and not saturating
them during a build was always something I noticed (usually have
system monitor always showing system load, always) but never had time
to look into.

It would be cool if your LLM could generate any visualizations of
what's going on during a build? Seeing what's serial vs parallelized
in perhaps useful. Particularly when you can compare the before vs
after.
--=20
Thanks,
~Nick Desaulniers
