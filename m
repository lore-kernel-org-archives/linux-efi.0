From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] EFI fix
Date: Fri, 11 Jan 2019 09:47:42 -0800
Message-ID: <CAHk-=whU4L4qzCmKhGGSthCGWkSSVFiP-0v16fpZTUzWgp39hg@mail.gmail.com>
References: <20190111074614.GA68053@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111074614.GA68053@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 10, 2019 at 11:46 PM Ingo Molnar <mingo@kernel.org> wrote:
>
> A single fix that adds an annotation to resolve a kmemleak false
> positive.

This one is apparently obviated by commit 80424b02d42b ("efi: Reduce
the amount of memblock reservations for persistent allocations")

               Linus
