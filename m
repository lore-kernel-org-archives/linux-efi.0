Return-Path: <SRS0=roqe=SM=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7C1C10F11
	for <linux-efi@archiver.kernel.org>; Wed, 10 Apr 2019 17:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E6C2077C
	for <linux-efi@archiver.kernel.org>; Wed, 10 Apr 2019 17:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSJRSo5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfDJRgu (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 10 Apr 2019 13:36:50 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:38240 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbfDJRgu (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 10 Apr 2019 13:36:50 -0400
Received: by mail-it1-f195.google.com with SMTP id f22so4818305ita.3
        for <linux-efi@vger.kernel.org>; Wed, 10 Apr 2019 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fsdwxzllgm3TZiNS2RBUzUWgv7Kl8/L4XW2AecOXicU=;
        b=bSJRSo5MsFgno1KgFsAA0YK3rrv031WHLUUGrO3xbQk7/2nDnoqhvqCJ15Ey02vmDN
         Hxk/8IqQAkGzzQ3RlVdOSQn4H8INleO5W/ThQpK7vUqwbxb2+jCr7keiDXwFtAWpkfNg
         4hD9j7FmHX7letmuEOZ4IDSOF/QivdG51ubmLFeGqbYbQ9clMSR1PhFfW/qE8KibK+8n
         SoWGBelTt+/DKTHDgSuq1WRucP6zbuqnPF2e3eqSAq4rMjWweTMpOp4pCDSu6FCEESOu
         cWqbWQeM5QscA0I5BMqRgU6XQnly8tSmYOXLaNcPtKQvF6my5Rx67jZ5R2MBRepNeR4B
         dMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fsdwxzllgm3TZiNS2RBUzUWgv7Kl8/L4XW2AecOXicU=;
        b=TsZyuUAg2k6nLhal935v/pCbHrkzNSji+IDdPRyNc30IEeoFgonEGcfohuFW9Xw5Kg
         7ga3aEp3q3a2yExN9EK3aVNP3iarKEl22UW39DWaQSrfmvfzdCFEvoAf7/ArlqQBUVLW
         6neWqR/SLmLohbZIE3WAG9uHNB90YiAouURLip6gYyPcwbmRZejVuarZGjTTULXtDNGn
         ywvkoVkvKgJojHF3ub3bg9h2ue7d7TwZWq5BXp73Yu5FTutwui1g3XoJBXDAik4cC6tv
         YhLGjzLlO09+S7dxg/Dp2CBGVp5Uz/jJbzRnLixJTjB5al/z7rVfUKJ1JfyDQ/2fbiQg
         ir0w==
X-Gm-Message-State: APjAAAXUU5Rc/TRkBmJyDtrOJf+cU8IVdM4bWsW8yJl8UO9uzUaCgkgs
        HNQNKlY7iNYx7/QIfrWi+rfqvq1oK8Alb39OoQYWMg==
X-Google-Smtp-Source: APXvYqwcxj9ETT2fC97ngGmh7CcsBy2+YL6kB6AnKQJasNCbUVIV8fGBdWEIhNBMFR1OZOiEkz1I6DPnF3iTkLVIYjE=
X-Received: by 2002:a24:7294:: with SMTP id x142mr4445023itc.7.1554917808975;
 Wed, 10 Apr 2019 10:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com> <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
 <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com> <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
 <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com> <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
 <28bfc0a7-9ae5-2c99-e472-ea53f856bafc@linux.ibm.com>
In-Reply-To: <28bfc0a7-9ae5-2c99-e472-ea53f856bafc@linux.ibm.com>
From:   Matthew Garrett <mjg59@google.com>
Date:   Wed, 10 Apr 2019 10:36:36 -0700
Message-ID:
 <CACdnJuvpUKiX5UgSOrzh+B9y68zKm+Bzu1c8KFJHd8diz=sm2Q@mail.gmail.com>
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
        Nayna Jain <nayna@linux.ibm.com>,
        Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190410173636.Y0BPXvjgDJQSKipJd7wQE1dFqWuzjUJ4i3OqBd7gkxw@z>

(Cc:ing Peter Jones)

On Tue, Apr 9, 2019 at 3:55 PM Claudio Carvalho <cclaudio@linux.ibm.com> wr=
ote:
>
>
> On 4/5/19 7:19 PM, Matthew Garrett wrote:
> > Based on our experience doing this in UEFI, that's insufficient - you
> > want to be able to block individual binaries or leaf certificates
> > without dropping trust in an intermediate certificate entirely.
>
>
> We agree that a dbx would be useful for blacklisting particular kernels
> signed with given certificate. However, we have been avoiding doing so fo=
r
> the initial release of secure boot on OpenPOWER. We don't have individual
> firmware binaries in OpenPOWER. Kernels are currently the only concern fo=
r
> the OS secure boot certificates we're discussing here. Also, we have a ve=
ry
> limited keystore space in POWER9.
>
> Petitboot doesn't have standardized OS kernel verification at all right
> now.  Having the capability even without dbx seems valuable.

I don't see the benefit in attempting to maintain compatibility with
existing tooling unless you're going to be *completely* compatible
with existing tooling. That means supporting dbx and dbt.

> >> The API is still a work in progress.  We are planning to publish a doc=
ument
> >> describing the current API and overall design shortly.
> > Ok. How are the attributes interpreted by the API?
>
>
> We support a subset of standard EFI variable attributes, and we only use
> EFI variables that relate to secure boot. Our goal is not to implement
> UEFI.  However, we do seek to be compatible with user space tooling and
> reuse as much existing infrastructure as possible. We don=E2=80=99t suppo=
rt the
> following: EFI_VARIABLE_HARDWARE_ERROR_RECORD,
> EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS and
> EFI_VARIABLE_ENHANCED_AUTHENTICATED_ACCESS.

Ok. I think that's realistically fine.

>
> >
> >> Perhaps the biggest departure is that the secure variables are stored =
in
> >> flash memory that is not lockable.  In order to protect the secure
> >> variables, hashes of the flash regions where they're stored are writte=
n to
> >> TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
> >> runtime.  The sysadmin enqueues update commands in flash.  During the =
next
> >> boot, the firmware verifies and processes the commands to update the
> >> certificate store and accompanying integrity hashes in the TPM NVRAM
> >> indices and write locks them.  Before certificates read from flash are
> >> used, the certificate store is hashed and compared against the hashes
> >> stored from the TPM.  The one exception is the PK. We store it in a TP=
M
> >> NVRAM index by itself rather than flash because updates to it must be
> >> guaranteed to be atomic.
> > What's the behaviour if multiple updates are enqueued? Does reading
> > back show a mocked up updated variable or the original state?
>
>
> Our secure variable updates are only applied at boot time. If any one of
> them fails, they all fail.

So I do the following:

1) Boot
2) Extend the contents of db
3) Extend the contents of db again
4) Read back the contents of db through efivarfs
5) Reboot
6) Read back the contents of db through efivarfs

Is what I see in (4) and (6) the same? Does it contain the values form
both extensions?

> > I'm not really clear on the workflow here. Who's the administrator
> > authority? When would they be updating the second level of keys? If
> > there's no support for revocation, why would distributions need two
> > levels of key in the system database rather than just distributing a
> > single intermediate and signing their actual signing certs with that?
>
>
> In OpenPOWER systems, we enable our customers and business partners to
> establish and manage the platform key certificate, which is the root of o=
ur
> key hierarchy. From there, through the KEK, they can delegate authority t=
o
> intermediate level organizations, e.g. distros or IT departments or
> business operations. Those intermediate level organizations then manage t=
he
> code signing certificates in the DB. If this answer doesn=E2=80=99t addre=
ss your
> question, can you please rephrase?

Why would the intermediate level organisations not just have entries
in db? The main reason we don't do it this way in UEFI is because we
need to support dbx, and if you're not supporting dbx I'm not sure I
see the benefit.
