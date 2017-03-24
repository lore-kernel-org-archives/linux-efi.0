From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 16:53:55 +0800
Message-ID: <20170324085355.GB6807@dhcp-128-65.nay.redhat.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170324080833.GA15200@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 03/24/17 at 09:08am, Ingo Molnar wrote:
> 
> * Baoquan He <bhe@redhat.com> wrote:
> 
> > Currently KASLR is enabled on three regions: the direct mapping of physical
> > memory, vamlloc and vmemmap. However EFI region is also mistakenly included
> > for VA space randomization because of misusing EFI_VA_START macro and
> > assuming EFI_VA_START < EFI_VA_END.
> > 
> > The EFI region is reserved for EFI runtime services virtual mapping which
> > should not be included in kaslr ranges. In Documentation/x86/x86_64/mm.txt,
> > we can see:
> >   ffffffef00000000 - fffffffeffffffff (=64 GB) EFI region mapping space
> > EFI use the space from -4G to -64G thus EFI_VA_START > EFI_VA_END,
> > Here EFI_VA_START = -4G, and EFI_VA_END = -64G.
> > 
> > Changing EFI_VA_START to EFI_VA_END in mm/kaslr.c fixes this problem.
> > 
> > Cc: <stable@vger.kernel.org> #4.8+
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > Acked-by: Dave Young <dyoung@redhat.com>
> > Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>
> > Acked-by: Thomas Garnier <thgarnie@google.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Cc: linux-efi@vger.kernel.org
> > Cc: Thomas Garnier <thgarnie@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Cc: Dave Young <dyoung@redhat.com>
> > Cc: Bhupesh Sharma <bhsharma@redhat.com>
> 
> So I applied this kexec fix and extended the changelog to clearly show why this 
> fix matters in practice.
> 
> Also, to make sure I understood it correctly: these addresses are all dynamic on 
> 64-bit kernels, i.e. we are establishing and then tearing down these page tables 
> around EFI calls, and they are 'normally' not present at all, right?

Ingo, if I understand the question right "these addresses" means EFI va addresses
then it is right, EFI switch to its own page tables, so they are not
present in kernel page tables.

> 
> Thanks,
> 
> 	Ingo
