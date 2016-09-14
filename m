From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v2 15/20] iommu/amd: AMD IOMMU support for memory
	encryption
Date: Wed, 14 Sep 2016 08:45:44 -0500
Message-ID: <27bc5c87-3a74-a1ee-55b1-7f19ec9cd6cc@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
	<20160822223820.29880.17752.stgit@tlendack-t1.amdoffice.net>
	<20160912114550.nwhtpmncwp22l7vy@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160912114550.nwhtpmncwp22l7vy-fF5Pk5pvG8Y@public.gmane.org>
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

On 09/12/2016 06:45 AM, Borislav Petkov wrote:
> On Mon, Aug 22, 2016 at 05:38:20PM -0500, Tom Lendacky wrote:
>> Add support to the AMD IOMMU driver to set the memory encryption mask if
>> memory encryption is enabled.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/include/asm/mem_encrypt.h |    2 ++
>>  arch/x86/mm/mem_encrypt.c          |    5 +++++
>>  drivers/iommu/amd_iommu.c          |   10 ++++++++++
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
>> index 384fdfb..e395729 100644
>> --- a/arch/x86/include/asm/mem_encrypt.h
>> +++ b/arch/x86/include/asm/mem_encrypt.h
>> @@ -36,6 +36,8 @@ void __init sme_early_init(void);
>>  /* Architecture __weak replacement functions */
>>  void __init mem_encrypt_init(void);
>>  
>> +unsigned long amd_iommu_get_me_mask(void);
>> +
>>  unsigned long swiotlb_get_me_mask(void);
>>  void swiotlb_set_mem_dec(void *vaddr, unsigned long size);
>>  
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 6b2e8bf..2f28d87 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -185,6 +185,11 @@ void __init mem_encrypt_init(void)
>>  	swiotlb_clear_encryption();
>>  }
>>  
>> +unsigned long amd_iommu_get_me_mask(void)
>> +{
>> +	return sme_me_mask;
>> +}
>> +
>>  unsigned long swiotlb_get_me_mask(void)
>>  {
>>  	return sme_me_mask;
>> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
>> index 96de97a..63995e3 100644
>> --- a/drivers/iommu/amd_iommu.c
>> +++ b/drivers/iommu/amd_iommu.c
>> @@ -166,6 +166,15 @@ struct dma_ops_domain {
>>  static struct iova_domain reserved_iova_ranges;
>>  static struct lock_class_key reserved_rbtree_key;
>>  
>> +/*
>> + * Support for memory encryption. If memory encryption is supported, then an
>> + * override to this function will be provided.
>> + */
>> +unsigned long __weak amd_iommu_get_me_mask(void)
>> +{
>> +	return 0;
>> +}
> 
> So instead of adding a function each time which returns sme_me_mask
> for each user it has, why don't you add a single function which
> returns sme_me_mask in mem_encrypt.c and add an inline in the header
> mem_encrypt.h which returns 0 for the !CONFIG_AMD_MEM_ENCRYPT case.

Currently, mem_encrypt.h only lives in the arch/x86 directory so it
wouldn't be able to be included here without breaking other archs.

> 
> This all is still funny because we access sme_me_mask directly for the
> different KERNEL_* masks but then you're adding an accessor function.

Because this lives outside of the arch/x86 I need to use the weak
function.

> 
> So what you should do instead, IMHO, is either hide sme_me_mask
> altogether and use the accessor functions only (not sure if that would
> work in all cases) or expose sme_me_mask unconditionally and have it be
> 0 if CONFIG_AMD_MEM_ENCRYPT is not enabled so that it just works.
> 
> Or is there a third, more graceful variant?

Is there a better way to do this given the support is only in x86?

Thanks,
Tom

> 
