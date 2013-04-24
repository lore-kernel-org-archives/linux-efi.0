From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
Date: Wed, 24 Apr 2013 18:08:31 +0800
Message-ID: <1366798111.23707.293.camel@linux-s257.site>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366056587-24414-4-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi all,=20

=E6=96=BC =E4=B8=80=EF=BC=8C2013-04-15 =E6=96=BC 13:09 -0700=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> EFI implementations distinguish between space that is actively used b=
y a
> variable and space that merely hasn't been garbage collected yet. Spa=
ce
> that hasn't yet been garbage collected isn't available for use and so=
 isn't
> counted in the remaining_space field returned by QueryVariableInfo().
>=20
> Combined with commit 68d9298 this can cause problems. Some implementa=
tions
> don't garbage collect until the remaining space is smaller than the m=
aximum
> variable size, and as a result check_var_size() will always fail once=
 more
> than 50% of the variable store has been used even if most of that spa=
ce is
> marked as available for garbage collection. The user is unable to cre=
ate
> new variables, and deleting variables doesn't increase the remaining =
space.
>=20
> The problem that 68d9298 was attempting to avoid was one where certai=
n
> platforms fail if the actively used space is greater than 50% of the
> available storage space. We should be able to calculate that by simpl=
y
> summing the size of each available variable and subtracting that from
> the total storage space. With luck this will fix the problem describe=
d in
> https://bugzilla.kernel.org/show_bug.cgi?id=3D55471 without permittin=
g
> damage to occur to the machines 68d9298 was attempting to fix.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 109 ++++++++++++++++++++++++++++++++++=
+++++++---
>  1 file changed, 102 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.=
c
> index e844d82..a3f03cd 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
=2E..
> @@ -1039,8 +1122,20 @@ efi_status_t efi_query_variable_store(u32 attr=
ibutes, unsigned long size)
>  	if (status !=3D EFI_SUCCESS)
>  		return status;
> =20
> -	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	/*
> +	 * Some firmware implementations refuse to boot if there's insuffic=
ient
> +	 * space in the variable store. We account for that by refusing the
> +	 * write if permitting it would reduce the available space to under
> +	 * 50%. However, some firmware won't reclaim variable space until
> +	 * after the used (not merely the actively used) space drops below
> +	 * a threshold. We can approximate that case with the value calcula=
ted
> +	 * above. If both the firmware and our calculations indicate that t=
he
> +	 * available space would drop below 50%, refuse the write.
> +	 */
> +
> +	if (!storage_size || size > remaining_size ||
> +	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
> +	     (remaining_size - size < storage_size / 2)))

I am afraid it could not completely avoid to brick Samsung machines whe=
n
binding active_size and remaining_size logic with AND.

I don't have machine for testing, but my concern is we can run
delete/create variables many cycles at runtime for trigger brick Samsun=
g
machines.
It causes the garbage size increased and remaining_size decreased. But
we still can create new variable because active_size doesn't increase
due to we delete variable before create new. So, the condition
"remaining_size - size < storage_size / 2" will not really hit because
active_size condition is pass.

And, here also can not use OR for binding active_size and remaining_siz=
e
logic, that causes many machines will not trigger garbage collection
because remaining_size will never tight.

Please let me know if I lost any other conditions or background
information.


Thanks a lot!
Joey Lee
