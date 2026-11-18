Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030562;
	b=xh8bpZKagOPi/MW2fXFSAYMK7cc2o7UdzkHqFcGVtz3BZvNeGQKFbhamdF6uSnTwSX6P
	 iGKA4+PlS4za6WZnE1gg1xPY8H4jJjrnPPJclv+Jr6+IwCUJRFKcm8kvg0RIfyanc6wJQ
	 XJMBpYZh2rMLcWQmRT6Gds8LDi/BnMr2Z8OCY/ehfGzqNwopkAiDhvaf+ttIXCcZ7AsPl
	 0S1416iTk/iXr3UAL4elXd5s0PhTmL0XrRPOPnPCK4QTmsz+6q9deB9aM7pw0n8eaoIfA
	 wWZwaVWiaFvi1Kkls9RsI6pqOkdAEoolFCvS37CxCPCl2U+WXDKocC4Z4AoCWdXWPgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030562;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=q5Mo/Kh1qLZ3uIRaKlBLItE0Zsx4/+Cy55RfXtKFyLU=;
	b=Cb6kvU2DM4AU0Qmd1P8qIXXOfT1qZp/dNWVMGVLAxZytOd4zqj/n3z1Nxkt3li0ztNEe
	 3BB4NqY7EIFcsfz7SWmJG0St0KIehkpORci4OpfsxLYtkFQyjx+La37bW0G874XKKglsS
	 VIE9zbP4i9bwTfj85FBJen+JP1rJeQdAdFeYy9KL28/2WdkXvR/BTekB4aAOg8+EiZAOA
	 XZ+BCmBrLOFI/cnleHFWV49wNawwzhNThi0pZcIAp85pCz1XkyrC2aqEMNCKoVaU+fc+a
	 7PqekAThAPNQ3DKg7JU8WSoHNxjMOAR0P0+t19SI5KxBs6lHvJveWRiK5apFWcx/xKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zytor.com;
	spf=pass smtp.mailfrom=zytor.com;
	dkim=pass header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=Cd6T897N;
	arc=none smtp.remote-ip=198.137.202.136
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3C606DD21;
	Wed, 18 Nov 2026 19:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD3C606DD21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=Cd6T897N
Received: from [IPV6:2601:646:8001:6901:cb27:19ed:d7a2:a981] ([IPv6:2601:646:8001:6901:cb27:19ed:d7a2:a981])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6AIJZu8a3700793
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Nov 2026 11:35:56 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6AIJZu8a3700793
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026102901; t=1795030557;
	bh=q5Mo/Kh1qLZ3uIRaKlBLItE0Zsx4/+Cy55RfXtKFyLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cd6T897NlrMMzl6wCswGkonOy6f1kl0OcPXgJETQAYNvF9v1tdKDwIPKuZPztHe5J
	 C23rrgCePy/4nYEhoN2NALyNex49pGP+8XFNEGnwXKTYrZ0i6KA2nTveaR/Ism7EqU
	 iNzp26v7JXi1C4EH5PUeEPhcmjDY96eKFV5D6z8EzWhse/hOkqcsQfxhNxDbKdi9Yg
	 EWnJrEUl/ywJwQKA+KW2DX0R4yJpun7wUsg1Cc++ccw/1MB9N7T3j5XvAfyQ0KdRzu
	 Wc+2MHZcJySSSSc5x0e8bPAj+v0yuTyC/wFOYL+BZ5cf5PEjX7t2hBrypAt4ELSqaL
	 XTCTmMszfiPIA==
Message-ID: <f2297061-4ad1-4ece-89de-5459816e5461@zytor.com>
Date: Wed, 18 Nov 2026 11:35:51 -0800
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: Make the 64-bit bzImage always physically
 relocatable
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20261111091843.3621782-2-ardb+git@google.com>
 <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com>
 <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
 <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com>
 <ab8628ec-9476-4f3c-80fc-b68556803002@app.fastmail.com>
 <5E2684EC-0F34-4008-B043-F912FA1AAE6C@zytor.com>
 <16b3f916-41cf-4ad6-bd54-45384051d4dc@app.fastmail.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <16b3f916-41cf-4ad6-bd54-45384051d4dc@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-11-18 09:26, Ard Biesheuvel wrote:
>>> ...
>>>> I'm going to vote NAK on this one... I was already thinking that it
>>>> would mess up low-level debugging too much,
>>>
>>> How so? The last time I proposed this, you replied that you were
>>> planning to do this yourself.
>>>
>>> https://lore.kernel.org/all/3f2e8d7c-6029-49ef-8e31-a3eb5efb385b@zytor.com/
>>>
>>
>> If we are going to get rid of it, we should get rid of it properly as
>> in removing the conditional machinery,
> 
> Which conditional machinery is that? All the code that reasons about the
> physical load address needs to stay, the only thing I am changing here
> is that you can no longer disable it on x86_64, as there is no upside to
> forcing the 64-bit kernel to run from a fixed physical address. This
> means the EFI stub no longer needs to depend on CONFIG_RELOCATABLE
> (which also controls the generation for relocation data for virtual
> displacement) for x86_64.
> 
> The i386 situation is different, but I left that alone on purpose.
> Would you prefer it if that always became relocatable as well?
> 

Yes, if we're going to do it, it would make more sense to do exactly that.

>> not use it as a backdoor for
>> doing something explicitly NAKed (forcing PIC compilation.)
>>
> 
> I know PIC compilation is a sensitive subject for some people, but
> would you mind not framing this as some backhanded action on my part?
> 
> Once I get to resending that series, you will have ample opportunity
> to voice your concerns and suggest workloads that will prove that
> it is infeasible. Or even provide one now so that I won't have to
> bother resending it in the first place.

I do (genuinely) apologize; that was indeed *quite* uncalled for.

What I *do* think is a real problem -- and you are far from the only or 
worst offender -- is to put a vague "future improvements" as 
justification for a change. This is literally asking people to take on 
faith that the "future improvements" is actually an engineering 
direction we want to go in.

The following points are in no way specific to your proposals, so please 
don't take it that way; these are more general statements about "why x86 
is special".

I do not believe in is pessimizing one of the most widely used 
architectures in the world in the name of "uniformity" or 
"compatibility", and there have been many, genuinely well-meaning, 
attempts to do so. If x86 were a niche architecture that would be a 
*very* different thing, but in the world we are living in right now, 
there is x86 and ARM; everything else is a rounding error (long tail). 
As such, for either of those architectures to carry more arch-specific 
stuff than other architectures is entirely fair.

Now, x86 and ARM are two very different beasts, which is entirely 
natural because they have evolved into their current market dominance 
through completely different routes. As such, ARM has a lot more 
*platform* divergences than x86 does, and that means it has has a lot of 
overlap with most other "platform rich" architectures. Here, ARM sits 
squarely with the long tail, and so it makes sense to strive for ARM to 
drive, cooperatively, where the other architectures go.

Here, the odd ones out are x86 and s390: they are architectures which 
have a dominant -- to the point of being universal -- *systems* 
architecture as well as a CPU architecture. This means that especially 
the early flows are heavily influenced by that systems architecture in 
ways other architectures aren't. This tight binding of systems 
architecture are a major aspect of those architectures which is very 
easy to forget.

>> What you are proposing is literally the exact opposite.
> 
> I don't think so, but I'm still not sure what you meant by "it
> would mess up low-level debugging too much", so maybe you could
> clarify that?

Certainly.

When I debug the early (1:1-mapped) flows I often find it useful to pin 
down the kernel to a specific address so that I don't have to convert 
between ELF addresses and physical addresses (for this purpose, I don't 
care about significant hex digits larger than the size of the kernel, 
which is *one* reason why kernel alignment moved to 16 MiB -- another 
reason was the somewhat special nature of the lower 16 MiB of the 
address space on some x86 systems.) Once we are running under the kernel 
mappings, it is just a matter of of turning off kASLR.

Now, you also quite correctly pointed out that I already proposed 
turning on kernel relocation by default. In practice it doesn't become a 
problem, as the kernel generally ends up loaded at 16 MiB in a legacy 
environment, and in an EFI environment you have to deal with the memory 
space EFI assigns you no matter what you do.

PIC compilation is another matter entirely (as you also very correctly 
point out!), as x86 unlike most RISC architectures has enough direct 
addressing reach to encompass the entire kernel (in the "medium" model 
for user space and the "kernel" model for kernel space.) This means that 
x86 benefits from GOT/PLT elision in ways that many other architectures 
don't. On the flipside, because x86 is a CISC architecture once you give 
atup performance in the compiler stage it is very hard to recover it 
even in the linker stage. Furthermore, on i386 PIC is *extremely* 
painful since it involves giving up one of only 7 usable GPRs (6 if you 
are compiling with frame pointers!) and a relatively expensive 
sequence(*) to get EIP manifest.

As a result, I very much will continue to object to PIC compilation on 
x86 as opposed to boot time relocation. Whereas code patching in user 
space is expensive due to breaking sharing and thus demand paging of 
executables and libraries, none of that applies to the kernel -- and we 
do runtime code patching of the kernel anyway. The relocation is just a 
special case of that.

Now I do know you don't like the compressed kernel relocation format 
(which you are not trying to change with this patch) and it is *most 
certainly* insufficiently expressive for fgKASLR. For fgKASLR you need 
to know the relocation base rather than a simple adjustment factor, even 
on an architecture like x86 that doesn't have to deal with "upper 
part"-type relocations (for which the compressed format approach, 
carrying embedded addends, completely collapses.) The metadata required 
by fgKASLR is positively vast in comparison to the ordinary kernel boot, 
and legitimately so.

However, fgKALSR is time-consuming. On bare metal this is rarely a 
concern, but users want to be able to spin up a VM kernel in ~100 ms. In 
that case, the compressed relocation format is highly efficient, both 
since it is compact and since the processing of those relocations is 
extremely simple. Furthermore, since the kernel is also ready to go if 
loaded at its advertised preferred address (which is the reason why this 
address is explicitly advertised, even for a relocatable kernel: "if you 
can load me at this specific address, I can boot faster and your vmlinux 
symbols will match the runtime, too."), the performance-sensitive VM 
spinup the (virtual) environment can be set up so that the relocation 
can be skipped entirely.

	-hpa


(*) That being said, the use of an out-of-line trampoline to do so is a 
thing that was only relevant on a small handful of cores that 
unfortunately fell right at the end of the true 32-bit era; on both 
older and newer cores CALL 0 is special cased to be a "PUSH xIP" 
instruction and does not mess up the call stack. It still costs a 
register, and if using PLT, requires that register to be %ebx, which 
further adds to the complexity; if %ebx was *permanently* assigned to 
this role like the gp register on (some) RISC architectures it might 
actually be less painful, but losing one register out of 7 is going to 
hurt like hell no matter how you slice it.

	-hpa



