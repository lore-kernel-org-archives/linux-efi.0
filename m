From: "Arend van Spriel" <arend-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: access efi variables
Date: Fri, 13 Sep 2013 17:37:29 +0200
Message-ID: <52333139.6020203@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I need to obtain a uefi variable so I went looking at the API in 
include/linux/efi.h. I found the following definition:

/*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
  * space in each part of the structure,
  * and we use a page for reading/writing.
  */

struct efi_variable {
	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
	efi_guid_t    VendorGuid;
	unsigned long DataSize;
	__u8          Data[1024];
	efi_status_t  Status;
	__u32         Attributes;
} __attribute__((packed));

But according to the specs the variable I need to obtain is 2k bytes. 
Should I expect trouble :-p

Regards,
Arend
