From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v3 2/3] x86/asm: add _ASM_ARG* constants for argument
 registers to <asm/asm.h>
Date: Thu, 7 Jun 2018 13:15:55 -0700
Message-ID: <CAKwvOdkhoOG=Ki-hLL-GtE_++TJ_fy6G_D+xER_vS-aZSjH61A@mail.gmail.com>
References: <20180607183219.192973-1-ndesaulniers@google.com>
 <20180607183219.192973-3-ndesaulniers@google.com> <2f7fc4bf-d0fe-0d3a-ffdd-02cc82c83747@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2f7fc4bf-d0fe-0d3a-ffdd-02cc82c83747@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, sedat.dilek@gmail.com, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, Arnd Bergmann <arnd@arndb.de>, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.c>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 7, 2018 at 1:14 PM H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> On 06/07/18 11:32, Nick Desaulniers wrote:
> >
> > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> If this was suggested by Sedat, I didn't see that suggestion...

I took his suggestion which was to fix the typo in the commit message.
https://lkml.org/lkml/2018/6/5/776

-- 
Thanks,
~Nick Desaulniers
