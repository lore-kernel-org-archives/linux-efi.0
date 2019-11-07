Return-Path: <SRS0=vceF=Y7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D59C5DF61
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 18:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6CE21D6C
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 18:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+s4tLRe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfKGSoB (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:44:01 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45110 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfKGSn7 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 7 Nov 2019 13:43:59 -0500
Received: by mail-ot1-f68.google.com with SMTP id r24so2879995otk.12
        for <linux-efi@vger.kernel.org>; Thu, 07 Nov 2019 10:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Np0FlikDqTmwL51OIp1+s+VGLrj6Eo2iSbS+rqBgcFU=;
        b=X+s4tLRet1xj+dqvHmXEfS/YHLe9+sdvUDznD6OlUWI1efIcn7AG/F2h+d/MAYLkzE
         RZAo2vYVy43hDiFbRXlMXoJJpsQgmQQStj+TuVAMQsuH8uyG1troWMTHxgRUkoaA2D0M
         lX78jV+zpKCFZNmj7pCPrLLYtNjxrJOdz0gg63KPn5E1sBi6CN2r3YbiZ/l0EebGtLvZ
         NtNYsP79rjcjCNmbUCeWEhAOfhSnRP/IZaWkcKtAJd6EriACLLGruAoJfWiVaoiu5qlN
         6h+gGPib2+VjxvGXiD9ykfXsmY75IIvFAAhMpUzqeAR1f4jvFwGMm/A3rlvbZJ9CCx90
         h7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Np0FlikDqTmwL51OIp1+s+VGLrj6Eo2iSbS+rqBgcFU=;
        b=Cc9PE0DnR038VAqzd8haq/3JSF6uDBut/JgsN3i2rtow+Eg06fghUdBRcTWwDEYhh7
         xYrZXoRxbWemOdvcoIJTlFVrrIyUD+ZnovmLzXINHO7Pp+LACDH76uEE5I3Obe+JDSEK
         99jhmQMoIXj66bMvGzdY2HrIv2FA5eqPNzbnQn6W/SL1qNPrDrLMAV+O3/nWsYo8THQI
         0I8rYriiR3JIF2OElP7qHB5oTDBA5yW2LnapYjlKt8cNNFu5+78LTu2iGTywWfjGPUoP
         cFUJMSlkgjUraoaZOjfEt34O87fYlNAhQpsffTzFb5g81BrF01k4OqN8R5LIntx/m1oa
         7qjA==
X-Gm-Message-State: APjAAAX5wMlzj5Uux/33FOMfugN2a3G/OZhIXBTL422aMXuCos7Kgnj6
        LbUGoRlIs8J6nQyhlV4yP9UhLXhQIGBMty6OS6JkmA==
X-Google-Smtp-Source: APXvYqwO3UnGuF7d4Y2gfzVJSb7LPWecfAiiK/QIM9BoHDNRh9E7Srx5p/4cCr/YwL4Jvfd1ibRj9LkTbNN2VnuQejM=
X-Received: by 2002:a05:6830:1e84:: with SMTP id n4mr4371298otr.233.1573152236918;
 Thu, 07 Nov 2019 10:43:56 -0800 (PST)
MIME-Version: 1.0
References: <20191104142745.14722-2-elver@google.com> <201911070445.vRUSVUAX%lkp@intel.com>
In-Reply-To: <201911070445.vRUSVUAX%lkp@intel.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 7 Nov 2019 19:43:45 +0100
Message-ID: <CANpmjNNWeM91Jmoh8aujpBA9YVfL6LSqH-taQO-6BJQwUZfCkw@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] kcsan: Add Kernel Concurrency Sanitizer infrastructure
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        LKMM Maintainers -- Akira Yokosawa <akiyks@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexander Potapenko <glider@google.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Daniel Axtens <dja@axtens.net>,
        Daniel Lustig <dlustig@nvidia.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 6 Nov 2019 at 21:35, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Marco,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.4-rc6]
> [cannot apply to next-20191106]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Marco-Elver/Add-Kernel-Concurrency-Sanitizer-KCSAN/20191105-002542
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git a99d8080aaf358d5d23581244e5da23b35e340b9
> config: x86_64-randconfig-a004-201944 (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.2-10+deb8u1) 4.9.2
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>

Thanks! Will send v4 with a fix.

> All warnings (new ones prefixed by >>):
>
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
> --
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    fs/afs/dynroot.c: In function 'afs_dynroot_lookup':
>    fs/afs/dynroot.c:117:6: warning: 'len' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      ret = lookup_one_len(name, dentry->d_parent, len);
>          ^
>    fs/afs/dynroot.c:91:6: note: 'len' was declared here
>      int len;
>          ^
> --
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    7 real  2 user  5 sys  107.26% cpu   make modules_prepare
> --
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    In file included from include/linux/compiler_types.h:59:0,
>                     from <command-line>:0:
> >> include/linux/compiler_attributes.h:35:29: warning: "__GCC4_has_attribute___no_sanitize_thread__" is not defined [-Wundef]
>     # define __has_attribute(x) __GCC4_has_attribute_##x
>                                 ^
> >> include/linux/compiler-gcc.h:148:5: note: in expansion of macro '__has_attribute'
>     #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>         ^
>    8 real  24 user  10 sys  405.87% cpu         make prepare
>
> vim +/__has_attribute +148 include/linux/compiler-gcc.h
>
>    147
>  > 148  #if __has_attribute(__no_sanitize_thread__) && defined(__SANITIZE_THREAD__)
>    149  #define __no_sanitize_thread                                                   \
>    150          __attribute__((__noinline__)) __attribute__((no_sanitize_thread))
>    151  #else
>    152  #define __no_sanitize_thread
>    153  #endif
>    154
>
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/kasan-dev/201911070445.vRUSVUAX%25lkp%40intel.com.
