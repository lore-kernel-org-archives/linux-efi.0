Return-Path: <SRS0=vceF=Y7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31C1C5DF60
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 14:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998732187F
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573135936;
	bh=eFSEHwy8H/yP84/R4iQg7rUkqjIElsqqX+7Lc2LxeiU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SYOywQzOz/XuNhhVtiUZpbZz/mMWQ9ZgeFVP+GAau6g2r4cGIvYdNbMA3nzRog3U9
	 Nz0WR3ItUsXBMMYOCYW8veBXD5WM3ub7kMIE9DTw9CR1fzbzUlMlXKgEuOPqD7Fj1q
	 cqg6L915u9YIXjJmX0psJsZXZgb13agkgrQ9ZM+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfKGOMQ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 7 Nov 2019 09:12:16 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42519 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGOMQ (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 7 Nov 2019 09:12:16 -0500
Received: by mail-ot1-f67.google.com with SMTP id b16so2102088otk.9;
        Thu, 07 Nov 2019 06:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWWfquVvfscWRLHvr28HN8i4Fy/KkuUnhhq0FcZYb0E=;
        b=r3Oz8uAbxlJ0BixvucNmdzmyK9qOk+Ohp2UB92DtcSynMnaPLKp+yZkWSCBOZdBaTE
         pN66G7czoEWR+S9DTpaqWHHY5YB9Ka4U5ZSXmUv7+j3n8LzupysOUpBoUwGjph6uJA5k
         1Bbi/MdC+2CZ5C2LmusPnA94/QLQfW0nZIDTdpnwcC2MFiEsyQr8neidS/E0YUa2gMZf
         CXMTLPxiMJEQ89UTxmda2XGkw6tHmnhhVwwrlVhyeWiDDOfIViKcyW8gUcnO6myYyH3C
         kP211JTHEQXZ7WspEOTtgEQwX6FfAWMcfXB2dch8a9wDHaymB87EmoRyJC17oWQXrGNP
         9CKQ==
X-Gm-Message-State: APjAAAVbPJgzfUdbC1wKD+xwA2VLavT5GO9/WKDVg8rRBRUmxxvXn2O3
        UbLKoNJac6SzPk1qRSAe5s6jY8Ee/RJP5vRTPuI=
X-Google-Smtp-Source: APXvYqxu6udHOvBSW/xwAJQXHKIOXHGoAa2IhEo7XpAgPdk3s2N7Ce8so1jz9m3xm7wa8ZRiIeEm/HJSABKwmeMR68s=
X-Received: by 2002:a9d:7d01:: with SMTP id v1mr3026793otn.167.1573135933257;
 Thu, 07 Nov 2019 06:12:13 -0800 (PST)
MIME-Version: 1.0
References: <157309097008.1579826.12818463304589384434.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAJZ5v0hDaxcPBwwx2FaxKKJGNOvY_+JuvF7CJ0tbX1TjEisvUQ@mail.gmail.com> <alpine.DEB.2.21.1911071447090.4256@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1911071447090.4256@nanos.tec.linutronix.de>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 7 Nov 2019 15:12:02 +0100
Message-ID: <CAJZ5v0g2PySxpYg_94aFiz+FBdZOvAw8DwR-B47Lx-H50hR2hw@mail.gmail.com>
Subject: Re: [PATCH v8 00/12] EFI Specific Purpose Memory Support
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andy Shevchenko <andy@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Keith Busch <kbusch@kernel.org>, Len Brown <lenb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Darren Hart <dvhart@infradead.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        kbuild test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Lutomirski <luto@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, Nov 7, 2019 at 2:49 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Thu, 7 Nov 2019, Rafael J. Wysocki wrote:
> > On Thu, Nov 7, 2019 at 2:57 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Indeed.
> >
> > I have waited for comments on x86 bits from Thomas, but since they are
> > not coming, I have just decided to take patch [1/12] from this series,
> > which should be totally non-controversial,  as keeping it out of the
> > tree has become increasingly painful (material depending on it has
> > been piling up already for some time).
>
> Sorry for letting this slip through the cracks.
>
> From x86 side I don't see any issues. It's mostly EFI stuff which Ard has
> looked at already. So feel free to pick up the lot
>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

I will, thank you!
