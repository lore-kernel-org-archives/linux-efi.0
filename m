From: Tim Gardner <rtg.canonical@gmail.com>
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
Date: Fri, 04 Jan 2013 08:08:54 -0700
Message-ID: <50E6F086.5020209@gmail.com>
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org> <1357219085-4312-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357219085-4312-2-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Steve Langasek <steve.langasek@canonical.com>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>, Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>, David Airlie <airlied@linux.ie>, Corentin Chary <corentincj@iksaif.net>, Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, tim.gardner@canonical.com
List-Id: linux-efi@vger.kernel.org

On 01/03/2013 06:18 AM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 

snip

>  /*
> - * We play games with efi_enabled so that the compiler will, if possible, remove
> - * EFI-related code altogether.
> + * We play games with efi_enabled so that the compiler will, if
> + * possible, remove EFI-related code altogether.
>   */
> +#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
> +#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system tables? */
> +#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config tables? */
> +#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime services? */
> +#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
> +#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
> +

Your use of test_bit() and set_bit() imply that these macros should be
bit numbers, not bit masks. It'll work until you define a mask with an
integer value greater then 31.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
