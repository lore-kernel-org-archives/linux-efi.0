From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -mmotm] efi: drop kmemleak_ignore() for page allocator
Date: Sat, 29 Dec 2018 10:17:58 +0100
Message-ID: <CAKv+Gu98AOB2LfQGMUHNc_B0MBvd3gATvtPypQaV1vgTcf87ww@mail.gmail.com>
References: <20181226023534.64048-1-cai@lca.pw> <CAKv+Gu_fiEDffKq_fONBYTOdSk-L7__+LgNEyVaNF3FGzBfAow@mail.gmail.com>
 <403405f1-b702-2feb-4616-35fc3dc3133e@lca.pw> <CAKv+Gu_e=NkKZ5C+KzBmgg2VMXNKPqXcPON8heRd0F_iW+aaEQ@mail.gmail.com>
 <20181227190456.0f21d511ef71f1b455403f2a@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181227190456.0f21d511ef71f1b455403f2a@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>, Ingo Molnar <mingo@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux-MM <linux-mm@kvack.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 28 Dec 2018 at 04:04, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 26 Dec 2018 16:31:59 +0100 Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> > Please stop sending EFI patches if you can't be bothered to
> > test/reproduce against the EFI tree.
>
> um, sorry, but that's a bit strong.  Finding (let alone fixing) a bug
> in EFI is a great contribution (thanks!) and the EFI maintainers are
> perfectly capable of reviewing and testing the proposed fix.  Or of
> fixing the bug by other means.
>

Qian did spot some issues recently, which was really helpful. But I
really think that reporting all issues you find against the -mmotm
tree because that happens to be your preferred tree for development is
not the correct approach.

> Let's not beat people up for helping us in a less-than-perfect way, no?

Fair enough. But asking people to ensure that an issue they found
actually exists on the subsystem tree in question is not that much to
ask, is it?
