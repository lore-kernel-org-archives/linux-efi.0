From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 2/4] tpm: Reserve the TPM final events table
Date: Fri, 3 May 2019 08:02:18 +0200
Message-ID: <20190503060218.GA28048@gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190227202658.197113-3-matthewgarrett@google.com>
 <CAJzaN5pUJoOCz5-ZDSnTb6dbVPuy0QwmFD0CeofAGK+bRQx0og@mail.gmail.com>
 <CACdnJutpBPAX6TOGgs3Ng2v_cC5hAf-3pHThESvjQ9vbvQeVkA@mail.gmail.com>
 <CAKv+Gu9PF4u=-7QL4e36Q3S5kC4+5Z=yLYHLT9jE+eNY7YUV7A@mail.gmail.com>
 <CACdnJuvDuw0X9iwEqOu7EjM5ca1f+n7f=xqzrTPS9PyrmqKNHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuvDuw0X9iwEqOu7EjM5ca1f+n7f=xqzrTPS9PyrmqKNHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Bartosz Szczepanek <bsz@semihalf.com>, linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>
List-Id: linux-efi@vger.kernel.org


* Matthew Garrett <mjg59@google.com> wrote:

> On Thu, May 2, 2019 at 12:15 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > (+ Ingo)
> >
> > On Tue, 30 Apr 2019 at 21:52, Matthew Garrett <mjg59@google.com> wrote:
> > >
> > > On Tue, Apr 30, 2019 at 6:07 AM Bartosz Szczepanek <bsz@semihalf.com> wrote:
> > > >
> > > > I may be a little late with this comment, but I've just tested these
> > > > patches on aarch64 platform (from the top of jjs/master) and got
> > > > kernel panic ("Unable to handle kernel read", full log at the end of
> > > > mail). I think there's problem with below call to
> > > > tpm2_calc_event_log_size(), where physical address of efi.tpm_log is
> > > > passed as (void *) and never remapped:
> > >
> > > Yes, it looks like this is just broken. Can you try with the attached patch?
> >
> > I'm a bit uncomfortable with EFI code that is obviously broken and
> > untested being queued for the next merge window in another tree.
> 
> The patchset was Cc:ed to linux-efi@. Is there anything else I should
> have done to ensure you picked it up rather than Jarkko?

That's not the workflow rule the Linux kernel is using, if Cc:-ing a 
patchset was the only condition for upstream inclusion then we'd have a 
*LOT* of crap in the Linux kernel.

Just applying those EFI changes without even as much as an Acked-by from 
the EFI maintainers is a *totally* unacceptable workflow.

Please revert/rebase and re-try this on the proper submission channels.

Meanwhile the broken code is NAK-ed by me:

   Nacked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
