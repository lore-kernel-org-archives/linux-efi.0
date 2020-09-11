Return-Path: <SRS0=tnJd=CU=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E4CC43461
	for <linux-efi@archiver.kernel.org>; Fri, 11 Sep 2020 16:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4164722204
	for <linux-efi@archiver.kernel.org>; Fri, 11 Sep 2020 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599841688;
	bh=38MigC5T1jTNkx+xBK9uZViwcPm5Nh+W6vwsYFE6okI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=q4xfE8z93m/8/3PlsCLxathBPsp7MeeV/U4CYsUWj8v369lMqfrD1Zxpy9jA89J/c
	 16g3uj6QSubcdfxTeND02ZP9lXQktui/XQzDewVFEgwM5tA+5rMHbxOY3Og5nKw19c
	 Yz/WLds59DUM3OkRsb8zcneztH2phpkkILDSk0kY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIKQ2A (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbgIKPUX (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 11 Sep 2020 11:20:23 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4497D221ED
        for <linux-efi@vger.kernel.org>; Fri, 11 Sep 2020 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599837557;
        bh=38MigC5T1jTNkx+xBK9uZViwcPm5Nh+W6vwsYFE6okI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ztRPRRrQ9Xv5gv5cepgv6h87p9JaEOaAVp2qfNjbsVNLI+KOKVKLx5HBfErwWUHTx
         D2JLHtnSdzqRKsKNTB5euMc5Z3uoPIIJq2lC/5aSaertsy0wj0i/uR5CHhVlTZlkyv
         LqT0/q0exhZH28XJO8VzmWhnJVnJLvlhIhFURt7E=
Received: by mail-oi1-f170.google.com with SMTP id n2so9805530oij.1
        for <linux-efi@vger.kernel.org>; Fri, 11 Sep 2020 08:19:17 -0700 (PDT)
X-Gm-Message-State: AOAM53337PiEOKPz9xHMDiI0pIJ5Sl8XiEjXtRLxXxQIkE15mFfHfZK1
        0/UK9MRgfzUcueAyOEOr9G2A6CWPqSQ0S9vO6gI=
X-Google-Smtp-Source: ABdhPJw8rM+Zmp4NfCd7h8YYezD3rxWRUyrI+NDefl/6qTEKTSzKlK63YFhu83AEh9ESkmxKCkoEEIpjMjdrqqjWwUM=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr1550621oic.33.1599837556578;
 Fri, 11 Sep 2020 08:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <1599633872-36784-1-git-send-email-tiantao6@hisilicon.com> <20200909190142.GB474185@rani.riverdale.lan>
In-Reply-To: <20200909190142.GB474185@rani.riverdale.lan>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 11 Sep 2020 18:19:05 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEdoZa8dLSYSX_Q3KZrLUBHCNiJnriLPZ20za62q3HJ2w@mail.gmail.com>
Message-ID: <CAMj1kXEdoZa8dLSYSX_Q3KZrLUBHCNiJnriLPZ20za62q3HJ2w@mail.gmail.com>
Subject: Re: [PATCH] efi/printf: remove unneeded semicolon
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Tian Tao <tiantao6@hisilicon.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 9 Sep 2020 at 22:01, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Wed, Sep 09, 2020 at 02:44:32PM +0800, Tian Tao wrote:
> > Fix the warning below.
> > efi/libstub/vsprintf.c:135:2-3: Unneeded semicolon
> >
> > Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> > ---
> >  drivers/firmware/efi/libstub/vsprintf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> > index e65ef49..1088e28 100644
> > --- a/drivers/firmware/efi/libstub/vsprintf.c
> > +++ b/drivers/firmware/efi/libstub/vsprintf.c
> > @@ -135,7 +135,7 @@ char *number(char *end, unsigned long long num, int base, char locase)
> >               break;
> >       default:
> >               unreachable();
> > -     };
> > +     }
> >
> >       return end;
> >  }
> > --
> > 2.7.4
> >
>
> Acked-by: Arvind Sankar <nivedita@alum.mit.edu>

Queued in efi/next, thanks.
