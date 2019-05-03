Return-Path: <SRS0=Sh1A=TD=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C144C04AAA
	for <linux-efi@archiver.kernel.org>; Fri,  3 May 2019 06:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D23D52089E
	for <linux-efi@archiver.kernel.org>; Fri,  3 May 2019 06:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556863344;
	bh=lfJ4AECVkuBuurX4SLMC408ppKFg+1DtpTzf19281S8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vZyk+W8SjCAGznvpYPPz4QFBmBRFqAIj1pohxczaWLoW4cONM0sk2nlPqhADXJzth
	 SQ9V7+ttAjPVi5LV6YyJ+4lzXk7bDIpL5s6T8aafsBtphcgd3jmU6A70RtuO3OkwJ6
	 p6RrjOYK3mc6S65lW38Ud7ZcnDBfJTtz9C0MXYww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfECGCY (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 3 May 2019 02:02:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37927 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfECGCY (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 3 May 2019 02:02:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id f2so284862wmj.3;
        Thu, 02 May 2019 23:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EWtSEcRAEClnp5qoyCUoVU+zszW981359OnvYuNYOfs=;
        b=L2+ILm3IPeNDoDv54VzYglc/Z6apZqqIdA5HG/I6kne6gOBhpfCNItAibcYkaeIRlq
         Ap2aLXdsKMj02bBSOTh2w3DSAAru0ZGnvA88S4TBR1A+Q1KOYEm5OLZxDj7LzJxibQJu
         ULKNrL78nR0cEVyCAD9n08LyNyvTHx66vj3gVW+Ztx9NoWvCGgxpWJllvZobzq0PC7ql
         9jnb4zg1VAWdDGlGprAizAaA0k7l8E1cvuV1UynOeOrhQB4QITyad6dKjQOQerXRT+Vd
         iybRWR2yzIp7fM2/4xPskqXoROzKnCanzT6pu6Lfs2C+6rp3MxGWu3vY6JLhoW7TGBlx
         hlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=EWtSEcRAEClnp5qoyCUoVU+zszW981359OnvYuNYOfs=;
        b=t5VI1FQ5lXEZvUpMxzEM/pKyiXFXqT4IcUo+RxLMCDV6eJIG/mcNzNauHQtD4IlkpK
         PjB7ysFIonP9YaJEK8XmOzJBm2JY/GKcDGEJet/U09MaFHIq01E3o8petU3tIhYyqEg1
         xJ+NCR0jyqJoKAG4SfpT8WYLQHMTV9Fy7L1JxEI4kBJI38l3IJHiyd6DDRJ/sQp5/hXd
         7jWeX/yZ+fr2gJ0oGRo41EZq02VH07MtXBHnVbb74blpXyGpiGaBFST8aXQPzKUbLSMv
         MG4B95jDNUl2nVZId9NtEr7EqJiWgqyXXQutyWb1CVCE9zj+Gt4ao1IemLj7CTVffeJe
         cJNg==
X-Gm-Message-State: APjAAAUbJLWSnIdIJST+1lgc3HK57o8BvdeNOL02PeCwVI1Pj5y+UDh2
        IKYySrGVZ3PEfS57i19g8gU=
X-Google-Smtp-Source: APXvYqye3M4BGNbRpm/002dbzifmSfoz6CZiHaO6lZrFk7m6+ow+ZSIovB7+7Rud5sYd2jLSts1sDA==
X-Received: by 2002:a1c:a00f:: with SMTP id j15mr4732038wme.148.1556863341211;
        Thu, 02 May 2019 23:02:21 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id h81sm3494166wmf.33.2019.05.02.23.02.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 23:02:20 -0700 (PDT)
Date:   Fri, 3 May 2019 08:02:18 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Matthew Garrett <mjg59@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>
Subject: Re: [PATCH V5 2/4] tpm: Reserve the TPM final events table
Message-ID: <20190503060218.GA28048@gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190227202658.197113-3-matthewgarrett@google.com>
 <CAJzaN5pUJoOCz5-ZDSnTb6dbVPuy0QwmFD0CeofAGK+bRQx0og@mail.gmail.com>
 <CACdnJutpBPAX6TOGgs3Ng2v_cC5hAf-3pHThESvjQ9vbvQeVkA@mail.gmail.com>
 <CAKv+Gu9PF4u=-7QL4e36Q3S5kC4+5Z=yLYHLT9jE+eNY7YUV7A@mail.gmail.com>
 <CACdnJuvDuw0X9iwEqOu7EjM5ca1f+n7f=xqzrTPS9PyrmqKNHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CACdnJuvDuw0X9iwEqOu7EjM5ca1f+n7f=xqzrTPS9PyrmqKNHQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190503060218.zq1o4_u2gQtkvzCfuPGF04M7ZYi4KrCHVzIqi_ocOMI@z>


* Matthew Garrett <mjg59@google.com> wrote:

> On Thu, May 2, 2019 at 12:15 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > (+ Ingo)
> >
> > On Tue, 30 Apr 2019 at 21:52, Matthew Garrett <mjg59@google.com> wrote:
> > >
> > > On Tue, Apr 30, 2019 at 6:07 AM Bartosz Szczepanek <bsz@semihalf.com> wrote:
> > > >
> > > > I may be a little late with this comment, but I've just tested these
> > > > patches on aarch64 platform (from the top of jjs/master) and got
> > > > kernel panic ("Unable to handle kernel read", full log at the end of
> > > > mail). I think there's problem with below call to
> > > > tpm2_calc_event_log_size(), where physical address of efi.tpm_log is
> > > > passed as (void *) and never remapped:
> > >
> > > Yes, it looks like this is just broken. Can you try with the attached patch?
> >
> > I'm a bit uncomfortable with EFI code that is obviously broken and
> > untested being queued for the next merge window in another tree.
> 
> The patchset was Cc:ed to linux-efi@. Is there anything else I should
> have done to ensure you picked it up rather than Jarkko?

That's not the workflow rule the Linux kernel is using, if Cc:-ing a 
patchset was the only condition for upstream inclusion then we'd have a 
*LOT* of crap in the Linux kernel.

Just applying those EFI changes without even as much as an Acked-by from 
the EFI maintainers is a *totally* unacceptable workflow.

Please revert/rebase and re-try this on the proper submission channels.

Meanwhile the broken code is NAK-ed by me:

   Nacked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
