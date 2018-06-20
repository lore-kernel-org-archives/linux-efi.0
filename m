From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v5 2/3] x86/asm: add _ASM_ARG* constants for argument
 registers to <asm/asm.h>
Date: Wed, 20 Jun 2018 09:40:46 -0700
Message-ID: <CAKwvOdmE-EHJY7tgzkhyQqNT3m3oWtd6iE3sWBTz19Rijzx4Ew@mail.gmail.com>
References: <20180613210518.113983-1-ndesaulniers@google.com>
 <20180613210518.113983-3-ndesaulniers@google.com> <b027a324-ffae-fd5e-d8a3-03934be91a2d@zytor.com>
 <CAKwvOdngs8k_T=nDKh8JYdAwwFoJRcCU0bZu0tJHQ+keZ5+RFQ@mail.gmail.com> <deb5a074-b057-9388-4ab7-42295b5bb46c@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <deb5a074-b057-9388-4ab7-42295b5bb46c@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com, mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, sedat.dilek@gmail.com, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, Arnd Bergmann <arnd@arndb.de>, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>Kate Stewart <k>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 14, 2018 at 5:17 PM H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 06/14/18 13:59, Nick Desaulniers wrote:
> > On Thu, Jun 14, 2018 at 1:48 PM H. Peter Anvin <hpa@zytor.com> wrote:
> >>
> >> On 06/13/18 14:05, Nick Desaulniers wrote:
> >>> From: "H. Peter Anvin" <hpa@linux.intel.com>
> >>>
> >>> i386 and x86-64 uses different registers for arguments; make them
> >>> available so we don't have to #ifdef in the actual code.
> >>>
> >>> Native size and specified size (q, l, w, b) versions are provided.
> >>>
> >>> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> >>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >>
> >> I still object to Suggested-by: here.  Sedat did a correction, which is
> >> a Reviewed-by:, but unless I'm completely out to sea, there was no
> >> suggestion on Sedat's part of this; and I had certainly not seen it when
> >> I wrote the code.
> >
> > I'm fine with changing it from a Suggested-by to a Reviewed-by.  Can
> > you do that when you apply the set, or should I send a v6?
> >
>
> I'm not handling patch mechanics for x86 at the moment.

Hi Ingo and Thomas,
Have you had a chance to review this patch series for application?

Note that Juergen (the paravirt maintainer) acked the series:
https://bugs.llvm.org/show_bug.cgi?id=37880
The only issue being swapping a Suggested-by for a Reviewed-by tag for
one commit, as above.

--
Thanks,
~Nick Desaulniers
