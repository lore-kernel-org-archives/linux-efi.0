Return-Path: <SRS0=8Nln=EJ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CB5C2D0A3
	for <linux-efi@archiver.kernel.org>; Tue,  3 Nov 2020 21:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBBB20756
	for <linux-efi@archiver.kernel.org>; Tue,  3 Nov 2020 21:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YqMv3dFv";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YqMv3dFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgKCViU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 3 Nov 2020 16:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732827AbgKCVh7 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 3 Nov 2020 16:37:59 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8333C0613D1
        for <linux-efi@vger.kernel.org>; Tue,  3 Nov 2020 13:37:59 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 734F41280812;
        Tue,  3 Nov 2020 13:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604439479;
        bh=ZpTFkpI6Ky29zX9Ek+40Nt+8UPkenHk0K+MQ1bEpPqI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=YqMv3dFvnKKWIefptoRRM+QB/Vf2ygKvYv5EtvtkAhXg6UTV7q6RgUshwFRzMYNY+
         UfrYdDdk7org1cQ/v/v7fW6mYdsXXyT13LEK6h5nkJDslBSZjyHUc5LwLSUrUoIcdq
         45SKeNmYALcehy+8xJHBG1lW4w0BXcD4vxaCSf4w=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UrSdLCEhaWUj; Tue,  3 Nov 2020 13:37:59 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E100E12807DB;
        Tue,  3 Nov 2020 13:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604439479;
        bh=ZpTFkpI6Ky29zX9Ek+40Nt+8UPkenHk0K+MQ1bEpPqI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=YqMv3dFvnKKWIefptoRRM+QB/Vf2ygKvYv5EtvtkAhXg6UTV7q6RgUshwFRzMYNY+
         UfrYdDdk7org1cQ/v/v7fW6mYdsXXyT13LEK6h5nkJDslBSZjyHUc5LwLSUrUoIcdq
         45SKeNmYALcehy+8xJHBG1lW4w0BXcD4vxaCSf4w=
Message-ID: <1a3bd0af2528eabdaac0d301050141e81f49ceeb.camel@HansenPartnership.com>
Subject: Re: [RFC PATCH 0/7] efi/libstub: measurement initrd data loaded by
 the EFI stub
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 03 Nov 2020 13:37:58 -0800
In-Reply-To: <CACdnJuuG2Zout7swB4su2wVJHan5B84wshFHit2L58pbYndmjg@mail.gmail.com>
References: <20201102170634.20575-1-ardb@kernel.org>
         <CACdnJuvC3EjQb5ZfOBynNzMPOwUm3w5CnXDCYGd10w_AW+_efw@mail.gmail.com>
         <CAMj1kXGXOb3Q9mwK7dGbhmTbN_82m7BBYW+0ATVmG59LK3N++A@mail.gmail.com>
         <CACdnJuuG2Zout7swB4su2wVJHan5B84wshFHit2L58pbYndmjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 2020-11-02 at 12:26 -0800, Matthew Garrett wrote:
> On Mon, Nov 2, 2020 at 12:24 PM Ard Biesheuvel <ardb@kernel.org>
> wrote:
> > Does Shim use PCR 7 for the MOK key database? Are there any
> > specific requirements from MS on which PCRs Shim must touch?
> 
> Yes, shim extends PCR 7 in the same way the firmware does. There's no
> requirement from MS on this, it just seemed like the right solution.

That's not fully correct: it extends PCR 7 for the
EV_EFI_VARIABLE_AUTHORITY event, but it measures the actual contents of
the variables to PCR 14 using an EV_IPL event.  I'm actually trying to
persuade Peter that we should replace this latter with an
EV_EFI_VARIABLE_DRIVER_CONFIG event through PCR 7 instead.

James


