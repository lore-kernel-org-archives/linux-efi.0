From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: dmi: List SMBIOS3 table before SMBIOS table
Date: Thu, 30 Apr 2015 17:04:01 +0100
Message-ID: <20150430160401.GF3014@codeblueprint.co.uk>
References: <20150430152305.26b89bd3@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150430152305.26b89bd3-R0o5gVi9kd7kN2dkZ6Wm7A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Apr, at 03:23:05PM, Jean Delvare wrote:
> The SMBIOS3 table should appear before the SMBIOS table in
> /sys/firmware/efi/systab. This allows user-space utilities which
> support both to pick the SMBIOS3 table with a single pass on systems
> where both are implemented. The SMBIOS3 entry point is more capable
> than the SMBIOS entry point so it should be preferred.
> 
> This follows the same logic as the ACPI20 table being listed before
> the ACPI table.
> 
> Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v1:
>  * Added a comment explaining why SMBIOS3 must be listed before SMBIOS,
>    so that it doesn't get accidentally broken in the future.
> 
>  drivers/firmware/efi/efi.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Thanks Jean. This looks OK to me but I'd really like to see some ACKs
from Leif, Ard or Ivan.

-- 
Matt Fleming, Intel Open Source Technology Center
