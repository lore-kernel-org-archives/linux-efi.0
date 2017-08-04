From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v6 RESEND] x86/boot/KASLR: Restrict kernel to be
 randomized in mirror regions
Date: Fri, 4 Aug 2017 20:02:46 +0800
Message-ID: <20170804120246.GI1874@x1>
References: <1500542189-15779-1-git-send-email-bhe@redhat.com>
 <20170721103757.hc74czr3mfunrv6c@gmail.com>
 <20170721131956.GK2344@x1>
 <20170724133410.GC11076@codeblueprint.co.uk>
 <20170728095525.y4tuv6aavzfs4ekb@gmail.com>
 <20170728112603.GS24304@x1>
 <20170804112325.GB8187@codeblueprint.co.uk>
 <20170804114005.GC29975@x1>
 <20170804115513.GD8187@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170804115513.GD8187@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, keescook@chromium.org, tglx@linutronix.de, hpa@zytor.com, izumi.taku@jp.fujitsu.com, fanc.fnst@cn.fujitsu.com, thgarnie@google.com, n-horiguchi@ah.jp.nec.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 08/04/17 at 12:55pm, Matt Fleming wrote:
> On Fri, 04 Aug, at 07:40:05PM, Baoquan He wrote:
> > On 08/04/17 at 12:23pm, Matt Fleming wrote:
> > > On Fri, 28 Jul, at 07:26:03PM, Baoquan He wrote:
> > > > Hi Matt,
> > > > 
> > > > On 07/28/17 at 11:55am, Ingo Molnar wrote:
> > > > > 
> > > > > * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> > > > > 
> > > > > > On Fri, 21 Jul, at 09:19:56PM, Baoquan He wrote:
> > > > > > >
> > > > > > > There are places where the efi map is getting and used like this. E.g
> > > > > > > in efi_high_alloc() of drivers/firmware/efi/libstub/efi-stub-helper.c.
> > > > > > > EFI developers worry the size of efi_memory_desc_t could not be the same
> > > > > > > as e->efi_memdesc_size?
> > > > > > > 
> > > > > > > Hi Matt,
> > > > > > > 
> > > > > > > Could you help have a look at this?
> > > > > > 
> > > > > > You're exactly right. The code guards against the size of the
> > > > > > efi_memory_desc_t struct changing. The UEFI spec says to traverse the
> > > > > > memory map this way.
> > > > > 
> > > > > This is not obvious and looks pretty ugly as well, and open coded in several 
> > > > > places.
> > > > > 
> > > > > At minimum we should have an efi_memdesc_ptr(efi, i) wrapper inline (or so) that 
> > > > > gives us the entry pointer, plus a comment that points out that ->memdesc_size 
> > > > > might not be equal to sizeof(efi_memory_memdesc_t).
> > > > 
> > > > I can make a efi_memdesc_ptr(efi, i) wrapper as Ingo suggested and use
> > > > it here if you agree. Seems it might be not good to add another
> > > > for_each_efi_memory_desc_xxxx wrapper since there are different memmap
> > > > data structures in x86 boot and in general efi libstub. Or any other
> > > > idea?
> > > 
> > > I think adding a wrapper is fine, but I'd suggest including the word
> > > "early" (or something similar) to explain that it should only be used
> > > during bootup -- we want everyone else to use the
> > > for_each_efi_memory_*() API.
> > 
> > Thanks, Matt. I can do that. Do you think if below helper definition is OK
> > to you? If yes, I can update with it and post v9.
> > 
> > #define efi_early_memdesc_ptr(map, desc_size, n)				\
> > 	(efi_memory_desc_t *)((void *)(map) + ((n) * (desc_size)))
>  
> Looks fine to me, but I'd wait for Ingo's OK before resending.

Sure, thanks!
