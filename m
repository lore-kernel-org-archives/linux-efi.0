From: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: access efi variables
Date: Fri, 13 Sep 2013 18:39:26 +0200
Message-ID: <52333FBE.2080206@broadcom.com>
References: <52333139.6020203@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52333139.6020203@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 09/13/2013 05:37 PM, Arend van Spriel wrote:
> I need to obtain a uefi variable so I went looking at the API in
> include/linux/efi.h. I found the following definition:
>
> /*
>   * The maximum size of VariableName + Data = 1024
>   * Therefore, it's reasonable to save that much
>   * space in each part of the structure,
>   * and we use a page for reading/writing.
>   */
>
> struct efi_variable {
>      efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
>      efi_guid_t    VendorGuid;
>      unsigned long DataSize;
>      __u8          Data[1024];
>      efi_status_t  Status;
>      __u32         Attributes;
> } __attribute__((packed));
>
> But according to the specs the variable I need to obtain is 2k bytes.

Maybe clarify that "the specs" is basically the feature information I 
received internally here.

> Should I expect trouble :-p
>
> Regards,
> Arend
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
