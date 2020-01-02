Return-Path: <SRS0=usRN=2X=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45317C2D0DC
	for <linux-efi@archiver.kernel.org>; Thu,  2 Jan 2020 15:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1890221835
	for <linux-efi@archiver.kernel.org>; Thu,  2 Jan 2020 15:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pOkgpZHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgABPU7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 2 Jan 2020 10:20:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41272 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbgABPU7 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 2 Jan 2020 10:20:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so39562396wrw.8
        for <linux-efi@vger.kernel.org>; Thu, 02 Jan 2020 07:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ixUEHIx5YRRvHmVMKln1Z8ycr1qmKO7EYhb0F/+EW0I=;
        b=pOkgpZHTTK4RBum8lH4CDgK4QdjBkscWzhkQr7DS4Mn5dFBpI3fE3M+Nsr8Kd6iVYZ
         vnt+obXLdZivCCjYY7L4kxzZ0aiMkxatlI7v2uoADHJ7Dn6wCxDEaYF8K//h/BkPV4sy
         pvyf9mLnQlGczdj6/Xq5dAbf17k+vqxqFqVPN8yOmsctlV7QmU6PnlQeo0DvKC2/Ei6f
         1CuuuoG5/5jBqqfsn+YJ4l6d0APjgPmrvLcGE3Ca4tsseXaNWPebAenYVIgXwnaNss4F
         vRhCVbgOzs0QgUZp0JEVv0P96GRX1Z9bJYCdFvMNqZ7BT3zzaxeGZzk7Ud1dyy5hInyr
         bnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ixUEHIx5YRRvHmVMKln1Z8ycr1qmKO7EYhb0F/+EW0I=;
        b=H4fFBrfuj0ZFTyylWMcj5Y5/+/QgzXCJGdB9VulNLOFkzWDDBOzZBgF95I9qOzCiTT
         w4vmbj9IJy2xudcS+58jHphM7DaLDDfRrwyKNYsgYtnMckvUa77vbxqDy6R+vQeH3mXi
         mBMJ94lZIsWI4kMi7KFPSIMIpZfLreR8eiWnRLEJrKZM8OU1/IjwxvMDvpfjC+Tvo3Eh
         l/lnylj6vWgU5Aewb07zLFQg7bugfmC9pHVJiONsO6NKmNOd5Coel6f4TyY0yGsYwO3+
         0cLu4w1d9QDv3Gt3C2OVe9a/vOaPwwiFVnDFXtDazGVrkV6QUzXB6sckX4z69LHbkm6A
         PStQ==
X-Gm-Message-State: APjAAAXCORatnb7b+XQx2I99r//AilmB8SHZA0WCP5z9A3XGxL4LLueV
        QVpuTrDUgFPQe9oIIa/YrdIjoBYIAUNxetTMqMohAQ==
X-Google-Smtp-Source: APXvYqyVrzekMKVXXZzNn06+jvihTBsotVCheQHR5SeA2SOhaiM/r1c5Lp0uuTJTcTOg8obPfZp6cyRGrwqm6wBo7pU=
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr81123088wrs.200.1577978457096;
 Thu, 02 Jan 2020 07:20:57 -0800 (PST)
MIME-Version: 1.0
References: <20191218170139.9468-1-ardb@kernel.org> <20191218170139.9468-14-ardb@kernel.org>
 <20191231230436.GA78532@rani.riverdale.lan> <CAKv+Gu_6zKX9vtvJ9r_CMfufh9-0yOJikYH-Z2xtVcn5i8qwsw@mail.gmail.com>
 <20200101190844.GA208136@rani.riverdale.lan> <CAKv+Gu-XRgRXgiuDEe+DXdcEzOuUWG6fWMO_oa41f2Ugki5kCA@mail.gmail.com>
 <20200102140653.GA626673@rani.riverdale.lan>
In-Reply-To: <20200102140653.GA626673@rani.riverdale.lan>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 2 Jan 2020 16:20:46 +0100
Message-ID: <CAKv+Gu_Ca4nBORcy8JzUhE5svxZ9nZosuif7EtToYxqiBZfEQA@mail.gmail.com>
Subject: Re: [PATCH v2 13/21] efi/libstub/x86: drop __efi_early() export of
 efi_config struct
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 2 Jan 2020 at 15:06, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Thu, Jan 02, 2020 at 08:33:54AM +0100, Ard Biesheuvel wrote:
> > On Wed, 1 Jan 2020 at 20:08, Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > >
> > > On Wed, Jan 01, 2020 at 07:13:45PM +0100, Ard Biesheuvel wrote:
> > > > The GCC documentation mentions that it does not make sense for a
> > > > function annotated as const not to take any arguments, so I'd rather
> > > > avoid it here.
> > >
> > > Where does it say that? I only see it saying it doesn't make sense for
> > > it to return void.
> > >
> >
> > You're right. I looked into this in the past, and I misremembered, and
> > paraphrased it incorrectly.
> >
> > The documentation does mention that const functions are not permitted
> > to read global memory.
> >
>
> What it says is that "[the const attribute] tells GCC that subsequent
> calls to function square with the same argument value can be replaced by
> the result of the first call regardless of the statements in between"
> and "The const attribute prohibits a function from reading objects that
> affect its return value between successive invocations. However,
> functions declared with the attribute can safely read objects that do
> not change their return value, such as non-volatile constants."
>
> In this case since the globals in question never change after being set,
> it should be safe -- every call to these functions does return the same
> value.
>

I agree that it should be safe. However, the document I looked at literally says

"""
Many functions do not examine any values except their arguments, and
have no effects except the return value. Basically this is just
slightly more strict class than the pure attribute below, since
function is not allowed to read global memory.
"""

However, this is actually a fairly old version of the docs [0], and
the most recent version seems to permit it.

[0] https://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Function-Attributes.html


> > > Currently if we call 5 EFI services in the same function, it has to
> > > re-evaluate systemtable and is64 for each call, which seems wasteful,
> > > though of course this is not exactly performance-critical code.
> >
> > The alternative would be to use globals with external linkage in a way
> > that is guaranteed not to rely on GOT entries, since we'll end up with
> > absolute addresses that need to be fixed up first. This has caused
> > breakage in the past, and is the reason we use this scheme with
> > globals with static linkage and __pure getters.
> >
> > However, hidden visibility should yield the same results so we should
> > be able to make it work with that instead. However, given the breakage
> > in the past, I don't think it's worth it since the performance gain
> > will be negligible.
>
> This only saves the overhead of the function call, but the compiler
> would still have to re-read the variables and re-test them, since so far
> as it knows the firmware call could change them. With the const function
> attribute, it will only load them once. To make it work with just the
> variables, they'd have to be declared const and initialized in the
> assembly entry code.

Yeah, good point.

I pushed as branch here;
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=efi-libstub-attr-const

Could you please check if that fixes the issue for efi_is_64bit() ?
