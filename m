From: jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org (Compostella, Jeremy)
Subject: Re: [PATCH 2/5] efibc: Fix excessive stack footprint warning
Date: Wed, 11 May 2016 17:16:24 +0200
Message-ID: <8737povd4n.fsf@intel.com>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
	<1462570771-13324-3-git-send-email-matt@codeblueprint.co.uk>
	<94D0CD8314A33A4D9D801C0FE68B4029639618A2@G4W3202.americas.hpqcorp.net>
	<87r3dauwzt.fsf@intel.com> <20160511124338.GW2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511124338.GW2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> (Matt Fleming's
	message of "Wed, 11 May 2016 13:43:38 +0100")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

You're right.  Here is the new patch.

Thanks,

J=C3=A9r=C3=A9my


--=-=-=
Content-Type: text/x-diff
Content-Disposition: attachment;
 filename=0001-efibc-report-more-information-in-the-error-messages.patch

>From 3a54e6872e220e1ac4db0eae126a20b5383dae3e Mon Sep 17 00:00:00 2001
From: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Tue, 10 May 2016 10:34:21 +0200
Subject: [PATCH] efibc: report more information in the error messages

Report the name of the EFI variable if the value size is too large or
if efibc_set_variable() fails to allocate the struct efivar_entry
object.  If efibc_set_variable() fails because the value size is too
large, it also reports the value size in the error message.

Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efibc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index cb4f573..369edb5 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -37,13 +37,15 @@ static int efibc_set_variable(const char *name, const char *value)
 	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
 
 	if (size > sizeof(entry->var.Data)) {
-		pr_err("value is too large");
+		pr_err("value is too large (%zu bytes) for %s EFI variable\n",
+		       size, name);
 		return -EINVAL;
 	}
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
-		pr_err("failed to allocate efivar entry");
+		pr_err("failed to allocate efivar entry for %s EFI variable\n",
+		       name);
 		return -ENOMEM;
 	}
 
-- 
1.9.1


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> writes:

> On Tue, 10 May, at 10:40:22AM, Jeremy Compostella wrote:
>> Why not.  See patch as attachment.
>>=20
>> Thanks,
>>=20
>> J=C3=A9r=C3=A9my
>>=20
>
>> From 8a9b07e2d7242fa8a36157f1025202a96c3c7c9a Mon Sep 17 00:00:00 2001
>> From: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Date: Tue, 10 May 2016 10:34:21 +0200
>> Subject: [PATCH] efibc: report the EFI variable name in the error messag=
es
>>=20
>> Report the name of the EFI variable if the value is incorrect or if
>> efibc_set_variable() fails to allocate the struct efivar_entry object.
>>=20
>> Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efibc.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
>> index cb4f573..93d34a1 100644
>> --- a/drivers/firmware/efi/efibc.c
>> +++ b/drivers/firmware/efi/efibc.c
>> @@ -37,13 +37,14 @@ static int efibc_set_variable(const char *name, cons=
t char *value)
>>  	size_t size =3D (strlen(value) + 1) * sizeof(efi_char16_t);
>>=20=20
>>  	if (size > sizeof(entry->var.Data)) {
>> -		pr_err("value is too large");
>> +		pr_err("value is too large for %s EFI variable", name);
>>  		return -EINVAL;
>>  	}
>
> It'd be a good idea to print 'size' too.
>
>>=20=20
>>  	entry =3D kmalloc(sizeof(*entry), GFP_KERNEL);
>>  	if (!entry) {
>> -		pr_err("failed to allocate efivar entry");
>> +		pr_err("failed to allocate efivar entry for %s EFI variable",
>> +		       name);
>>  		return -ENOMEM;
>>  	}
>
> Aren't these pr_err() calls missing newline characters?

--=20
One Emacs to rule them all

--=-=-=--
