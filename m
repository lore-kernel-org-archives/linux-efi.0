From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v6 6/8] efi: load SSTDs from EFI variables
Date: Wed, 6 Jul 2016 12:58:27 +0100
Message-ID: <20160706115827.GR8415@codeblueprint.co.uk>
References: <1467713392-24825-1-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467713392-24825-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com, geert@linux-m68k.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Jul, at 01:09:52PM, Octavian Purdila wrote:
> This patch allows SSDTs to be loaded from EFI variables. It works by
> specifying the EFI variable name containing the SSDT to be loaded. All
> variables with the same name (regardless of the vendor GUID) will be
> loaded.
> 
> Note that we can't use acpi_install_table and we must rely on the
> dynamic ACPI table loading and bus re-scanning mechanisms. That is
> because I2C/SPI controllers are initialized earlier then the EFI
> subsystems and all I2C/SPI ACPI devices are enumerated when the
> I2C/SPI controllers are initialized.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
> 
> As the rest of the series remains unchanged and it got Acks from most
> of the other patches, I've resend only this patch. Rafael, please let
> me know if you prefer to resend the whole series.
> 
> Changes from v5:
> 
> * enable duplicate detection to avoid firmware bugs that returns the
> same variable over and over again; this requires pushing the entry
> allocation back into efivar_ssdt_iter() and creating a temporary list
> that is iterated over in efivar_ssdt_load()
> 
> * marked efivar_ssdt with __initdata
> 
> 
>  Documentation/acpi/ssdt-overlays.txt | 67 +++++++++++++++++++++++++
>  Documentation/kernel-parameters.txt  |  7 +++
>  drivers/firmware/efi/efi.c           | 96 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 170 insertions(+)

Looks fine to me. Thanks Octavian.

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
