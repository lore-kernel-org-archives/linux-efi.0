From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] EFI fix
Date: Fri, 11 Jan 2019 09:55:36 -0800
Message-ID: <CAHk-=wjNhQsT2h0M25dDELgaCfkWYBGx_5gQw=yEM10uTO4Ycw@mail.gmail.com>
References: <20190111074614.GA68053@gmail.com> <CAKv+Gu8oY6VFeuH3T0FU452W-rKGGQk3top5kEbuP2aCxzJTCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8oY6VFeuH3T0FU452W-rKGGQk3top5kEbuP2aCxzJTCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 11, 2019 at 6:22 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> I was hoping we could merge this patch (so we can backport it), but
> resolve the conflict by dropping the kmemleak_ignore() again [..]

Well, we'd drop the new #include line also, since it would be
pointless without the kmemleak_ignore().

End result: there would be nothing left. Better not to merge it at all.

It's easy enough to backport, and just say "done differently upstream
in commit 80424b02d42b ("efi: Reduce the amount of memblock
reservations for persistent allocations").

The stable tree doesn't require that the *same* commits be upstream,
it only requires that the fixes be upstream and Greg&al want a pointer
to the upstream fix just so that they know they're not fixing
something that might still be broken upstream.

See for example (just random googling)

   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=37435f7e80ef9adc32a69013c18f135e3f434244

which shows that "fixed differently upstream" case and points to why.

                  Linus
