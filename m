From: Julien Grall <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH] efi/libstub/fdt: Standardize the names of
 EFI stub parameters
Date: Thu, 10 Sep 2015 13:53:42 +0100
Message-ID: <55F17D56.60300@citrix.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
	<20150910123251.7e0810d1@bender.Home> <55F16DF5.1080705@citrix.com>
 <55F1721D.1010801@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F1721D.1010801-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Turner <andrew-/GQUgJ3qWXsIvnNNuaVxrw@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/09/15 13:05, Roger Pau Monn=E9 wrote:
> El 10/09/15 a les 13.48, Julien Grall ha escrit:
>> On 10/09/15 12:32, Andrew Turner wrote:
>>> On Thu, 10 Sep 2015 16:41:56 +0800
>>> Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>
>>>> These EFI stub parameters are used to internal communication betwe=
en
>>>> EFI stub and Linux kernel and EFI stub creates these parameters. B=
ut
>>>> for Xen on ARM when booting with UEFI, Xen will create a minimal D=
T
>>>> providing these parameters for Dom0 and Dom0 is not only Linux
>>>> kernel, but also other OS (such as FreeBSD) which will be used in =
the
>>>> future. So here we plan to standardize the names by dropping the
>>>> prefix "linux," and make them common to other OS. Also this will n=
ot
>>>> break the compatibility since these parameters are used to interna=
l
>>>> communication between EFI stub and kernel.
>>>
>>> It is unlikely FreeBSD will use this property when booting ad Xen d=
om0.
>>> The kernel expects to be passed a data structure to find boot this
>>> information.
>>>
>>> My preference would be to have the FreeBSD loader load the xen bina=
ry,
>>> the FreeBSD kernel, and set up these data structs before passing
>>> control to Xen, with the information it needs to boot the kernel. M=
y
>>> understanding is this is how it is done on x86.
>>
>> Well, AFAICT, there is no FreeBSD specific code in Xen for x86. We a=
re
>> faking a multiboot module which contains all the informations.
>>
>> I know that the bootloader is at least involved, I don't remember if
>> there is some code in FreeBSD to read this boot module. I've CCed Ro=
ger
>> to confirm.
>=20
> The metadata/modules needed by the FreeBSD Dom0 kernel is generated b=
y
> the native FreeBSD bootloader (as would be done when booting bare
> metal). Then this blob is passed as a multiboot module in the same pl=
ace
> that Linux puts it's initramfs. Xen simply copies this blob straight
> into guest memory and sets start_info.mod_start to point to the start
> memory address of this blob.
>=20
> I've done it this way because I don't see many other options. Xen is
> tailored for Linux and only allows passing one module to the Dom0 ker=
nel
> (initramfs). For FreeBSD it would be good to be able to pass at least
> two modules to the Dom0 kernel, one containing the metadata, and the
> other one containing the modules themselves. The new PVH work (HVMlit=
e
> or whatever) will hopefully allow passing more than one module to the
> Dom0 kernel, and should make the code in the FreeBSD loader simpler.

We have a multiboot based on device tree to boot Xen on ARM [1].

It may be possible to create another kind of module storing the FreeBSD
metadata and make a trampoline for Xen in FreeBSD to pass the
information correctly to the DOM0 kernel.

But the main problem is we have to modify those metadata because,
AFAICT, the device tree/ACPI blob is part of them. It also seems to be
the same for UEFI.

That means we need some knowledge in Xen to parse/modify those metadata=
=2E
Unless they are stable (i.e clearly defined, not changing, place in
memory known...), we can't use them in Xen as we would need to adapt fo=
r
every changes.

If it's stable, we have to know that we are using FreeBSD (could be don=
e
with the multiboot string).

Although, I would be more in favor of the loader using the Xen boot
interface with a new multiboot module, Xen jumping on a trampoline in
the FreeBSD kernel still using the Guest Boot ABI (similar the the Linu=
x
ABI). The trampoline would recreate the metadata with the new DT and
jump into the kernel.

I will give a look to this when I'm done with the FreeBSD ARM guest sup=
port.

Regards,

[1] http://xenbits.xen.org/docs/unstable/misc/arm/device-tree/booting.t=
xt

--=20
Julien Grall
