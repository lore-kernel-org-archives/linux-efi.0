Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE893BB128;
	Tue, 15 Sep 2026 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789495430; cv=none; b=tK4FFG8ohWsp5+XDk7sY5HDSHWhrl7zpA1HVcXy8oWwz/yb4HSSOGyHE/JV/KOmZa7w0AzD81ylvTzJr59pgEcAXtFF/IN+hQTVwmNZSatbH8G7rSDFAraPhGkEz1S9BVRNCL37Yor7BPsSXfDYXZGXO58YKSmisJa8b/PNadog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789495430; c=relaxed/simple;
	bh=acA8Pl0ra8uGRhaY3yUxU7JeUeRVK1VSh+mJtBE56Dw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FjRt/+BS8Hn6v7Iig5+S2PbQwc3+TzJco9Px79pzrcaif7dTkFr+tA6ullkbQpIq8+llqCoACoCyW0i9BxC8aSKLvwX/FDq6/wON5VwzStrS2x8A5rdZNVyx0VtF/AO4ZKYQgxEODbBk06FYXPAcGMpExxU0HzdpOMK0uSW16VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=U4sf78++; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oq9Ixf7y; arc=none smtp.client-ip=202.12.124.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="U4sf78++";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oq9Ixf7y"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.stl.internal (Postfix) with ESMTP id 5358A1300085;
	Tue, 15 Sep 2026 14:03:43 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 15 Sep 2026 14:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789495422;
	 x=1789502622; bh=M+18z9TRevaxtOpUOsKP4yasoi0N4a+EiZHqRi1jYdY=; b=
	U4sf78++DYavqgGlejlEwUXoEqhIsCFB/2NyMKaj1PndBkbO10J1TMqWCQzUYQ9k
	CTbm52mBhfYJSzo7pJnhLJi2SRLdZ/DVdPmXmQb1D3hIh8EpSvsDulGT6hQvUFIl
	s0XDhlwy8JxTxnRPbwZ8jQBUc/hT3IDcWw2vdOWMrVTXA9ZLM45kBy2fOChmGOqv
	0+L20OS6Ia1ohb1HeKO1C98ue8KmLWJK5lQn+jdj5x6oU046t+BwxkTtESnJG923
	Lu2frFKww9pEJwXwyFRjRWXBSJW2faQu3PiYgYk4lGG/swolQik/CSxOyRbDqKzZ
	5i/cSlA0RTVVNA5vyJ1UPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789495422; x=
	1789502622; bh=M+18z9TRevaxtOpUOsKP4yasoi0N4a+EiZHqRi1jYdY=; b=o
	q9Ixf7yRpyn6OvcbGl5rXjJFa1njovmQxMYA4/EkJhzjD+maxV5GG3ba19SaW++G
	QOs6J0Fa/LV1lhtIdMIv5u3xcXBUQ/BkWbwv2PwZIHlLdfK4i2AUGu8CtspgtS8c
	EWbgkgpdTYWZOz/tN4VFpLBiz9bx7j7kSMWM1k6IOH5QrWdbjh9m+DsvGh3OX/+q
	Taj+DrKSfg4H32xe+YDJe5XD6ZR2tm8J04XsaAu0J35LGaavhJOritpYkOeAJ783
	j8NjM0zLLgbkFuWyOYBUo5LLRpGC7dSHRYUJ8wIUxD2UbwvDMvzzE9DiB6DFOo42
	tzIy3NobehRhziIOFHhPA==
X-ME-Sender: <xms:cYipailbmg0-tN27ofHkhd07IO9gZOWNIOQrLQ9DCYqzmFuBBSchdw>
    <xme:cYipakp6-uuZN1YnstpXkrEp_5StGTOJ0BtK_HxcCa3-ZFjlPC2cZMGQDppbVG_uA
    JTnyuDh-VT8k9QjS8W0fkX0MgtjMGCzioAvPHVpm5r0ohPlZ5ZtiQ>
X-ME-Proxy-Cause: dmFkZTFLubBmkF9VxUXZctMrdWBp2PvxU3vddrDMSNApH/C34f5Jo4vGvSjFWGqcIiCAm3
    t2jJUO6j4wP3lQHA6L91qY+aXHlhV17TaNSiKSTmW0xstZgu79Dl5jU03KzK1s2YlOJo/3
    wa4j2nKMRel037MnTHQ8te/M/aE7zD4CsPrI9tQLPGUChDom3CR70v4zVmv3gD6zyRZry/
    fxHOTxmp3YVEprGwCEBNhJAcVk1vsP7wwArzoSgdgEFZ4vL9ELlAkcVUbdVwjHtuSZqaWP
    AWe9eJ3y4fgUpnZHio/2j2aSBhv/10jGSapZIF0QaWlVDG6ssnreMapOlCHyUWq6kttutf
    oDo7WlKZ5fFrKrT5By2389BEZwy+E2RhGE3phrfshauQuSZFgNJgWkijQF179i664QRgP6
    LWCHtGbyIntI8ToE6NC1nHUqRV3n/l7uF4Eg8HGHeMFuBET58m59Ywkhe67LY7fOzyBVcI
    2Q7BJAsK3NiPZYa+Jk7vj6XEdScnNdAgzPbI5zWgH6tlyIhnXAgIix0rQDdHElBplOBVyO
    ekn2oaLCLvIcziLphnqNFkN6LJXV4JahCtpz7G1bwv76eoWQ39SAfPB6eTwfYtTu3wFAkR
    34zZQJYlvXiTbuPfeqaj/5YlnP92Hdkc8ppMPu1ilrNf3/OICLnd/8+gehrQ
X-ME-Proxy: <xmx:eIipatwHmU1_ouWm4I4RW_lK9XEMTS_CpIwSlkIYf8iZURXKG1MQPg>
    <xmx:eIiparsReeDpWZOQeMc6tmSPPtMQx5IHt8-Vd8XR-iDUaNV_5h26nQ>
    <xmx:eIipaucVS9uDmW_RRTNLCtqQ-2PAstNP4U_wVoGhtDrwlfy64or6jg>
    <xmx:eIipajGS1AnUEw8rJ-AJ0f-ObcOldpUsOc-p5zmlPVGDO0QxR48S1A>
    <xmx:foipaoajkqxqQ1sWqPi4SzqugSxTjUav0JGVACWsRKXejYebtAmyZxYQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2D5C132A0081; Tue, 15 Sep 2026 14:03:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ArHA-gVR6p-N
Date: Tue, 15 Sep 2026 20:02:38 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nick Desaulniers" <ndesaulniers@google.com>,
 "Kees Cook" <kees@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nicolas Schier" <nsc@kernel.org>, "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Alexey Gladkov" <legion@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>,
 "Gary Guo" <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Tamir Duberstein" <tamird@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
 Linux-Arch <linux-arch@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
 "Jens Axboe" <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Message-Id: <90006ad1-73df-4bd0-a434-61875edd5bb9@app.fastmail.com>
In-Reply-To: 
 <CAKwvOdmgeyqivO4pVa=30XDWpXvdRzBR8f13rfuPzDx=LJ1Tsw@mail.gmail.com>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609140844.FA7E848A@keescook> <aqk9gakQhxToLnDI@gremlin>
 <202609150955.A51C9F7A20@keescook>
 <CAKwvOdmgeyqivO4pVa=30XDWpXvdRzBR8f13rfuPzDx=LJ1Tsw@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if available
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026, at 19:47, Nick Desaulniers wrote:
> On Tue, Sep 15, 2026 at 10:31=E2=80=AFAM Kees Cook <kees@kernel.org> w=
rote:
>> On Tue, Sep 15, 2026 at 03:30:43PM +0100, Lorenzo Stoakes (ARM) wrote:
>> a)
>> My main concern is the lack of respecting the -j make argument. In my
>> mind, this is a blocker, because it means a build will now _always_ s=
pin
>> up max CPUs (not what -j has limited it to), and for CIs, shared comp=
ute
>> systems, or whatever, this violates the requested parallelism level. =
For
>> example, if I'm doing a long-running Coccinelle replacement in one tr=
ee
>> (which uses half the CPUs), any builds I launch I'm asking for the ot=
her
>> half of my CPUs to be used so they don't thrash my cache.
>>
>> This is the kind of "why are all the CPUs spinning up?" question I
>> helped track down with commit 51e46c7a4007 ("docs, parallelism: Rearr=
ange
>> how jobserver reservations are made") forever ago.
>
> Parse -j from MAKEFLAGS (https://stackoverflow.com/a/76517886),
> forward it to pigz?

That still has a potential O(n=C2=B2) problem: if one builds N kernels
with a top-level jobserver on N CPUs, and they all take the same
amount of time, you end up with N pigz processes each trying to use
N cpus at the same time. Ideally we'd use the equivalent of
-flto=3Dauto in the compiler, which respects jobserver settings,
but I don't think pigz supports this at the moment.

      Arnd
