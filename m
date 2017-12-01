From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/4] MODSIGN: do not load mok when secure boot disabled
Date: Fri, 1 Dec 2017 14:59:16 +0800
Message-ID: <20171201065916.GA25857@linux-l9pv.suse>
References: <20171129141139.20088-1-jlee@suse.com>
 <20171129141139.20088-2-jlee@suse.com>
 <1512057063.3020.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512057063.3020.11.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi James, 

First, thank you for reviewing and comment!

On Thu, Nov 30, 2017 at 07:51:03AM -0800, James Bottomley wrote:
> On Wed, 2017-11-29 at 22:11 +0800, Lee, Chun-Yi wrote:
> > The mok can not be trusted when the secure boot is disabled. Which
> > means that the kernel embedded certificate is the only trusted key.
> > 
> > Due to db/dbx are authenticated variables, they needs manufacturer's
> > KEK for update. So db/dbx are secure when secureboot disabled.
> > 
> > Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> 
> > Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> > Signed-off-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  certs/load_uefi.c | 26 +++++++++++++++-----------
> >  1 file changed, 15 insertions(+), 11 deletions(-)
> > 
> > diff --git a/certs/load_uefi.c b/certs/load_uefi.c
> > index 3d88459..d6de4d0 100644
> > --- a/certs/load_uefi.c
> > +++ b/certs/load_uefi.c
> > @@ -164,17 +164,6 @@ static int __init load_uefi_certs(void)
> >  		}
> >  	}
> >  
> > -	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
> > -	if (!mok) {
> > -		pr_info("MODSIGN: Couldn't get UEFI MokListRT\n");
> > -	} else {
> > -		rc = parse_efi_signature_list("UEFI:MokListRT",
> > -					      mok, moksize,
> > get_handler_for_db);
> > -		if (rc)
> > -			pr_err("Couldn't parse MokListRT signatures:
> > %d\n", rc);
> > -		kfree(mok);
> > -	}
> > -
> >  	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
> >  	if (!dbx) {
> >  		pr_info("MODSIGN: Couldn't get UEFI dbx list\n");
> > @@ -187,6 +176,21 @@ static int __init load_uefi_certs(void)
> >  		kfree(dbx);
> >  	}
> >  
> > +	/* the MOK can not be trusted when secure boot is disabled
> > */
> > +	if (!efi_enabled(EFI_SECURE_BOOT))
> > +		return 0;
> > +
> > +	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
> 
> This isn't really a criticism of your patch but the underlying: all of
> the *RT variables, like MokListRT are insecure runtime variables and
> can be tampered with.  I can agree that I can't see a tamper attack
> between exit boot services and pulling this in to the key list, but I'd
> feel a lot happier if the values were obtained directly from the BS
> variable before exit boot services because that's means the path for
> getting the values is directly within the secure envelope and doesn't
> rely on passing via an insecure element.
>

The shim creates MokListRT as a Runtime-Volatile variable then copies
MokList to MokListRT at boot time. According to spec, the Runtime-Volatile
variable is read only after ExitBootService:

UEFI Sepc V2.7, P.281
...
Once ExitBootServices() is performed, only variables that have
EFI_VARIABLE_RUNTIME_ACCESS and EFI_VARIABLE_NON_VOLATILE set can be
set with SetVariable().
Variables that have runtime access but that are not nonvolatile
are read-only data variables once ExitBootServices() is performed.
...

On the other hand, the kernel code is signed and verified by shim. So
all codes in initial kernel path are secure. 

But, your suggestion reminds me that the code in get_cert_list() must
checks MOK/MOKx's attribute to make sure they are Runtime-Volatile
variables. I will update this patch.

Thanks a lot!
Joey Lee
