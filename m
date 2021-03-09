Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE51C433E0
	for <linux-efi@archiver.kernel.org>; Tue,  9 Mar 2021 02:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1400F6528A
	for <linux-efi@archiver.kernel.org>; Tue,  9 Mar 2021 02:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhCICoh (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Mar 2021 21:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhCICoU (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 8 Mar 2021 21:44:20 -0500
X-Greylist: delayed 5142 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 08 Mar 2021 18:44:20 PST
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919EFC06174A;
        Mon,  8 Mar 2021 18:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=ohLrrpvgSOL6BKQCrL7o+OT4R83iMQsPDgorCsdAWDI=; b=e/Vhb0McTCu32iTJOX2aHwNhnx
        mkM/r6R1D2APpncqHb5aKXIE/Z5coG/f4Dnzz5ttWiJ1WrBWeLZG8eJqjnxD76At1FBdx34+hudfX
        PnuNiqwrnZ6ZKSfsrdU931eUQnH7V/T03xmpawNUwVi+49p6gpZBSIs8g39ia+lGjkGzLASE83Ueu
        Wwlk6VFJAlu05os7FC7AfFolN02mV9FeQIKYFcCP+pLb56W0XAdy6COnLjeEiHpIZ7RaTv33L4sZI
        IZ2nBO5KnejtTj6qge7mLvkscXf636sblrt4j5fuUy5VcvKjxp5iXckAvHeHc4udeTTSCDWp8WPB7
        8d+4q2Qw==;
Received: from merlin.infradead.org ([2001:8b0:10b:1234::107])
        by desiato.infradead.org with esmtps (Exim 4.94 #2 (Red Hat Linux))
        id 1lJR1A-003ZHV-Fx; Tue, 09 Mar 2021 01:18:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ohLrrpvgSOL6BKQCrL7o+OT4R83iMQsPDgorCsdAWDI=; b=GGzNqkY17R95JMgHzQ8YlZW//3
        LyyBEPAcY2QLM82TNsLs2vnsyt5XDwvovMlX+p5k6oKiQqBuEHAIfyKGa8vzlm9T0rOJnWJ3BqqMI
        FYs8mqG5h1xXomVANRjU6/eR5YTHbpayQA13J4i1mdG9PHJVQm+LtWaY2eX8mXmiXIFPHvmedi+FU
        WbedogkIODy4xLavthTAfrJZLBmVqQSC3XtQkbarjYOv2XyOOYBgu92wARi3/gD7B8YaxS7dLsznI
        s5ygDZXoGZplV9IWXT5v0h8CJfxSpvqPWZkGtYzqTwVM1R9KZZVSQgDWYyCsjNBoSWow6BYs9z0w8
        Zh6ErVCw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJR0J-000bIi-4d; Tue, 09 Mar 2021 01:17:43 +0000
Subject: Re: [PATCH v2 0/7] Generic Command Line changes
To:     Daniel Walker <danielwa@cisco.com>, Will Deacon <will@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Rob Herring <robh@kernel.org>,
        Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     linux-efi@vger.kernel.org
References: <20210308235319.2988609-1-danielwa@cisco.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e5685605-adc7-e05d-31ce-d743afd79c9b@infradead.org>
Date:   Mon, 8 Mar 2021 17:17:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210308235319.2988609-1-danielwa@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 3/8/21 3:53 PM, Daniel Walker wrote:
> This fixed some problem identified in my last release. I made updates
> based on comments from Christophe Leroy.
> 
> I added scripted updates to the defconfig file for mips and powerpc.
> This is required in order to maintain the status quo for those platforms
> which used the prior builtin command line system.
> 
> These were tested on all effected architectures.
> 
> Daniel Walker (7):
>   CMDLINE: add generic builtin command line
>   CMDLINE: drivers: of: ifdef out cmdline section
>   powerpc: convert config files to generic cmdline
>   CMDLINE: powerpc: convert to generic builtin command line
>   mips: convert config files to generic cmdline
>   CMDLINE: mips: convert to generic builtin command line
>   CMDLINE: x86: convert to generic builtin command line
> 


Hi Daniel,

These patches (1 - 7) should be sent as a Reply-to patch #0.

In .gitconfig, could you use
	thread = true

or use --thread on the command line?

HTH.
thanks.
-- 
~Randy

