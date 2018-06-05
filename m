From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2 2/2] x86: paravirt: make native_save_fl extern inline
Date: Tue, 5 Jun 2018 14:51:23 -0700
Message-ID: <CAKwvOdmqU+fco3JLPh66sfevrf5_E3pQBdus4sDqS-qP0bXr0A@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-3-ndesaulniers@google.com> <CAK8P3a0v6sr_oZmYTZV7E-uJ8JdG6D8JqUesHDPkPY2UrWKdvw@mail.gmail.com>
 <CAK8P3a1MY1-ennr_g=viLSiKodO8uva_jvmtUUU283aXWDLnHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1MY1-ennr_g=viLSiKodO8uva_jvmtUUU283aXWDLnHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Greg KH <gregkh@linuxfoundation.org>, hpa@zytor.com, "J. Kiszka" <jan.kiszka@siemens.com>, jarkko.sakkinen@linux.intel.com, jgross@suse.com, Josh Poimboeuf <jpoimboe@redhat.com>, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, Matthias Kaehlcke <mka@chromium.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com, Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtua
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 5, 2018 at 2:31 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Jun 5, 2018 at 11:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tue, Jun 5, 2018 at 7:05 PM, Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> >>
> >> The semantics of extern inline has changed since gnu89. This means that
> >> folks using GCC versions >= 5.1 may see symbol redefinition errors at
> >> link time for subdirs that override KBUILD_CFLAGS (making the C standard
> >> used implicit) regardless of this patch. This has been cleaned up
> >> earlier in the patch set, but is left as a note in the commit message
> >> for future travelers.
> >
> > I think the keyword you are missing is
> >
> > __attribute__((gnu_inline))
> >
> > which forces the gnu89 behavior on all compiler versions. It's been supported
> > since gcc-4.2, so it should not cause problems on any compiler that is able
> > to build an x86 kernel.
>
> Nevermind, I just saw you already posted that.
>
>        Arnd

That's ok, I appreciate you taking the time to review.  Your point
made me consider adding the function attribute to just
native_save_fl() in this patch, but it seems that that lone function
attribute is not used outside of compiler-gcc.h, so it would be good
to change all users of inline in one place.
-- 
Thanks,
~Nick Desaulniers
