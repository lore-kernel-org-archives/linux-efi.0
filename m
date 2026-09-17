Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B05F4E0B9E
	for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 20:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675384; cv=pass; b=Zju/YPQ9H1LnScppKw1VCzQrFTuytnQ59hWp+JPCBbk9FvsF3q0y/QEvSSuBXGtC5/86WRym6mFFjuB5XJuUX+hNzX0W3X/dFF5N13tl7hljkI5PXcPnjxIQYd5PR+Etyqc+lWQ3P/bY5UoUR+ewWsugO0XP/oVMmJtNUfsUc9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675384; c=relaxed/simple;
	bh=GpHjDtqu+AzW6bYVn14IR7601Ha7EtaAYwvYSeYG9jc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHgHd/T8RsCf7Vr2JiLFM2wfNHOkwgc7oCkGQHFGIzJJbQSRui0h5TKLMVAp0B7za+03PJG9TY/oVK5hbDIIMH4pSpws5DF4kNsHRRLizKDzU6cJPG+XJAacqhcWub46W2Q1Tai27NzHvF/looCwWylli1m0agzhhiraMmxiFDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RfRoG1si; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RfRoG1si"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso244385e9.3
        for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 13:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789675380; cv=none;
        d=google.com; s=arc-20260327;
        b=AQEVTQ2pyY+OqkXzP0MP1pXWpEjfPr6KFKIFHlpija27wD/JW1YGZuNUmFfmOP6C35
         yPDUSr15fDu+7y9Jso9NWIeGJuUcHFcrBRK7w9TJ82xJ4yP/2/svRKQ+ZbUjv/DOhATM
         3Gl4TUEvpIh5Re0WpRQu8B5fZFC/N1GEHI/itm2SqLn+f2IDSxdTetIfNJ+wLI5Mwxe9
         2gm840Ta/2oHrC6CiVU1NgXO9w0HL/i1H5ZWgkZzWfiHYFvuiUk+TSHrrzTaIQ0oeGBG
         pjDsdgQn7f8OfdNBBL9jRB0Z/iUS0y5gCUZg4CkXEy9Ltbkz00hXllO8YKgd9vTGYeZA
         VM3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=25a39fQthoJQenvf3ilsmj4we8U0R1UDFLTQO2djkUo=;
        fh=6wFh1+wCOaahoz/n5w5fPUcBtVqmZ6miK0HUL3jiyOo=;
        b=B6EZpqZRF9KpiF6hoZnIhWcN33dzOTVp7Y2NZdCRFgOAUaLkONRHgCWwILR38Ca97L
         DHlC5Xb4tMDSjbPRecrM7BDXN2MQD1PUTAI+YNa90arjPEexf0RSqvFwzyKz94FO8hL5
         Aer9THJx8+WHn2JPdONNGO1Fr8QBLjpMuNjUVOqnksVVXBut+AAMSHaAgeLLuW6fumbm
         0zpd6nqNy3gH67M83xal7A4Wi4uu8WSkjqOahm5HeMHrbVS+RlTtJdsfpU/tAI3crVTD
         dZidajv8a8kvLPLazno0vcAJ54+yyIQWWDjDjA1meATg/Bx3pAvcw6AmuPB5evFPmzTj
         hyJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789675380; x=1790280180; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=25a39fQthoJQenvf3ilsmj4we8U0R1UDFLTQO2djkUo=;
        b=RfRoG1sioHwQsGYSkcve3ZDGfErdmSWrgCWHA2JlCBaobnXxnBfdr0TKVq27LK2zIZ
         UOvE17R6vYGLa6zQAttig93toa0GDEpwxIgGBTum0FIhjWQ2ZvB9dyNYwvdV/otOI5vm
         A3ZFMmlVd6uq3DhAGMGK/mu80sINzK4rP2D3RMyU2gORKLRV1tGre9kz1kts6W1QAYaT
         9XuABFIURZMRzl1KZihvHVFw9CQ9VbWSNQiQyhE/Rv/Yb9DXy8oRagR/6b1gegQS3v8y
         YYEboH4Y45Pq3GkmJCdeXvha1ezGt4n7sH0US7ujlIUX6kFFOMpc2oolhcFXbjqXk/zG
         N+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789675380; x=1790280180;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=25a39fQthoJQenvf3ilsmj4we8U0R1UDFLTQO2djkUo=;
        b=msvGqDwklOB9JnA6mkYyP+4coGm0Mlli/kDF+KcBjbF9Fco8Q/15qjQVr09wxGPxdC
         0sTiz6jO7Lub4BpnpbIUd9zVPuWBj8r28te7CJDd5FoSuFLzmrZhU0UVnSUIhEYkPN18
         0OS2aoSUMb+5gnkOqzjojD6llZ92Y/RA94S5CY5fSA+S0eI6R7o5h9comc2Vxwt7FGTg
         lfX9Ozsdjt+UeoO1j4QGaHghA2ilM3PaE7Iz0v/Du56OkK6vuT+TNIRoyRnEV5eEKf/E
         fi7uCwRTWViq5u1PqHJDO0czc1+GLa5rJkSwSpGQFdR4B1FvoFO3fJnll7WQ959H7Igm
         O+ow==
X-Forwarded-Encrypted: i=1; AKwUvBwcyogmg1fqbcARJfoLkHwaW7Kg0M3T5ho41fYeiOW4hSAp5ubJ0yRtkELWAwH0y6OS5SOYo4tOnpA=@vger.kernel.org
X-Gm-Message-State: AFuF++n6VGPPH4yk9x8pSgYgE5HUdf/YlFSkxnLvZdVQDOwUQhVYNN1w
	C3uMEhott0wVr69qguLXa05XO5Doq8euUHtfUMYHT1kL1fx7xIUqVOvwAE9CyXu3Su8Xy9HNH+b
	mwwS3aeagY13KfgEbCi/zFSZtfRP2HdYvbr3hflAS
X-Gm-Gg: AYBFou3nkb1FH5vst0EQP08tfF9jLBl9srYqEv4dDF5dlNdSX8QqwVwhnOEuJKHq0Fv
	Atbw77rwaA9hJgRSv0fFwPd+4k3NWygr5PCt38fRc8zZfkJona5Tr1++ava6Ify/2rwLkjwUiXQ
	8IwySxXyMozuGg0ymfxLhVtzwSs8RQN37Rsq4oXq9XEMgrjdeJJjD6LgZSHv4y2V2MuDyTbPP6R
	o78aMgfTaA7GclDjh6oK4g0fbIhFyTWIJpfKD0uS/VqOAF26zEZfpNuSDUs8XD53IAtC5lB6UHg
	UOTMPFT4afk1ogvWFPruVKo0efd3uMRLygAKIBXWLT/q/Qi6rpzWPXbBM+7JElqFrF2/EupViLf
	C+mU86yo0YL/ntQt/fzzQkf9qiXUXFUtW1F1P16I6xIV990hdmys+7lQ4G7sRc8lqMpgL7Nc=
X-Received: by 2002:a05:600c:a013:b0:49e:6891:27a8 with SMTP id
 5b1f17b1804b1-49fc574a9bcmr72735e9.25.1789675379819; Thu, 17 Sep 2026
 13:02:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <CAHk-=wjwtJQPW+MRAkQCcSGA1EZWehxBTUiEUUhdACCNHSKvTQ@mail.gmail.com>
 <aqwkk7FcQ0XWeqJW@gremlin> <aqxCNyxYRzN2Oher@gremlin>
In-Reply-To: <aqxCNyxYRzN2Oher@gremlin>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 17 Sep 2026 13:02:48 -0700
X-Gm-Features: AcwNN1XUt93HLe1Zu-oZLdknUZyAU05hxj4P7Ko_JzOHOx4U0fnT6yaI1XKYaw4
Message-ID: <CAKwvOd=zbE8MZXCNCBJNpd2WWn7f+AOfxYcmCp7e-8uFSM+D9g@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] kbuild: significantly speed up kernel builds
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
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
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 12:42=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Thu, Sep 17, 2026 at 06:36:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 17, 2026 at 10:15:26AM -0700, Linus Torvalds wrote:
> > > On Thu, 17 Sept 2026 at 09:06, Lorenzo Stoakes (ARM) <ljs@kernel.org>=
 wrote:
> > > >
> > > >                 =3D=3D defconfig FULL build =3D=3D
> > > >
> > > >                         before    after     delta
> > > >                       ----------------------------------
> > > > Threadripper, gcc        32.5s    26.3s     -6.1s (-19%)
> > > > Threadripper, clang      34.5s    27.2s     -7.3s (-21%)
> > > > EPYC, gcc                28.7s    20.6s     -8.1s (-28%)
> > > > EPYC, clang              39.8s    32.2s     -7.6s (-19%)
> > > > M2, gcc                 519.3s   512.4s     -6.9s (-1%)
> > > > M2, clang               634.5s   569.4s    -65.1s (-10%)
> > >
> > > There's something odd going on with that M2 gcc build. Why is it such
> > > an odd duck?
> >
> > Ugh dear lord I think the LLM somehow corrupted the numbers... Let me
> > re-run those myself locally and come back with the actual times!
>
> OK numbers are in:
>
> M2, gcc                 564.7s   512.1s    -52.6s (-9%)
> M2, clang               615.1s   564.1s    -51.0s (-8%)
>
> From the v1:
>
> M2, gcc                 564.0s   512.4s    -51.6s (-9%)
> M2, clang               616.1s   569.4s    -46.7s (-8%)
>
> (Tested as per the cover letter pre-reqs, i.e. applying dependent series
> first etc.)
>
> Not sure on the -5s delta on the clang build :) that might have been me

Clang is faster on Thursdays.

> being more disciplined this time to not use the laptop at the same time.
>
> But broadly in line with the original numbers.
>
> >
> > >
> > >              Linus
> >
> > --
> > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo



--=20
Thanks,
~Nick Desaulniers
