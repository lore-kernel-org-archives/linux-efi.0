From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Revert "x86/mm/ASLR: Propagate base load address
 calculation"
Date: Tue, 17 Mar 2015 09:14:15 +0100
Message-ID: <20150317081415.GB28462@gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
 <20150313122756.GA28855@gmail.com>
 <CAE9FiQXaRmJFdEUhyn2q0v=9ymdbqZWEo1pzo6iyaNupWEp5Xg@mail.gmail.com>
 <20150314075357.GA8319@gmail.com>
 <20150314095923.GA3114@pd.tnic>
 <20150316100628.GD22995@pd.tnic>
 <alpine.LNX.2.00.1503161441280.25438@pobox.suse.cz>
 <CAE9FiQU4xD9Jafbu7X=NDyBzRWAXnLqM0F-aCuVMVYgkqFp6sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQU4xD9Jafbu7X=NDyBzRWAXnLqM0F-aCuVMVYgkqFp6sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Mar 16, 2015 at 6:56 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Mon, 16 Mar 2015, Borislav Petkov wrote:
> >> From: Borislav Petkov <bp@suse.de>
> >> Date: Mon, 16 Mar 2015 10:57:56 +0100
> >> Subject: [PATCH] Revert "x86/mm/ASLR: Propagate base load address calculation"
> >>
> >> This reverts commit f47233c2d34f243ecdaac179c3408a39ff9216a7.
> ...
> >
> > Agreed. Let's work on a better refresh for 4.1+. The fix attempts were
> > quite chaotic.
> 
> Then what is the plan for 4.1+ ?

My plan is to apply correct, clean, properly granular and properly 
changelogged patches.

Thanks,

	Ingo
