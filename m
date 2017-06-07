From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V17 08/11] efi: print unrecognized CPER section
Date: Wed, 7 Jun 2017 10:08:13 +0000
Message-ID: <CAKv+Gu8DjAnd5SSPchZnL+ZAK_MckgCveC8K3gVHbQy4zCnhbA@mail.gmail.com>
References: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
 <1495225933-4410-9-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1495225933-4410-9-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Robert Moore <robert.moore@intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Lv Zheng <lv.zheng@intel.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Fu Wei <fu.wei@linaro.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Russell King <linux@armlinux.org.uk>, gengdongjiu@huawei.com, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, eun.taik.lee@samsung.com, shijie.huang@arm.com, Laura Abbott <labbott@redhat.com>, Len Brown <lenb@kernel.org>, harba@codeaurora.org, John Garry <john.garry@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawa>
List-Id: linux-efi@vger.kernel.org

On 19 May 2017 at 21:32, Tyler Baicar <tbaicar@codeaurora.org> wrote:
> UEFI spec allows for non-standard section in Common Platform Error
> Record. This is defined in section N.2.3 of UEFI version 2.5.
>
> Currently if the CPER section's type (UUID) does not match with
> one of the section types that the kernel knows how to parse, the
> section is skipped. Therefore, user is not able to see
> such CPER data, for instance, error record of non-standard section.
>
> This change prints out the raw data in hex in the dmesg buffer so
> that non-standard sections are reported to the user. Non-standard
> section type errors should be reported to the user because these
> can include errors which are vendor specific. The data length is
> taken from Error Data length field of Generic Error Data Entry.
>
> The following is a sample output from dmesg:
>  Hardware error from APEI Generic Hardware Error Source: 2
>  It has been corrected by h/w and requires no further action
>  event severity: corrected
>   time: precise 2017-03-15 20:37:35
>   Error 0, type: corrected
>    section type: unknown, d2e2621c-f936-468d-0d84-15a4ed015c8b
>    section length: 0x238
>    00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
>    00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
>    00000020: 00000000 00000000 00000000 00000000  ................
>    00000030: 00000000 00000000 01010000 01010000  ................
>    00000040: 00000000 00000000 00000005 00000000  ................
>    00000050: 01010000 00000000 00000001 00dddd00  ................
> ...
>
> The raw data from the error can then be decoded using vendor
> specific tools.
>
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Reviewed-by: James Morse <james.morse@arm.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/cper.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index eac0854..d5a5855 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -585,8 +585,15 @@ static void cper_print_tstamp(const char *pfx,
>                 else
>                         goto err_section_too_small;
>  #endif
> -       } else
> -               printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
> +       } else {
> +               const void *err = acpi_hest_get_payload(gdata);
> +
> +               printk("%ssection type: unknown, %pUl\n", newpfx, sec_type);
> +               printk("%ssection length: %#x\n", newpfx,
> +                      gdata->error_data_length);
> +               print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4, err,
> +                              gdata->error_data_length, true);
> +       }
>
>         return;
>
> --
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
