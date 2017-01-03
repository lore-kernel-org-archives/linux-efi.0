From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/10] efi: Constify GetVariable() / SetVariable()
 arguments
Date: Tue, 3 Jan 2017 13:25:37 -0500
Message-ID: <f5a32d9c-8d42-cbac-ff78-b2557416863d@intel.com>
References: <cover.1483318593.git.lukas@wunner.de>
 <2be92e87ff7855bcd88c86a7436f46d3488483f0.1483318593.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2be92e87ff7855bcd88c86a7436f46d3488483f0.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Artur Paszkiewicz <artur.paszkiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For the hfi1 bits below:

Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 01/02/2017 05:24 AM, Lukas Wunner wrote:
> iff --git a/drivers/infiniband/hw/hfi1/efivar.c b/drivers/infiniband/hw/hfi1/efivar.c
> index 106349f..f769cc2 100644
> --- a/drivers/infiniband/hw/hfi1/efivar.c
> +++ b/drivers/infiniband/hw/hfi1/efivar.c
> @@ -66,7 +66,6 @@ static int read_efi_var(const char *name, unsigned long *size,
>  {
>  	efi_status_t status;
>  	efi_char16_t *uni_name;
> -	efi_guid_t guid;
>  	unsigned long temp_size;
>  	void *temp_buffer;
>  	void *data;
> @@ -95,13 +94,10 @@ static int read_efi_var(const char *name, unsigned long *size,
>  	for (i = 0; name[i]; i++)
>  		uni_name[i] = name[i];
>
> -	/* need a variable for our GUID */
> -	guid = HFI1_EFIVAR_GUID;
> -
>  	/* call into EFI runtime services */
>  	status = efi.get_variable(
>  			uni_name,
> -			&guid,
> +			&HFI1_EFIVAR_GUID,
>  			NULL,
>  			&temp_size,
>  			temp_buffer);
