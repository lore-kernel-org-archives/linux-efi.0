From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/pgtable: Drop pgtable_t variable from pte_fn_t
 functions
Date: Fri, 3 May 2019 06:27:33 -0700
Message-ID: <20190503132733.GA5201@bombadil.infradead.org>
References: <1556803126-26596-1-git-send-email-anshuman.khandual@arm.com>
 <20190502134623.GA18948@bombadil.infradead.org>
 <20190502161457.1c9dbd94@mschwideX1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190502161457.1c9dbd94@mschwideX1>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, akpm@linux-foundation.org, linux-mm@kvack.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Michal Hocko <mhocko@suse.com>, Logan Gunthorpe <logang@deltatee.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, jglisse@redhat.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
List-Id: linux-efi@vger.kernel.org

On Thu, May 02, 2019 at 04:14:57PM +0200, Martin Schwidefsky wrote:
> On Thu, 2 May 2019 06:46:23 -0700
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Thu, May 02, 2019 at 06:48:46PM +0530, Anshuman Khandual wrote:
> > > Drop the pgtable_t variable from all implementation for pte_fn_t as none of
> > > them use it. apply_to_pte_range() should stop computing it as well. Should
> > > help us save some cycles.  
> > 
> > You didn't add Martin Schwidefsky for some reason.  He introduced
> > it originally for s390 for sub-page page tables back in 2008 (commit
> > 2f569afd9c).  I think he should confirm that he no longer needs it.
> 
> With its 2K pte tables s390 can not deal with a (struct page *) as a reference
> to a page table. But if there are no user of the apply_to_page_range() API
> left which actually make use of the token argument we can safely drop it.

Interestingly, I don't think there ever was a user which used that
argument.  Looking at your 2f56 patch, you only converted one function
(presumably there was only one caller of apply_to_page_range() at the
time), and it didn't u se any of the arguments.  Xen was the initial user,
and the two other functions they added also didn't use that argument.

Looking at a quick sample of users added since, none of them appear to
have ever used that argument.  So removing it seems best.

Acked-by: Matthew Wilcox <willy@infradead.org>
