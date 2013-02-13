From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Tue, 12 Feb 2013 16:48:12 -0800
Message-ID: <511AE2CC.5040705@zytor.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>  <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>  <1360355671.18083.18.camel@x230.lan>  <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>  <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>  <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>  <1360373383.18083.23.camel@x230.lan>  <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>  <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1360422712.18083.24.camel@x230.lan>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 02/09/2013 07:11 AM, Matthew Garrett wrote:
> On Sat, 2013-02-09 at 10:29 +0100, Borislav Petkov wrote:
>> On Fri, Feb 08, 2013 at 10:45:35PM -0800, Kees Cook wrote:
>>> Also, _reading_ MSRs from userspace arguably has utility that doesn't
>>> compromise ring-0.
>>
>> And to come back to the original question: what is that utility, who
>> would need it on a secure boot system and why?
> 
> Things like Turbostat are useful, although perhaps that information
> should be exposed in a better way.
> 

OK... what none of this gets into:

Why should CAP_RAWIO be allowed on a secure boot system, when there are
2^n known ways of compromise a system with CAP_RAWIO?

	-hpa

