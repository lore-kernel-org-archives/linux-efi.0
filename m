Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9DD3DC4C8;
	Wed, 16 Sep 2026 07:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542341; cv=none; b=O647cbbIodEe0VNAOyBU3o8mSGrYYYbPYew5wAjF8B4nIzAW5xmq+QK//OzvEHJwGcJp8RArFgF6OsDyOGhlGDHcx/UNV3+bIbGpAZJX0keblfG1V1EQ64ueZeUJofSVdZT+XsTKPpgMrjGgSaid1v9zumg9Pv1Q7Vo28HP4YeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542341; c=relaxed/simple;
	bh=ykposK3Qn+iumoox2DDdhIadVTJ/tw9QAuhjyULIZhE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ErWzqOv+DSdrKGVONnw6IlNaQrP940Z0rAdlhXwzIdlnqoOi394PiCbmGvP2taSpFrbGVWW3me3oGkgiHcZQmqq+OFUIww6BgITVC3UFJ54iNwlehiwORuIj76/+IX9hOUu0vPKnHLRDBQBTbbDeoSIJapA8FpPm2w5WAlwRNAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWNNIAl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWNNIAl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F001F000FF;
	Wed, 16 Sep 2026 07:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789542340;
	bh=mR2HTq9K6bZI0xIfLcfWG5JclWyg1NjLC1Lkph4mdDY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=dWNNIAl82Ut6PMz2iJ4RSxpi9hwFQFWUsWDJzJgvuu9pk8K5rivQN2NsEIdCoa4u0
	 oIlFHEogXYGwDdgWiGvxY1cMLtSGn+2AvWB86CJVQhqbwM7uO01ZQfd7HYY9BDVkyY
	 eKy6gzo4hqtHO2x3AXyLhfcVV9TnXbbWyljS43d6fOESl7kixAK4ZuDF8P66NDcSo1
	 PloltBvR3FN2JDTesDLddLNhslcCbVUSdZM80+gViOOf7jt6hxYxStCHMrVbpvAe7a
	 Qzf9L367Kd1nfjNGB1LBCaFRBkDI9ACouDnuYeW9ET6tc21NNfbqOQpH2zH4HUonYR
	 slL08sQdyPmJA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 890881980064;
	Wed, 16 Sep 2026 03:05:37 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 16 Sep 2026 03:05:37 -0400
X-ME-Sender: <xms:wD-qaq1XuQKkGITtLWW0T3M9OmbDPvRQJ3S-iw0UdHlba27wWmmC1g>
    <xme:wD-qan6WumJoigQkmgp8aLiyowDnIj1PINzag7qdv9-Z3kFYwly0ipXwMixlOmXCi
    eGUS04FysFjY15BItkX2zEoDMbHfbtty2IGPKzNS9dWwFJ52k8z9ck>
X-ME-Proxy-Cause: dmFkZTEWNGtfQ4VQt6526Uhxk3LCoz00Mp7pOyFlEjzTe/dFHV8VJUzVsuKoq5tMBrAW9k
    dP4DCmQzU7vkTjMvlOz5ctfST4I2RV9b3IwhXzV0yh8kEKLdB5wmyxWKPxn2R+JEwuW5pd
    RpIrRc2I5XJijYBRvg8D6Ejeze/d1XTiUzYEGVCKx2mBOV7wKAzlLVWwpaqnMvJ3Tv7Uz6
    nb3gubW+zxN5iNz6bYdc8yxTwpRa3ZVMlcTgli3wdXuO3iAlWUcd0orBzt/xKWCOgoUzeA
    AdPUdlFhQzWM1eXdl9Yui7bud+AgMI1cUEM7SCSZINw2Zp4O4A8F1S/1kJ8lJvvAH0hLG1
    y++n853hnRB9DPs3uNgf05942CsZzIMweB/QXJ62GcCilWmgeOLMIeHKb9U2A9tVu75bhu
    1IS9Zs+j531zwRANfyrpXXMG1QfNZ0xY8Rz5gOlIMbCiUQ8KRBulYrfhNDwlL55CGpp9lw
    iWKmx/WXnx7KEF4jdtvVqm5sgIRT/EdS90fWtYRc4cr9gSR0Ab2HHVsa1SDKFMj4Mb+IqV
    RShU7gyM/KXKWEM/jJmmX4FA/St9vDwx0e5/tFkl0ibW1EInclxk/VoQZlh43yOlQDOOwt
    YQn+HMEtvZd3zgshdEX1Ncd7sPivcSrc2dCnDsewVMHiyRE1lQIow66zU0eQ
X-ME-Proxy: <xmx:wT-qamde649gBFfGqDXh57XYZoDLOSA-puKY4vqQ0bO--m8iSVfmZA>
    <xmx:wT-qauIDNW1m63dJxEXvf2H3edPgNJx3Q-DpqvmOUpAbmwfd0PAdog>
    <xmx:wT-qap302Ki5D7Gj_kxk40k0EuNxvIaC7irAXqvQkA5FHJ_f9JkJmA>
    <xmx:wT-qaoiPpL_GzaxBsub4BG2LqpSTsc3fj6VSormkeUvolP8YX52_hw>
    <xmx:wT-qaqW8Upfc8cuC5TuP4XsRXH820kxK-tE1FpOaYEbsTVbKVlVb6W44>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 0335FF80080; Wed, 16 Sep 2026 03:05:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 16 Sep 2026 09:05:14 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Borislav Petkov" <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Message-Id: <3abaa241-289c-4b60-a048-3f0bc90d3142@app.fastmail.com>
In-Reply-To: <20260915031141.GEaqi3bW7TGjblHLg1@fat_crate.local>
References: <20260914183745.37538-5-ardb@kernel.org>
 <20260914183745.37538-6-ardb@kernel.org>
 <20260915031141.GEaqi3bW7TGjblHLg1@fat_crate.local>
Subject: Re: [PATCH 1/3] x86/tdx: Share tdx_panic() with the EFI stub
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 15 Sep 2026, at 05:11, Borislav Petkov wrote:
> On Mon, Sep 14, 2026 at 08:37:47PM +0200, Ard Biesheuvel wrote:
>> Move the implementation of tdx_panic() into the source file that is
>> shared with the decompressor and the EFI stub.
>> 
>> Use memcpy() and strnlen() instead of strtomem_pad(), as the latter does
>> not exist in the early boot code.
>> 
>> Note that __tdx_hypercall() may call __tdx_hypercall_failed() if the
>> hypercall returns with an error (while it should never return to begin
>> with). __tdx_hypercall_failed() calls the decompressor's error()
>> routine, which prints a message and then loops forever.
>> 
>> When called from the EFI stub, this error() call may attempt to use port
>> I/O to the default serial port rather than the TDX hypercalls which the
>> decompressor uses normally to print diagnostics to the console, but this
>> is fine: given that this situation only occurs after a catastrophic
>> error, and a subsequent spurious return from tdx_panic(), whether
>> error() uses port I/O or not is rather moot at that point, as long as it
>> never returns.
>> 
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/x86/coco/tdx/tdx-shared.c    | 35 ++++++++++++++++++++
>>  arch/x86/coco/tdx/tdx.c           | 35 --------------------
>>  arch/x86/include/asm/shared/tdx.h |  1 +
>>  3 files changed, 36 insertions(+), 35 deletions(-)
>
> Nah, that doesn't work:
>
> ld: arch/x86/boot/compressed/tdx-shared.o: in function `tdx_panic':
> tdx-shared.c:(.text+0x2a3): undefined reference to `__fortify_panic'
> ld: tdx-shared.c:(.text+0x2b2): undefined reference to `__fortify_panic'
> ld: arch/x86/boot/compressed/vmlinux: hidden symbol `__SCK__WARN_trap' 
> isn't defined
> ld: final link failed: bad value
> make[3]: *** [arch/x86/boot/compressed/Makefile:117: 
> arch/x86/boot/compressed/vmlinux] Error 1
> make[2]: *** [arch/x86/boot/Makefile:96: 
> arch/x86/boot/compressed/vmlinux] Error 2
> make[1]: *** [arch/x86/Makefile:304: bzImage] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
>

The bot hit this error too, but without your change so it is something
I will need to address anyway, e.g., by doing

--- a/arch/x86/boot/compressed/tdx-shared.c
+++ b/arch/x86/boot/compressed/tdx-shared.c
@@ -1,2 +1,3 @@
+#define __NO_FORTIFY
 #include "error.h"
 #include "../../coco/tdx/tdx-shared.c"

But I realized the whole union thing is redundant in the first place. We
might just do

--- a/arch/x86/coco/tdx/tdx-shared.c
+++ b/arch/x86/coco/tdx/tdx-shared.c
@@ -97,15 +97,13 @@ void __noreturn tdx_panic(const char *msg)
                .r11 = TDVMCALL_REPORT_FATAL_ERROR,
                .r12 = 0, /* Error code: 0 is Panic */
        };
-       union {
-               /* Define register order according to the GHCI */
-               struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
-
-               char bytes[64] __nonstring;
+       /* Define register order according to the GHCI */
+       struct {
+               u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx;
        } message = {};
 
        /* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
-       memcpy(message.bytes, msg, strnlen(msg, sizeof(message)));
+       memcpy(&message, msg, strnlen(msg, sizeof(message)));
 
        args.r8  = message.r8;
        args.r9  = message.r9;

