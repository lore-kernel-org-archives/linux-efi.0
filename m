From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Tue, 5 Jun 2018 12:50:34 -0700
Message-ID: <CAKwvOd=zuy0BJC3f3EKT_9Mg83qdZxAxw_RJ4okAMKrpKjJRHQ@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-2-ndesaulniers@google.com> <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
 <5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Greg KH <gregkh@linuxfoundation.org>, hpa@zytor.com, "J. Kiszka" <jan.kiszka@siemens.com>, jarkko.sakkinen@linux.intel.com, jgross@suse.com, Josh Poimboeuf <jpoimboe@redhat.com>, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, Matthias Kaehlcke <mka@chromium.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com, Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtua
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 5, 2018 at 12:14 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2018-06-05 at 10:23 -0700, Joe Perches wrote:
> > Perhaps these are simpler as
> >
> > #define __inline__    inline
> > #define __inline      inline
>
> Currently, there are these uses of inline variants in the kernel
>
> $ git grep -w inline | wc -l
> 68410
> $ git grep -w __inline__ | wc -l
> 503
> $ git grep -w __inline | wc -l
> 57
>
> So it seems it's also reasonable to sed all uses of __inline to inline
> and perhaps remove __inline eventually altogether.
> (perhaps there are still too many __inline__ uses)

Yeah, that sounds good. Should I split that into 3 patches:

> Excluding scripts and a few other files,
> here's a possible patch done with:
>
> $ git grep -w --name-only __inline | \
>   grep -vP '^(?:arch/alpha/|include/|scripts/)' | \
>   xargs sed -r -i -e 's/\b__inline\b/inline/g' \
>                   -e 's/\binline\s+static\b/static inline/g'
> ---
>  Documentation/trace/tracepoint-analysis.rst             |  2 +-
>  drivers/staging/rtl8723bs/core/rtw_pwrctrl.c            |  4 ++--
>  drivers/staging/rtl8723bs/core/rtw_wlan_util.c          |  2 +-
>  drivers/staging/rtl8723bs/include/drv_types.h           |  6 +++---
>  drivers/staging/rtl8723bs/include/ieee80211.h           |  6 +++---
>  drivers/staging/rtl8723bs/include/osdep_service.h       | 10 +++++-----
>  drivers/staging/rtl8723bs/include/osdep_service_linux.h | 14 +++++++-------
>  drivers/staging/rtl8723bs/include/rtw_mlme.h            | 14 +++++++-------
>  drivers/staging/rtl8723bs/include/rtw_recv.h            | 16 ++++++++--------
>  drivers/staging/rtl8723bs/include/sta_info.h            |  2 +-
>  drivers/staging/rtl8723bs/include/wifi.h                | 14 +++++++-------
>  drivers/staging/rtl8723bs/include/wlan_bssdef.h         |  2 +-
>  lib/zstd/mem.h                                          |  2 +-
>  13 files changed, 47 insertions(+), 47 deletions(-)


1 for documentation, 1 for rtl8723bs, 1 for zstd?

Follow up set or include in v3?
-- 
Thanks,
~Nick Desaulniers
