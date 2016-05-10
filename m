From: jeremy.compostella@intel.com (Compostella, Jeremy)
Subject: Re: [PATCH 2/5] efibc: Fix excessive stack footprint warning
Date: Tue, 10 May 2016 10:40:22 +0200
Message-ID: <87r3dauwzt.fsf@intel.com>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
	<1462570771-13324-3-git-send-email-matt@codeblueprint.co.uk>
	<94D0CD8314A33A4D9D801C0FE68B4029639618A2@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029639618A2@G4W3202.americas.hpqcorp.net>
	(Robert Elliott's message of "Tue, 10 May 2016 01:41:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-efi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Why not.  See patch as attachment.

Thanks,

J=C3=A9r=C3=A9my


--=-=-=
Content-Type: text/x-diff
Content-Disposition: attachment;
 filename=0001-efibc-report-the-EFI-variable-name-in-the-error-mess.patch

>From 8a9b07e2d7242fa8a36157f1025202a96c3c7c9a Mon Sep 17 00:00:00 2001
From: Jeremy Compostella <jeremy.compostella@intel.com>
Date: Tue, 10 May 2016 10:34:21 +0200
Subject: [PATCH] efibc: report the EFI variable name in the error messages

Report the name of the EFI variable if the value is incorrect or if
efibc_set_variable() fails to allocate the struct efivar_entry object.

Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
---
 drivers/firmware/efi/efibc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index cb4f573..93d34a1 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -37,13 +37,14 @@ static int efibc_set_variable(const char *name, const char *value)
 	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
 
 	if (size > sizeof(entry->var.Data)) {
-		pr_err("value is too large");
+		pr_err("value is too large for %s EFI variable", name);
 		return -EINVAL;
 	}
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
-		pr_err("failed to allocate efivar entry");
+		pr_err("failed to allocate efivar entry for %s EFI variable",
+		       name);
 		return -ENOMEM;
 	}
 
-- 
1.9.1


--=-=-=
Content-Type: text/plain



"Elliott, Robert (Persistent Memory)" <elliott@hpe.com> writes:

>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Matt Fleming
>> Sent: Friday, May 06, 2016 4:39 PM
> ...
>> Subject: [PATCH 2/5] efibc: Fix excessive stack footprint warning
>>
>> From: Jeremy Compostella <jeremy.compostella@intel.com>
>>
> ...
>>
>> -static void efibc_set_variable(const char *name, const char *value)
>> +static int efibc_set_variable(const char *name, const char *value)
>>  {
>>       int ret;
>>       efi_guid_t guid = LINUX_EFI_LOADER_ENTRY_GUID;
>> -     struct efivar_entry entry;
>> +     struct efivar_entry *entry;
>>       size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
>>
>> -     if (size > sizeof(entry.var.Data))
>> +     if (size > sizeof(entry->var.Data)) {
>>               pr_err("value is too large");
>
> That pr_err is introduced by patch 25/40 of the first series.
>
> How about including the name of the variable for which this is failing,
> like the final pr_err?
>
>> +             return -EINVAL;
>> +     }
>>
>> -     efibc_str_to_str16(name, entry.var.VariableName);
>> -     efibc_str_to_str16(value, (efi_char16_t *)entry.var.Data);
>> -     memcpy(&entry.var.VendorGuid, &guid, sizeof(guid));
>> +     entry = kmalloc(sizeof(*entry), GFP_KERNEL);
>> +     if (!entry) {
>> +             pr_err("failed to allocate efivar entry");
>
> How about including the name of the variable for which this
> is failing, like the final pr_err?
>
>> +             return -ENOMEM;
>> +     }
>>
>> -     ret = efivar_entry_set(&entry,
>> +     efibc_str_to_str16(name, entry->var.VariableName);
>> +     efibc_str_to_str16(value, (efi_char16_t *)entry->var.Data);
>> +     memcpy(&entry->var.VendorGuid, &guid, sizeof(guid));
>> +
>> +     ret = efivar_entry_set(entry,
>>                              EFI_VARIABLE_NON_VOLATILE
>>                              | EFI_VARIABLE_BOOTSERVICE_ACCESS
>>                              | EFI_VARIABLE_RUNTIME_ACCESS,
>> -                            size, entry.var.Data, NULL);
>> +                            size, entry->var.Data, NULL);
>>       if (ret)
>>               pr_err("failed to set %s EFI variable: 0x%x\n",
>>                      name, ret);
>> +
>> +     kfree(entry);
>> +     return ret;
>>  }
>

-- 
One Emacs to rule them all

--=-=-=--
