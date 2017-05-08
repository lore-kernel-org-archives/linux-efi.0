From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [tip:x86/mm] x86/boot/32: Defer resyncing initial_page_table
 until per-cpu is set up
Date: Mon, 8 May 2017 17:24:58 +0200
Message-ID: <7bc13fad-ef45-03e3-ad43-7bca3fdf7f21@siemens.com>
References: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
 <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee@git.kernel.org>
 <0c4d6d04-7038-fb82-87b3-343784550d0a@siemens.com>
 <CAHp75VdX-kUqW0MKOSTz9zByU-eipBMnKpdUbTt2SVOJ8Kvrig@mail.gmail.com>
 <CALCETrXzzhoyzyqp5s7sSOkAtsR2Cor6j+x16OLv=+G30Y6+WQ@mail.gmail.com>
 <7f5916b5-01c0-52d5-9f44-dee4bf355212@siemens.com>
 <CAHp75Ve3nAyy1KxwUGz74Xt3cz-=Mc=7QqWAjwvrLQUrJsEH8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Ve3nAyy1KxwUGz74Xt3cz-=Mc=7QqWAjwvrLQUrJsEH8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>, Thomas Garnier <thgarnie@google.com>, Denys Vlasenko <dvlasenk@redhat.com>, Juergen Gross <jgross@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On 2017-05-08 16:45, Andy Shevchenko wrote:
> On Mon, May 8, 2017 at 3:34 PM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>> On 2017-05-08 13:21, Andy Lutomirski wrote:
> 
>> Yes, it's an EFI thing. Unfortunately, I didn't make
>> earlycon/earlyprintk work yet.
> 
> Quark does use HS UART for the console and we have no support for such
> in x86/earlyprintk. earlycon should work if you add proper parameters
> to the command line (including port base address, no ttySx), though I
> don't remember if it makes really "early".

Ah, that explains it. I've tried earlycon, also with the apparently
correct params, but it didn't print anything in this case. And
earlyprintk=efi seems to use a framebuffer, while our devices are
headless...

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
