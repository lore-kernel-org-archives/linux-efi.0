From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/2] x86: paravirt: make native_save_fl extern inline
Date: Tue, 5 Jun 2018 23:31:35 +0200
Message-ID: <CAK8P3a1MY1-ennr_g=viLSiKodO8uva_jvmtUUU283aXWDLnHw@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-3-ndesaulniers@google.com> <CAK8P3a0v6sr_oZmYTZV7E-uJ8JdG6D8JqUesHDPkPY2UrWKdvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0v6sr_oZmYTZV7E-uJ8JdG6D8JqUesHDPkPY2UrWKdvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, akataria@vmware.com, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, gregkh <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kiszka <jan.kiszka@siemens.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Juergen Gross <jgross@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, mjg59@google.com, Matthias Kaehlcke <mka@chromium.org>, Philippe Ombredanne <pombredanne@nexb.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutroni>
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 5, 2018 at 11:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jun 5, 2018 at 7:05 PM, Nick Desaulniers
> <ndesaulniers@google.com> wrote:
>>
>> The semantics of extern inline has changed since gnu89. This means that
>> folks using GCC versions >= 5.1 may see symbol redefinition errors at
>> link time for subdirs that override KBUILD_CFLAGS (making the C standard
>> used implicit) regardless of this patch. This has been cleaned up
>> earlier in the patch set, but is left as a note in the commit message
>> for future travelers.
>
> I think the keyword you are missing is
>
> __attribute__((gnu_inline))
>
> which forces the gnu89 behavior on all compiler versions. It's been supported
> since gcc-4.2, so it should not cause problems on any compiler that is able
> to build an x86 kernel.

Nevermind, I just saw you already posted that.

       Arnd
