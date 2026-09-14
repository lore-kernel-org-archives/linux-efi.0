Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2635E48F844;
	Mon, 14 Sep 2026 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404702; cv=none; b=fvwOFpkxsaWWxkCuJD2CzYc+qM9TVDCqu0adhuVz2gOnVpGWOMKUv2RZ0LJvZOTbdM6OFt6iksFIi/DB5KEpGb2H9mXZ/V4yrOqIUeSXcH72XCkn6oyy4qEnCw/aD8s6TuZpj0SejqC152Vyln+otIDz7PTuuqLJqgT6ueMPhAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404702; c=relaxed/simple;
	bh=uGY6NcMWNLywvTowFym9tgnQwZjzy9Owr6elQkyVpjk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=YHt38HarHcVMVVkdicMBp8qgC602SZTn3JFkKHtL1QtKRSgvxLCk7fAKnLPH6iWK8+4qhL9JzUBO6xqYUrEARpB7lAi/YPmRHjidNMVsrU5duIlIW17YiO9IEr/FGjHo7TyQ+2wRhTUUlgUL7cf8lIT/D8ChUMG70y2OiSnggRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UPqg+1WX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UPqg+1WX"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 68EGnuOe3963808
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 14 Sep 2026 09:49:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 68EGnuOe3963808
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026082801; t=1789404601;
	bh=chqvEsr84Q297eDSZWoD36RZB2nZvFGrsL9c2mf5qBQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=UPqg+1WX23h3Ki5DLrty1pJx1am44iqWHAyIVVRI9r5yZ0J2cNq/MctPf7fMKr0Nn
	 1YGB5OcBbL6YqDk32/y1VC1DUpsxdZaJ0ojSZhe8qeiGwSjiIFm7smQ4QJ9Yx8iTtq
	 wd3waGp1gGqIyiv10qjg0VAYZIm0gE18GeUOH4Gkf13htytTHq8YQMCf8LSqUnGWp4
	 nnKj/qVbZk1Hye5oVOx7+nQyO8rNnREqM0BHrOWHcL7tICPNAhTMCN0lVlRsV1u+cB
	 rC9NpgEtdZ5Cf1Ki4BlrNSpYuzW/XrLi2+rCMZx/UZOwL2EgCOj6sn9KaOggIsy0MH
	 wSEhy1WjEjh3g==
Date: Mon, 14 Sep 2026 09:49:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Kees Cook <kees@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
        Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
        =?ISO-8859-1?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>,
        Daniel Almeida <daniel.almeida@collabora.com>,
        Tamir Duberstein <tamird@kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        =?ISO-8859-1?Q?Onur_=D6zkan?= <work@onurozkan.dev>,
        Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
        linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-hardening@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_21/21=5D_kbuild=3A_use_pi?=
 =?US-ASCII?Q?gz_for_gzip_compression_if_available?=
User-Agent: K-9 Mail for Android
In-Reply-To: <202609140844.FA7E848A@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org> <20260914-build-speedup-v2-21-39817ec5db23@kernel.org> <202609140844.FA7E848A@keescook>
Message-ID: <BCCCC1E7-25B7-4A8D-BDFC-D5D1FA295F6C@zytor.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On September 14, 2026 9:39:07 AM PDT, Kees Cook <kees@kernel=2Eorg> wrote:
>On Mon, Sep 14, 2026 at 10:22:20AM +0100, Lorenzo Stoakes (ARM) wrote:
>> On a 128-core Threadripper, gzip -9 of a 36 MiB x86-64 vmlinux=2Ebin ta=
kes
>> 1=2E6s, and with pigz it takes 0=2E09s, so the performance increase is
>> significant=2E
>
>Neat! I wanna go learn how pigz accomplishes this -- I thought the
>problem with gzip was a common lookup table=2E Anyway=2E=2E=2E
>
>> --- a/Documentation/kbuild/reproducible-builds=2Erst
>> +++ b/Documentation/kbuild/reproducible-builds=2Erst
>> @@ -76,6 +76,22 @@ include generated files=2E  You should ensure the so=
urce tree is
>>  pristine by running ``make mrproper`` or ``git clean -d -f -x`` before
>>  building a source package=2E
>> =20
>> +Compression tools
>> +-----------------
>> +
>> +The compressed kernel image, compressed modules and packages are produ=
ced
>> +using the program named by the make variable ``KGZIP`` (described in
>> +Documentation/kbuild/kbuild=2Erst)=2E
>> +
>> +It defaults to ``pigz`` if installed (a parallel implementation of gzi=
p),
>> +or ``gzip`` otherwise=2E
>> +
>> +The generated output between two invocations of identical builds with
>> +either of the default tools will be byte-for-byte equivalent=2E
>> +
>> +However, for reproducible builds, ensure the same tool is used on all =
build
>> +hosts, as different tools may generate different output from one anoth=
er=2E
>> +
>>  Module signing
>>  --------------
>> =20
>
>This doc update seems totally unneeded? Having the same build tools for R=
B
>is already a known requirement=2E I don't think anything new is added her=
e?
>
>> diff --git a/Makefile b/Makefile
>> index 790ef23c5e8a=2E=2E38c0cdc9f591 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -561,7 +561,7 @@ PERL		=3D perl
>>  PYTHON3		=3D python3
>>  CHECK		=3D sparse
>>  BASH		=3D bash
>> -KGZIP		=3D gzip
>> +KGZIP		:=3D $(if $(shell command -v pigz 2>/dev/null),pigz,gzip)
>
>I think the more idiomatic way to do this is:
>
>KGZIP :=3D $(call try-run,command -v pigz,pigz,gzip)
>
>However, parallelism needs to be set=2E We can't let it eat all CPUs: it
>needs to respect the -j make option (and make its CPU reservation known
>to "make"), which we already have a solution for in
>scripts/jobserver-exec=2E
>
>However, I would actually argue that given such an improvement we should =
just
>make pigz explicitly required and not optional=2E It is packaged everywhe=
re:
>
>  =E2=94=82 Debian / Ubuntu              =E2=94=82 =E2=9C=85          =E2=
=94=82 pigz (main)
>  =E2=94=82 Fedora                       =E2=94=82 =E2=9C=85          =E2=
=94=82 pigz 2=2E8 (current)
>  =E2=94=82 RHEL / CentOS / Rocky / Alma =E2=94=82 =E2=9C=85 via EPEL =E2=
=94=82 pigz =E2=80=94 not in base/AppStream
>  =E2=94=82 openSUSE / SLE               =E2=94=82 =E2=9C=85          =E2=
=94=82 pigz
>  =E2=94=82 Arch Linux                   =E2=94=82 =E2=9C=85          =E2=
=94=82 pigz (extra)
>  =E2=94=82 Alpine                       =E2=94=82 =E2=9C=85          =E2=
=94=82 pigz
>  =E2=94=82 Gentoo                       =E2=94=82 =E2=9C=85          =E2=
=94=82 app-arch/pigz 2=2E8
>
>Only RHEL appears a little glitchy, but likely they would trivially move
>it to base since it's already packaged, but off in EPEL=2E
>
>So, I would say that pigz would be best run as something like:
>
>  KGZIP :=3D $(PYTHON3) $(abs_srctree)/scripts/jobserver-exec $(abs_srctr=
ee)/scripts/parallel-pigz
>
>with scripts/parallel-pigz being something like:
>
>	#!/bin/sh
>	exec pigz -p ${PARALLELISM:-1} "$@"
>
>> --- a/scripts/Makefile=2Emodinst
>> +++ b/scripts/Makefile=2Emodinst
>> @@ -145,8 +145,10 @@ endif
>>  #
>>  # Compression
>>  #
>> +# Modules are compressed in parallel by make itself, so keep the compr=
essor
>> +# single-threaded when it is pigz=2E
>>  quiet_cmd_gzip =3D GZIP    $@
>> -      cmd_gzip =3D $(KGZIP) -n -f $<
>> +      cmd_gzip =3D $(KGZIP) $(if $(filter pigz,$(notdir $(firstword $(=
KGZIP)))),-p 1) -n -f $<
>>  quiet_cmd_xz =3D XZ      $@
>
>Then this could be:
>
>	cmd_gzip =3D SINGLE_THREADED=3D1 $(KGZIP) -n -f $<
>
>and we patch scripts/jobserver-exec:
>
>diff --git a/scripts/jobserver-exec b/scripts/jobserver-exec
>index 21b319e6c9a5=2E=2E8b953148ee9f 100755
>--- a/scripts/jobserver-exec
>+++ b/scripts/jobserver-exec
>@@ -5,6 +5,7 @@
> Determines how many parallel tasks "make" is expecting, as it is
> not exposed via any special variables, reserves them all, runs a subproc=
ess
> with PARALLELISM environment variable set, and releases the jobs back ag=
ain=2E
>+If SINGLE_THREADED is set, nothing is reserved and PARALLELISM is 1=2E
>=20
> See:
>     https://www=2Egnu=2Eorg/software/make/manual/html_node/POSIX-Jobserv=
er=2Ehtml#POSIX-Jobserver
>diff --git a/tools/lib/python/jobserver=2Epy b/tools/lib/python/jobserver=
=2Epy
>index 0b1ffdf9f7a3=2E=2Efc38c5020b22 100755
>--- a/tools/lib/python/jobserver=2Epy
>+++ b/tools/lib/python/jobserver=2Epy
>@@ -29,6 +29,11 @@ $claim child to do the actual work=2E
> The end goal here is to keep the total number of build tasks under the
> limit established by the initial ``make -j$n_proc`` call=2E
>=20
>+Setting the ``SINGLE_THREADED`` environment variable skips the reservati=
on
>+entirely and runs the command with ``PARALLELISM=3D1``=2E This is meant =
for callers
>+that run many short commands in parallel themselves, where each one shou=
ld use
>+only the job slot it already holds=2E
>+
> See:
>     https://www=2Egnu=2Eorg/software/make/manual/html_node/POSIX-Jobserv=
er=2Ehtml#POSIX-Jobserver
> """
>@@ -68,6 +73,13 @@ class JobserverExec:
>         self=2Eis_open =3D True  # We only try once
>         self=2Eclaim =3D None
>         #
>+        # SINGLE_THREADED asks for no reservation at all: the command ru=
ns
>+        # with PARALLELISM=3D1, using only the slot its caller already h=
olds=2E
>+        #
>+        if os=2Eenviron=2Eget('SINGLE_THREADED'):
>+            self=2Eclaim =3D 1
>+            return
>+        #
>         # Check the make flags for "--jobserver=3DR,W"
>         # Note that GNU Make has used --jobserver-fds and --jobserver-au=
th
>         # so this handles all of them=2E
>

If we are going to add dependencies, can we add *any* scripting language t=
hat is less stone tablet than POSIX awk?
