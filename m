Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082434;
	b=2HoucCz70G/bCTnDJrckcwJRJ0naAwi97ZfQR64jmvFSLXOtJgPFKmjPFTzNKSJKRkwu
	 8JHVnmi5rPAF4FtM+Xc1PzNn8TgJxcpGryoj2rgqMYu224FYjPG1h7FE+aiflsPidVhRg
	 L/edaJr0+QvLRX979hr0PnMUZuGNI28azMRU2s8jrYZdqxs+Gur8OwsES8W3qiRbGcKKr
	 ibzoYjeuCLOQbpwqoLAXC/cMZGP4YlvsV38u4ljktLurb4+KaXlVEklPqnnA0iUXaJXee
	 tKbEs7AfMmaQ5ZnvUwKFbUP0LuEwXMfAAjgsw8YaCeQ5WCxBN4x61kdJqkEHy+u+Otw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082434;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=Vo/QPuyt9xAuVc4bYgeGFAf56PcN2UEvOdauMxhbg+4=;
	b=sOUHuLu8tU7phHrCwQy6oNQ4BuQAIWMtb977S5qTqjJ3grQzAyYOO1FaZVnBn8sRxclv
	 NtFrGk8pzylemTy2WUL/GLmc4tWcO8Sn8TFOQCsF/faTio3MJUzF7QecKxrc7gAmvq20p
	 5hAYODKI0WNxDYBaNH+iEAzMBfWokmSmGr26M+zKq0LhCDmVDy60rGr+Dg2Bp5W0f3tGn
	 vWA3KEQ+UdcMCAxTkJKElrdRW+DxZzo5Xq1LK9LUV40kuST45H0HdcARyYGGIb+jcQjFU
	 CE0e9GIWuivRTRXlYXSF6zJoTyUOyDTVJ8YCrs6tgjTFU5VjlKXNXfYe0AFHaL5s9Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmrYS7U4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE76E606A332
	for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmrYS7U4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011F51F000C6;
	Thu, 19 Nov 2026 10:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795082434;
	bh=Vo/QPuyt9xAuVc4bYgeGFAf56PcN2UEvOdauMxhbg+4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ZmrYS7U4pePP2mBE1wx/rbjbc0FhnjJPILbXpfM/dNCNb7gF8gM+3PVWI1+rHW+VJ
	 qjQxJXdLsX1rJmP8541s9P0KDJsjXo447UrSXcNepkzn/D0/09lTjYKJhFboUl1o6f
	 GQJ3AcAFaAmHXEUWFyvgflxUPXWppoOFD3YBE0OwLN/Yqix+t4zuLPz7qz3bO1cImd
	 VbhkIoRKpyYye2yr5m3vXwxQJ1By3LEKd/56A4zUy9Cr1bJbPwNyRxKiVjAQBe9nPe
	 hjfl5rZmSOuvSiOmdUV1mbn987/XdPvwlcnQjjfSJc+ZkAw0ymn1g5dcl8CbYz8zm2
	 SuYLsTESi/z3A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3F7541980050;
	Thu, 19 Nov 2026 05:00:32 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 19 Nov 2026 05:00:32 -0500
X-ME-Sender: <xms:vsj-avqMWg9Ebw9PL_nZ4XxfFdNKhAa1jlstwwowZaexwzrmCFrvzg>
    <xme:vsj-akd2PYJ1MNPKY5xWqjXqCpuZLbvxbCTPZualVuenePe2qoWWro3sPOqFbU0km
    5ATfH-6gM8x1U42V8Wa3OrRO8M81MQMQonvMEYpzh5AxeVSPhY1v3l7Xg>
X-ME-Proxy-Cause: dmFkZTGjww8F+XJuiEtzEuQxXT8X8Z5U5wwSDx+1e1m8iuz0iRNJwrP8yIHzbMKKp/KbB+
    5uEjTWw+UlMMGHasgP9mv7TsqROodvJHaHMwuWoZmwxCP7AJKXoOT4a3jUgqLaIrlpHx62
    s5VM9Ztn5Z6U5nSSV/6ZZW+jNV+5yYeIpsxGcM5Jk+7SRUBE3J2Xnj+jaAdNZvRHVSc8Fb
    YFzPjAeVFpeniWMeY/bK5PCQolF45dHLJQd9js7ckuw/VqAz+JIRtTpCYhiV9xdRv6fUCi
    ZKj75CEHNT1oYEX1xJRbNLKmLvvzuXVN8tFkf0PRkVaB+UfbBIMICpBeyIyeIrC0IDsfIs
    +KIdtk1yk1h+2DGTqP4rbymMY74MJaV3S/DEke6KMuSIlQ+dl6Lgwzv4d3iaJ2IAI+lRMY
    a3tbT6wVQ9Q3OcwSjY7Abvt75WucMEZOO/vO6wIF1fKIL8EwEcNIiUFtfTAupbvCtU+hZg
    60YgAA6/5HhCiBzG2HScMpAGrdDrYQ6hYyBQMndxErcXUTKU6vrZPRhZU141Mg013p1WS1
    UProcQr3P+TnJGTIZi3G6OGqXhZJIvaX2zZxXceDgLOWeLX9tRlAbz1uOBsQhUNTlQ0FXX
    qeDWcI2gjsPENiq+OC3S9zRZbqyUrMgOEccaiMUMhANAryFf6GFa6NP9dvoA
X-ME-Proxy: <xmx:wMj-ag3ZG-zeDmda1qr1KQlfeX2dU6uhQyWDfRr9ygtKXC_W9LUkJw>
    <xmx:wMj-akBy1e4iQx7LlqIq-kUB3rhRz_F5s3EBEkkAsY-sNm83Mu-TLw>
    <xmx:wMj-akdtwJ7-BwFm2AnLwWi63o1WVBFhXedepzow8z83loOEnOFeXg>
    <xmx:wMj-ap6SAcFhsZW_q2OMtaOdp1RmQtx8S4YikPjFnxEWCTbiGcg_fw>
    <xmx:wMj-avW70A1QhZM-QkE72eyArfaoA-gK4YcIknPSNlWC7JSAYDHOqM_G>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id AC36DF8009A; Thu, 19 Nov 2026 05:00:30 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 10:58:55 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "H . Peter Anvin" <hpa@zytor.com>, "Ard Biesheuvel" <ardb+git@google.com>,
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <1cba56de-1094-4245-9100-2598039a09f7@app.fastmail.com>
In-Reply-To: <f2297061-4ad1-4ece-89de-5459816e5461@zytor.com>
References: <20261111091843.3621782-2-ardb+git@google.com>
 <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com>
 <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
 <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com>
 <ab8628ec-9476-4f3c-80fc-b68556803002@app.fastmail.com>
 <5E2684EC-0F34-4008-B043-F912FA1AAE6C@zytor.com>
 <16b3f916-41cf-4ad6-bd54-45384051d4dc@app.fastmail.com>
 <f2297061-4ad1-4ece-89de-5459816e5461@zytor.com>
Subject: Re: [PATCH] x86: Make the 64-bit bzImage always physically relocatable
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 18 Nov 2026, at 20:35, H. Peter Anvin wrote:
> On 2026-11-18 09:26, Ard Biesheuvel wrote:
>>>> ...
>>>>> I'm going to vote NAK on this one... I was already thinking that it
>>>>> would mess up low-level debugging too much,
>>>>
>>>> How so? The last time I proposed this, you replied that you were
>>>> planning to do this yourself.
>>>>
>>>> https://lore.kernel.org/all/3f2e8d7c-6029-49ef-8e31-a3eb5efb385b@zytor.com/
>>>>
>>>
>>> If we are going to get rid of it, we should get rid of it properly as
>>> in removing the conditional machinery,
>> 
>> Which conditional machinery is that? All the code that reasons about the
>> physical load address needs to stay, the only thing I am changing here
>> is that you can no longer disable it on x86_64, as there is no upside to
>> forcing the 64-bit kernel to run from a fixed physical address. This
>> means the EFI stub no longer needs to depend on CONFIG_RELOCATABLE
>> (which also controls the generation for relocation data for virtual
>> displacement) for x86_64.
>> 
>> The i386 situation is different, but I left that alone on purpose.
>> Would you prefer it if that always became relocatable as well?
>> 
>
> Yes, if we're going to do it, it would make more sense to do exactly that.
>

OK I'll go that way then.

>>> not use it as a backdoor for
>>> doing something explicitly NAKed (forcing PIC compilation.)
>>>
>> 
>> I know PIC compilation is a sensitive subject for some people, but
>> would you mind not framing this as some backhanded action on my part?
>> 
>> Once I get to resending that series, you will have ample opportunity
>> to voice your concerns and suggest workloads that will prove that
>> it is infeasible. Or even provide one now so that I won't have to
>> bother resending it in the first place.
>
> I do (genuinely) apologize; that was indeed *quite* uncalled for.
>

Thanks, much appreciated.

> What I *do* think is a real problem -- and you are far from the only or 
> worst offender -- is to put a vague "future improvements" as 
> justification for a change. This is literally asking people to take on 
> faith that the "future improvements" is actually an engineering 
> direction we want to go in.
>

Point taken.

Since we are discussing the future respin of my PIC proposal here, let
me address those points as well.

> PIC compilation is another matter entirely (as you also very correctly 
> point out!), as x86 unlike most RISC architectures has enough direct 
> addressing reach to encompass the entire kernel (in the "medium" model 
> for user space and the "kernel" model for kernel space.) This means that 
> x86 benefits from GOT/PLT elision in ways that many other architectures 
> don't. On the flipside, because x86 is a CISC architecture once you give 
> atup performance in the compiler stage it is very hard to recover it 
> even in the linker stage. Furthermore, on i386 PIC is *extremely* 
> painful since it involves giving up one of only 7 usable GPRs (6 if you 
> are compiling with frame pointers!) and a relatively expensive 
> sequence(*) to get EIP manifest.
>
> As a result, I very much will continue to object to PIC compilation on 
> x86 as opposed to boot time relocation. Whereas code patching in user 
> space is expensive due to breaking sharing and thus demand paging of 
> executables and libraries, none of that applies to the kernel -- and we 
> do runtime code patching of the kernel anyway. The relocation is just a 
> special case of that.
>

Please wait for me to make my proposal before shooting it down. You are
making assumptions about the impact these changes will have without ever
having looked at them.

I am not proposing any changes to i386.
I am not proposing the use of GOTs, PLTs, etc.

What I will be proposing is the use of RIP-relative references instead of
sign-extended 32-bit references to global symbols. The reason for that is
that this will allow use to run the linker in -pie mode, which then produces
all metadata that traditional kaslr needs at boot time.

> Now I do know you don't like the compressed kernel relocation format 
> (which you are not trying to change with this patch) and it is *most 
> certainly* insufficiently expressive for fgKASLR. For fgKASLR you need 
> to know the relocation base rather than a simple adjustment factor, even 
> on an architecture like x86 that doesn't have to deal with "upper 
> part"-type relocations (for which the compressed format approach, 
> carrying embedded addends, completely collapses.)

PIE linking allows the use of RELR packing, which reduces the size of
these compressed kernel relocations by about 95%. This is the same
format used by PIE in user space, as well as other architectures in
Linux.

The size increase of .text is between 0.3% and 0.5%, and none of the
benchmarks I've tried showed any significant performance impact on
the micro-architectures I have access to. With this patch applied,
you get those 0.5% back if you disable CONFIG_RANDOMIZE_BASE. This
is the future work I was referring to.

I will be more than happy to try any benchmark you can throw at this.

> The metadata required 
> by fgKASLR is positively vast in comparison to the ordinary kernel boot, 
> and legitimately so.
>

Indeed.

The implementation I will be proposing is essentially layered on top of
the ELF representation, using a seed to permute the contents of .text
in a stable manner.

This means that a debugger that knows the seed can permute the image in
the same way before loading it, and so all post-mortem and source level
debug use cases are still supported. (Whether the seed is preserved on
the system itself is a separate matter - on Android we will probably
discard it after booting)

So the permutation performed by the loader and by the debugger is
implemented by the same shared code, and the resulting ELF image
remains a valid image as before. This allows permuted images to
be packaged and shipped as well, without changes to the runtime
loader (this might be useful for Android in some cases). It also
means that traditional KASLR is still possible too - fgkaslr just
fixes up the RELR/RELA metadata after doing the permutation, and
the existing code works exactly the same as before.

The upshot of this is that relocations tacked onto the binary after
linking will go out of sync, and fgkaslr boot would lose the ability
to do traditional KASLR as a result, which is undesirable. This is
why the existing x86 relocation format is incompatible.

> However, fgKALSR is time-consuming. On bare metal this is rarely a 
> concern, but users want to be able to spin up a VM kernel in ~100 ms. In 
> that case, the compressed relocation format is highly efficient, both 
> since it is compact and since the processing of those relocations is 
> extremely simple.

I am not proposing to replace those relocations with fgkaslr, but
with standard packed RELR relocations, which take up only 5% of the
space used by the bespoke x86 relocation format, and can be applied
by the following for loop:

for (const u64 *relr = relr_start; relr < relr_end; relr++) {
    if ((*relr & 1) == 0) {
        place = (u64 *)(*relr + offset);
        *place++ += offset;
    } else {
        for (u64 *p = place, r = *relr >> 1; r; p++, r >>= 1)
            if (r & 1)
                *p += offset;
        place += 63;
    }
}

> Furthermore, since the kernel is also ready to go if 
> loaded at its advertised preferred address (which is the reason why this 
> address is explicitly advertised, even for a relocatable kernel: "if you 
> can load me at this specific address, I can boot faster and your vmlinux 
> symbols will match the runtime, too."), the performance-sensitive VM 
> spinup the (virtual) environment can be set up so that the relocation 
> can be skipped entirely.
>

Both RELR packing and the fgkaslr I will be proposing have the same
properties: the metadata can just be ignored, and the kernel will boot
in its default permutation from its default virtual load address.

So perhaps we can continue this discussion based on the actual code once
I post it, rather than on your assumptions on how these things will be
implemented? I promise you I will take your feedback very seriously.




