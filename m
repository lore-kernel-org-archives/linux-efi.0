Return-Path: <SRS0=P1O2=YP=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD60ECA9EA0
	for <linux-efi@archiver.kernel.org>; Tue, 22 Oct 2019 18:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FEFB21928
	for <linux-efi@archiver.kernel.org>; Tue, 22 Oct 2019 18:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XJgdWmt1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbfJVSR4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:17:56 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39722 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732331AbfJVSR4 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 22 Oct 2019 14:17:56 -0400
Received: by mail-oi1-f196.google.com with SMTP id w144so15043701oia.6
        for <linux-efi@vger.kernel.org>; Tue, 22 Oct 2019 11:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOpu0OseuiXc08mdI69tOPOopIwWTdbk8nIc2lokKaQ=;
        b=XJgdWmt1Fb01rtimxVs7UGUgg2nNjFELzvqXbKwOR2N0+RlvYp+1STsURqwktcTbn2
         CYNMx5zkYFWeJy9Pp1crLJpMWkAa9lnFUFosfymwVkAw2Zg93wYs5IZnlIcSzzVhtZF0
         FUS8z+oUFT8cShOthSahN28+4Ofg9kOnVmr4aZbNmLi3ccowGggxISCVpdu0yGs+4dht
         HEvSGx4jDzphsM83UtxMqUGmYRC24HTm+icekjZvloyRwMHGGcP1JG6vcTt90amPncwd
         0BBPZwnc6ueQxoqkD5kc4oeuKHk0+UEm4XXoClIYHx9pYHlHK6zhE2OqzSStqn3lR46/
         b6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOpu0OseuiXc08mdI69tOPOopIwWTdbk8nIc2lokKaQ=;
        b=U53elXS8nHJAtO9QG2AGpK115qSrIcxFWaq/s6/NXIAkqRnI+6pF+TpUMvk5/3pCbj
         yQ6Bumwi+RypWghIn1jQ8GEnra5VJMpyQ9p91bOnMl2DOErASogKzZutqyxeprMs+Q/z
         1Xpw0AHba/TeA4RVi2/zlU0NSaJcVaiporNDrFTnnwqcsG92//cEM+qcajP5T/58nTTc
         pKNuLqN9HoVoB750Ab87OdHsAUgDj/sD5BMqprzOvVt7QTsxLJ1HA9Mzhba7oCbMtM4d
         K4/TERJJz1RU9ts9kfpLQOWnB0UlzugAf4etkR2Iskf2rN2hCMI1Hs8rSw3Y1LuGnWUt
         jAgw==
X-Gm-Message-State: APjAAAV6N5B4SQdzBmv8HEMBEt2yhv3YJGP0UdBITahD8nQHVALGdRhL
        484IgX4DSZyAvwNxizXk73f661nyDjz87X+YJi8ouQ==
X-Google-Smtp-Source: APXvYqzX+UBLuSqSX7xu+0iFpX/BMy6QMySPZgTjJ3NU0aDX6ipn2ST8I/CCQJ5VPBJ/kifUvNY+rliR1JaUu8riJKw=
X-Received: by 2002:a05:6808:4b:: with SMTP id v11mr4195346oic.70.1571768274619;
 Tue, 22 Oct 2019 11:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191017141305.146193-1-elver@google.com> <20191017141305.146193-8-elver@google.com>
 <20191022123329.GC11583@lakrids.cambridge.arm.com>
In-Reply-To: <20191022123329.GC11583@lakrids.cambridge.arm.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 22 Oct 2019 20:17:43 +0200
Message-ID: <CANpmjNOhoyDMFMUz6by3hLtX7aBFk4pXTmzjmWYiq2+z+R5fAQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] locking/atomics, kcsan: Add KCSAN instrumentation
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     LKMM Maintainers -- Akira Yokosawa <akiyks@gmail.com>,
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
        Nicholas Piggin <npiggin@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
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

On Tue, 22 Oct 2019 at 14:33, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Thu, Oct 17, 2019 at 04:13:04PM +0200, Marco Elver wrote:
> > This adds KCSAN instrumentation to atomic-instrumented.h.
> >
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> > v2:
> > * Use kcsan_check{,_atomic}_{read,write} instead of
> >   kcsan_check_{access,atomic}.
> > * Introduce __atomic_check_{read,write} [Suggested by Mark Rutland].
> > ---
> >  include/asm-generic/atomic-instrumented.h | 393 +++++++++++-----------
> >  scripts/atomic/gen-atomic-instrumented.sh |  17 +-
> >  2 files changed, 218 insertions(+), 192 deletions(-)
>
> The script changes and generated code look fine to me, so FWIW:
>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Great, thank you Mark!

> Thanks,
> Mark.
>
> > diff --git a/scripts/atomic/gen-atomic-instrumented.sh b/scripts/atomic/gen-atomic-instrumented.sh
> > index e09812372b17..8b8b2a6f8d68 100755
> > --- a/scripts/atomic/gen-atomic-instrumented.sh
> > +++ b/scripts/atomic/gen-atomic-instrumented.sh
> > @@ -20,7 +20,7 @@ gen_param_check()
> >       # We don't write to constant parameters
> >       [ ${type#c} != ${type} ] && rw="read"
> >
> > -     printf "\tkasan_check_${rw}(${name}, sizeof(*${name}));\n"
> > +     printf "\t__atomic_check_${rw}(${name}, sizeof(*${name}));\n"
> >  }
> >
> >  #gen_param_check(arg...)
> > @@ -107,7 +107,7 @@ cat <<EOF
> >  #define ${xchg}(ptr, ...)                                            \\
> >  ({                                                                   \\
> >       typeof(ptr) __ai_ptr = (ptr);                                   \\
> > -     kasan_check_write(__ai_ptr, ${mult}sizeof(*__ai_ptr));          \\
> > +     __atomic_check_write(__ai_ptr, ${mult}sizeof(*__ai_ptr));               \\
> >       arch_${xchg}(__ai_ptr, __VA_ARGS__);                            \\
> >  })
> >  EOF
> > @@ -148,6 +148,19 @@ cat << EOF
> >
> >  #include <linux/build_bug.h>
> >  #include <linux/kasan-checks.h>
> > +#include <linux/kcsan-checks.h>
> > +
> > +static inline void __atomic_check_read(const volatile void *v, size_t size)
> > +{
> > +     kasan_check_read(v, size);
> > +     kcsan_check_atomic_read(v, size);
> > +}
> > +
> > +static inline void __atomic_check_write(const volatile void *v, size_t size)
> > +{
> > +     kasan_check_write(v, size);
> > +     kcsan_check_atomic_write(v, size);
> > +}
> >
> >  EOF
> >
> > --
> > 2.23.0.866.gb869b98d4c-goog
> >
