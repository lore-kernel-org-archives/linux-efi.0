From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 2/2] efi: fix build error redeclaration of enumerator
Date: Tue, 12 Feb 2019 12:19:53 +0200
Message-ID: <CAHp75Vd161xYcOgESiA2Ex5gzM39_CSSH11HsVzOyyA+g0rYTw@mail.gmail.com>
References: <20190212100825.9113-1-anders.roxell@linaro.org>
 <20190212100825.9113-2-anders.roxell@linaro.org> <CAKv+Gu_y++P259Bi92kJr0XHxw8Tvpag74vvFiPQf34DmJq3uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_y++P259Bi92kJr0XHxw8Tvpag74vvFiPQf34DmJq3uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>, Mimi Zohar <zohar@linux.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 12, 2019 at 12:16 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On Tue, 12 Feb 2019 at 11:09, Anders Roxell <anders.roxell@linaro.org> wrote:
> >
> > Commit a893ea15d764 ("tpm: move tpm_chip definition to
> > include/linux/tpm.h") introduced a build error when both ima and efi is
> > enabled. What happens is that both headers (ima.h and efi.h) defines the
> > same 'NONE' constant, and it broke when they started getting included
> > from the same file.

> I'd argue that we should apply both patches. 'NONE' is far too
> generic, so it requires a subsystem prefix if it has a special meaning
> inside a subsystem.

I was about to say the same thing.

-- 
With Best Regards,
Andy Shevchenko
