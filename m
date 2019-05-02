From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] mm/pgtable: Drop pgtable_t variable from pte_fn_t
 functions
Date: Thu, 2 May 2019 19:32:42 +0530
Message-ID: <03be69c4-9a63-041c-49fc-249b2bf1d58a@arm.com>
References: <1556803126-26596-1-git-send-email-anshuman.khandual@arm.com>
 <20190502134623.GA18948@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190502134623.GA18948@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Michal Hocko <mhocko@suse.com>, Logan Gunthorpe <logang@deltatee.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, jglisse@redhat.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, schwidefsky@de.ibm.com
List-Id: linux-efi@vger.kernel.org



On 05/02/2019 07:16 PM, Matthew Wilcox wrote:
> On Thu, May 02, 2019 at 06:48:46PM +0530, Anshuman Khandual wrote:
>> Drop the pgtable_t variable from all implementation for pte_fn_t as none of
>> them use it. apply_to_pte_range() should stop computing it as well. Should
>> help us save some cycles.
> You didn't add Martin Schwidefsky for some reason.  He introduced

scripts/get_maintainer.pl did not list the email but anyways I should have
added it from git blame. Thanks for adding his email to the thread.
 
