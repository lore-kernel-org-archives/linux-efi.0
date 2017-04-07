From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH v2 14/32] x86: mm: Provide support to use memblock
 when spliting large pages
Date: Fri, 7 Apr 2017 09:50:48 -0500
Message-ID: <cdb9c846-f4cd-81c1-eff3-6ca2de7c3e20@amd.com>
References: <f46ff1e1-1cc7-1907-74a0-e2709fa1e5fb@amd.com>
 <20170406172520.iyjjtz56u3jlnjhq@pd.tnic>
 <ba739600-d468-1f1b-aff6-89c79fd6030b@amd.com>
 <20170407113325.vykr4g3qdufgt2rd@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170407113325.vykr4g3qdufgt2rd@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@suse.de>
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>, simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org
List-Id: linux-efi@vger.kernel.org



On 04/07/2017 06:33 AM, Borislav Petkov wrote:
> On Thu, Apr 06, 2017 at 01:37:41PM -0500, Brijesh Singh wrote:
>> I did thought about prot idea but ran into another corner case which may require
>> us changing the signature of phys_pud_init and phys_pmd_init. The paddr_start
>> and paddr_end args into kernel_physical_mapping_init() should be aligned on PMD
>> level down (see comment [1]). So, if we encounter a case where our address range
>> is part of large page but we need to clear only one entry (i.e asked to clear just
>> one page into 2M region). In that case, now we need to pass additional arguments
>> into kernel_physical_mapping, phys_pud_init and phys_pmd_init to hint the splitting
>> code that it should use our prot for specific entries and all other entries will use
>> the old_prot.
>
> Ok, but your !4K case:
>
> +               /*
> +                * virtual address is part of large page, create the page
> +                * table mapping to use smaller pages (4K). The virtual and
> +                * physical address must be aligned to PMD level.
> +                */
> +               kernel_physical_mapping_init(__pa(vaddr & PMD_MASK),
> +                                            __pa((vaddr_end & PMD_MASK) + PMD_SIZE),
> +                                            0);
>
>
> would map a 2M page as encrypted by default. What if we want to map a 2M page
> frame as ~_PAGE_ENC?
>

Thanks for feedbacks, I will make sure that we cover all other cases in final patch.
Untested but something like this can be used to check whether we can change the large page
in one go or request the splitting.

+               psize = page_level_size(level);
+               pmask = page_level_mask(level);
+
+               /*
+                * Check, whether we can change the large page in one go.
+                * We request a split, when the address is not aligned and
+                * the number of pages to set or clear encryption bit is smaller
+                * than the number of pages in the large page.
+                */
+               if (vaddr == (vaddr & pmask) && ((vaddr_end - vaddr) >= psize)) {
+                       /* UPDATE PMD HERE */
+                       vaddr_next = (vaddr & pmask) + psize;
+                       continue;
+               }
+

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
