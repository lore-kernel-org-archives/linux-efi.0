From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: General protection fault in efivarfs
Date: Tue, 25 Dec 2012 12:13:04 +0800
Message-ID: <1356408784.6113.68.camel@linux-s257.site>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <50D44279.7010008@redhat.com> <1356346840.6113.45.camel@linux-s257.site>
	 <50D90E61.40702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D90E61.40702-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, glin-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2012-12-25 =E6=96=BC 10:24 +0800=EF=BC=8CLi=
ngzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/24/2012 07:00 PM, joeyli wrote:
> > =E6=96=BC =E4=BA=94=EF=BC=8C2012-12-21 =E6=96=BC 19:05 +0800=EF=BC=8C=
Lingzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> >> The following reproducer triggers certain bugs in efivarfs_file_wr=
ite.
> >>
> >> #!/bin/bash
> >> p=3D/sys/firmware/efi/efivars
> >> mount -t efivarfs - $p
> >> cat $p/Lang-*>$p/test-12341234-1234-1234-1234-123412341234
> >> umount $p
> >> mount -t efivarfs - $p
> >> echo -en "\0\0\0\0">$p/test-12341234-1234-1234-1234-123412341234
> >=20
> > The problem is check EFI_VARIABLE_MASK in efivars.c that is not eno=
ugh
> > for deny use 0x00000000 attributes.
> >=20
> > Per UEFI spec, runtime variable at least need has attributes
> > EFI_VARIABLE_BOOTSERVICE_ACCESS and EFI_VARIABLE_RUNTIME_ACCESS.
> > Otherwise UEFI BIOS will occur unexpected error.
> >=20
> > Please try the following patch.
>=20
> Thank you for your patch.
>=20
> Per UEFI spec, echo -en "\0\0\0\0" should be equivalent to deleting.

Per spec, the variable will be deleted when set DataSize to zero:

Unless the EFI_VARIABLE_APPEND_WRITE,
EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS, or
EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS attribute is set, a
size of zero causes the variable to be deleted.

But, about the attributes description of SetVariable, it said:

Attributes Attributes bitmask to set for the variable. Refer to the
GetVariable() function description.

In description of GetVariable(), it reference to the definitions of
"Variable Attributes", it said:

Any attempts to access a variable that does not have the attribute set
for runtime access will yield the EFI_NOT_FOUND error.


So, if doesn't set any attribute, then will receive EFI_NOT_FOUND. That
also means we should not allow 0x00000000 in SetVariable(). I still
think we should reply -EINVAL to user space application when they do no=
t
set any attributes.

> This is what efivarfs_unlink is doing but I wanted to avoid its
> underflowing when reproducing this.
>=20
> This still reproduces the bug and passes the check in your patch:
>=20
> echo -en "\x07\0\0\0" >$p/test-12341234-1234-1234-1234-123412341234

I can NOT reproduce issue by feeding "\x07\0\0\0" to variable on my
system, the test variable was been deleted normally.

My 2 testing environment:=20
	+ qemu-kvm with OVMF-0.1+r13902-1.1.x86_64 on openSUSE
	+ Intel DQ57TM board (Tunnel Mountain) with B.11 UEFI BIOS

Kernel version is:
	+ latest commit is 54e37b8dbe on Linus kernel tree
	  with
	  my patch for check attributes need define bootservice and runtime ac=
cess
	 =20
I can not reproduce on OVMF and Intel DQ57TM board. After I delete
variable, I also umount/mount filesystem a couple of times and
write/delete again, didn't reproduce issue.

Maybe you can try v3.8-rc1 kernel.

>=20
> > diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.=
c
> > index 7b1c374..7aeb4a5 100644
> > --- a/drivers/firmware/efivars.c
> > +++ b/drivers/firmware/efivars.c
> > @@ -706,6 +706,10 @@ static ssize_t efivarfs_file_write(struct file=
 *file,
> >   	if (attributes&  ~(EFI_VARIABLE_MASK))
> >   		return -EINVAL;
> >=20
> > +	if (!((attributes&  EFI_VARIABLE_BOOTSERVICE_ACCESS)&&
> > +		(attributes&  EFI_VARIABLE_RUNTIME_ACCESS)))
> > +		return -EINVAL;
> > +
> >   	efivars =3D var->efivars;
>=20
> --
> Lingzhu Xiang
>=20

Thanks
Joey Lee
