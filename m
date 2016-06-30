From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] efi/libstub: Retry ExitBootServices if map key is
 invalid
Date: Thu, 30 Jun 2016 17:27:52 +0100
Message-ID: <20160630162751.GC29700@leverpostej>
References: <1467300933-3991-1-git-send-email-jhugo@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467300933-3991-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

[Adding Ard and Leif]

On Thu, Jun 30, 2016 at 09:35:33AM -0600, Jeff Hugo wrote:
> From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>=20
> There exists a race condition between when the efi stub grabs the mem=
ory
> map, and when ExitBootServices is called at which point the EFI can p=
rocess
> an event which causes the memory map to be invalidated.=20

=46or reference, do you have a particular example of such an event?

Do these events cause the memory map to grow?

> According to the UEFI spec, ExitBootServices will return
> EFI_INVALID_PARAMETER if this occurs, at which point the efi stub is
> expected to obtain the new memory map, and retry the call to
> ExitBootServices.
>=20
> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>=20
> I'm not particularly happy with the current state of this fix, but I =
feel like
> this issue is somewhat unsolvable.  Currently I've based this solutio=
n upon
> arch/x86/boot/compressed/eboot.c however it has two primary issues I'=
d like
> feedback upon-
>=20
> First issue-
> efi_get_memory_map() performs an allocation as it attempts to create =
a
> minimal sized buffer to hold the map.  Per my understanding of the UE=
=46I spec,
> allocations are not permitted after a call to ExitBootServices:
>=20
> "A UEFI OS loader should not make calls to any boot service function =
other than
> GetMemoryMap() after the first call to ExitBootServices()."

I see that appears on page 222 of the EFI 2.6 spec. To sve others from
digging, the relevant paragraph reads:

	A UEFI OS loader must ensure that it has the system=E2=80=99s current
	memory map at the time it calls ExitBootServices(). This is done
	by passing in the current memory map=E2=80=99s MapKey value as returne=
d
	by EFI_BOOT_SERVICES.GetMemoryMap(). Care must be taken to
	ensure that the memory map does not change between these two
	calls. It is suggested that GetMemoryMap()be called immediately
	before calling ExitBootServices(). If MapKey value is incorrect,
	ExitBootServices() returns EFI_INVALID_PARAMETER and
	GetMemoryMap() with ExitBootServices() must be called again.
	Firmware implementation may choose to do a partial shutdown of
	the boot services during the first call to ExitBootServices(). A
	UEFI OS loader should not make calls to any boot service
	function other than GetMemoryMap() after the first call to
	ExitBootServices().

That "partial shutdown" also means that giving up after a failed
ExitBootServices() call is difficult. We can't log anything, and
whatever we return to can't call any boot services.

> However the only alternative I can think of it to allocate a sufficen=
tly large
> buffer so that it can be reused to hold the modified memory map.  The=
re doesn't
> seem to be any limit to the new map, so any buffer space value I woul=
d choose
> would be arbitrary, and there would be some chance that it would be i=
nsufficent.
> efi_get_memory_map() would need to be modified to "return" the origio=
nal size
> of the allocated buffer as well, so I feel like this solution makes a=
 mess of
> the code, reduces the value of the efi_get_memory_map() helper functi=
on, and for
> all that effort, we still can't fully address this race condition.
>=20
> I guess the question is, where do we draw the line at "good enough" f=
or
> addressing this issue?  Do we use efi_get_memory_map() since it appea=
rs to be
> cleaner and does not seem to cause a problem today, despite violating=
 the spec?

We shouldn't be knowingly violating the UEFI spec.

At the very least, this should be raised with the USWG. This feels like
a specification bug, given that it's impossible (rather than simply
difficult) to solve the issue.

Ideally, we have the rules regarding a failed call to ExitBootServices(=
)
tightened such that other boot services calls are valid. The current
wording appears to result in a number of unsolvable issues.

> Second issue-
> When do we give up if we cannot get a good memory map to use with
> ExitBootServices?  Currently there is an infinite loop in my patch.  =
I noticed
> arch/x86/boot/compressed/eboot.c only retrys after the first failure.=
  I think
> a single retry is insufficent, we could do better, but I'm aware that=
 an
> infinite loop is generally a bad idea.  Any strong opinions on when t=
o quit?
> 100 attempts?  Either way, it seems the system will require a hard re=
boot if
> the retry(s) ever end up failing.

I think this depends on what the problematic events are.

Thanks,
Mark.

>=20
>  drivers/firmware/efi/libstub/fdt.c | 45 ++++++++++++++++++++++++++++=
++--------
>  1 file changed, 36 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/ef=
i/libstub/fdt.c
> index e58abfa..d3e70b0 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -250,16 +250,43 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi=
_system_table_t *sys_table,
>  		}
>  	}
> =20
> -	/*
> -	 * Update the memory map with virtual addresses. The function will =
also
> -	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
> -	 * entries so that we can pass it straight into SetVirtualAddressMa=
p()
> -	 */
> -	efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
> -			&runtime_entry_count);
> +	do {
> +		/*
> +		 * We should not free and/or allocate after calling
> +		 * ExitBootServices, but this avoids the issue of guessing how
> +		 * large of a buffer we need to store an updated memory map,
> +		 * and its common for the implementation of ExitBootServices to
> +		 * first check if the map key is current, and error out early
> +		 * leaving all other services active.
> +		 */
> +		sys_table->boottime->free_pool(memory_map);
> +		status =3D efi_get_memory_map(sys_table, &memory_map, &map_size,
> +					    &desc_size, &desc_ver, &mmap_key);
> +		if (status !=3D EFI_SUCCESS) {
> +			pr_efi_err(sys_table, "Unable to grab memory map for ExitBootServ=
ices.\n");
> +			break;
> +		}
> +		/*
> +		 * Update the memory map with virtual addresses. The function
> +		 * will also populate @runtime_map with copies of just the
> +		 * EFI_MEMORY_RUNTIME entries so that we can pass it straight
> +		 * into SetVirtualAddressMap()
> +		 */
> +		efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
> +				&runtime_entry_count);
> +
> +		/* Now we are ready to exit_boot_services.*/
> +		status =3D sys_table->boottime->exit_boot_services(handle,
> +								 mmap_key);
> +		/*
> +		 * EFI_INVALID_PARAMETER means our memory map key does not
> +		 * match the current map, likely because some event such as an
> +		 * interrupt caused an allocation ourside of our control.  Thus
> +		 * we need to get the updated map, and try again.  Our FDT
> +		 * allocation from above remains valid, so no need to redo that.
> +		 */
> +	} while (status =3D=3D EFI_INVALID_PARAMETER);
> =20
> -	/* Now we are ready to exit_boot_services.*/
> -	status =3D sys_table->boottime->exit_boot_services(handle, mmap_key=
);
> =20
>  	if (status =3D=3D EFI_SUCCESS) {
>  		efi_set_virtual_address_map_t *svam;
> --=20
> Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
