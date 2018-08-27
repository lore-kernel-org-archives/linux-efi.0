From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 4.4 018/107] x86/paravirt: Make native_save_fl() extern inline
Date: Mon, 27 Aug 2018 14:06:07 -0700
Message-ID: <CAKwvOd=8rVG5L8dzE5v_jj6o3gruRStxF=orX4jA+tzB=gf2Vg@mail.gmail.com>
References: <20180723122413.003644357@linuxfoundation.org> <20180723122413.797031305@linuxfoundation.org>
 <1535152080.2902.58.camel@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535152080.2902.58.camel@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: ben.hutchings@codethink.co.uk
Cc: stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, hpa@zytor.com, tstellar@redhat.com, sedat.dilek@gmail.com, jgross@suse.com, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, acme@redhat.com, akataria@vmware.com, Andrew Morton <akpm@linux-foundation.org>, andrea.parri@amarulasolutions.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alistair Strachan <astrachan@google.com>, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Greg Hackmann <ghackmann@google.com>, "J. Kiszka" <jan.kiszka@siemens.com>, jarkko.sakkinen@linux.intel.com, joe@perches.com, Josh
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 24, 2018 at 4:08 PM Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
>
> On Mon, 2018-07-23 at 14:41 +0200, Greg Kroah-Hartman wrote:
> > 4.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Nick Desaulniers <ndesaulniers@google.com>
> >
> > commit d0a8d9378d16eb3c69bd8e6d23779fbdbee3a8c7 upstream.
> >
> > native_save_fl() is marked static inline, but by using it as
> > a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.
> >
> > paravirt's use of native_save_fl() also requires that no GPRs other than
> > %rax are clobbered.
> [...]
>
> Shouldn't native_restore_fl() be changed similarly?  You added an out-
> of-line definition, but it doesn't seem like it will actually be used.
>

Good catch, will send a patch with your reported by. Thank you for the report.
-- 
Thanks,
~Nick Desaulniers
