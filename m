Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795698697;
	b=bOTrOhsZ71h14P+Zo/T/3mKyfuThfEwG2K24HjomJSNXC+uOOGVVs2MOkYYo9jiIgLHx
	 q/lrhqHPxgE2ENYZrgEw8Dku+I3rfSalveoQbFUMgnF2E/3G18JJmIa7VRmpqKFjtKqQ2
	 /l+husUSPot7XLqDfnCuMpAcTnKbmluM93iuJqvfT7Rd/1gmM5ty5NmTxyiy9GMgfgNk3
	 27O5lW7HZGW62Z4UvLZ29AJLGehg0J9iMs1BiBmHsXCLuw3gEtI+p8vwm+OEfKlp5yKDR
	 ZK/D4iMC4REJDov/hPfah49TlX7EtJYFMW+TyOJ85erd76e+vSfOHy0rGM4HTBxmGFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795698697;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=4qIob5ecw/EDtdW4JXn4U6a5PNV3bL3WnV9y1TRrlPM=;
	b=JqbxI0BMQSEz/pCxb6tEL8SAj0JcBSP/lD9H53xRXmO/FtIa4qEM7qzX//HPt8i5yCmg
	 UdI/921i1mSuH4bYDWkUarQJCjpiEQlsQSFCIXwc/1FbnaDCoG/8o6BvwVW2Ag3QbblYu
	 NSEvJTpSKaIsJQ1Kl/YV2MOzdJvoZzd5XpZxQmQwl02f2v7AH2NpFCXFcYIVboYAIpXEo
	 1qNn0SicJhAkEs5S67cVifBbBCQor7Fg1a3wsl/oju1ZNQvrTFnAmVg7f+wjENCnvW/OO
	 z/U9JW2Evg9GwiSgsNn7Dj1ueBVvj1QZWZgG5aAZgoVSUBZmjvNIgkHyYgywyrQdyCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U5Q0BOcs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA640606A321;
	Thu, 26 Nov 2026 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U5Q0BOcs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAF61F000C4;
	Thu, 26 Nov 2026 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795698697;
	bh=4qIob5ecw/EDtdW4JXn4U6a5PNV3bL3WnV9y1TRrlPM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=U5Q0BOcszRJq+LlfemhbgIm6XrR/dPmxcJI005ynZ6g4z2QfvnsXUwwtr59/WP44i
	 X+fNT22nHLECql5yJRUvXepolGCUafcJeZ8JYPJO1+hj9UHinC+4oVRxopBCmXDLVe
	 6MHP1APtTzWXtSILASp0mlhsltWJkZpyliSJGddHsd+Ua96d82otOWiumlcz/IBcco
	 xUTZKevlrNsMI64yI5kkT/YW5C8n8vM3bSZa9GjPyO/Ozu01Ej248qXntGlS/9mdMq
	 m0ePIi7cu+lq3q0bQRmo9AADFZMZcst225HXhdR77xaRVB7QFR3xlLSnz3S08/u+gL
	 Um88Aoes7OA5g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 459A5198003A;
	Thu, 26 Nov 2026 08:11:35 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 26 Nov 2026 08:11:35 -0500
X-ME-Sender: <xms:BTAIazUJv-Tg735s5eHqNQsMksVfYYI11iIQyRmbN3tWuwGxHF9pgw>
    <xme:BTAIa2ZdB1bTmPwzLzxXXQdP-H4L83AO9cWLZ8Q5kRXOjX4cqVxQnh5eaMCZ443Pw
    ElXW-BLdZjzPqjbOaLuqaSjq6H-aKSAcBRHju4v3Mlq4aaBP9b7-Eac>
X-ME-Proxy-Cause: dmFkZTGyWYlMjGiB0QuNyDLTJh3iGKPfaVC1CLCsXIRIr7rBa0J9VEYgeFOy+QoG0a10D6
    0bL0os9kVLuV9uX1iWJzEoO4pTaIteVWUpPW+nhReK29o9Mn6MIniqiqOVJxauNKj2kiX8
    jCQuoiCLOBfVaaF7LGG8lQb4DrdxKW+SRRGPuy5V5lVSZPWCi6eShlS+XI2v12YsIdx1TD
    bYIUOzOqs3h/S7xobdFSxwkdgPq89dxVJeELPfPt/D7S7Vi2qwtxj/AferMNzbCWU/0cvV
    +dfgdEDrZ1GOXZLp4F/Y+bjUrwA0eIGPzL8YoQ5HTSVcStP5HJDwqjVs3+69ebxjZjOROr
    gXsXwEKOCs+k2UFy9cWlA/Y9zH7fuJLzJeli4ov+Mv+hBXmG4gld9EYdbhlCkII/KiaG39
    1t956fHN0tdqeTIcFPcgi2wNtWQV7AidZIQXUqgp1xmQLqWaujdF1NLHb2LFWUMySr002/
    kSAkVhpfGkzKsFHWpiRreKPTc+2i0nG7CiBbtUexzip127VlpHGGLK+K8tiCjajxKPqnRf
    Q1TK5T+3trTaB5fjxZN7dwIePqzivKy1Qt48CQ+1gVP2xiw4jApFwdD75lumoq5xoiYtWB
    lrr+nLMtWzKoamZAOi6H4NZlxSBkfW01zuOPpRy2vl0xiRVrxshtoE7hvK1w
X-ME-Proxy: <xmx:BzAIaz1VOn-6ATZBC94QsG7FnsqPUItKkB6IkGOYXc6YQrhAhQpQgw>
    <xmx:BzAIa9A31501LVv0Ga3NHMjqRxA87N1BN_xEwrxuF33wv2iFm6c3iw>
    <xmx:BzAIay4akHKOIhCvLEsleSTDU7z2H-q4Gy4JrVAdPDl8p8r1xXuD-Q>
    <xmx:BzAIa-J9FkSh5t1ooHdEd2Q4bm2wNCjadHOZHV4sZWEeAGl_QW6j3Q>
    <xmx:BzAIazuBSCZtJXDHf4Onag0m32ig_Yjw1eJJzGRFobqk8ko7c8fIpW6C>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2BE6FF80093; Thu, 26 Nov 2026 08:11:33 -0500 (EST)
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
Date: Thu, 26 Nov 2026 14:11:12 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>,
 "Huacai Chen" <chenhuacai@kernel.org>
Cc: "WANG Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org,
 loongarch@lists.linux.dev, "kernel test robot" <lkp@intel.com>
Message-Id: <6223ff0a-b5f3-4f11-8f60-43ca0efe8448@app.fastmail.com>
In-Reply-To: <534a9786-8594-4f0b-8ce8-ea1844581c0b@app.fastmail.com>
References: <20261126124145.876953-1-dmantipov@yandex.ru>
 <534a9786-8594-4f0b-8ce8-ea1844581c0b@app.fastmail.com>
Subject: Re: [PATCH v2] efi/libstub: fix building loongarch32 without zboot enabled
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 26 Nov 2026, at 13:53, Ard Biesheuvel wrote:
> On Thu, 26 Nov 2026, at 13:41, Dmitry Antipov wrote:
>> Kernel test robot has reported the following error observed on loongarch:
>>
>> loongarch64-linux-ld: 
>> ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function 
>> `__efistub_.L47':
>> __efistub_cmdline.c:(.init.text+0x258): undefined reference to 
>> `__efistub___ashldi3'
>> loongarch64-linux-ld: __efistub_cmdline.c:(.init.text+0x268): undefined 
>> reference to `__efistub___lshrdi3'
>>
>> Following the approach introduced in commit a354b8de9ad6
>> ("riscv: add platform-specific double word shifts for riscv32"),
>> define EFI stub aliases for __ashldi3() and __lshrdi3() for
>> loongarch32 as well, thus making the related EFI stub's Makefile
>> quirks redundant.
>>
>> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: 
>> https://lore.kernel.org/oe-kbuild-all/20261122125352.gAcg5yLx-lkp@intel.com/
>> Fixes: 442082297e3d ("riscv: fix building compressed EFI image")
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>> ---
>> v2: define relevant EFI stubs in image-vars.h (Ard) 
>> ---
>>  arch/loongarch/kernel/image-vars.h    | 2 ++
>>  drivers/firmware/efi/libstub/Makefile | 7 +------
>>  2 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/loongarch/kernel/image-vars.h 
>> b/arch/loongarch/kernel/image-vars.h
>> index e557ebd46c2b..19202f4f84c2 100644
>> --- a/arch/loongarch/kernel/image-vars.h
>> +++ b/arch/loongarch/kernel/image-vars.h
>> @@ -8,6 +8,8 @@
>>  #ifdef CONFIG_EFI_STUB
>> 
>>  __efistub_strcmp		= strcmp;
>> +__efistub___lshrdi3		= __lshrdi3;
>> +__efistub___ashldi3		= __ashldi3;
>>  __efistub_kernel_entry		= kernel_entry;
>>  __efistub_kernel_asize		= kernel_asize;
>>  __efistub_kernel_fsize		= kernel_fsize;
>
> For the part above ^^^:
>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>
> NAK to the changes below, they break zboot and need to be dropped.
>

OK, never mind. Based on the Sashiko feedback, we should be doing
the following instead.

--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -88,7 +88,9 @@
 lib-$(CONFIG_X86)              += x86-stub.o smbios.o
 lib-$(CONFIG_X86_64)           += x86-5lvl.o
 lib-$(CONFIG_RISCV)            += kaslr.o riscv.o riscv-stub.o
-lib-$(CONFIG_LOONGARCH)                += loongarch.o loongarch-stub.o
+lib-loongarch-$(CONFIG_32BIT)  := lib-ashldi3.o lib-lshrdi3.o
+lib-$(CONFIG_LOONGARCH)                += loongarch.o loongarch-stub.o \
+                                  $(lib-loongarch-y)
 
 CFLAGS_arm32-stub.o            := -DTEXT_OFFSET=$(TEXT_OFFSET)
 
@@ -99,8 +101,7 @@
 
 zboot-riscv-obj-$(CONFIG_32BIT)        := lib-ashldi3.o lib-lshrdi3.o
 zboot-obj-$(CONFIG_RISCV)      += lib-clz_ctz.o $(zboot-riscv-obj-y)
-zboot-loongarch-obj-$(CONFIG_32BIT) := lib-ashldi3.o lib-lshrdi3.o
-zboot-obj-$(CONFIG_LOONGARCH)  += lib-clz_ctz.o $(zboot-loongarch-obj-y)
+zboot-obj-$(CONFIG_LOONGARCH)  += lib-clz_ctz.o
 lib-$(CONFIG_EFI_ZBOOT)                += zboot.o $(zboot-obj-y)
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
