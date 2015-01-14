From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Wed, 14 Jan 2015 10:49:32 -0800
Message-ID: <CALCETrVUw=Pg+UqQ-B23dd+o3_ROoziH84B-BdBRqDk5-J=amQ@mail.gmail.com>
References: <5491B4A8.905@amacapital.net> <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org> <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
 <20150114183546.GC6902@pd.tnic> <CALCETrUEfQY-hnmNV9-PfDbEYLa7bVoRcsZc2X0V+mEAbfNH2g@mail.gmail.com>
 <20150114184714.GD6902@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150114184714.GD6902@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 14, 2015 at 10:47 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Jan 14, 2015 at 10:38:25AM -0800, Andy Lutomirski wrote:
>> That's not a real MCE, though -- it happens synchronously instead of
>
> MCE can be synchronous in a sense too, as a result of executing an insn,
> for example, i.e., EIPV bit set.
>
>> at MCE priority with all the associated messiness.  Or is the idea to
>> just stick that in after switching to the 32-bit mode being tested?
>
> Yes, the idea was to simply trigger a real exception after switching to
> 32-bit while still with 64-bit IDT handlers.
>

Seems like a reasonable test to me.

--Andy
