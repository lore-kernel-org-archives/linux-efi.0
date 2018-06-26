From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Tue, 26 Jun 2018 12:22:47 -0400
Message-ID: <CAKwvOdnW9r=pgmodEL0VXCv=PZVt_WMCA+B5x4D5oKRM1y-0Ow@mail.gmail.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
 <20180621162324.36656-4-ndesaulniers@google.com> <20180622022402.GA24194@gmail.com>
 <CAKwvOdn5gnB5cK=cy6weKyxAn4SNEdZTT_MtT_D_nHRG5EDZ4g@mail.gmail.com> <20180626071325.GA25751@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180626071325.GA25751@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, sedat.dilek@gmail.com, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, Arnd Bergmann <arnd@arndb.de>, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.c>
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 26, 2018 at 3:13 AM Ingo Molnar <mingo@kernel.org> wrote:
> Ok!
>
> Acked-by: Ingo Molnar <mingo@kernel.org>
>
> What's the planned upstreaming route for these patches/fixes?

While the fix is mainly for paravirt, 2/3 of the patches exclusively
touch arch/x86, so I think they should go up in the x86 tree (as
opposed to paravirt's), if you would be so kind.  hpa mentioned not
handling merges in https://lkml.org/lkml/2018/6/14/903, so I reached
out to you and tglx.

(Also, this is the first series I've ever sent (as opposed to one off
commits), so I'm unfamiliar with the protocol for merging series that
may be touch more than one subsystem.  I assume we don't split up
series to take parts in one tree vs another?)

-- 
Thanks,
~Nick Desaulniers
