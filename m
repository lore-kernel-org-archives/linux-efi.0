From: Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 1/2] ima: fix build error redeclaration of enumerator
Date: Tue, 12 Feb 2019 12:00:33 +0100
Message-ID: <CADYN=9JhN=x67Jj_L6Jk2ShTJsARUK6rQHWQttvNLJuZ0mfQDQ@mail.gmail.com>
References: <20190212100825.9113-1-anders.roxell@linaro.org>
 <CAHp75Vd8yi0u7S6oA=Vr7E9ptYdvBvXBJn=fG2kM-=vS-7oOQg@mail.gmail.com> <CAHp75VcPeKDLOB7vKeSG9+UfsYnPfTPy_omuTgJSUgKzC0caNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcPeKDLOB7vKeSG9+UfsYnPfTPy_omuTgJSUgKzC0caNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 12 Feb 2019 at 11:23, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>
> On Tue, Feb 12, 2019 at 12:21 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > On Tue, Feb 12, 2019 at 12:15 PM Anders Roxell <anders.roxell@linaro.org> wrote:
> > >
> > > Commit a893ea15d764 ("tpm: move tpm_chip definition to
> > > include/linux/tpm.h") introduced a build error when both ima and efi is
> > > enabled. What happens is that both headers (ima.h and efi.h) defines the
> > > same 'NONE' constant, and it broke when they started getting included
> > > from the same file.
> >
> > > We only need one of the two patches applied.
> >
> > I would argue that we need two patches applied. Namespace is a hidden
> > issue in the code.
> >
> > This patch looks good to me, FWIW,
> > Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>
> Oh, did you change ABI? So, I have to say that enum changes are okay,
> but ABI, if any, are not.

urgh, thank you for the review. It looks like I changed a bit too much
in ima_parse_rule() =/
I'll send send out a v2 shortly.

Cheers,
Anders
