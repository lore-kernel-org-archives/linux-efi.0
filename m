From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/20] mm: Access BOOT related data in the clear
Date: Mon, 12 Sep 2016 10:14:59 -0500
Message-ID: <6431e761-a4c8-c9bb-1352-6d66672200fd@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
	<20160822223738.29880.6909.stgit@tlendack-t1.amdoffice.net>
	<20160909163814.sgsi2jlxlshskt5c@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160909163814.sgsi2jlxlshskt5c-fF5Pk5pvG8Y@public.gmane.org>
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
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/09/2016 11:38 AM, Borislav Petkov wrote:
> On Mon, Aug 22, 2016 at 05:37:38PM -0500, Tom Lendacky wrote:
>> BOOT data (such as EFI related data) is not encyrpted when the system is
>> booted and needs to be accessed as non-encrypted.  Add support to the
>> early_memremap API to identify the type of data being accessed so that
>> the proper encryption attribute can be applied.  Currently, two types
>> of data are defined, KERNEL_DATA and BOOT_DATA.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
> 
> ...
> 
>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>> index 031db21..e3bdc5a 100644
>> --- a/arch/x86/mm/ioremap.c
>> +++ b/arch/x86/mm/ioremap.c
>> @@ -419,6 +419,25 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
>>  	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
>>  }
>>  
>> +/*
>> + * Architecure override of __weak function to adjust the protection attributes
>> + * used when remapping memory.
>> + */
>> +pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
>> +					     unsigned long size,
>> +					     enum memremap_owner owner,
>> +					     pgprot_t prot)
>> +{
>> +	/*
>> +	 * If memory encryption is enabled and BOOT_DATA is being mapped
>> +	 * then remove the encryption bit.
>> +	 */
>> +	if (_PAGE_ENC && (owner == BOOT_DATA))
>> +		prot = __pgprot(pgprot_val(prot) & ~_PAGE_ENC);
>> +
>> +	return prot;
>> +}
>> +
> 
> Hmm, so AFAICT, only arch/x86/xen needs KERNEL_DATA and everything else
> is BOOT_DATA.
> 
> So instead of touching so many files and changing early_memremap(),
> why can't you remove _PAGE_ENC by default on x86 and define a specific
> early_memremap() for arch/x86/xen/ which you call there?
> 
> That would make this patch soo much smaller and the change simpler.

Yes it would.  I'll take a look into that.

> 
> ...
> 
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index 5a2631a..f9286c6 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -386,7 +386,7 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
>>  		 * So just always get our own virtual map on the CPU.
>>  		 *
>>  		 */
>> -		md = early_memremap(p, sizeof (*md));
>> +		md = early_memremap(p, sizeof (*md), BOOT_DATA);
> 
> WARNING: space prohibited between function name and open parenthesis '('
> #432: FILE: drivers/firmware/efi/efi.c:389:
> +               md = early_memremap(p, sizeof (*md), BOOT_DATA);
> 
> Please integrate checkpatch.pl into your workflow so that you can catch
> small style nits like this. And don't take its output too seriously... :-)

I did run checkpatch against everything, but was always under the
assumption that I shouldn't change existing warnings/errors like this.
If it's considered ok since I'm touching that line of code then I'll
take care of those situations.

Thanks,
Tom

> 
>>  		if (!md) {
>>  			pr_err_once("early_memremap(%pa, %zu) failed.\n",
>>  				    &p, sizeof (*md));
>> @@ -501,7 +501,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>>  	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
>>  		efi_properties_table_t *tbl;
>>  
>> -		tbl = early_memremap(efi.properties_table, sizeof(*tbl));
>> +		tbl = early_memremap(efi.properties_table, sizeof(*tbl),
>> +				     BOOT_DATA);
>>  		if (tbl == NULL) {
>>  			pr_err("Could not map Properties table!\n");
>>  			return -ENOMEM;
