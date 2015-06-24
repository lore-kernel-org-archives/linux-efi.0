From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: compatability with older versions of UEFI
Date: Wed, 24 Jun 2015 19:14:43 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32A9FB7C@ORSMSX114.amr.corp.intel.com>
References: <20150623170534.GA21341@agluck-desk.sc.intel.com>
 <558AF115.8020909@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558AF115.8020909-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Another option would be to have 2 structs, the first one
> "struct cper_sec_mem_err" holds the structure as defined by UEFI
> 2.1, the 2nd one "struct cper_sec_mem_err_24_ext" holds the 4
> elements added in UEFI 2.3.1.

Reading some more of the UEFI 2.5 spec ... I see we are in for a world of pain
here.

2.5 adds some small tweaks to the memory structure (adding a couple of extra
bits to the "row" entry that can be grabbed from the formerly reserved byte
at offset 73).  But then there is a whole new GUID for a "Memory Error Section 2"
which has doubled the width of the device, row, column, rank, and bit_pos fields
together with adding two new fields for chip_id and status.  This will be painful
because we hardwired the old sizes into extlog_mem_event in <ras/ras_event.h>

-Tony
