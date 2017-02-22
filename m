From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v4 08/28] x86: Extend the early_memremap support with
	additional attrs
Date: Wed, 22 Feb 2017 09:42:02 -0600
Message-ID: <f9ff9b86-1b6e-d5e6-95f8-89892da52051@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154348.19244.11884.stgit@tlendack-t1.amdoffice.net>
	<20170220154354.ggb7yzpjotmbrd5a@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170220154354.ggb7yzpjotmbrd5a-fF5Pk5pvG8Y@public.gmane.org>
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

On 2/20/2017 9:43 AM, Borislav Petkov wrote:
> On Thu, Feb 16, 2017 at 09:43:48AM -0600, Tom Lendacky wrote:
>> Add to the early_memremap support to be able to specify encrypted and
>
> early_memremap()
>
> Please append "()" to function names in your commit messages text.
>
>> decrypted mappings with and without write-protection. The use of
>> write-protection is necessary when encrypting data "in place". The
>> write-protect attribute is considered cacheable for loads, but not
>> stores. This implies that the hardware will never give the core a
>> dirty line with this memtype.
>
> By "hardware will never give" you mean that WP writes won't land dirty
> in the cache but will go out to mem and when some other core needs them,
> they will have to come from memory?

I think this best explains it, from Table 7-8 of the APM Vol 2:

"Reads allocate cache lines on a cache miss, but only to the shared
state. All writes update main memory. Cache lines are not allocated
on a write miss. Write hits invalidate the cache line and update
main memory."

We're early enough that only the BSP is running and we don't have
to worry about accesses from other cores.  If this was to be used
outside of early boot processing, then some safeties might have to
be added.

>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/Kconfig                     |    4 +++
>>  arch/x86/include/asm/fixmap.h        |   13 ++++++++++
>>  arch/x86/include/asm/pgtable_types.h |    8 ++++++
>>  arch/x86/mm/ioremap.c                |   44 ++++++++++++++++++++++++++++++++++
>>  include/asm-generic/early_ioremap.h  |    2 ++
>>  mm/early_ioremap.c                   |   10 ++++++++
>>  6 files changed, 81 insertions(+)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index a3b8c71..581eae4 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1417,6 +1417,10 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>>  	  If set to N, then the encryption of system memory can be
>>  	  activated with the mem_encrypt=on command line option.
>>
>> +config ARCH_USE_MEMREMAP_PROT
>> +	def_bool y
>> +	depends on AMD_MEM_ENCRYPT
>
> Why do we need this?
>
> IOW, all those helpers below will end up being defined unconditionally,
> in practice. Think distro kernels. Then saving the couple of bytes is
> not really worth the overhead.

I added this because some other architectures use a u64 for the
protection value instead of an unsigned long (i386 for one) and it
was causing build errors/warnings on those archs. And trying to bring
in the header to use pgprot_t instead of an unsigned long caused a ton
of build issues. This seemed to be the simplest and least intrusive way
to approach the issue.

Thanks,
Tom

>
