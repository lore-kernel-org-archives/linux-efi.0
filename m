From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v4 16/28] x86: Add support for changing memory
	encryption attribute
Date: Tue, 28 Feb 2017 16:46:15 -0600
Message-ID: <409ec9f1-896d-a9f0-0e4c-4d102cbf86cf@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154535.19244.6294.stgit@tlendack-t1.amdoffice.net>
	<20170222185215.atbntnyw7252kkbk@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170222185215.atbntnyw7252kkbk-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S.
	Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2/22/2017 12:52 PM, Borislav Petkov wrote:
> On Thu, Feb 16, 2017 at 09:45:35AM -0600, Tom Lendacky wrote:
>> Add support for changing the memory encryption attribute for one or more
>> memory pages.
>
> "This will be useful when we, ...., for example."

Yup, will expand on the "why".

>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/include/asm/cacheflush.h |    3 ++
>>  arch/x86/mm/pageattr.c            |   66 +++++++++++++++++++++++++++++++++++++
>>  2 files changed, 69 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
>> index 872877d..33ae60a 100644
>> --- a/arch/x86/include/asm/cacheflush.h
>> +++ b/arch/x86/include/asm/cacheflush.h
>> @@ -12,6 +12,7 @@
>>   * Executability : eXeutable, NoteXecutable
>>   * Read/Write    : ReadOnly, ReadWrite
>>   * Presence      : NotPresent
>> + * Encryption    : Encrypted, Decrypted
>>   *
>>   * Within a category, the attributes are mutually exclusive.
>>   *
>> @@ -47,6 +48,8 @@
>>  int set_memory_rw(unsigned long addr, int numpages);
>>  int set_memory_np(unsigned long addr, int numpages);
>>  int set_memory_4k(unsigned long addr, int numpages);
>> +int set_memory_encrypted(unsigned long addr, int numpages);
>> +int set_memory_decrypted(unsigned long addr, int numpages);
>>
>>  int set_memory_array_uc(unsigned long *addr, int addrinarray);
>>  int set_memory_array_wc(unsigned long *addr, int addrinarray);
>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>> index 91c5c63..9710f5c 100644
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -1742,6 +1742,72 @@ int set_memory_4k(unsigned long addr, int numpages)
>>  					__pgprot(0), 1, 0, NULL);
>>  }
>>
>> +static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>> +{
>> +	struct cpa_data cpa;
>> +	unsigned long start;
>> +	int ret;
>> +
>> +	/* Nothing to do if the _PAGE_ENC attribute is zero */
>> +	if (_PAGE_ENC == 0)
>
> Why not:
>
> 	if (!sme_active())
>
> ?

Yup, it would be more clear.

>
>> +		return 0;
>> +
>> +	/* Save original start address since it will be modified */
>
> That's obvious - it is a small-enough function to fit on the screen. No
> need for the comment.

Ok.

>
>> +	start = addr;
>> +
>> +	memset(&cpa, 0, sizeof(cpa));
>> +	cpa.vaddr = &addr;
>> +	cpa.numpages = numpages;
>> +	cpa.mask_set = enc ? __pgprot(_PAGE_ENC) : __pgprot(0);
>> +	cpa.mask_clr = enc ? __pgprot(0) : __pgprot(_PAGE_ENC);
>> +	cpa.pgd = init_mm.pgd;
>> +
>> +	/* Should not be working on unaligned addresses */
>> +	if (WARN_ONCE(*cpa.vaddr & ~PAGE_MASK,
>> +		      "misaligned address: %#lx\n", *cpa.vaddr))
>
> Use addr here so that you don't have to deref. gcc is probably smart
> enough but the code should look more readable this way too.
>

Ok.

>> +		*cpa.vaddr &= PAGE_MASK;
>
> I know, you must use cpa.vaddr here but if you move that alignment check
> over the cpa assignment, you can use addr solely.

Ok.

>
>> +
>> +	/* Must avoid aliasing mappings in the highmem code */
>> +	kmap_flush_unused();
>> +	vm_unmap_aliases();
>> +
>> +	/*
>> +	 * Before changing the encryption attribute, we need to flush caches.
>> +	 */
>> +	if (static_cpu_has(X86_FEATURE_CLFLUSH))
>> +		cpa_flush_range(start, numpages, 1);
>> +	else
>> +		cpa_flush_all(1);
>
> I guess we don't really need the distinction since a SME CPU most
> definitely implies CLFLUSH support but ok, let's be careful.
>
>> +
>> +	ret = __change_page_attr_set_clr(&cpa, 1);
>> +
>> +	/*
>> +	 * After changing the encryption attribute, we need to flush TLBs
>> +	 * again in case any speculative TLB caching occurred (but no need
>> +	 * to flush caches again).  We could just use cpa_flush_all(), but
>> +	 * in case TLB flushing gets optimized in the cpa_flush_range()
>> +	 * path use the same logic as above.
>> +	 */
>> +	if (static_cpu_has(X86_FEATURE_CLFLUSH))
>> +		cpa_flush_range(start, numpages, 0);
>> +	else
>> +		cpa_flush_all(0);
>> +
>> +	return ret;
>> +}
>
