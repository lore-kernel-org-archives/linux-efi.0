From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 14/34] x86/mm: Insure that boot memory areas are mapped
	properly
Date: Mon, 12 Jun 2017 08:31:58 -0500
Message-ID: <64d7cb4e-64fe-0882-ad17-fc3918c3a09a@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191539.28645.70161.stgit@tlendack-t1.amdoffice.net>
	<20170610160119.bnx5ir5dj3i27igx@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170610160119.bnx5ir5dj3i27igx-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
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
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst>
List-Id: linux-efi@vger.kernel.org

On 6/10/2017 11:01 AM, Borislav Petkov wrote:
> On Wed, Jun 07, 2017 at 02:15:39PM -0500, Tom Lendacky wrote:
>> The boot data and command line data are present in memory in a decrypted
>> state and are copied early in the boot process.  The early page fault
>> support will map these areas as encrypted, so before attempting to copy
>> them, add decrypted mappings so the data is accessed properly when copied.
>>
>> For the initrd, encrypt this data in place. Since the future mapping of the
>> initrd area will be mapped as encrypted the data will be accessed properly.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>   arch/x86/include/asm/mem_encrypt.h |   11 +++++
>>   arch/x86/include/asm/pgtable.h     |    3 +
>>   arch/x86/kernel/head64.c           |   30 ++++++++++++--
>>   arch/x86/kernel/setup.c            |    9 ++++
>>   arch/x86/mm/mem_encrypt.c          |   77 ++++++++++++++++++++++++++++++++++++
>>   5 files changed, 126 insertions(+), 4 deletions(-)
> 
> Some cleanups ontop in case you get to send v7:

There will be a v7.

> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 61a704945294..5959a42dd4d5 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -45,13 +45,8 @@ static inline void __init sme_early_decrypt(resource_size_t paddr,
>   {
>   }
>   
> -static inline void __init sme_map_bootdata(char *real_mode_data)
> -{
> -}
> -
> -static inline void __init sme_unmap_bootdata(char *real_mode_data)
> -{
> -}
> +static inline void __init sme_map_bootdata(char *real_mode_data)	{ }
> +static inline void __init sme_unmap_bootdata(char *real_mode_data)	{ }
>   
>   static inline void __init sme_early_init(void)
>   {
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 2321f05045e5..32ebbe0ab04d 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -132,6 +132,10 @@ static void __init __sme_map_unmap_bootdata(char *real_mode_data, bool map)
>   	struct boot_params *boot_data;
>   	unsigned long cmdline_paddr;
>   
> +	/* If SME is not active, the bootdata is in the correct state */
> +	if (!sme_active())
> +		return;
> +
>   	__sme_early_map_unmap_mem(real_mode_data, sizeof(boot_params), map);
>   	boot_data = (struct boot_params *)real_mode_data;
>   
> @@ -142,40 +146,22 @@ static void __init __sme_map_unmap_bootdata(char *real_mode_data, bool map)
>   	cmdline_paddr = boot_data->hdr.cmd_line_ptr |
>   			((u64)boot_data->ext_cmd_line_ptr << 32);
>   
> -	if (cmdline_paddr)
> -		__sme_early_map_unmap_mem(__va(cmdline_paddr),
> -					  COMMAND_LINE_SIZE, map);
> +	if (!cmdline_paddr)
> +		return;
> +
> +	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, map);
> +
> +	sme_early_pgtable_flush();

Yup, overall it definitely simplifies things.

I have to call sme_early_pgtable_flush() even if cmdline_paddr is NULL,
so I'll either keep the if and have one flush at the end or I can move
the flush into __sme_early_map_unmap_mem(). I'm leaning towards the
latter.

Thanks,
Tom

>   }
>   
>   void __init sme_unmap_bootdata(char *real_mode_data)
>   {
> -	/* If SME is not active, the bootdata is in the correct state */
> -	if (!sme_active())
> -		return;
> -
> -	/*
> -	 * The bootdata and command line aren't needed anymore so clear
> -	 * any mapping of them.
> -	 */
>   	__sme_map_unmap_bootdata(real_mode_data, false);
> -
> -	sme_early_pgtable_flush();
>   }
>   
>   void __init sme_map_bootdata(char *real_mode_data)
>   {
> -	/* If SME is not active, the bootdata is in the correct state */
> -	if (!sme_active())
> -		return;
> -
> -	/*
> -	 * The bootdata and command line will not be encrypted, so they
> -	 * need to be mapped as decrypted memory so they can be copied
> -	 * properly.
> -	 */
>   	__sme_map_unmap_bootdata(real_mode_data, true);
> -
> -	sme_early_pgtable_flush();
>   }
>   
>   void __init sme_early_init(void)
> 
