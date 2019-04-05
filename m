Return-Path: <SRS0=oSEl=SH=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E0EC282CE
	for <linux-efi@archiver.kernel.org>; Fri,  5 Apr 2019 22:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C49E21855
	for <linux-efi@archiver.kernel.org>; Fri,  5 Apr 2019 22:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bc0tJq9N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfDEWTU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 5 Apr 2019 18:19:20 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35967 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfDEWTU (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 5 Apr 2019 18:19:20 -0400
Received: by mail-it1-f196.google.com with SMTP id y10so12156374itc.1
        for <linux-efi@vger.kernel.org>; Fri, 05 Apr 2019 15:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p70rh8DzLMoO9YQR1wIHClyyXHDpqpEks55cuvOjfCY=;
        b=Bc0tJq9N/sPYw85QXGSIH0hbEtzljs8EWItZ9MIwCmNwpRUoa/Wpc5hsHoxnO/te/o
         O3F7X0+2bCdaluN6rPhO4hAZPUmPfFaaJIknDhttv3aW3vSR2RBpC49xL+P10rlIABz2
         FtRzhFhWl+sdRw1u7SF5C+Ul/CUNeqzj2OmmTtoUzMM/nubLgmCHk1xDxXr9CenY1pcQ
         b0moIO332HU3WYNlXK8fBIj84fYUgtIGZOcp9farU3QDzoBMhwPPDbrro6c1+P9Jk9BI
         dtakwadfwEhfde93OHQh09dc8rKxnXgvtSMn54RFzPcjbCcm/hATCmPV1sGr1TIM37QO
         ZEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p70rh8DzLMoO9YQR1wIHClyyXHDpqpEks55cuvOjfCY=;
        b=lH+9o1lQXceDtbZGMl43/t0ykcp5Px4hB+y0ui6TWINt3k1DX9R6kaKGsJqvCXgygj
         kQ5wWi4P24+A/ok0cHWLWESBxZUBaqAhdl+AkLYROE8s5fcDJ9B3UlN4jRU+KOMk7sAv
         aeLtYx2mZV11kt8MLPQADzpHXdsAyFPY/7QvY/lLS7B7TdLveDyH+opGMqF/Jg9Sitlr
         jdf9w6GHGvXu48iKpv9Lg2vfg0Re6/xkLLiQ3xsl7j8zyqlPXIJYZ8fDER6OfK24wjzg
         2oYjM7NUUjGcwO3jJuY/EeklHvDx05ck+a7kvqGSjTlN8D3F97jqogoKWaTySq3oQC/F
         TE9g==
X-Gm-Message-State: APjAAAUUhTz4UJS5HoirETk4xykS/3qfZTAoLfqypR3YhmWBBOutR0zH
        AdrWdS5g2J+1z5QfZNsgCUn7DHD1t/yk7RGGuUYYJA==
X-Google-Smtp-Source: APXvYqz8L0DRIH950OrISsoMW75m56cdjyA82W8JwtiaTtpNLc8MeWdCquXt/H6qVstvEF2gn6aGUbrGlapaBmieosc=
X-Received: by 2002:a02:1a45:: with SMTP id 66mr11594981jai.124.1554502759204;
 Fri, 05 Apr 2019 15:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com> <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
 <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com> <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
 <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
In-Reply-To: <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
From:   Matthew Garrett <mjg59@google.com>
Date:   Fri, 5 Apr 2019 15:19:07 -0700
Message-ID:
 <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garret <matthew.garret@nebula.com>,
        Nayna Jain <nayna@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190405221907.ufV-z7_v_lYpcxlgnJnkDTlvZ-w-Ys5ZyBiYorEDI5I@z>

On Fri, Apr 5, 2019 at 2:11 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>
>
> On 4/3/19 7:27 PM, Matthew Garrett wrote:
> > Not supporting dbx seems like a pretty significant shortcoming. How
> > are signatures meant to be revoked?
>
>
> We began by focusing on certificates for keys that can be added at
> runtime.  Before adding support for revocation, we plan to gather
> additional use cases.  In the meantime, unwanted certificates can be
> removed by the administrator.

Based on our experience doing this in UEFI, that's insufficient - you
want to be able to block individual binaries or leaf certificates
without dropping trust in an intermediate certificate entirely.

>
> >
> >> PK, KEK and db updates will be signed the same way, that is, using
> >> userspace tooling like efitools in PowerNV. As for the authentication
> >> descriptors, only the EFI_VARIABLE_AUTHENTICATION_2 descriptor will be
> >> supported.
> > Is this API documented?
>
>
> The API is still a work in progress.  We are planning to publish a document
> describing the current API and overall design shortly.

Ok. How are the attributes interpreted by the API?

> Perhaps the biggest departure is that the secure variables are stored in
> flash memory that is not lockable.  In order to protect the secure
> variables, hashes of the flash regions where they're stored are written to
> TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
> runtime.  The sysadmin enqueues update commands in flash.  During the next
> boot, the firmware verifies and processes the commands to update the
> certificate store and accompanying integrity hashes in the TPM NVRAM
> indices and write locks them.  Before certificates read from flash are
> used, the certificate store is hashed and compared against the hashes
> stored from the TPM.  The one exception is the PK. We store it in a TPM
> NVRAM index by itself rather than flash because updates to it must be
> guaranteed to be atomic.

What's the behaviour if multiple updates are enqueued? Does reading
back show a mocked up updated variable or the original state?

> > I think that depends on exactly what problem you're trying to solve.
> > Some aspects of the EFI secure boot design end up mirroring the
> > economics of the PC ecosystem rather than being inherently good design
> > goals, so it'd be helpful to know whether you're taking this solution
> > because you want the same three-level key infrastructure or because
> > that just leaves you compatible with the tooling.
>
>
> In our use case,  the three-level key hierarchy conveniently supports the
> concept of (1) an administrator authority, who authorizes (2) other
> organizations, e.g., distros, to provide (3) certificates for their code
> signing keys.   By using efivars, we leverage pre-existing userspace EFI
> tools to generate authenticated updates and certificates.  Additionally,
> pre-existing kernel infrastructure simplifies efivars processing.

I'm not really clear on the workflow here. Who's the administrator
authority? When would they be updating the second level of keys? If
there's no support for revocation, why would distributions need two
levels of key in the system database rather than just distributing a
single intermediate and signing their actual signing certs with that?
