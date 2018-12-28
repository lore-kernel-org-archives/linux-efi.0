From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mmotm] efi: drop kmemleak_ignore() for page allocator
Date: Thu, 27 Dec 2018 19:04:56 -0800
Message-ID: <20181227190456.0f21d511ef71f1b455403f2a@linux-foundation.org>
References: <20181226023534.64048-1-cai@lca.pw>
        <CAKv+Gu_fiEDffKq_fONBYTOdSk-L7__+LgNEyVaNF3FGzBfAow@mail.gmail.com>
        <403405f1-b702-2feb-4616-35fc3dc3133e@lca.pw>
        <CAKv+Gu_e=NkKZ5C+KzBmgg2VMXNKPqXcPON8heRd0F_iW+aaEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_e=NkKZ5C+KzBmgg2VMXNKPqXcPON8heRd0F_iW+aaEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Qian Cai <cai@lca.pw>, Ingo Molnar <mingo@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux-MM <linux-mm@kvack.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Dec 2018 16:31:59 +0100 Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Please stop sending EFI patches if you can't be bothered to
> test/reproduce against the EFI tree.

um, sorry, but that's a bit strong.  Finding (let alone fixing) a bug
in EFI is a great contribution (thanks!) and the EFI maintainers are
perfectly capable of reviewing and testing the proposed fix.  Or of
fixing the bug by other means.

Let's not beat people up for helping us in a less-than-perfect way, no?
