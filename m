From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 8/9] MODSIGN: Import certificates from UEFI Secure Boot
Date: Mon, 21 Nov 2016 11:25:00 -0500
Message-ID: <CA+5PVA6dWw-p3q9SBmJwQvuru4k7JZAraRZeb2=VDf8E=c=SmA@mail.gmail.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931990222.16460.11621102657967011265.stgit@warthog.procyon.org.uk> <CAKv+Gu_QVyd1Jx7ZdnBzYmZzUnH4ZuhQgiGO-zx-JPViWosjXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_QVyd1Jx7ZdnBzYmZzUnH4ZuhQgiGO-zx-JPViWosjXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 21, 2016 at 11:16 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 16 November 2016 at 18:11, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>>
>> Secure Boot stores a list of allowed certificates in the 'db' variable.
>> This imports those certificates into the system trusted keyring.  This
>> allows for a third party signing certificate to be used in conjunction
>> with signed modules.  By importing the public certificate into the 'db'
>> variable, a user can allow a module signed with that certificate to
>> load.  The shim UEFI bootloader has a similar certificate list stored
>> in the 'MokListRT' variable.  We import those as well.
>>
>
> This sounds like a bad idea to me. For the standard databases like db
> and dbx, we can rely on the firmware to ensure that they are what you
> expect. For MokListRt, not so much: anyone with sufficient
> capabilities can generate such a variable from userland, and not every
> arch/distro combo will be using shim and/or mokmanager. (The debates
> are still ongoing, but my position is that there is no need for shim
> at all on ARM given that the M$ problem only exists on x86)

In order for MokListRT to be modified, the user has to have physical
access and boot into Mok and complete the enrollment.  That is no
different than simply enrolling in db or dbx.  I don't see a
difference in security under the thread model that Secure Boot is
attempting to protect against.

josh

>
>> Secure Boot also maintains a list of disallowed certificates in the 'dbx'
>> variable.  We load those certificates into the newly introduced system
>> blacklist keyring and forbid any module signed with those from loading and
>> forbid the use within the kernel of any key with a matching hash.
>>
>> This facility is enabled by setting CONFIG_LOAD_UEFI_KEYS.
>>
>> Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>
>>  certs/Kconfig     |   16 +++++
>>  certs/Makefile    |    4 +
>>  certs/load_uefi.c |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 188 insertions(+)
>>  create mode 100644 certs/load_uefi.c
>>
>> diff --git a/certs/Kconfig b/certs/Kconfig
>> index 630ae09bbea2..3b09c5edc1a2 100644
>> --- a/certs/Kconfig
>> +++ b/certs/Kconfig
>> @@ -90,4 +90,20 @@ config EFI_SIGNATURE_LIST_PARSER
>>           This option provides support for parsing EFI signature lists for
>>           X.509 certificates and turning them into keys.
>>
>> +config LOAD_UEFI_KEYS
>> +       bool "Load certs and blacklist from UEFI db for module checking"
>> +       depends on SYSTEM_BLACKLIST_KEYRING
>> +       depends on SECONDARY_TRUSTED_KEYRING
>> +       depends on EFI
>> +       select EFI_SIGNATURE_LIST_PARSER
>> +       help
>> +         If the kernel is booted in secure boot mode, this option will cause
>> +         the kernel to load the certificates from the UEFI db and MokListRT
>> +         into the secondary trusted keyring.  It will also load any X.509
>> +         SHA256 hashes in the dbx list into the blacklist.
>> +
>> +         The effect of this is that, if the kernel is booted in secure boot
>> +         mode, modules signed with UEFI-stored keys will be permitted to be
>> +         loaded and keys that match the blacklist will be rejected.
>> +
>>  endmenu
>> diff --git a/certs/Makefile b/certs/Makefile
>> index 738151ac76af..a5e057af98a3 100644
>> --- a/certs/Makefile
>> +++ b/certs/Makefile
>> @@ -11,6 +11,10 @@ obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_nohashes.o
>>  endif
>>  obj-$(CONFIG_EFI_SIGNATURE_LIST_PARSER) += efi_parser.o
>>
>> +obj-$(CONFIG_LOAD_UEFI_KEYS) += load_uefi.o
>> +$(obj)/load_uefi.o: KBUILD_CFLAGS += -fshort-wchar
>> +
>> +
>>  ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
>>
>>  $(eval $(call config_filename,SYSTEM_TRUSTED_KEYS))
>> diff --git a/certs/load_uefi.c b/certs/load_uefi.c
>> new file mode 100644
>> index 000000000000..b44e464c3ff4
>> --- /dev/null
>> +++ b/certs/load_uefi.c
>> @@ -0,0 +1,168 @@
>> +#include <linux/kernel.h>
>> +#include <linux/sched.h>
>> +#include <linux/cred.h>
>> +#include <linux/err.h>
>> +#include <linux/efi.h>
>> +#include <linux/slab.h>
>> +#include <keys/asymmetric-type.h>
>> +#include <keys/system_keyring.h>
>> +#include "internal.h"
>> +
>> +static __initdata efi_guid_t efi_cert_x509_guid = EFI_CERT_X509_GUID;
>> +static __initdata efi_guid_t efi_cert_x509_sha256_guid = EFI_CERT_X509_SHA256_GUID;
>> +static __initdata efi_guid_t efi_cert_sha256_guid = EFI_CERT_SHA256_GUID;
>> +
>> +/*
>> + * Get a certificate list blob from the named EFI variable.
>> + */
>> +static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
>> +                                 unsigned long *size)
>> +{
>> +       efi_status_t status;
>> +       unsigned long lsize = 4;
>> +       unsigned long tmpdb[4];
>> +       void *db;
>> +
>> +       status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
>> +       if (status != EFI_BUFFER_TOO_SMALL) {
>> +               pr_err("Couldn't get size: 0x%lx\n", status);
>> +               return NULL;
>> +       }
>> +
>> +       db = kmalloc(lsize, GFP_KERNEL);
>> +       if (!db) {
>> +               pr_err("Couldn't allocate memory for uefi cert list\n");
>> +               return NULL;
>> +       }
>> +
>> +       status = efi.get_variable(name, guid, NULL, &lsize, db);
>> +       if (status != EFI_SUCCESS) {
>> +               kfree(db);
>> +               pr_err("Error reading db var: 0x%lx\n", status);
>> +               return NULL;
>> +       }
>> +
>> +       *size = lsize;
>> +       return db;
>> +}
>> +
>> +/*
>> + * Blacklist an X509 TBS hash.
>> + */
>> +static __init void uefi_blacklist_x509_tbs(const char *source,
>> +                                          const void *data, size_t len)
>> +{
>> +       char *hash, *p;
>> +
>> +       hash = kmalloc(4 + len * 2 + 1, GFP_KERNEL);
>> +       if (!hash)
>> +               return;
>> +       p = memcpy(hash, "tbs:", 4);
>> +       p += 4;
>> +       bin2hex(p, data, len);
>> +       p += len * 2;
>> +       *p = 0;
>> +
>> +       mark_hash_blacklisted(hash);
>> +       kfree(hash);
>> +}
>> +
>> +/*
>> + * Blacklist the hash of an executable.
>> + */
>> +static __init void uefi_blacklist_binary(const char *source,
>> +                                        const void *data, size_t len)
>> +{
>> +       char *hash, *p;
>> +
>> +       hash = kmalloc(4 + len * 2 + 1, GFP_KERNEL);
>> +       if (!hash)
>> +               return;
>> +       p = memcpy(hash, "bin:", 4);
>> +       p += 4;
>> +       bin2hex(p, data, len);
>> +       p += len * 2;
>> +       *p = 0;
>> +
>> +       mark_hash_blacklisted(hash);
>> +       kfree(hash);
>> +}
>> +
>> +/*
>> + * Return the appropriate handler for particular signature list types found in
>> + * the UEFI db and MokListRT tables.
>> + */
>> +static __init efi_element_handler_t get_handler_for_db(const efi_guid_t *sig_type)
>> +{
>> +       if (efi_guidcmp(*sig_type, efi_cert_x509_guid) == 0)
>> +               return add_trusted_secondary_key;
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Return the appropriate handler for particular signature list types found in
>> + * the UEFI dbx and MokListXRT tables.
>> + */
>> +static __init efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_type)
>> +{
>> +       if (efi_guidcmp(*sig_type, efi_cert_x509_sha256_guid) == 0)
>> +               return uefi_blacklist_x509_tbs;
>> +       if (efi_guidcmp(*sig_type, efi_cert_sha256_guid) == 0)
>> +               return uefi_blacklist_binary;
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Load the certs contained in the UEFI databases
>> + */
>> +static int __init load_uefi_certs(void)
>> +{
>> +       efi_guid_t secure_var = EFI_IMAGE_SECURITY_DATABASE_GUID;
>> +       efi_guid_t mok_var = EFI_SHIM_LOCK_GUID;
>> +       void *db = NULL, *dbx = NULL, *mok = NULL;
>> +       unsigned long dbsize = 0, dbxsize = 0, moksize = 0;
>> +       int rc = 0;
>> +
>> +       if (!efi.get_variable)
>> +               return false;
>> +
>> +       /* Get db, MokListRT, and dbx.  They might not exist, so it isn't
>> +        * an error if we can't get them.
>> +        */
>> +       db = get_cert_list(L"db", &secure_var, &dbsize);
>> +       if (!db) {
>> +               pr_err("MODSIGN: Couldn't get UEFI db list\n");
>> +       } else {
>> +               rc = parse_efi_signature_list("UEFI:db",
>> +                                             db, dbsize, get_handler_for_db);
>> +               if (rc)
>> +                       pr_err("Couldn't parse db signatures: %d\n", rc);
>> +               kfree(db);
>> +       }
>> +
>> +       mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
>> +       if (!mok) {
>> +               pr_info("MODSIGN: Couldn't get UEFI MokListRT\n");
>> +       } else {
>> +               rc = parse_efi_signature_list("UEFI:MokListRT",
>> +                                             mok, moksize, get_handler_for_db);
>> +               if (rc)
>> +                       pr_err("Couldn't parse MokListRT signatures: %d\n", rc);
>> +               kfree(mok);
>> +       }
>> +
>> +       dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
>> +       if (!dbx) {
>> +               pr_info("MODSIGN: Couldn't get UEFI dbx list\n");
>> +       } else {
>> +               rc = parse_efi_signature_list("UEFI:dbx",
>> +                                             dbx, dbxsize,
>> +                                             get_handler_for_dbx);
>> +               if (rc)
>> +                       pr_err("Couldn't parse dbx signatures: %d\n", rc);
>> +               kfree(dbx);
>> +       }
>> +
>> +       return rc;
>> +}
>> +late_initcall(load_uefi_certs);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
