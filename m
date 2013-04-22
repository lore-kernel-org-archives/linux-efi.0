From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH V6 2/3] efi: Pass boot services variable info to runtime
 code
Date: Mon, 22 Apr 2013 17:03:26 +0200
Message-ID: <1366643006.3251.14.camel@x61.thuisdomein>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-3-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366056587-24414-3-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-04-15 at 13:09 -0700, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot ser=
vices.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the r=
esults
> from QueryVariableInfo() to the space used by all of our variables, b=
ut
> that fails if the platform doesn't garbage collect on every boot. Tha=
nkfully,
> calling QueryVariableInfo() while still inside boot services gives a =
more
> reliable answer. This patch passes that information from the EFI boot=
 stub
> up to the efi platform code.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

This seems to be the patch that has become commit
cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f ("efi: Pass boot services
variable info to runtime code"), which is part of v3.9-rc8.

It triggers this GCC warning (on Fedora 17, 32 bit):
    arch/x86/boot/compressed/eboot.c: In function =E2=80=98setup_efi_va=
rs=E2=80=99:
    arch/x86/boot/compressed/eboot.c:269:2: warning: passing argument 1=
 of =E2=80=98efi_call_phys=E2=80=99 makes pointer from integer without =
a cast [enabled by default]
    In file included from arch/x86/boot/compressed/eboot.c:12:0:
    [...]/arch/x86/include/asm/efi.h:8:33: note: expected =E2=80=98void=
 *=E2=80=99 but argument is of type =E2=80=98long unsigned int=E2=80=99

> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -251,6 +251,51 @@ static void find_bits(unsigned long mask, u8 *po=
s, u8 *size)
>  	*size =3D len;
>  }
> =20
> +static efi_status_t setup_efi_vars(struct boot_params *params)
> +{
> +	struct setup_data *data;
> +	struct efi_var_bootdata *efidata;
> +	u64 store_size, remaining_size, var_size;
> +	efi_status_t status;
> +
> +	if (!sys_table->runtime->query_variable_info)
> +		return EFI_UNSUPPORTED;
> +
> +	data =3D (struct setup_data *)(unsigned long)params->hdr.setup_data=
;
> +
> +	while (data && data->next)
> +		data =3D (struct setup_data *)(unsigned long)data->next;
> +
> +	status =3D efi_call_phys4(sys_table->runtime->query_variable_info,

Casting to void * here makes the warning go away. But the code is
sufficiently complicated (for me) to make it unobvious whether that is
the right thing to do. Besides, I don't think I have hardware to test
this.

> +				EFI_VARIABLE_NON_VOLATILE |
> +				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> +				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> +				&remaining_size, &var_size);
> +
> +	if (status !=3D EFI_SUCCESS)
> +		return status;
> +
> +	status =3D efi_call_phys3(sys_table->boottime->allocate_pool,
> +				EFI_LOADER_DATA, sizeof(*efidata), &efidata);
> +
> +	if (status !=3D EFI_SUCCESS)
> +		return status;
> +
> +	efidata->data.type =3D SETUP_EFI_VARS;
> +	efidata->data.len =3D sizeof(struct efi_var_bootdata) -
> +		sizeof(struct setup_data);
> +	efidata->data.next =3D 0;
> +	efidata->store_size =3D store_size;
> +	efidata->remaining_size =3D remaining_size;
> +	efidata->max_var_size =3D var_size;
> +
> +	if (data)
> +		data->next =3D (unsigned long)efidata;
> +	else
> +		params->hdr.setup_data =3D (unsigned long)efidata;
> +
> +}
> +
>  static efi_status_t setup_efi_pci(struct boot_params *params)
>  {
>  	efi_pci_io_protocol *pci;


Paul Bolle
