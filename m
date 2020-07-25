Return-Path: <SRS0=32gl=BE=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3042CC433E5
	for <linux-efi@archiver.kernel.org>; Sat, 25 Jul 2020 15:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112BD206F6
	for <linux-efi@archiver.kernel.org>; Sat, 25 Jul 2020 15:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TKpyxyvQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGYPuk (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 25 Jul 2020 11:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbgGYPug (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sat, 25 Jul 2020 11:50:36 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F96BC08C5DE
        for <linux-efi@vger.kernel.org>; Sat, 25 Jul 2020 08:50:36 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j19so7025080pgm.11
        for <linux-efi@vger.kernel.org>; Sat, 25 Jul 2020 08:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bcLcYtn/5EXjyyKK+pdJfQFFgGu5Nf11dS5S/Z/JYdA=;
        b=TKpyxyvQofSWhMw/ULpw8l0YUvfCsNuArU58WtzTf5mmfKXj9cJdscPlLD28Wr1rZl
         RLTlzE5cJeKX8910OpbdxX9OgYKEttD58FM/UdbzhmKORezH7LFec2H2qaPUMoc12959
         u1nOlANeu/eFp+031emHEa3vJAeascp/sG7Rw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bcLcYtn/5EXjyyKK+pdJfQFFgGu5Nf11dS5S/Z/JYdA=;
        b=JLsvyFWUA8zBoxi212baqsQ9BufRP8h5CLR6ek5OzDROZnSqZA6TWWFTDm8cwQDl1S
         Ob3N6TCkvjeEt0k8/7x+tfDZrn3xFo/ZbOS+7/4LGITLPJaKi+fJLRL/ByzbPMtah6uF
         mPSGQRlHNGuq/JOUIt2g1x6szc2G1mXPMzB4C5XimN17Y8/iCIo80nCla/K9SdybmhDD
         Hs/uleoVGq9OcpMHSgRPlnZDRTeXtuCSc265vCuAyqqZosEIjLOQSSdEqHX2nTTJrKlL
         SpfRpb7RtFwaArR4KBOgOg/6ZFwlsXJtwT0b/We6oFKTuZn3PXMXn3qVTwvn/7p8kNeE
         cRdA==
X-Gm-Message-State: AOAM5307C7KqFnlLZhwAQLx+4E19pV2x+Yxx3rEBBzkHnCLZlneZ2iCT
        zevvJ0GFqfQ5mCPT38c3yxgzwA==
X-Google-Smtp-Source: ABdhPJwA2gHcQ6pTTJcKgRnxdYSRIi/wTmQWm8YUexB647QP8HPj8ygmB8SXoUSnqs/kfBozVfUi5g==
X-Received: by 2002:aa7:9ac3:: with SMTP id x3mr13028951pfp.261.1595692235526;
        Sat, 25 Jul 2020 08:50:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m31sm9813112pjb.52.2020.07.25.08.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 08:50:34 -0700 (PDT)
Date:   Sat, 25 Jul 2020 08:50:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/19] firmware_loader: EFI firmware loader must
 handle pre-allocated buffer
Message-ID: <202007250849.2B58CD3B@keescook>
References: <20200724213640.389191-1-keescook@chromium.org>
 <20200724213640.389191-4-keescook@chromium.org>
 <20200725100700.GB1073708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725100700.GB1073708@kroah.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Sat, Jul 25, 2020 at 12:07:00PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 24, 2020 at 02:36:24PM -0700, Kees Cook wrote:
> > The EFI platform firmware fallback would clobber any pre-allocated
> > buffers. Instead, correctly refuse to reallocate when too small (as
> > already done in the sysfs fallback), or perform allocation normally
> > when needed.
> > 
> > Fixes: e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firm ware_request_platform()")
> 
> "firmware_request_platform()" :)

Weird... I'm not sure where that mangling happened. Perhaps a bad
cut/paste at 80 columns? Hmpf; thanks for catching. I've updated it on
my end (I assume you fixed this manually, though?)

Thanks!

-- 
Kees Cook
