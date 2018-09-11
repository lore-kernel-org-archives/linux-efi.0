From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH] x86/boot: get_acpi_srat_table() can be static
Date: Tue, 11 Sep 2018 16:55:25 +0800
Message-ID: <20180911085525.GF8519@localhost.localdomain>
References: <20180910124015.18073-2-fanc.fnst@cn.fujitsu.com>
 <20180911085226.GA25670@athens>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180911085226.GA25670@athens>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, douly.fnst@cn.fujitsu.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 11, 2018 at 04:52:26PM +0800, kbuild test robot wrote:
>
>Fixes: cc1a4e2a5474 ("x86/boot: Add acpitb.c to parse acpi tables")
>Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
>---
> acpitb.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
>index 66c5154..4ddd732 100644
>--- a/arch/x86/boot/compressed/acpitb.c
>+++ b/arch/x86/boot/compressed/acpitb.c
>@@ -279,7 +279,7 @@ static acpi_physical_address get_rsdp_addr(void)
> 	return pa;
> }
> 
>-struct acpi_table_header *get_acpi_srat_table(void)
>+static struct acpi_table_header *get_acpi_srat_table(void)

Good catch, will add it.

Thanks,
Chao Fan

> {
> 	char *args = (char *)get_cmd_line_ptr();
> 	acpi_physical_address acpi_table;
>
>
