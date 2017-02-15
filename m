From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH V10 07/10] efi: print unrecognized CPER section
Date: Wed, 15 Feb 2017 12:07:03 -0800
Message-ID: <1487189223.6214.60.camel@perches.com>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
         <1487188282-2568-8-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487188282-2568-8-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vge
List-Id: linux-efi@vger.kernel.org

On Wed, 2017-02-15 at 12:51 -0700, Tyler Baicar wrote:
> UEFI spec allows for non-standard section in Common Platform Error
> Record. This is defined in section N.2.3 of UEFI version 2.5.
> 
> Currently if the CPER section's type (UUID) does not match with
> one of the section types that the kernel knows how to parse, the
> section is skipped. Therefore, user is not able to see
> such CPER data, for instance, error record of non-standard section.
> 
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
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> ---
>  drivers/firmware/efi/cper.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index c2b0a12..48cb8ee 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -591,8 +591,16 @@ static void cper_estatus_print_section(
>  			cper_print_proc_arm(newpfx, arm_err);
>  		else
>  			goto err_section_too_small;
> -	} else
> -		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
> +	} else {
> +		const void *unknown_err;
> +
> +		unknown_err = acpi_hest_generic_data_payload(gdata);
> +		printk("%ssection type: %pUl\n", newpfx, sec_type);
> +		printk("%ssection length: %d\n", newpfx,
> +		       gdata->error_data_length);
> +		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
> +			       unknown_err, gdata->error_data_length, 0);

I suggest using true instead of 0 for the last argument

		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
			       unknown_err, gdata->error_data_length, true);

It might help make deciphering the hex block a little easier.
