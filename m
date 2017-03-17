From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 14/32] x86: mm: Provide support to use memblock
 when spliting large pages
Date: Fri, 17 Mar 2017 11:47:16 +0100
Message-ID: <b6f9f46c-58c4-a19c-4955-2d07bd411443@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846771545.2349.9373586041426414252.stgit@brijesh-build-machine>
 <20170310110657.hophlog2juw5hpzz@pd.tnic>
 <cb6a9a56-2c52-d98d-3ff6-3b61d0e5875e@amd.com>
 <20170316182836.tyvxoeq56thtc4pd@pd.tnic>
 <ec134379-6a48-905c-26e4-f6f2738814dc@redhat.com>
 <20170317101737.icdois7sdmtutt6b@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170317101737.icdois7sdmtutt6b@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@suse.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org, devel@linuxdriverproject.org, bhelgaas@google.com, tglx@linutronix.de, mchehab@kernel.org
List-Id: linux-efi@vger.kernel.org



On 17/03/2017 11:17, Borislav Petkov wrote:
> 
>> I also don't really like the patch as is (plus it fails modpost), but
>> IMO reusing __change_page_attr and __split_large_page is the right thing
>> to do.
> 
> Right, so teaching pageattr.c about memblock could theoretically come
> around and bite us later when a page allocated with memblock gets freed
> with free_page().

Theoretically or practically?

> And looking at this more, we have all this kernel pagetable preparation
> code down the init_mem_mapping() call and the pagetable setup in
> arch/x86/mm/init_{32,64}.c

It only looks at the E820 map, doesn't it?  Why does it have to do
anything with percpu memory areas?

Paolo

> And that code even does some basic page splitting. Oh and it uses
> alloc_low_pages() which knows whether to do memblock reservation or the
> common __get_free_pages() when slabs are up.
> 
> So what would be much cleaner, IMHO, is if one would reuse that code to
> change init_mm.pgd mappings early without copying pageattr.c.
> 
> init_mem_mapping() gets called before kvm_guest_init() in setup_arch()
> so the guest would simply fixup its pagetable right there.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
