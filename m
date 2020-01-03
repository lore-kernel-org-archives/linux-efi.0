Return-Path: <SRS0=zl8W=2Y=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E49C3276C
	for <linux-efi@archiver.kernel.org>; Fri,  3 Jan 2020 00:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3385D21D56
	for <linux-efi@archiver.kernel.org>; Fri,  3 Jan 2020 00:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hYouOpgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgACABW (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 2 Jan 2020 19:01:22 -0500
Received: from mail-io1-f52.google.com ([209.85.166.52]:39890 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACABW (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 2 Jan 2020 19:01:22 -0500
Received: by mail-io1-f52.google.com with SMTP id c16so10017999ioh.6
        for <linux-efi@vger.kernel.org>; Thu, 02 Jan 2020 16:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=691DHmCdS87c/j6bFuyR/Zjr435luJ0oY0CkBQ5EO/4=;
        b=hYouOpgJMBZGuUxPCrahQThzllJfbJcJhFSGwkHHW7u9MlIX9FrtZx0WGxWl/oKder
         FQJXTUnY7RAFLQhUV5qX83N/SaxXrq8i/6qR7r2rbX3oPnEAgoNIk0q4vadogsxp/PVa
         ZhK6Q6tP5YvqqAHDYuZcobOBKODuXNkfl0luKVzbkSB/LWGXorwkxMvVs5fNnF/1NCFA
         uffKHhlxuEYnKXgj82iXNMesJVhc3bvMg9n7sG3b4wuGVYAPKhL/EepQtyRvOM+B0/Rh
         zN4QPBO6ApDj18hoYg0HCwfj42Ha03beObL2LsYm+j1OGj+fpEjL0E6nGIO3XEqS5Dvh
         OJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=691DHmCdS87c/j6bFuyR/Zjr435luJ0oY0CkBQ5EO/4=;
        b=dYF7LuCLifAZNll1YpGZgcekUUyhJ99/8QXK2lAApiuVvaX5KCNB/6bY16aGEEIUNU
         HmiBmrFwYXCF5nhF8hIqpGgWU7gNhJTBhDxtfNeakbhjDRJbdJyQDTAEMI2hFCizUGi7
         2AfEVh1j8d45XJpUJ6pCNsFZaMorolc7jVILcaJSQKk/FgZX47Ot0lxRe+SOxYAa7QQZ
         pfSBL9JlpQfrZr8ph3CCtXpBvXa4AQo6mieMumC6rY4ymNHHZ8DtEBU1xWzYHC0qBBdK
         IPkEAQd5q5GMZaAlSVb6BMAAq7LQUMkwjq3GR8/7BAEHXxROm4bV8k2LScre7EZwyTly
         FQ1g==
X-Gm-Message-State: APjAAAX4AEIRvKzcmSX0+wXfpfR2FmtLm7iJaya2yggbIw/bI+Q16g7F
        0I/8X9iEKYY7qSzTSsGEJz6nFv38FNw2wjIyal+kYhlI
X-Google-Smtp-Source: APXvYqx0o3raUtomZEvWudWn67Yd9beSAutw3pCPeQncZ3S3CVFeqnFgDf6AdtSNEScNv5gINwzZnc+gfUZ1Fozl53A=
X-Received: by 2002:a02:b893:: with SMTP id p19mr64674690jam.103.1578009681642;
 Thu, 02 Jan 2020 16:01:21 -0800 (PST)
MIME-Version: 1.0
References: <20191231162344.130654-1-ardb@kernel.org>
In-Reply-To: <20191231162344.130654-1-ardb@kernel.org>
From:   Matthew Garrett <mjg59@google.com>
Date:   Thu, 2 Jan 2020 16:01:10 -0800
Message-ID: <CACdnJutiw_JygnfddfCynb79L-t57EPibmcmJUSQvviwkNu5Rg@mail.gmail.com>
Subject: Re: [PATCH v3] efi: Allow disabling PCI busmastering on bridges
 during boot
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Tue, Dec 31, 2019 at 8:25 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> From: Matthew Garrett <matthewgarrett@google.com>

(snip)

This version looks good to me, thanks!
