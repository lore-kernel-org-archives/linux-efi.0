From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] EFI fix
Date: Sat, 12 Jan 2019 09:54:32 +0100
Message-ID: <20190112085432.GB119110@gmail.com>
References: <20190111074614.GA68053@gmail.com>
 <CAHk-=whU4L4qzCmKhGGSthCGWkSSVFiP-0v16fpZTUzWgp39hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whU4L4qzCmKhGGSthCGWkSSVFiP-0v16fpZTUzWgp39hg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 10, 2019 at 11:46 PM Ingo Molnar <mingo@kernel.org> wrote:
> >
> > A single fix that adds an annotation to resolve a kmemleak false
> > positive.
> 
> This one is apparently obviated by commit 80424b02d42b ("efi: Reduce
> the amount of memblock reservations for persistent allocations")

... and it turns out I mis-merged it in tip:master not realizing this 
connection (hence the pull request) - so good thing that Ard warned about 
this and you double checked it!

Thanks,

	Ingo
