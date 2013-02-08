From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 11:21:39 -0800
Message-ID: <CAGXu5j+aXxQb_Jyn6G+JUdjNOF2EGo9pTw8dBYuZUTb+S1vWow@mail.gmail.com>
References: <20130208191213.GA25081@www.outflux.net>
	<1360351047.18083.14.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1360351047.18083.14.camel@x230.lan>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 8, 2013 at 11:17 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2013-02-08 at 11:12 -0800, Kees Cook wrote:
>> Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
>> set since it could lead to execution of arbitrary code in kernel mode.
>
> Willing to buy this, but do you have a description of one potential
> approach? We should probably also figure out what's writing to MSRs at
> the moment (anything other than energy_perf_bias?) and decide what the
> best thing to do there is.

Yes, change the SYSENTER entry point to where-ever you like. There are
examples already written:
http://grsecurity.net/~spender/msr32.c

IMO, _writing_ an MSR from userspace should be considered a bug. If
writing is needed, a kernel driver should be mediating the change.
wrmsr (and rdmsr) are ring-0 only for good reason. :)

-Kees

--
Kees Cook
Chrome OS Security
