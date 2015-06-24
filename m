From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: compatability with older versions of UEFI
Date: Wed, 24 Jun 2015 12:50:16 -0700
Message-ID: <558B09F8.4060706@codeaurora.org>
References: <20150623170534.GA21341@agluck-desk.sc.intel.com> <558AF115.8020909@codeaurora.org> <3908561D78D1C84285E8C5FCA982C28F32A9FB7C@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32A9FB7C-8oqHQFITsIE64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, "harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 6/24/2015 12:14 PM, Luck, Tony wrote:
>> Another option would be to have 2 structs, the first one
>> "struct cper_sec_mem_err" holds the structure as defined by UEFI
>> 2.1, the 2nd one "struct cper_sec_mem_err_24_ext" holds the 4
>> elements added in UEFI 2.3.1.
>
> Reading some more of the UEFI 2.5 spec ... I see we are in for a world of pain
> here.
>
> 2.5 adds some small tweaks to the memory structure (adding a couple of extra
> bits to the "row" entry that can be grabbed from the formerly reserved byte
> at offset 73).
I think this can be dealt with easily as long as all platforms observe
the rule that if a bit is reserved, the bit should be set a '0' instead
of being set randomly. Is this a fair assumption on all platforms?

> But then there is a whole new GUID for a "Memory Error Section 2"
> which has doubled the width of the device, row, column, rank, and bit_pos fields
> together with adding two new fields for chip_id and status.  This will be painful
> because we hardwired the old sizes into extlog_mem_event in <ras/ras_event.h>
The old size is encoded in "stuct cper_mem_err_compact", other members
of the trace data are the same between "Memory Error Section" and
"Memory Error Section 2". One option we have without having to disturb
user space handler of memory error trace data would be to change
"struct cper_mem_err_compact" so the affected elements are of
__u32 instead of __u16. Drawback of this option is that the trace
buffer will be unnecessarily bigger if a platform generates
"Memory Error Section" data instead of "Memory Error Section 2" data.
Such drawback is not a big issue given that uncorrected memory error
happens infrequently and corrected memory error should be grouped
by platform.

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
