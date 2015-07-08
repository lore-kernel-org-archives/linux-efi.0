From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCHv2] efi: Handle memory error structures produced based on
 old versions of standard
Date: Wed, 8 Jul 2015 16:54:40 +0100
Message-ID: <20150708155440.GA5598@codeblueprint.co.uk>
References: <20150623170534.GA21341@agluck-desk.sc.intel.com>
 <558AF115.8020909@codeaurora.org>
 <20150628142909.GA28334@codeblueprint.co.uk>
 <20150629182106.GA25924@agluck-desk.sc.intel.com>
 <20150630122244.GJ28334@codeblueprint.co.uk>
 <20150630225751.GA18060@agluck-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150630225751.GA18060-E6Nu+q68HHTI/KE9syI0vLvm/XP+8Wra@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 30 Jun, at 03:57:51PM, Luck, Tony wrote:
> The memory error record structure includes as its first field a
> bitmask of which subsequent fields are valid. The allows new fields
> to be added to the structure while keeping compatibility with older
> software that parses these records. This mechanism was used between
> versions 2.2 and 2.3 to add four new fields, growing the size of the
> structure from 73 bytes to 80. But Linux just added all the new
> fields so this test:
> 	if (gdata->error_data_length >= sizeof(*mem_err))
> 		cper_print_mem(newpfx, mem_err);
> 	else
> 		goto err_section_too_small;
> now make Linux complain about old format records being too short.
> 
> Add a definition for the old format of the structure and use that
> for the minimum size check. Pass the actual size to cper_print_mem()
> so it can sanity check the validation_bits field to ensure that if
> a BIOS using the old format sets bits as if it were new, we won't
> access fields beyond the end of the structure.
> 
> Signed-off-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> v1-v2: print FW_WARN if we see bogus validation bits from an old sized structure
> 
>  drivers/firmware/efi/cper.c | 15 ++++++++++++---
>  include/linux/cper.h        | 22 +++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 4 deletions(-)

Looks good to me Tony. Since this is essentially a bug fix, does it need
applying to stable?

-- 
Matt Fleming, Intel Open Source Technology Center
