From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] efi/arm: Don't expect a return value of
 ptdump_debugfs_register
Date: Mon, 4 Feb 2019 13:44:45 +0000
Message-ID: <20190204134445.GA22170@fuggles.cambridge.arm.com>
References: <20190201192001.6495-1-natechancellor@gmail.com>
 <CAKv+Gu9tcpZvMZdbD0D+EUCTbdnszv3+MHM68utLZssuMcxyZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9tcpZvMZdbD0D+EUCTbdnszv3+MHM68utLZssuMcxyZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 01, 2019 at 11:18:22PM +0100, Ard Biesheuvel wrote:
> On Fri, 1 Feb 2019 at 20:21, Nathan Chancellor <natechancellor@gmail.com> wrote:
> >
> > As of commit e2a2e56e4082 ("arm64: dump: no need to check return value
> > of debugfs_create functions") in the arm64 for-next/core branch,
> > ptdump_debugfs_register does not have a return value, which causes a
> > build error here:
> >
> > drivers/firmware/efi/arm-runtime.c:51:9: error: returning 'void' from a
> > function with incompatible result type 'int'
> >         return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
> >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 1 error generated.
> >
> > The arm version is still awaiting acceptance [1] but in anticipation
> > of that patch being merged, restructure this function to call
> > ptdump_debugfs_register without expecting a return value.
> >
> > [1]: https://lore.kernel.org/lkml/20190122144114.9816-3-gregkh@linuxfoundation.org/
> >
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> 
> Catalin, Will,
> 
> Could you please apply this directly?

Sure, we'll pick it up.

Will
