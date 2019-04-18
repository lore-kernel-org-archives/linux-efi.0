Return-Path: <SRS0=5ZN8=SU=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB64C10F0E
	for <linux-efi@archiver.kernel.org>; Thu, 18 Apr 2019 19:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD85206B6
	for <linux-efi@archiver.kernel.org>; Thu, 18 Apr 2019 19:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OH//zo4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbfDRTcM (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 18 Apr 2019 15:32:12 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:38825 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfDRTcM (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 18 Apr 2019 15:32:12 -0400
Received: by mail-io1-f50.google.com with SMTP id v4so2816091ioj.5
        for <linux-efi@vger.kernel.org>; Thu, 18 Apr 2019 12:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPGsazOWVxmxpAM1cNfJkPNQkGFAnVPTTCF532RZhiM=;
        b=OH//zo4LL4ONH2WTmW4BWpbQs3CUh+qtDeWDrnAqTOu6q5gJGyvoNP9mvTlY9u3UkI
         Vkm6MH535T5fsPSf+Ne5iroRVWas6nEKQClwKqChEMU7yZIiIK/rEi3Xcym1Xyj+FxUY
         FrAp+LZr6XaUR0RgX49RuG84pcz0l4mLPnJOvll7pPE4zq4sWuRiCT5k5HpII+ios4im
         /NG0C5q+bGq5DkrcsuQsK3IZ5IGku93rqRfrEYPTpWt+4Y1R4urnI3UxDgixp4ihKeSP
         Tnz09XgamcXFQhGix1zGzoYpYu9TNjAUCJ/2qnYrcNSdzEYxJf9nnxy1FJsbk24ogXui
         T+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPGsazOWVxmxpAM1cNfJkPNQkGFAnVPTTCF532RZhiM=;
        b=Wsdbv44NkaHL+2qufCU5vW0FzU/z8rkL42/lbB2hHLn93oX6/jXJoi3BNSCf1k6mK6
         sfutlqzPTwodzWDgvsxet9Qv5vDfEM/4IkLeYKKhvorLPN/XiddHqk0KWhQDD8zCaxhQ
         5003uypS7PQx5Kdb3qGglk8BMG/qcx1yBwvL+7Y02Nbkj3pnDIr1+cCw4HAUGS0IxSk4
         8d7dhQzz+O2fb1hi4vkR8LSsAeVFV8p21s7IAPgaOzKqp0Hecr3pklHL9laweU1i7GbN
         Nyde57HKRbXKeL6sKprR+BHjkK5fB/A9LiM+VDrh+5jsKQS6gOlFxSsVGbiGeVWNUFFx
         7gLQ==
X-Gm-Message-State: APjAAAWfOn7hTVFoaXahlYpskhomwn0qb4vSVUVV6yTEFbnF0Mk1uS1W
        ImzKbmUjffWWU5oorKQ3YUJQX3X2+AmxE8P8Wp+6EQ==
X-Google-Smtp-Source: APXvYqxBdsWgh/7vAe00CdRpBgOVIPz93dUdHPJxyD6KAOb7NMx+MHtFlZ3mAyUbliTZP7UbdmVYPnfdojYyQCmFNLg=
X-Received: by 2002:a6b:e509:: with SMTP id y9mr54705521ioc.169.1555615931117;
 Thu, 18 Apr 2019 12:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190418034425.GA14950@dhcp-128-65.nay.redhat.com>
In-Reply-To: <20190418034425.GA14950@dhcp-128-65.nay.redhat.com>
From:   Matthew Garrett <mjg59@google.com>
Date:   Thu, 18 Apr 2019 12:32:00 -0700
Message-ID: <CACdnJus8ecXzVBQyfPSraRTapbh3PD_2YmfLH-a+5k-bmX9muQ@mail.gmail.com>
Subject: Re: kexec reboot reset with efi_delete_dummy_variable
To:     Dave Young <dyoung@redhat.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Apr 17, 2019 at 8:44 PM Dave Young <dyoung@redhat.com> wrote:
> So why we still need delete/cleanup the dummy var after entering virt
> mode?  Am I missing something?

I can't think of any reason why you'd need to do this on kexec, but
it's vital to do so in the real enter_virtual_mode() path. It should
be safe to remove it from kexec_enter_virtual_mode(), but on the other
hand it shouldn't be crashing, so I'd recommend figuring out what else
is broken first rather than just deleting it.
