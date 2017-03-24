From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] efi/capsule: Add support for Quark security header
Date: Fri, 24 Mar 2017 17:44:34 +0100
Message-ID: <a7e8db47-2ea7-bae4-ef4d-59d352286175@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <47e493c47aa79b68be52f743ac1790fddab22938.1487182480.git.jan.kiszka@siemens.com>
 <9949ecad-4b73-cccc-7e66-0afe0d2f4087@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9949ecad-4b73-cccc-7e66-0afe0d2f4087-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(restarting this topic, new patches are in the make)

On 2017-02-17 02:30, Bryan O'Donoghue wrote:
> 
> 
> On 15/02/17 18:14, Jan Kiszka wrote:
>> The firmware for Quark X102x prepends a security header to the capsule
>> which is needed to support the mandatory secure boot on this processor.
>> The header can be detected by checking for the "_CSH" signature and -
>> to avoid any GUID conflict - validating its size field to contain the
>> expected value. Then we need to look for the EFI header right after the
>> security header and pass the image offset to efi_capsule_update while
>> keeping the whole image in RAM - the firmware will look for the header
>> on its own.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  drivers/firmware/efi/capsule-loader.c | 73
>> ++++++++++++++++++++++++++++++-----
>>  1 file changed, 63 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/capsule-loader.c
>> b/drivers/firmware/efi/capsule-loader.c
>> index 63ceca9..571d931 100644
>> --- a/drivers/firmware/efi/capsule-loader.c
>> +++ b/drivers/firmware/efi/capsule-loader.c
>> @@ -26,10 +26,32 @@ struct capsule_info {
>>      long        index;
>>      size_t        count;
>>      size_t        total_size;
>> +    unsigned int    efi_hdr_offset;
>>      struct page    **pages;
>>      size_t        page_bytes_remain;
>>  };
>>
>> +#define QUARK_CSH_SIGNATURE        0x5f435348    /* _CSH */
>> +#define QUARK_SECURITY_HEADER_SIZE    0x400
>> +
>> +struct efi_quark_security_header {
>> +    u32 csh_signature;
>> +    u32 version;
>> +    u32 modulesize;
>> +    u32 security_version_number_index;
>> +    u32 security_version_number;
>> +    u32 rsvd_module_id;
>> +    u32 rsvd_module_vendor;
>> +    u32 rsvd_date;
>> +    u32 headersize;
>> +    u32 hash_algo;
>> +    u32 cryp_algo;
>> +    u32 keysize;
>> +    u32 signaturesize;
>> +    u32 rsvd_next_header;
>> +    u32 rsvd[2];
>> +};
> 
> This is a real nitpick (sorry) - but it'd be nice to have a document
> reference or a link to describe this header i.e. it is officially
> documented - outside of the UEFI specification. Make life easy for
> someone reading this header and make an document reference.
> 
> Also it'd be appreciated if you could describe the format of the
> structure with
> 
> @member    member-attribute description

Done.

> 
>> +
>>  /**
>>   * efi_free_all_buff_pages - free all previous allocated buffer pages
>>   * @cap_info: pointer to current instance of capsule_info structure
>> @@ -56,18 +78,46 @@ static void efi_free_all_buff_pages(struct
>> capsule_info *cap_info)
>>  static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
>>                        void *kbuff, size_t hdr_bytes)
>>  {
>> +    struct efi_quark_security_header *quark_hdr;
>>      efi_capsule_header_t *cap_hdr;
>>      size_t pages_needed;
>>      int ret;
>>      void *temp_page;
>>
>> -    /* Only process data block that is larger than efi header size */
>> -    if (hdr_bytes < sizeof(efi_capsule_header_t))
>> +    /* Only process data block that is larger than the security header
>> +     * (which is larger than the EFI header) */
>> +    if (hdr_bytes < sizeof(struct efi_quark_security_header))
>>          return 0;
>>
>>      /* Reset back to the correct offset of header */
>>      cap_hdr = kbuff - cap_info->count;
>> -    pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
>> +
>> +    quark_hdr = (struct efi_quark_security_header *)cap_hdr;
>> +
>> +    if (quark_hdr->csh_signature == QUARK_CSH_SIGNATURE &&
>> +        quark_hdr->headersize == QUARK_SECURITY_HEADER_SIZE) {
>> +        /* Only process data block if EFI header is included */
>> +        if (hdr_bytes < QUARK_SECURITY_HEADER_SIZE +
>> +                sizeof(efi_capsule_header_t))
>> +            return 0;
> 
> At this point if cap_info->header_obtained == false then this is an
> error - you should be barfing on this - not literally barfing - at least
> not on your keyboard :)
> 
> return -ETHISHEADERSUCKS or some other sensible value -EINVAL like you
> have below.
> 
> Point being you've validated the signature, the header size and
> cap_info->header_obtained is false then you definitely have a bogus
> capsule..

Nope: efi_capsule_setup_info is called whenever the user wrote some bits
to the device, not necessarily enough to evaluate all the headers. We
need to return 0 here (and not set header_obtained) until we find enough
data to declare the capsule valid or broken.

> 
> 
>> +
>> +        pr_debug("%s: Quark security header detected\n", __func__);
> 
> ... and %s __func__ is verboten don't do it. actually there's a bunch of
> those pairs all over this code - if you have the time in a supplementary
> patch please kill them - there must be a a dev pointer we can get at
> somewhere that makes sense to use dev_dbg- if not those __func__
> parameters still need to go away - please kill them.

I've written some cleanup patches for this module and refrain from
adding my own mess.

> 
>> +
>> +        if (quark_hdr->rsvd_next_header != 0) {
>> +            pr_err("%s: multiple security headers not supported\n",
>> +                   __func__);
>> +            return -EINVAL;
>> +        }
> 
> 
>> +
>> +        cap_hdr = (void *)cap_hdr + quark_hdr->headersize;
> 
> You could have a separate void * variable and not have the cast.
> 

Done.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
