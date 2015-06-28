From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: compatability with older versions of UEFI
Date: Sun, 28 Jun 2015 15:29:09 +0100
Message-ID: <20150628142909.GA28334@codeblueprint.co.uk>
References: <20150623170534.GA21341@agluck-desk.sc.intel.com>
 <558AF115.8020909@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <558AF115.8020909-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 24 Jun, at 11:04:05AM, Zhang, Jonathan Zhixiong wrote:
> Another option would be to have 2 structs, the first one
> "struct cper_sec_mem_err" holds the structure as defined by UEFI
> 2.1, the 2nd one "struct cper_sec_mem_err_24_ext" holds the 4
> elements added in UEFI 2.3.1.

Yes, this is traditionally how we've handled this issue in other parts
of the kernel that deal with UEFI/ACPI.

-- 
Matt Fleming, Intel Open Source Technology Center
