Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3405FC433FE
	for <linux-efi@archiver.kernel.org>; Thu, 20 Oct 2022 13:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJTNab (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 20 Oct 2022 09:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJTNaa (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 20 Oct 2022 09:30:30 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61C610C4E8;
        Thu, 20 Oct 2022 06:30:28 -0700 (PDT)
Received: from mail.ispras.ru (unknown [83.149.199.84])
        by mail.ispras.ru (Postfix) with ESMTPSA id 05F3040D403D;
        Thu, 20 Oct 2022 13:30:27 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 05F3040D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1666272627;
        bh=Q/p5Xj04qijnjiyAT2EorH15e9euRvJPoeU/62Hof4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3qx7G4MsUk5AEDScC0Va0ACWUYY7IidTVRrFCETnXOSzapkDAEOB96vGPlybIlUX
         gfFvijYIcnUhd9Nro6XgQJlwvvtdYSZ4D0if2uR/1ejLx3nCEdGPNf4JfIjPYCEOtb
         0KS7MGDoiQ0YdNgJOoU6+7YFakblc4Yk6SueJ1cw=
MIME-Version: 1.0
Date:   Thu, 20 Oct 2022 16:30:26 +0300
From:   Evgeniy Baskov <baskov@ispras.ru>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 06/16] x86/boot: Setup memory protection for bzImage code
In-Reply-To: <58b9f97c-36d5-6b9e-5336-14ad3a09ad18@citrix.com>
References: <cover.1662459668.git.baskov@ispras.ru>
 <2fd61a79a1e6885dc47ec826b62a936dd88a0a16.1662459668.git.baskov@ispras.ru>
 <58b9f97c-36d5-6b9e-5336-14ad3a09ad18@citrix.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <ed8c18e42870da96afc9ce1222816189@ispras.ru>
X-Sender: baskov@ispras.ru
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 2022-10-19 10:57, Andrew Cooper wrote:
> On 06/09/2022 11:41, Evgeniy Baskov wrote:
>> diff --git a/arch/x86/boot/compressed/head_64.S 
>> b/arch/x86/boot/compressed/head_64.S
>> index 5273367283b7..889ca7176aa7 100644
>> --- a/arch/x86/boot/compressed/head_64.S
>> +++ b/arch/x86/boot/compressed/head_64.S
>> @@ -602,6 +603,28 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
>>  	jmp	*%rax
>>  SYM_FUNC_END(.Lrelocated)
>> 
>> +SYM_FUNC_START_LOCAL_NOALIGN(startup32_enable_nx_if_supported)
>> +	pushq	%rbx
>> +
>> +	leaq	has_nx(%rip), %rcx
>> +
>> +	mov	$0x80000001, %eax
>> +	cpuid
>> +	btl	$20, %edx
> 
> btl $(X86_FEATURE_NX & 31), %edx
> 
> But also need to check for the availability of the extended leaf in the
> first place.

Yes, thank you for suggestion, that looks more readable. I will
also add the leaf node check. Is there any processor though that
supports long mode and does not support 0x80000001 leaf node?

> 
>> +	jnc	.Lnonx
>> +
>> +	movl	$1, (%rcx)
> 
> Your pointer has been clobbered with some feature flags.

Thanks, I apparently forgot to include fix for this into a patch set...

> 
> movl $1, has_nx(%rip)
> 
> will work fine without needing the intermediary lea.
> 
> ~Andrew
