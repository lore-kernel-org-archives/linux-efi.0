From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: General protection fault in efivarfs
Date: Tue, 25 Dec 2012 10:24:33 +0800
Message-ID: <50D90E61.40702@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>  <1351237923-10313-2-git-send-email-matt@console-pimps.org>  <50D44279.7010008@redhat.com> <1356346840.6113.45.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356346840.6113.45.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, glin-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/24/2012 07:00 PM, joeyli wrote:
> =E6=96=BC =E4=BA=94=EF=BC=8C2012-12-21 =E6=96=BC 19:05 +0800=EF=BC=8C=
Lingzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
>> The following reproducer triggers certain bugs in efivarfs_file_writ=
e.
>>
>> #!/bin/bash
>> p=3D/sys/firmware/efi/efivars
>> mount -t efivarfs - $p
>> cat $p/Lang-*>$p/test-12341234-1234-1234-1234-123412341234
>> umount $p
>> mount -t efivarfs - $p
>> echo -en "\0\0\0\0">$p/test-12341234-1234-1234-1234-123412341234
>=20
> The problem is check EFI_VARIABLE_MASK in efivars.c that is not enoug=
h
> for deny use 0x00000000 attributes.
>=20
> Per UEFI spec, runtime variable at least need has attributes
> EFI_VARIABLE_BOOTSERVICE_ACCESS and EFI_VARIABLE_RUNTIME_ACCESS.
> Otherwise UEFI BIOS will occur unexpected error.
>=20
> Please try the following patch.

Thank you for your patch.

Per UEFI spec, echo -en "\0\0\0\0" should be equivalent to deleting.
This is what efivarfs_unlink is doing but I wanted to avoid its
underflowing when reproducing this.

This still reproduces the bug and passes the check in your patch:

echo -en "\x07\0\0\0" >$p/test-12341234-1234-1234-1234-123412341234

> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7b1c374..7aeb4a5 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -706,6 +706,10 @@ static ssize_t efivarfs_file_write(struct file *=
file,
>   	if (attributes&  ~(EFI_VARIABLE_MASK))
>   		return -EINVAL;
>=20
> +	if (!((attributes&  EFI_VARIABLE_BOOTSERVICE_ACCESS)&&
> +		(attributes&  EFI_VARIABLE_RUNTIME_ACCESS)))
> +		return -EINVAL;
> +
>   	efivars =3D var->efivars;

--
Lingzhu Xiang
