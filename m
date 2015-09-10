From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 1/2] efi: print unrecognized CPER section
Date: Thu, 10 Sep 2015 20:27:15 +0200
Message-ID: <20150910182715.GB10457@pd.tnic>
References: <1441747761-12012-1-git-send-email-zjzhang@codeaurora.org>
 <1441747761-12012-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441747761-12012-2-git-send-email-zjzhang@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Cc: Matt Fleming <matt.fleming@intel.com>, tony.luck@intel.com, fu.wei@linaro.org, al.stone@linaro.org, rjw@rjwysocki.net, mchehab@osg.samsung.com, mingo@redhat.com, gong.chen@linux.intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org, linux-acpi@vger.kernel.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 08, 2015 at 02:29:20PM -0700, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
> 
> UEFI spec allows for non-standard section in Common Platform Error
> Record. This is defined in section N.2.3 of UEFI version 2.5.
> 
> Currently if the CPER section's type (UUID) does not match with
> one of the section types that the kernel knows how to parse, the
> section is skipped. Therefore, user is not able to see
> such CPER data, for instace, error record of non-standard section.

instace?

Introduce a spellchecker into your workflow, pls.

> For above mentioned case, this change prints out the raw data in
> hex in dmesg buffer. Data length is taken from Error Data length
> field of Generic Error Data Entry.
> 
> Following is a sample output from dmesg:
> [  115.771702] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
> [  115.779042] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
> [  115.787456] {1}[Hardware Error]: event severity: corrected
> [  115.792927] {1}[Hardware Error]:  Error 0, type: corrected
> [  115.798415] {1}[Hardware Error]:  fru_id: 00000000-0000-0000-0000-000000000000
> [  115.805596] {1}[Hardware Error]:  fru_text:
> [  115.816105] {1}[Hardware Error]:  section type: d2e2621c-f936-468d-0d84-15a4ed015c8b
> [  115.823880] {1}[Hardware Error]:  section length: 88
> [  115.828779] {1}[Hardware Error]:   00000000: 01000001 00000002 5f434345 525f4543
> [  115.836153] {1}[Hardware Error]:   00000010: 0000574d 00000000 00000000 00000000
> [  115.843531] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000
> [  115.850908] {1}[Hardware Error]:   00000030: 00000000 00000000 00000000 00000000
> [  115.858288] {1}[Hardware Error]:   00000040: fe800000 00000000 00000004 5f434345
> [  115.865665] {1}[Hardware Error]:   00000050: 525f4543 0000574d
> 
> Change-Id: I663a6e3ae6dcf68e4e389f76d555e9106ffee165

As already noted, no internal cset IDs or whatever other markup.

> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> ---
>  drivers/firmware/efi/cper.c | 39 +++++++++++++++++++++++++++++++--------
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index d42537425438..8a58b2927408 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -32,12 +32,31 @@
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/aer.h>
> +#include <linux/printk.h>
>  
>  #define INDENT_SP	" "
>  
> +#define ROW_SIZE 16
> +#define GROUP_SIZE 4
> +
>  static char rcd_decode_str[CPER_REC_LEN];
>  
>  /*
> + * cper_print_hex - print hex from a CPER data buffer
> + * @pfx: prefix for each line, including log level and prefix string

Why?

First argument of print_hex_dump() is @level and second is @prefix_str.
But you're calling print_hex_dump() with "" as a second arg...

> + * @buf: buffer pointer
> + * @len: size of buffer
> + *
> + * print_hex_dump() expects log level and prefix string to be passed
> + * in two different paramters. Internally it concatenates them. In
> + * our case, those two are already concatenated in pfx.

This doesn't make any sense, why?

And WTH are you defining a macro for, to use exactly *once*?! Why can't
you simply use print_hex_dump() like normal kids would do? Same with
those ROW_SIZE and GROUP_SIZE defines... Kill them. Kill it all.

> + */
> +#define cper_print_hex(pfx, buf, len)				\
> +	print_hex_dump(pfx, "",					\
> +		DUMP_PREFIX_OFFSET, ROW_SIZE, GROUP_SIZE,	\
> +		buf, len, 0)
> +
> +/*
>   * CPER record ID need to be unique even after reboot, because record
>   * ID is used as index for ERST storage, while CPER records from
>   * multiple boot may co-exist in ERST.
> @@ -392,7 +411,9 @@ static void cper_estatus_print_section(
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
>  	char newpfx[64];
> +	u32 len;
>  
> +	len = gdata->error_data_length;

This and the changes it brings with it are unrelated to this patch -
needs to be a separate patch.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
