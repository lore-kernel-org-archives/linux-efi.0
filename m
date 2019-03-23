From: jlee@suse.com
Subject: Re: [PATCH 2/2] efi: print appropriate status message when loading
 certificates
Date: Sat, 23 Mar 2019 10:56:13 +0800
Message-ID: <20190323025613.GA7196@localhost>
References: <20190322103350.27764-1-jlee@suse.com>
 <20190322103350.27764-2-jlee@suse.com>
 <CAKv+Gu8Xg3SBTpAFDSe5zyT8yjU71+HUT9LO18D+HiT+Hhp+Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8Xg3SBTpAFDSe5zyT8yjU71+HUT9LO18D+HiT+Hhp+Zg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Nayna Jain <nayna@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-efi <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Fri, Mar 22, 2019 at 03:27:46PM +0100, Ard Biesheuvel wrote:
> On Fri, 22 Mar 2019 at 11:34, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> >
> > When loading certificates list from UEFI variable, the original error
> > message direct shows the efi status code from UEFI firmware. It looks
> > ugly:
> >
> > [    2.335031] Couldn't get size: 0x800000000000000e
> > [    2.335032] Couldn't get UEFI MokListRT
> > [    2.339985] Couldn't get size: 0x800000000000000e
> > [    2.339987] Couldn't get UEFI dbx list
> >
> 
> Why is it an error in the first place if these EFI variables do not exist?
> 

As you said, the error message should only be exposed when
these EFI variables exist. I will change it in next version of
my patch.

Thanks a lot!
Joey Lee

> 
> > So, this patch shows the status string instead of status code.
> >
> > On the other hand, the error message of EFI_NOT_FOUND
> > (0x800000000000000e) doesn't need to be exposed because kernel
> > already prints "Couldn't get UEFI..." message. This patch also
> > filtered out it.
> >
> > Link: https://forums.opensuse.org/showthread.php/535324-MODSIGN-Couldn-t-get-UEFI-db-list?p=2897516#post2897516
> > Cc: James Morris <jmorris@namei.org>
> > Cc: Serge E. Hallyn" <serge@hallyn.com>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Nayna Jain <nayna@linux.ibm.com>
> > Cc: Josh Boyer <jwboyer@fedoraproject.org>
> > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> > ---
> >  security/integrity/platform_certs/load_uefi.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
> > index 81b19c52832b..fe261166621f 100644
> > --- a/security/integrity/platform_certs/load_uefi.c
> > +++ b/security/integrity/platform_certs/load_uefi.c
> > @@ -48,7 +48,9 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
> >
> >         status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
> >         if (status != EFI_BUFFER_TOO_SMALL) {
> > -               pr_err("Couldn't get size: 0x%lx\n", status);
> > +               if (status != EFI_NOT_FOUND)
> > +                       pr_err("Couldn't get size: %s\n",
> > +                               efi_status_to_str(status));
> >                 return NULL;
> >         }
> >
> > @@ -59,7 +61,8 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
> >         status = efi.get_variable(name, guid, NULL, &lsize, db);
> >         if (status != EFI_SUCCESS) {
> >                 kfree(db);
> > -               pr_err("Error reading db var: 0x%lx\n", status);
> > +               pr_err("Error reading db var: %s\n",
> > +                       efi_status_to_str(status));
> >                 return NULL;
> >         }
> >
> > --
> > 2.16.4
> >
