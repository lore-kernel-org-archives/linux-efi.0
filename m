Return-Path: <SRS0=DG+M=7B=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B64C433DF
	for <linux-efi@archiver.kernel.org>; Tue, 19 May 2020 15:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7223E207FB
	for <linux-efi@archiver.kernel.org>; Tue, 19 May 2020 15:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6AayBEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgESPH7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 19 May 2020 11:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbgESPH6 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 19 May 2020 11:07:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD901C08C5C0
        for <linux-efi@vger.kernel.org>; Tue, 19 May 2020 08:07:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id n22so8927383qtv.12
        for <linux-efi@vger.kernel.org>; Tue, 19 May 2020 08:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FL0lYVBEdrsavLCSwp+djU04kLiuYFJuK9caVGXPXQs=;
        b=g6AayBEIdPOeT7UYmU+qIpzYoKxh0pVHWRvAaSGQ2VqHeh6jpFpxe8AyW656WTkT51
         v3zRbmkUsSymslCuiD5tJtsRE3EncjI+eSJNNRBaX4GmfHFCdBKQiRJE7FfXAYHciyWS
         bT/ftLgJxrdT28q6Vj48+VbEEu9jLKYFvunA8o5RvDqOy6RqZ4Ld9ZVoLGh1MgN6TR6h
         jC/jxg264HC7gQQJsPK2I7TtvQEvJxd/QnH+WwAtecTzN8y4TtISNNMpD7c/qT0Ej4bf
         +4QpwvwHgLwFPeO53B7OlU+phgEooWeggE0p0sVrd4ya1zcOxiBx3SSXiIsNxmYGYXqi
         oAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FL0lYVBEdrsavLCSwp+djU04kLiuYFJuK9caVGXPXQs=;
        b=hpOiCd+KX5CYhpFDuxR8k9eT7FbGd9xZwf8R5vAf5vMl7EDVI/4M2Bs/eT3LPJpfPp
         k9/yecwmxAMGkZZHCdR5emVS/g+9suEk6l5DeQaJseFd4Qt7Y+HuXBHZdxPIXvhwLOGO
         iiwU/WXt2niAzjBELtpKtSYUJSXEzE+ZHBoH0AiBl0fFnIz80INDmFYlGjxwEf3HD5ve
         eLSPjVlobH5WRI1LcTQBkWaFqXIJ6dNk/99SwGh6JMYSGXHI+bCvWkh5yzhzyiO+LrqM
         U3ipv3jDQJvxtGzI66IsPLwQ/4v+VYGjI98HCr0a+4qJlhehRBMOQ67pRzD2Vn/K4+4V
         1H8w==
X-Gm-Message-State: AOAM532PfLoolIR6YYmKDC7lsoFVyVZurP9RsyiEwXFOEb53idFxbxNx
        BvUZvLJUJZ+pmZTVboSNQMIPGSnIF1E=
X-Google-Smtp-Source: ABdhPJyLd6GZyA2kiiINk0F4yL+G60egwemEfVBolgcezOkWAMBEtTdn6wPOE9tSrWwliezGEphCzA==
X-Received: by 2002:ac8:3782:: with SMTP id d2mr182843qtc.74.1589900878008;
        Tue, 19 May 2020 08:07:58 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id p38sm12539636qtp.60.2020.05.19.08.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 08:07:57 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 19 May 2020 11:07:55 -0400
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 17/24] efi/libstub: Implement printk-style logging
Message-ID: <20200519150755.GC1526900@rani.riverdale.lan>
References: <20200518190716.751506-1-nivedita@alum.mit.edu>
 <20200518190716.751506-18-nivedita@alum.mit.edu>
 <CAMj1kXE=YowWg2CbqXVhPcXoq3eZdowzTnGxLkpD5xcf29fHhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXE=YowWg2CbqXVhPcXoq3eZdowzTnGxLkpD5xcf29fHhw@mail.gmail.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, May 19, 2020 at 10:22:40AM +0200, Ard Biesheuvel wrote:
> On Mon, 18 May 2020 at 21:07, Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > @@ -100,7 +123,9 @@ efi_status_t efi_parse_options(char const *cmdline)
> >                 if (!strcmp(param, "nokaslr")) {
> >                         efi_nokaslr = true;
> >                 } else if (!strcmp(param, "quiet")) {
> > -                       efi_quiet = true;
> > +                       efi_loglevel = CONSOLE_LOGLEVEL_QUIET;
> > +               } else if (!strcmp(param, "debug")) {
> > +                       efi_loglevel = CONSOLE_LOGLEVEL_DEBUG;
> 
> Should we wire this to 'efi=debug' instead?
> 

Sure.
