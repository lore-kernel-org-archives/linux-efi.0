From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 1/5] MODSIGN: do not load mok when secure boot disabled
Date: Wed, 14 Mar 2018 18:23:52 +0800
Message-ID: <20180314102352.GG19718@linux-l9pv.suse>
References: <20180313103803.13388-1-jlee@suse.com>
 <20180313103803.13388-2-jlee@suse.com>
 <CAKv+Gu_1+8AOy4Fj_yD6iEJQvjw3hA4KW11agU+ozujxMNQHVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_1+8AOy4Fj_yD6iEJQvjw3hA4KW11agU+ozujxMNQHVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, David Howells <dhowells@redhat.com>, linux-fs@vger.kernel.org, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-efi@vger.kernel.org

Hi Ard, 

First! Thanks for your review!

On Tue, Mar 13, 2018 at 05:25:30PM +0000, Ard Biesheuvel wrote:
> On 13 March 2018 at 10:37, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> > The mok can not be trusted when the secure boot is disabled. Which
> > means that the kernel embedded certificate is the only trusted key.
> >
> > Due to db/dbx are authenticated variables, they needs manufacturer's
> > KEK for update. So db/dbx are secure when secureboot disabled.
> >
> 
> Did you consider the case where secure boot is not implemented? I
> don't think db/dbx are secure in that case, although perhaps it may
> not matter (a bit more information on the purpose of these patches and
> all the shim lingo etc would be appreciated)
> 

The patch 5 in this series checks that the db/dbx must have
EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS attribute. But I agree
with you that kernel should checks the SecureBoot variable must
exist in system. I will add patch to detect it.

> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Josh Boyer <jwboyer@fedoraproject.org>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> > ---
> >  certs/load_uefi.c | 26 +++++++++++++++-----------
> >  1 file changed, 15 insertions(+), 11 deletions(-)
> >
> > diff --git a/certs/load_uefi.c b/certs/load_uefi.c
> > index 3d88459..d6de4d0 100644
> > --- a/certs/load_uefi.c
> > +++ b/certs/load_uefi.c
> > @@ -164,17 +164,6 @@ static int __init load_uefi_certs(void)
> >                 }
> >         }
> >
> > -       mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
> 
> Which tree does this apply to? My tree doesn't have get_cert_list()
>

This patch set is base on the efi-lock-down and keys-uefi branchs in
David Howells's linux-fs git tree.
    https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-uefi

Thanks a lot!
Joey Lee 
